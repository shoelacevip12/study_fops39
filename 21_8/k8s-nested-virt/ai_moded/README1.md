# LXC-контейнеры с Nested Virtualization под Kubernetes-кластер

## Задача
Добавить **nested virtualization** в XML-конфиг libvirt-LXC контейнера и растиражировать его
на кластер K8s из **1 control-plane + 4 рабочих нод**.

---

## ⚠️ Предварительное требование: наличие `/dev/kvm` на хосте

В конфигах используется bind-mount `/dev/kvm` внутрь контейнера. **Если на хосте нет
устройства `/dev/kvm`, контейнер не стартует** (libvirt не сможет смонтировать несуществующий источник).

На данном хосте `/dev/kvm` **отсутствует**, хотя CPU поддерживает виртуализацию (`svm` —
AMD). Причина — не загружен модуль `kvm_amd`. Диагностика:

```bash
# флаги виртуализации CPU (svm = AMD, vmx = Intel)
grep -oE 'vmx|svm' /proc/cpuinfo | sort -u
# загружен ли kvm-модуль
lsmod | grep kvm
# есть ли /dev/kvm
ls -l /dev/kvm
```

### Как включить (для AMD — `kvm_amd`)
```bash
# 1. Загрузить модуль с поддержкой nested virtualization
sudo modprobe kvm_amd nested=1

# 2. Проверить, что nested включён и появился /dev/kvm
cat /sys/module/kvm_amd/parameters/nested   # ожидаем '1'
ls -l /dev/kvm                              # ожидаем crw-rw---- ... /dev/kvm
```

### Автозагрузка при старте (постоянно)
```bash
# AMD
echo "options kvm_amd nested=1" | sudo tee /etc/modprobe.d/kvm_amd.conf
# Intel (если vmx)
# echo "options kvm_intel nested=1" | sudo tee /etc/modprobe.d/kvm_intel.conf
```

> Требуется root-доступ. Если контейнеры планируются без KVM (только containerd/runC),
> bind-mount `/dev/kvm` можно исключить из конфигов — nested virtualization не потребуется.

---

## Номенклатура нод

| Роль            | Имя    | IP             | Файл конфига     |
|-----------------|--------|----------------|------------------|
| control-plane   | k8s-cp | 192.168.89.11 | lxc-k8s-cp.xml   |
| worker-1        | k8s-w1 | 192.168.89.12 | lxc-k8s-w1.xml   |
| worker-2        | k8s-w2 | 192.168.89.13 | lxc-k8s-w2.xml   |
| worker-3        | k8s-w3 | 192.168.89.14 | lxc-k8s-w3.xml   |
| worker-4        | k8s-w4 | 192.168.89.15 | lxc-k8s-w4.xml   |

