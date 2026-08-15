# Для домашнего задания 21.1 `Базовые объекты K8S`

## commit_72, master Предварительная подготовка

```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master
```

<details>
<summary>
переход на master
</summary>

```log
Уже на «master»
```

</details>

```bash
# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/kuber-homeworks.git

# Удаление всех файлов и каталогов кроме нужных
find kuber-homeworks/ \
-mindepth 1 \
-not -path "*1.2*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем
mv -v kuber-homeworks \
21_1

# Переход в каталог по последней переменной вывода последней команды
cd !$
```

```bash
# Просмотр текущих удаленных репозиториев
git remote -v

# Проверка текущего локального состояния репозитория
git status

git rm -r --cached \
../

git remote -v

# Добавляем ключи агенту ssh от репозитория gitflic и github
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_gitflic_2026_ed25519 \
&& ssh-add ~/.ssh/id_github_2026_ed25519 \
&& ssh-agent -c

# Просмотр различий в рабочей директории и индексов
git diff \
&& git diff --staged

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

git diff \
&& git diff --staged

# Просмотр истории коммитов в кратком формате
git log --oneline

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий
git commit -am 'commit_72, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master \
&& git push \
--set-upstream \
study-fops39_sc \
master
```

## commit_1, `21_1-pods-bases`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 21_1-pods-bases

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавляем ключи агенту ssh от репозитория gitflic и github
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_gitflic_2026_ed25519 \
&& ssh-add ~/.ssh/id_github_2026_ed25519 \
&& ssh-agent -c

# Просмотр различий в рабочей директории и индексов
git diff \
&& git diff --staged

git rm -r --cached \
./ ../

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit1, 21_1-pods-bases' \
&& git push \
--set-upstream \
study_fops39 \
21_1-pods-bases \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_1-pods-bases \
&& git push \
--set-upstream \
study-fops39_sc \
21_1-pods-bases
```

## commit_2,`21_1-pods-bases`

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

<details>
<summary>
проверка версии kubectl
</summary>

```log
Client Version: v1.36.3
Kustomize Version: v5.8.1
```

</details>

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
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit1, 21_1-pods-bases' \
&& git push \
--set-upstream \
study_fops39 \
21_1-pods-bases \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_1-pods-bases \
&& git push \
--set-upstream \
study-fops39_sc \
21_1-pods-bases
```

## commit_3,`21_1-pods-bases`

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

### `Yaml`-файл описания модуля pod hello-world

<details>
<summary>
Yaml-файл описания модуля pod
</summary>

```bash
cat > echoserver.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: hello-world
  labels:
    role: den-hello-world
    app: my-test-hello-world-pod
    organization: my-test-org
    creator: denskv
spec:
  containers:
  - name: some-name-of-echoserver
    image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
    ports:
    - name: some-app-port
      containerPort: 8080
EOF
```

</details>

```bash
# Создание пода из Yaml-файла
kubectl create -f ./echoserver.yaml
```

<details>
<summary>
создание пода hello-world
</summary>

```log
pod/hello-world created
```

</details>

```bash
# Просмотр подов в namespace default
kubectl get pods -n default
```

<details>
<summary>
просмотр подов в default
</summary>

```log
NAME          READY   STATUS    RESTARTS   AGE
hello-world   1/1     Running   0          103s
```

</details>

```bash
# Проброс портов к поду hello-world
kubectl port-forward hello-world 8082:8080 --address='0.0.0.0' &
```

<details>
<summary>
проброс портов к поду
</summary>

```log
[1] 111779
Forwarding from 0.0.0.0:8082 -> 8080
Handling connection for 8082
Handling connection for 8082
```

</details>

```bash
# Проверка прослушиваемого порта 8082
ss -tlpn | grep 8082
```

<details>
<summary>
проверка проброшенного порта
</summary>

```log
LISTEN 0      4096         0.0.0.0:8082       0.0.0.0:*    users:(("kubectl",pid=111779,fd=8))
```

</details>

```bash
# Проверка работы пода через проброшенный порт
curl 127.0.0.1:8082
```

<details>
<summary>
обращение к поду через curl
</summary>

```log
Hostname: hello-world

Pod Information:
        -no pod information available-

Server values:
        server_version=nginx: 1.12.2 - lua: 10010

Request Information:
        client_address=127.0.0.1
        method=GET
        real path=/
        query=
        request_version=1.1
        request_scheme=http
        request_uri=http://127.0.0.1:8080/

Request Headers:
        accept=*/*
        host=127.0.0.1:8082
        user-agent=curl/8.21.0

Request Body:
        -no body in request-
```

</details>

```bash
# Возврат фонового задания проброса портов на передний план
fg

# Прерывание работы kubectl port-forward
# CTRL+C
```

### `Yaml`-файл описания модуля service hello-world-svc

<details>
<summary>
Yaml-файл описания модуля service для приложения hello-world
</summary>

```bash
cat > echoserver_svc.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: hello-world-svc
  labels:
    role: den-hello-world
    organization: my-test-org
    creator: denskv
spec:
  selector:
    app: my-test-hello-world-pod
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: 8080
EOF
```

</details>

```bash
# Применение Yaml-файла описания сервиса
kubectl apply -f ./echoserver_svc.yaml
```

<details>
<summary>
создание сервиса hello-world-svc
</summary>

```log
service/hello-world-svc created
```

</details>

```bash
# Просмотр сервиса и подов с меткой role=den-hello-world
kubectl get svc -l role=den-hello-world \
&& kubectl get po -l role=den-hello-world
```

<details>
<summary>
просмотр сервиса и подов
</summary>

```log
NAME              TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
hello-world-svc   ClusterIP   10.96.105.1   <none>        80/TCP    64s
NAME          READY   STATUS    RESTARTS   AGE
hello-world   1/1     Running   0          11m
```

</details>

```bash
# Просмотр всех подов и сервисов во всех namespace
kubectl get pods -A \
&& kubectl get svc -A
```

<details>
<summary>
просмотр всех подов и сервисов
</summary>

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

</details>

```bash
# Удаление пода и сервиса из Yaml-файлов
for del in echoserver{,_svc}.yaml; \
do kubectl delete -f $del; done
```

<details>
<summary>
удаление пода и сервиса
</summary>

```log
pod "hello-world" deleted from default namespace
service "hello-world-svc" deleted from default namespace
```

</details>

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit3, 21_1-pods-bases' \
&& git push \
--set-upstream \
study_fops39 \
21_1-pods-bases \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_1-pods-bases \
&& git push \
--set-upstream \
study-fops39_sc \
21_1-pods-bases
```

## commit_73, master

```bash
cd ..

git checkout master

git branch -v

git merge 21_1-pods-bases

git branch -v

git status

git diff \
&& git diff \
--staged

git add . \
&& git status

git log --oneline

git commit -am 'commit_74, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master \
&& git push \
--set-upstream \
study-fops39_sc \
master

git add . \
&& git status \
&& git commit --amend --no-edit \
&& git push \
--set-upstream \
study_fops39 \
master --force \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master --force
```