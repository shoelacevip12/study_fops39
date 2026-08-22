# Домашнее задание к занятию «`Базовые объекты K8S`» `Скворцов Денис`

## Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Pod с приложением и подключиться к нему со своего локального компьютера.

------

## Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).

```bash
# Поиск пакета kind (Kubernetes IN Docker) в репозиториях
sudo pacman -Ss kind | grep -B1 Docker
```

<details>
<summary>
поиск пакета kind
</summary>

```log
extra/kind 0.32.0-2
    Kubernetes IN Docker - local clusters for testing Kubernetes
```

</details>

```bash
# Обновление и установка пакета kind
sudo pacman -Syu kind
```

<details>
<summary>
установка kind
</summary>

```log
Пакеты (1) kind-0.32.0-2

Будет установлено:  10,14 MiB

:: Приступить к установке? [Y/n] Y
(1/1) проверка ключей                                                                [################################################] 100%
(1/1) проверка целостности пакета                                                    [################################################] 100%
(1/1) загрузка файлов пакетов                                                        [################################################] 100%
(1/1) проверка конфликтов файлов                                                     [################################################] 100%
(1/1) проверка доступного места                                                      [################################################] 100%
:: Обработка изменений пакета...
(1/1) установка kind                                                                 [################################################] 100%
Дополнительные зависимости для 'kind'
    docker: docker node provider [установлено]
    podman: podman node provider [установлено]
    nerdctl: nerdctl node provider
:: Запуск post-transaction hooks...
(1/1) Arming ConditionNeedsUpdate...
```

</details>

```bash
# Добавление модуля overlay в систему
echo 'overlay' \
| sudo tee /etc/modules-load.d/overlay.conf

# Пересборка initramfs образов
sudo mkinitcpio -P
```

<details>
<summary>
пересборка initramfs
</summary>

```log
overlay

==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'default'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux -g /boot/initramfs-linux.img
==> Starting build: '7.1.8-arch1-3'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
  -> Running build hook: [autodetect]
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
  -> Running build hook: [keyboard]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux.img'
  -> Early uncompressed CPIO image generation successful
==> Initcpio image generation successful
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'fallback'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux -g /boot/initramfs-linux-fallback.img -S autodetect
==> Starting build: '7.1.8-arch1-3'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
  -> Running build hook: [keyboard]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-fallback.img'
  -> Early uncompressed CPIO image generation successful
==> Initcpio image generation successful
==> Building image from preset: /etc/mkinitcpio.d/linux-zen.preset: 'default'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux-zen -g /boot/initramfs-linux-zen.img
==> Starting build: '7.1.8-zen1-3-zen'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
  -> Running build hook: [autodetect]
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
  -> Running build hook: [keyboard]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-zen.img'
  -> Early uncompressed CPIO image generation successful
==> Initcpio image generation successful
==> Building image from preset: /etc/mkinitcpio.d/linux-zen.preset: 'fallback'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux-zen -g /boot/initramfs-linux-zen-fallback.img -S autodetect
==> Starting build: '7.1.8-zen1-3-zen'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
  -> Running build hook: [keyboard]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-zen-fallback.img'
  -> Early uncompressed CPIO image generation successful
==> Initcpio image generation successful
```

</details>

```bash
sudo reboot
```

```bash
# Проверка загрузки модуля overlay
sudo lsmod \
| grep overlay
```

<details>
<summary>
проверка модуля overlay
</summary>

```log
overlay               270336  0
```

</details>

```bash
# Запуск docker и проверка его активности
sudo bash -c "systemctl start docker && systemctl is-active docker"
```

<details>
<summary>
запуск и проверка docker
</summary>

```log
active
```

</details>

```bash
# Создание Kubernetes кластера в docker
kind create cluster
```

<details>
<summary>
создание кластера kind
</summary>

```log
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.36.1) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Have a question, bug, or feature request? Let us know! https://kind.sigs.k8s.io/#community 🙂
```

</details>

```bash
# Просмотр всех подов кластера
kubectl get pods --all-namespaces -o wide
```

<details>
<summary>
просмотр подов кластера
</summary>

```log
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE     IP           NODE                 NOMINATED NODE   READINESS GATES
kube-system          coredns-589f44dc88-6zdxb                     1/1     Running   0          2m34s   10.244.0.2   kind-control-plane   <none>           <none>
kube-system          coredns-589f44dc88-9g4bt                     1/1     Running   0          2m34s   10.244.0.4   kind-control-plane   <none>           <none>
kube-system          etcd-kind-control-plane                      1/1     Running   0          2m41s   172.18.0.2   kind-control-plane   <none>           <none>
kube-system          kindnet-ndzbz                                1/1     Running   0          2m34s   172.18.0.2   kind-control-plane   <none>           <none>
kube-system          kube-apiserver-kind-control-plane            1/1     Running   0          2m41s   172.18.0.2   kind-control-plane   <none>           <none>
kube-system          kube-controller-manager-kind-control-plane   1/1     Running   0          2m41s   172.18.0.2   kind-control-plane   <none>           <none>
kube-system          kube-proxy-znw4b                             1/1     Running   0          2m34s   172.18.0.2   kind-control-plane   <none>           <none>
kube-system          kube-scheduler-kind-control-plane            1/1     Running   0          2m41s   172.18.0.2   kind-control-plane   <none>           <none>
local-path-storage   local-path-provisioner-855c7b7774-9wkl5      1/1     Running   0          2m34s   10.244.0.3   kind-control-plane   <none>           <none>
```

