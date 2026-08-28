# План установки Kubernetes на 5 LXC-нодах (Alt Linux p11)

Основа: руководство [https://www.altlinux.org/Kubernetes](https://www.altlinux.org/Kubernetes)
(локальная копия `Kubernetes.htm`). Текущее состояние инфраструктуры см. в `README.md`/`README1.md`.

## Ноды (статические IP, мост br0, nested virt, свой rootfs)

| Роль (Задание 1) | Имя    | IP             | rootfs                    |
|------------------|--------|----------------|---------------------------|
| master           | k8s-cp | 192.168.89.11  | /disk/VMs/k8s-cp/rootfs   |
| worker           | k8s-w1 | 192.168.89.12  | /disk/VMs/k8s-w1/rootfs   |
| worker           | k8s-w2 | 192.168.89.13  | /disk/VMs/k8s-w2/rootfs   |
| worker           | k8s-w3 | 192.168.89.14  | /disk/VMs/k8s-w3/rootfs   |
| worker           | k8s-w4 | 192.168.89.15  | /disk/VMs/k8s-w4/rootfs   |

## ✅ Решение по CRI — CRI-O (по руководству Alt)

- Выбран **CRI-O** (`kubernetes1.36-crio`, сокет `unix:///var/run/crio/crio.sock`).
- Ноды уже подготовлены под crio (`prepare_crio_node.sh`, iptables/nftables).
- В `kubeadm init/join` и конфиге `criSocket` используем `unix:///var/run/crio/crio.sock`.
- (Если позже потребуется строго containerd — доустановить `containerd` и сменить `criSocket`
  на `unix:///var/run/containerd/containerd.sock`; шаги ниже рассчитаны на crio.)

---

## Задание 1 — кластер 1 master + 4 worker (CRI: CRI-O)

### Шаг 0. Подготовка нод
- swap off: `./scripts/disable_swap_node.sh` (внутри каждой ноды)
- iptables/nftables для CRI: `./scripts/prepare_crio_node.sh` (внутри каждой ноды)
- уникальный hostname у всех ✓ (задаётся при клонировании rootfs)
- взаимное разрешение имён: добавить записи в `/etc/hosts` каждой ноды:
  ```
  192.168.89.11 k8s-cp
  192.168.89.12 k8s-w1
  192.168.89.13 k8s-w2
  192.168.89.14 k8s-w3
  192.168.89.15 k8s-w4
  ```

### Шаг 1. Установка пакетов (на ВСЕХ нодах) — k8s 1.36
```bash
apt-get install kubernetes1.36-kubeadm kubernetes1.36-kubelet kubernetes1.36-crio cri-tools1.36
```
Если выбран containerd: `apt-get install containerd` и настроить `/etc/containerd/config.toml`
(plugins.cri.systemd_cgroup = true), затем `systemctl enable --now containerd`.

### Шаг 2. Запуск служб (на ВСЕХ нодах)
```bash
systemctl enable --now crio      # или containerd
systemctl enable kubelet
```

### Шаг 3. Инициализация мастера (на k8s-cp) — Calico, под-сеть 10.10.0.0/16
```bash
kubeadm init \
  --pod-network-cidr=10.10.0.0/16 \
  --kubernetes-version=1.36.1 \
  --image-repository=registry.altlinux.org/p11
```

В конце вывода появится команда `kubeadm join ...` — сохранить.

### Шаг 4. kubectl для пользователя (на k8s-cp)
```bash
mkdir -p ~/.kube
cp /etc/kubernetes/admin.conf ~/.kube/config
kubectl get nodes
```

### Шаг 5. CNI (Calico)
Манифесты: `https://altlinux.space/cloud/manifests/src/branch/master/calico/<platform=p11>`
```bash
kubectl apply -f <calico-manifest.yaml>
# согласовать IPPool с под-сетью (если в манифесте другой CIDR):
kubectl -n kube-system get ippool -o yaml   # при необходимости задать cidr: 10.10.0.0/16
```

### Шаг 6. Присоединение рабочих нод (k8s-w1..w4)
```bash
kubeadm join 192.168.89.11:6443 \
  --token <токен> \
  --discovery-token-ca-cert-hash sha256:<хэш>
```

### Шаг 7. Проверка
```bash
kubectl get nodes -o wide
kubectl get pods -A
```

### Шаг 8. Тестовый запуск nginx (по руководству)
```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=NodePort
```

---

## Задание 2* — HA-кластер (3 master + 2 worker)

Требование: нечётное число master (3), cluster IP через keepalived.

### Роли
| Master            | Worker |
|-------------------|--------|
| k8s-cp, k8s-w1, k8s-w2 | k8s-w3, k8s-w4 |

### Шаг A. keepalived на 3 мастерах (VIP)
Установить `keepalived` на k8s-cp, k8s-w1, k8s-w2, VIP например `192.168.89.100`.
Конфиг `/etc/keepalived/keepalived.conf` (пример):
```conf
vrrp_instance VI_1 {
    state MASTER            # k8s-cp: MASTER; k8s-w1/w2: BACKUP
    interface eth0
    virtual_router_id 51
    priority 100            # cp=100, w1=90, w2=80
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass k8svip
    }
    virtual_ipaddress { 192.168.89.100/24 dev eth0 }
}
```
`systemctl enable --now keepalived`

### Шаг B. kubeadm init с control-plane endpoint (на k8s-cp) — Calico, под-сеть 10.10.0.0/16
```bash
kubeadm init \
  --control-plane-endpoint=192.168.89.100:6443 \
  --upload-certs \
  --pod-network-cidr=10.10.0.0/16 \
  --kubernetes-version=1.36.1 \
  --image-repository=registry.altlinux.org/p11
```
Сохранить обе команды (для control-plane и для worker).

### Шаг C. Добавить мастера k8s-w1, k8s-w2
```bash
kubeadm join 192.168.89.100:6443 \
  --token <токен> \
  --discovery-token-ca-cert-hash sha256:<хэш> \
  --control-plane \
  --certificate-key <key>
```

### Шаг D. Добавить workers k8s-w3, k8s-w4 (без --control-plane)
```bash
kubeadm join 192.168.89.100:6443 \
  --token <токен> \
  --discovery-token-ca-cert-hash sha256:<хэш>
```

### Шаг E. CNI + проверка HA
- Применить **Calico** (`.../calico/<platform=p11>`), согласовать IPPool с `10.10.0.0/16`.
- `kubectl get nodes`: 3 master Ready, 2 worker Ready.
- Тест отказоустойчивости: остановить kubelet на k8s-cp → VIP переедет на BACKUP, API доступен.

---

## Документирование
В `README.md` (или итоговый отчёт) включить:
- тексты манифестов (kubeadm-config.yaml, flannel, keepalived.conf, deployments);
- скриншоты `kubectl get nodes`, `kubectl get pods -A`;
- результат тестового деплоя nginx.