> **Важно:** каждой ноде соответствует **свой** rootfs-каталог `/disk/VMs/<нода>/rootfs`
> (не общий!). Иначе контейнеры конфликтуют по `/etc/hosts`, machine-id, `/run`, `/tmp`,
> cgroup и pid-файлам. Подготовка rootfs — см. [Применение](#применение-конфигов).
>
> Базовая (эталонная) rootfs Alt Linux p11 уже подготовлена: `/disk/VMs/k8s_rootfs`.
>
> **Назначение нод:** только kubeadm + kubelet (kube-proxy/CNI) как чистые k8s-ноды.
> Работают на хостовой сети (bridge `br0`), NFS-store НЕ монтируется (удалён из конфигов).

---

## Что было исправлено в исходном шаблоне

### 1. Структурная ошибка: `<features>` внутри `<devices>`
Исходный шаблон был невалидным:
```xml
<devices>
  <features>
    <capabilities policy='allow'></capabilities>
  </features>
  ...
```
В корректной схеме libvirt `<features>` должен быть **прямым потомком** `<domain>`
на одном уровне с `<os>`, `<memory>`, `<vcpu>`, `<clock>`, `<devices>`.

### 2. Пустой `<capabilities policy='allow'>` невалиден
Блок `<capabilities>` требует реальные имена capability. Пустой блок отклоняется libvirt.

---

## Что добавлено для nested virtualization

1. **CPU host-passthrough** — пробрасывает флаги хоста (`vmx`/`svm`), чтобы в контейнере
   `/proc/cpuinfo` показывал аппаратную виртуализацию:
   ```xml
   <cpu mode='host-passthrough'/>
   ```
2. **Проброс `/dev/kvm`** в контейнер (bind-mount через `<filesystem>`), чтобы внутри
   работал KVM (для подов) и не требовался дополнительный hostdev:
   ```xml
   <filesystem type='mount'>
     <source dir='/dev/kvm'/>
     <target dir='/dev/kvm'/>
   </filesystem>
   ```
3. **Capabilities** для работы containerd/kubelet/CNI:
   - `net_admin` — сетевые namespace подов (CNI)
   - `sys_admin` — overlayfs, cgroup-операции kubelet
   - `mknod` — создание device-nodes (в т.ч. внутри подов)
   - `sys_ptrace` — диагностика процессов подов

---

## Параметризованный шаблон (templates/lxc-k8s.xml.j2)

Файл уже лежит в [`templates/lxc-k8s.xml.j2`](templates/lxc-k8s.xml.j2). Параметры:
- `node_name` — имя ноды (`k8s-cp`, `k8s-w1`, …)
- `ip_address` — статический IP ноды

Путь rootfs задан как `/disk/VMs/{{ node_name }}/rootfs` (соответствует пулу `VMs`).
IP задаётся статически, шлюз `192.168.89.1`.

Содержимое:

```xml
<domain type='lxc'>
  <name>{{ node_name }}</name>
  <memory unit='KiB'>{{ memory_kib | default(14680064) }}</memory>
  <vcpu>2</vcpu>

  <os>
    <type>exe</type>
    <init>/sbin/init</init>
  </os>

  <cpu mode='host-passthrough'/>

  <features>
    <capabilities policy='allow'>
      <net_admin/>
      <sys_admin/>
      <sys_ptrace/>
      <mknod/>
      <chown/>
      <dac_override/>
      <fowner/>
      <fsetid/>
      <kill/>
      <setgid/>
      <setuid/>
      <setpcap/>
      <net_bind_service/>
      <net_raw/>
      <sys_chroot/>
      <sys_resource/>
      <audit_write/>
    </capabilities>
  </features>

  <clock offset="timezone" timezone="Europe/Moscow"/>

  <devices>
    <filesystem type='mount'>
      <source dir='/disk/VMs/{{ node_name }}/rootfs'/>
      <target dir='/'/>
    </filesystem>

    <filesystem type='mount'>
      <source dir='/dev/kvm'/>
      <target dir='/dev/kvm'/>
    </filesystem>

    <interface type='bridge'>
      <source bridge='br0'/>
      <ip address='{{ ip_address }}' family='ipv4' prefix='24'/>
      <route family='ipv4' address='0.0.0.0' gateway='192.168.89.1'/>
      <guest dev='eth0'/>
      <link state='up'/>
    </interface>

    <console type='pty'>
      <target type='lxc' port='0'/>
    </console>
    <tty/>
  </devices>
</domain>
```

---

## Растиражированные конфиги (готовые к применению)

Каждый файл — отдельный полный XML для своей ноды (отличаются только `<name>`, статический IP и путь rootfs):

| Файл                     | Нода    | Статический IP | rootfs                    |
|--------------------------|---------|----------------|---------------------------|
| [`lxc-k8s-cp.xml`](lxc-k8s-cp.xml)   | k8s-cp  | 192.168.89.11  | `/disk/VMs/k8s-cp/rootfs` |
| [`lxc-k8s-w1.xml`](lxc-k8s-w1.xml)   | k8s-w1  | 192.168.89.12  | `/disk/VMs/k8s-w1/rootfs` |
| [`lxc-k8s-w2.xml`](lxc-k8s-w2.xml)   | k8s-w2  | 192.168.89.13  | `/disk/VMs/k8s-w2/rootfs` |
| [`lxc-k8s-w3.xml`](lxc-k8s-w3.xml)   | k8s-w3  | 192.168.89.14  | `/disk/VMs/k8s-w3/rootfs` |
| [`lxc-k8s-w4.xml`](lxc-k8s-w4.xml)   | k8s-w4  | 192.168.89.15  | `/disk/VMs/k8s-w4/rootfs` |

IP задаётся статически в XML (`<ip address=...>`, prefix 24, шлюз `192.168.89.1`).
Все файлы проверены `xmllint` — well-formed.

---

## Применение конфигов

> ⚠️ Каждый контейнер должен иметь **свою** rootfs — контейнеры не должны монтировать
> один и тот же каталог как `/` (иначе конфликты `/etc/hosts`, machine-id, `/run`,
> `/tmp`, cgroup, pid-файлы). В конфигах путь задан как `/disk/VMs/<нода>/rootfs`.

### Шаг 1. Подготовить отдельные rootfs для каждой ноды

Скрипт [`scripts/clone_rootfs.sh`](scripts/clone_rootfs.sh) копирует эталонную rootfs
(`/disk/VMs/k8s_rootfs`) для каждой ноды, сбрасывает machine-id и задаёт hostname:

```bash
cd 21_8/k8s-nested-virt
chmod +x scripts/clone_rootfs.sh

# базу можно указать явно, если она не /disk/VMs/k8s_rootfs
BASE_ROOTFS=/disk/VMs/k8s_rootfs ./scripts/clone_rootfs.sh
```

Результат: `/disk/VMs/{k8s-cp,k8s-w1,k8s-w2,k8s-w3,k8s-w4}/rootfs`.

### Шаг 2. Определить и запустить контейнеры

```bash
for f in lxc-k8s-*.xml; do
  echo "Определяю $f"
  virsh -c lxc:/// define "$f"
done
```

```bash
# Запуск всех нод
for n in k8s-cp k8s-w1 k8s-w2 k8s-w3 k8s-w4; do
virsh -c lxc:/// start "$n"
done
```

---

## Проверка nested virtualization внутри контейнера

```bash
# на каждой ноде
grep -oE 'vmx|svm' /proc/cpuinfo | sort -u
ls -l /dev/kvm && test -w /dev/kvm && echo "KVM writable"
```

Ожидаемый результат:
```
vmx   # или svm на AMD
crw-rw---- ... /dev/kvm
KVM writable
```

---

## Диагностика (использованные команды и вывод)

Команды, применённые при подготовке/проверке конфигов, и их актуальный вывод:

### 1. Проверка nested virtualization на хосте (AMD)
```bash
cat /sys/module/kvm_amd/parameters/nested
```
```text
1
```

### 2. Проверка наличия /dev/kvm
```bash
ls -l /dev/kvm
```
```text
crw-rw-rw- 1 root kvm 10, 232 авг 25 18:40 /dev/kvm
```

### 3. Валидация XML-конфигов
```bash
for f in lxc-k8s-*.xml; do xmllint --noout "$f" && echo "OK: $f"; done
```
```text
OK: lxc-k8s-cp.xml
OK: lxc-k8s-w1.xml
OK: lxc-k8s-w2.xml
OK: lxc-k8s-w3.xml
OK: lxc-k8s-w4.xml
```

### 4. Контроль отсутствия NFS-store (после удаления)
```bash
grep -rn "for_nfs\|nfs-store" lxc-k8s-*.xml templates/ 2>/dev/null || echo "NONE"
```
```text
NONE
```

### 5. Контроль статической адресации в сети
```bash
grep -H "<ip address=\|<source bridge=\|gateway=" lxc-k8s-*.xml
```
```text
lxc-k8s-cp.xml:      <source bridge='br0'/>
lxc-k8s-cp.xml:      <ip address='192.168.89.11' family='ipv4' prefix='24'/>
lxc-k8s-cp.xml:      <route family='ipv4' address='0.0.0.0' gateway='192.168.89.1'/>
lxc-k8s-w1.xml:      <source bridge='br0'/>
lxc-k8s-w1.xml:      <ip address='192.168.89.12' family='ipv4' prefix='24'/>
lxc-k8s-w1.xml:      <route family='ipv4' address='0.0.0.0' gateway='192.168.89.1'/>
lxc-k8s-w2.xml:      <source bridge='br0'/>
lxc-k8s-w2.xml:      <ip address='192.168.89.13' family='ipv4' prefix='24'/>
lxc-k8s-w2.xml:      <route family='ipv4' address='0.0.0.0' gateway='192.168.89.1'/>
lxc-k8s-w3.xml:      <source bridge='br0'/>
lxc-k8s-w3.xml:      <ip address='192.168.89.14' family='ipv4' prefix='24'/>
lxc-k8s-w3.xml:      <route family='ipv4' address='0.0.0.0' gateway='192.168.89.1'/>
lxc-k8s-w4.xml:      <source bridge='br0'/>
lxc-k8s-w4.xml:      <ip address='192.168.89.15' family='ipv4' prefix='24'/>
lxc-k8s-w4.xml:      <route family='ipv4' address='0.0.0.0' gateway='192.168.89.1'/>
```

### 7. Синтаксис скрипта подготовки rootfs
```bash
bash -n scripts/clone_rootfs.sh && echo "syntax OK"
```
```text
syntax OK
```

---

## Важные замечания

1. **На хосте должна быть включена nested virtualization** для KVM:
   ```bash
   # Intel
   echo "options kvm_intel nested=1" | sudo tee /etc/modprobe.d/kvm_intel.conf
   # AMD
   echo "options kvm_amd nested=1" | sudo tee /etc/modprobe.d/kvm_amd.conf
   ```
2. **LXC-контейнер с `/dev/kvm`** может требовать запуска от root и корректных
   прав на устройство в rootfs (внутри контейнера `/dev` пересоздаётся при старте).
3. **Каждой ноде — своя rootfs.** Путь в конфигах: `/disk/VMs/<нода>/rootfs`.
   Для подготовки используйте [`scripts/clone_rootfs.sh`](scripts/clone_rootfs.sh)
   (копирует эталонную `/disk/VMs/k8s_rootfs` и сбрасывает machine-id для каждой ноды).
4. Альтернатива отдельным копиям — **OverlayFS** (общая read-only база + per-node
   upper/work слой), как реализовано в `21_8/ansible-local-stand`.

---

# Развёртывание Kubernetes по руководству Alt Linux

Руководство: [https://www.altlinux.org/Kubernetes](https://www.altlinux.org/Kubernetes)
(локальная копия `Kubernetes.htm`). См. также план [`PLAN_k8s_cluster.md`](PLAN_k8s_cluster.md).

## Параметры кластера
- **CRI: CRI-O** (сокет `unix:///var/run/crio/crio.sock`) — по руководству Alt.
- **CNI: Calico**, под-сеть **`10.10.0.0/16`**.
- Версия k8s: **`1.36.1`**, реестр образов: `registry.altlinux.org/p11`.
- Образы control plane тянем из `registry.altlinux.org/p11`.

## Ноды
| Роль | Имя | IP |
|------|-----|-----|
| master | k8s-cp | 192.168.89.11 |
| worker | k8s-w1 | 192.168.89.12 |
| worker | k8s-w2 | 192.168.89.13 |
| worker | k8s-w3 | 192.168.89.14 |
| worker | k8s-w4 | 192.168.89.15 |

## Шаг 1. Подготовка нод (на ВСЕХ 5 нодах)

```bash
# /etc/hosts для взаимного разрешения имён
cat >> /etc/hosts <<'EOF'
192.168.89.11 k8s-cp
192.168.89.12 k8s-w1
192.168.89.13 k8s-w2
192.168.89.14 k8s-w3
192.168.89.15 k8s-w4
EOF

swapoff -a   # + ./scripts/disable_swap_node.sh (host-овый zram-swap не убрать из контейнера)
```

## Шаг 2. Установка пакетов и запуск служб (на ВСЕХ нодах)

```bash
apt-get update
apt-get install -y \
    kubernetes1.36-kubeadm kubernetes1.36-kubelet \
    kubernetes1.36-crio cri-tools1.36 \
    iptables nftables

systemctl enable --now crio
systemctl enable kubelet
```

Готовый скрипт: [`scripts/setup_k8s_node.sh`](scripts/setup_k8s_node.sh).
> Если CRI-O падает с ошибкой про iptables/nftables — см. [`scripts/prepare_crio_node.sh`](scripts/prepare_crio_node.sh).

## Шаг 3. Инициализация мастера (на k8s-cp) — Calico, под-сеть 10.10.0.0/16

```bash
kubeadm init \
  --pod-network-cidr=10.10.0.0/16 \
  --kubernetes-version=1.36.1 \
  --image-repository=registry.altlinux.org/p11 \
  --ignore-preflight-errors=Swap
```
В конце вывода сохранить команду `kubeadm join ...` для рабочих нод.

## Шаг 4. kubectl для root (на k8s-cp)

```bash
mkdir -p ~/.kube
cp /etc/kubernetes/admin.conf ~/.kube/config
kubectl get nodes
```

## Шаг 5. CNI Calico

```bash
# манифесты Alt: https://altlinux.space/cloud/manifests/src/branch/master/calico/<platform=p11>
kubectl apply -f <calico-manifest.yaml>

# согласовать IPPool с под-сетью (если в манифесте другой CIDR)
kubectl -n kube-system get ippool -o yaml   # при необходимости задать cidr: 10.10.0.0/16
```

## Шаг 6. Присоединение рабочих нод (на k8s-w1..w4)

```bash
kubeadm join 192.168.89.11:6443 \
  --token <токен> \
  --discovery-token-ca-cert-hash sha256:<хэш> \
  --ignore-preflight-errors=Swap
```

## Шаг 7. Проверка кластера

```bash
kubectl get nodes -o wide
kubectl get pods -A
```

## Шаг 8. Тестовый запуск nginx

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=NodePort
kubectl get svc,pods -o wide
```

---

# Задание 2* — HA-кластер (3 master + 2 worker)

Требования: нечётное число master (3), cluster IP через keepalived.

## Роли
- **Master:** k8s-cp, k8s-w1, k8s-w2
- **Worker:** k8s-w3, k8s-w4
- **VIP (cluster IP):** `192.168.89.100`

## Шаг A. keepalived на 3 мастерах

```bash
apt-get install keepalived
# файлы готовы: keepalived/keepalived.conf.{cp,w1,w2}
cp keepalived/keepalived.conf.<роль> /etc/keepalived/keepalived.conf
systemctl enable --now keepalived
ip addr show eth0   # VIP должен быть на MASTER (k8s-cp)
```

## Шаг B. kubeadm init с control-plane endpoint (на k8s-cp)

```bash
kubeadm init \
  --control-plane-endpoint=192.168.89.100:6443 \
  --upload-certs \
  --pod-network-cidr=10.10.0.0/16 \
  --kubernetes-version=1.36.1 \
  --image-repository=registry.altlinux.org/p11 \
  --ignore-preflight-errors=Swap
```
Сохранить ОБЕ команды join (для control-plane и для worker).

## Шаг C. Добавить мастера k8s-w1, k8s-w2

```bash
kubeadm join 192.168.89.100:6443 \
  --token <токен> \
  --discovery-token-ca-cert-hash sha256:<хэш> \
  --control-plane \
  --certificate-key <key> \
  --ignore-preflight-errors=Swap
```

## Шаг D. Добавить workers k8s-w3, k8s-w4 (без --control-plane)

```bash
kubeadm join 192.168.89.100:6443 \
  --token <токен> \
  --discovery-token-ca-cert-hash sha256:<хэш> \
  --ignore-preflight-errors=Swap
```

## Шаг E. CNI Calico + проверка HA

```bash
kubectl apply -f <calico-manifest.yaml>        # согласовать IPPool: 10.10.0.0/16
kubectl get nodes -o wide                        # 3 master Ready, 2 worker Ready
# тест отказоустойчивости: остановить kubelet на k8s-cp -> VIP уходит на BACKUP
```

---

## Файлы этого раздела
- [`PLAN_k8s_cluster.md`](PLAN_k8s_cluster.md) — полный план
- [`scripts/setup_k8s_node.sh`](scripts/setup_k8s_node.sh) — установка k8s + CRI-O на ноде
- [`scripts/init_cp.sh`](scripts/init_cp.sh) — kubeadm init (1 мастер, Calico 10.10.0.0/16)
- [`scripts/init_cp_ha.sh`](scripts/init_cp_ha.sh) — kubeadm init HA (3 мастера, VIP)
- [`scripts/fix_pause_image.sh`](scripts/fix_pause_image.sh) — устранение ошибки pause-образа
- [`keepalived/keepalived.conf.{cp,w1,w2}`](keepalived/keepalived.conf.cp) — конфиги keepalived

---

# Устранение неполадок

## Ошибка preflight: `manifest unknown` для `registry.altlinux.org/p11/pause:3.10.2`

Симптом:
```text
[WARNING] detected that the sandbox image "registry.k8s.io/pause:3.10.1" of the container runtime
          is inconsistent ... recommended to use "registry.altlinux.org/p11/pause:3.10.2"
[ERROR ImagePull]: failed to pull image registry.altlinux.org/p11/pause:3.10.2:
  reading manifest ... manifest unknown
```

Причина: CRI-O настроен на `registry.k8s.io/pause:3.10.1`, а kubeadm 1.36.1 хочет
`registry.altlinux.org/p11/pause:3.10.2`, которого **нет в реестре Alt**.

Решение (на КАЖДОЙ ноде до `kubeadm init/join`):
```bash
./scripts/fix_pause_image.sh        # задаёт CRI-O pause_image на существующий тег Alt и рестартит crio
```
Скрипт: `crictl pull registry.altlinux.org/p11/pause:<тег>` → правит `/etc/crio/crio.conf`
(`[crio.image] pause_image`) → `systemctl restart crio`.

Если kubeadm всё равно требует `pause:3.10.2` — локально добавить тег к существующему образу:
```bash
skopeo copy docker://registry.altlinux.org/p11/pause:3.10.1 \
       containers-storage:registry.altlinux.org/p11/pause:3.10.2
```

> Прочие предупреждения (`Swap`, `cgroup v2`) не фатальны — у нас уже задано
> `--ignore-preflight-errors=Swap` и kubelet настроен через `disable_swap_node.sh`.

---

## Ошибка init: `wait-control-plane: ... context deadline exceeded`

Симптом:
```text
error execution phase wait-control-plane: cannot obtain client without bootstrap:
  could not bootstrap the admin user ... unable to create ClusterRoleBinding:
  client rate limiter Wait returned an error: context deadline exceeded
```

Причина: **API-сервер не стал Ready в отведённое время**, поэтому kubeadm не смог
создать ClusterRoleBinding. Обычно из-за того, что control-plane статические поды
(etcd, kube-apiserver) не запустились — либо kubelet не работает, либо образы ещё не
скачаны/поды падают.

Диагностика (на k8s-cp):
```bash
systemctl is-active kubelet                       # должен быть active
journalctl -u kubelet -n 100 --no-pager           # ошибки kubelet
ls /etc/kubernetes/manifests/                     # статик-манифесты (etcd, apiserver...)
crictl ps -a                                      # какие контейнеры запущены/ошибки
crictl images | grep -E 'apiserver|etcd|controller|scheduler'
# если контейнер есть — смотреть логи
crictl logs <container-id>
```

Типичные причины и решения:
1. **⚠️ Нет доступа к `/dev/kmsg` в контейнере (главная причина в LXC)**. kubelet падает сразу.
   Симптомы:
   - узла `/dev/kmsg` нет → `open /dev/kmsg: no such file or directory`;
   - узел есть, но доступ запрещён device-cgroup → `open /dev/kmsg: operation not permitted`.
   static-pods (etcd/apiserver) не запускаются, `crictl ps -a` пусто.

   > ⚠️ **Хост на cgroup v2**: у устройства нет файла `devices.allow`, фильтрация идёт через
   > eBPF. Поэтому подход «bind-mount + разрешить устройство скриптом на хосте»
   > ([`scripts/allow_devices_host.sh`](scripts/allow_devices_host.sh)) **НЕ работает** —
   > этот скрипт оставлен только как диагностика для cgroup v1.

   **Рабочее решение** — подменить `/dev/kmsg` на симлинк к `/dev/null`
   (открытие `/dev/null`, major 1 minor 3, разрешено по умолчанию). Это делает
   **скрипт внутри каждой ноды** [`scripts/fix_kmsg_node.sh`](scripts/fix_kmsg_node.sh):
   ```bash
   # ВНУТРИ каждой ноды от root:
   ./scripts/fix_kmsg_node.sh
   ```
   Что делает скрипт:
   - снимает остаточный bind-mount `/dev/kmsg` (если был проброшен из старого XML);
   - удаляет реальную ноду и создаёт `ln -sf /dev/null /dev/kmsg`;
   - пишет постоянство в `/etc/tmpfiles.d/kmsg.conf` (восстановится при пересоздании `/dev`);
   - перезапускает kubelet.

   ВАЖНО: из конфигов удалён bind-mount `/dev/kmsg` (симлинк не ложится на точку монтирования),
   оставлен только проброс `/dev/kvm`. Правки уже внесены в `lxc-k8s-*.xml` и шаблон.
   После правки XML переопределить и перезапустить контейнер:
   ```bash
   virsh -c lxc:/// destroy k8s-cp
   virsh -c lxc:/// undefine k8s-cp
   virsh -c lxc:/// define lxc-k8s-cp.xml
   virsh -c lxc:/// start k8s-cp
   ```
   Внутри ноды проверить:
   ```bash
   ls -l /dev/kmsg                      # симлинк на /dev/null
   cat /dev/kmsg > /dev/null            # без "operation not permitted"
   systemctl is-active kubelet          # active
   ```
2. **kubelet падает на старте ContainerManager из-за read-only `/proc/sys`**. Симптом в журнале:
   ```text
   kubelet.go:1821] "Failed to start ContainerManager"
     err="[open /proc/sys/vm/overcommit_memory: read-only file system,
           open /proc/sys/kernel/panic: read-only file system,
           open /proc/sys/kernel/panic_on_oops: read-only file system]"
   ```
   Причина: внутри LXC `/proc/sys` смонтирован **read-only**, а kubelet
   (`SetupKernelTunables`) хочет записать ожидаемые значения. Ключевой момент: kubelet
   **читает** значение и пишет **только если оно не совпадает** с желаемым
   (`vm.overcommit_memory=1`, `kernel.panic=10`, `kernel.panic_on_oops=1`). Поэтому эти
   **глобальные** sysctl достаточно выставить на **хосте** — тогда kubelet в нодах
   прочитает совпадение и пропустит запись.
   Решение — скрипт на ХОСТЕ [`scripts/fix_sysctl_host.sh`](scripts/fix_sysctl_host.sh):
   ```bash
   # на хосте (shoellin, где libvirt), от root:
   sudo ./scripts/fix_sysctl_host.sh
   # затем на всех нодах:
   for f in {1..5}; do
     ssh -i ~/.ssh/id_kvm_host root@192.168.89.1$f \
       'systemctl restart kubelet && systemctl is-active kubelet'
   done
   ```
3. **kubelet не активен** → `systemctl enable --now kubelet`; проверить флаги
   (`--fail-swap-on=false` из `disable_swap_node.sh`).
4. **Образы control plane не скачаны** → предварительно:
   ```bash
   kubeadm config images pull \
     --image-repository=registry.altlinux.org/p11 \
     --kubernetes-version=1.36.1
   ```
5. **etcd/apiserver падают** → смотреть `crictl logs <id>`; частые причины в LXC —
   права на hostPath `/var/lib/etcd`, `/etc/kubernetes`, сеть 6443.
6. **Повторный init**: кластер частично создан → сбросить и повторить:
   ```bash
   kubeadm reset -f
   rm -rf /etc/kubernetes /var/lib/etcd /var/lib/kubelet
   kubeadm init ...
   ```

---

## ⚙️ Сводка всех исправлений для Kubernetes ВНУТРИ LXC (libvirt, cgroup v2)

> Проверено на 5 LXC (Alt Linux p11) на хосте Arch (libvirt, cgroup v2). Это — цепочка
> проблем вложенной виртуализации, которые НУЖНО пройти, чтобы `kubeadm init` завершился
> и поды заработали. Итог: кластер из 1 control-plane + 4 worker, Calico 10.10.0.0/16,
> все 5 нод Ready, nginx работает (NodePort HTTP 200, ClusterIP).

### 1. pause-образ (manifest unknown)
`registry.altlinux.org/p11/pause:3.10.2` неизвестен в репозитории. Решение — `fix_pause_image.sh`:
указать существующий `pause:3.10.1` в CRI-O и добавить локальный тег `3.10.2` через `skopeo copy`.

### 2. `/dev/kmsg` блокируется device-cgroup (cgroup v2)
Реальное `/dev/kmsg` недоступно (eBPF-фильтр libvirt), kubelet падает `open /dev/kmsg: operation not permitted`.
**Рабочее решение** — подмена на симлинк к `/dev/null` внутри ноды ([`scripts/fix_kmsg_node.sh`](scripts/fix_kmsg_node.sh)).
Bind-mount `/dev/kmsg` из XML **удалён** (симлинк не ложится на точку монтирования).

### 3. kubelet падает: ContainerManager, read-only `/proc/sys`
```
Failed to start ContainerManager:
  open /proc/sys/vm/overcommit_memory: read-only file system