</details>

```bash
# Просмотр docker контейнеров
docker ps -a
```

<details>
<summary>
просмотр docker контейнеров
</summary>

```log
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                       NAMES
03fc4d32ddd6   kindest/node:v1.36.1   "/usr/local/bin/entr…"   7 minutes ago   Up 7 minutes   127.0.0.1:43853->6443/tcp   kind-control-plane
```

</details>

```bash
# Вход в контейнер kind-control-plane и проверка параметров
docker exec -it kind-control-plane bash
```

<details>
<summary>
вход в контейнер kind-control-plane
</summary>

```log
root@kind-control-plane:/# hostname
kind-control-plane
root@kind-control-plane:/# hostname -i
fc00:f853:ccd:e793::2 172.18.0.2
root@kind-control-plane:/# whoami
root
root@kind-control-plane:/# exit
exit
[shoel@shoellin 21_1]$
```

</details>

```bash
# Просмотр нод кластера
kubectl get no -o wide
```

<details>
<summary>
просмотр нод кластера
</summary>

```log
NAME                 STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                       KERNEL-VERSION             CONTAINER-RUNTIME
kind-control-plane   Ready    control-plane   23m   v1.36.1   172.18.0.2    <none>        Debian GNU/Linux 13 (trixie)   7.1.8-zen1-3-zen (amd64)   containerd://2.3.1
```

</details>

1. Установленный локальный kubectl.

```bash
# Поиск пакета kubectl в репозиториях
sudo pacman -Ss kubectl
```

<details>
<summary>
поиск пакета kubectl
</summary>

```log
extra/krew 0.5.0-1 (kubectl-plugins)
    Find and install kubectl plugins
extra/kubectl 1.36.3-1 (kubernetes-tools) [установлен]
    A command line tool for communicating with a Kubernetes API server
extra/kubectl-cert-manager 1.13.3-2 (kubectl-plugins)
    Automatically provision and manage TLS certificates in Kubernetes
extra/kubectl-ingress-nginx 1.12.0-2 (kubectl-plugins)
    kubectl plugin for managing NGINX Ingress Controller for Kubernetes
extra/kubectx 0.11.0-1
    Utility to manage and switch between kubectl contexts and Kubernetes namespaces
```

</details>

```bash
# Обновление и установка пакета kubectl
sudo pacman -Syu kubectl
```

<details>
<summary>
установка kubectl
</summary>

```log
Будет установлено:  85,08 MiB

:: Приступить к установке? [Y/n] Y
(1/1) проверка ключей                                                                [################################################] 100%
(1/1) проверка целостности пакета                                                    [################################################] 100%
(1/1) загрузка файлов пакетов                                                        [################################################] 100%
(1/1) проверка конфликтов файлов                                                     [################################################] 100%
(1/1) проверка доступного места                                                      [################################################] 100%
:: Обработка изменений пакета...
(1/1) установка kubectl                                                              [################################################] 100%
:: Запуск post-transaction hooks...
(1/1) Arming ConditionNeedsUpdate...
```

</details>

```bash
# Проверка версии установленного kubectl
kubectl version --client
```

```log
Client Version: v1.36.3
Kustomize Version: v5.8.1
```

1. Редактор YAML-файлов с подключенным Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Описание [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) и примеры манифестов.
2. Описание [Service](https://kubernetes.io/docs/concepts/services-networking/service/).

------

### Задание 1. Создать Pod с именем hello-world

1. Создать манифест (yaml-конфигурацию) Pod.
2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

![](./img/1.png)

------

### Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.
2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Создать Service с именем netology-svc и подключить к netology-web.
4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

![](./img/2.png) ![](./img/3.png)

```bash
# Просмотр всех подов и сервисов во всех namespace
kubectl get pods -A \
&& kubectl get svc -A
```

```log
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE
default              hello-world                                  1/1     Running   0          30m
kube-system          coredns-589f44dc88-6zdxb                     1/1     Running   0          123m
kube-system          coredns-589f44dc88-9g4bt                     1/1     Running   0          123m
kube-system          etcd-kind-control-plane                      1/1     Running   0          123m
kube-system          kindnet-ndzbz                                1/1     Running   0          123m
kube-system          kube-apiserver-kind-control-plane            1/1     Running   0          123m
kube-system          kube-controller-manager-kind-control-plane   1/1     Running   0          123m
kube-system          kube-proxy-znw4b                             1/1     Running   0          123m
kube-system          kube-scheduler-kind-control-plane            1/1     Running   0          123m
local-path-storage   local-path-provisioner-855c7b7774-9wkl5      1/1     Running   0          123m

NAMESPACE     NAME              TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                  AGE
default       hello-world-svc   ClusterIP   10.96.105.1   <none>        80/TCP                   20m
default       kubernetes        ClusterIP   10.96.0.1     <none>        443/TCP                  123m
kube-system   kube-dns          ClusterIP   10.96.0.10    <none>        53/UDP,53/TCP,9153/TCP   123m
```

------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода команд `kubectl get pods`, а также скриншот результата подключения.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------

### Критерии оценки

Зачёт — выполнены все задания, ответы даны в развернутой форме, приложены соответствующие скриншоты и файлы проекта, в выполненных заданиях нет противоречий и нарушения логики.

На доработку — задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки.