```
Kubelet **читает** значения и пишет только если они не совпадают. Достаточно выставить
**глобальные** sysctl на хосте: [`scripts/fix_sysctl_host.sh`](scripts/fix_sysctl_host.sh)
(`vm.overcommit_memory=1`, `kernel.panic=10`, `kernel.panic_on_oops=1`).

### 4. crun: `bpf attach: Operation not permitted` (device-BPF)
CRI-O инжектит deny-all правило устройств (`allow:false rwm`) → crun обязан прикрепить
cgroup_device-BPF, а вложенно под libvirt attach даёт `EPERM`. Диагностировано strace:
`BPF_PROG_LOAD = 6`, но `BPF_PROG_ATTACH = EPERM`.
**Решение** — runtime-wrapper, который вырезает `linux.resources.devices`/`linux.devices`
из OCI-bundle перед запуском crun (см. [`scripts/fix_runtime_nested.sh`](scripts/fix_runtime_nested.sh),
бинарник `/usr/local/bin/crun-nobpf`). Безопасно: внешний libvirt всё равно ограничивает устройства.

### 5. контроллер `pids` недоступен при systemd-менеджере
После обхода BPF crun падал: `controller pids is not available under ...`.
**Решение** — перевести CRI-O и kubelet на **cgroupfs** драйвер (`cgroup_manager="cgroupfs"`,
`--cgroup-driver=cgroupfs`).

### 6. kube-proxy: `nf_conntrack_max: no such file or directory`
В LXC модуль `nf_conntrack` не загружен → в `/proc/sys/net/netfilter/` нет контракт-систклтов.
Без kube-proxy не работает Service ClusterIP (10.96.0.1), ломая и Calico install-cni.
**Решение** — в ConfigMap `kube-proxy` выставить `conntrack.maxPerCore: 0`, `min: 0`,
`tcpEstablishedTimeout: 0s`, `tcpCloseWaitTimeout: 0s` (kube-proxy пропускает запись sysctl).

### 7. Calico CNI: `/proc/sys/net/ipv4/ip_forward: read-only file system`
libvirt монтирует `/proc/sys` внутри LXC как **ro**; Calico не может выставить sysctl в netns подов.
**Решение** — `mount -o remount,rw /proc/sys` + systemd-unit `proc-sys-rw.service`
(включён в [`scripts/fix_runtime_nested.sh`](scripts/fix_runtime_nested.sh)) для персистентности.

### 8. Calico `mount-bpffs`: `/sys/fs` не является shared mount
В iptables-режиме BPF-fs не нужен → из DaemonSet `calico-node` удалён init-container
`mount-bpffs` и выставлено `FELIX_BPFFSENABLED=false` (jq-патч live-объекта).

### 9. MemoryPressure=True на всех нодах (ложное срабатывание)
Из-за `Committed_AS` (глобально на хосте) > небольшого лимита памяти ноды kubelet считает
`memory.available ≈ 0` → MemoryPressure + taint `memory-pressure:NoSchedule`, поды не планируются.
Рабочий working-set в root-cgroup ноды превышал лимит.
**Решение** — поднять память ВСЕХ нод до **14 GiB** (`<memory unit='KiB'>14680064</memory>`,
шаблон `{{ memory_kib | default(14680064) }}`), чтобы capacity > working-set и `MemTotal > Committed_AS`.
Также снят control-plane taint (мастер хостит system-поды).

### 10. Короткое имя образа nginx → ImageInspectError
CRI-O со strict short-name не резолвит `nginx:alpine` (`short name mode is enforcing ... ambiguous`).
**Решение** — использовать полностью квалифицированное имя: `docker.io/library/nginx:alpine`.

### Проверка итога
```bash
kubectl get nodes                    # 5x Ready
kubectl get pods -A -o wide          # coredns/calico/kube-proxy Running
kubectl create deployment nginx-test --image=docker.io/library/nginx:alpine --replicas=3
kubectl expose deployment nginx-test --port=80 --type=NodePort
curl http://192.168.89.11:<NodePort>/   # HTTP 200 (Welcome to nginx)
```