# Создание модулей POD через инструмент `kind`

## Установка на archlinux

### поиск в репозитории

```bash
sudo pacman -Ss kubectl
```

<details>
<summary>
Вывод доступных пакетов по поиску
</summary>

```log
[sudo] пароль для shoel: 
extra/krew 0.5.0-1 (kubectl-plugins)
    Find and install kubectl plugins
extra/kubectl 1.36.2-1 (kubernetes-tools)
    A command line tool for communicating with a Kubernetes API server
extra/kubectl-cert-manager 1.13.3-2 (kubectl-plugins)
    Automatically provision and manage TLS certificates in Kubernetes
extra/kubectl-ingress-nginx 1.12.0-2 (kubectl-plugins)
    kubectl plugin for managing NGINX Ingress Controller for Kubernetes
extra/kubectx 0.11.0-1
    Utility to manage and switch between kubectl contexts and Kubernetes namespaces
```

</details>

### Установка инструмента `kubectl` и обновление системы

```bash
sudo pacman -Syu kubectl
```

### Вывод версии инструмента `kubectl`

```bash
kubectl version --client
```

<details>
<summary>
Вывод доступных пакетов по поиску
</summary>

```log
Client Version: v1.36.2
Kustomize Version: v5.8.1
```

</details>

### установка kind

```bash
sudo pacman -Ss kind | grep -B1 Docker
```

<details>
<summary>
Вывод доступных пакетов по поиску
</summary>

```log
extra/kind 0.32.0-2
    Kubernetes IN Docker - local clusters for testing Kubernetes
```

</details>

```bash
sudo pacman -Syu kind
```

### Загрузить модуль overlay

```bash
echo 'overlay' \
| sudo tee /etc/modules-load.d/overlay.conf

sudo mkinitcpio -P
```

### [ОБЯЗАТЕЛЬНО]

#### Перезагрузка системы после обновления ядра и включения загрузки модуля в `/etc/modules-load.d/`

```bash
sudo reboot
```

### проверка модуля `overlay`

```bash
sudo lsmod \
| grep overlay
```

<details>
<summary>
Вывод доступных пакетов по поиску
</summary>

```log
overlay               270336  0
```

</details>

```bash
sudo systemctl start docker
```

```bash
sudo systemctl is-active docker
```

<details>
<summary>
Проверка статуса
</summary>

```log
active
```

</details>

## создание кластера в `kind`

```bash
kind create cluster
```

<details>
<summary>
создание учебного кластера
</summary>

```log
kind create cluster
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

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
```

</details>

### Получение списка модулей в кластере

```bash
kubectl get pods --all-namespaces
```

<details>
<summary>
создание учебного кластера
</summary>

```log
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE
kube-system          coredns-589f44dc88-bfc7d                     1/1     Running   0          75s
kube-system          coredns-589f44dc88-f7tlh                     1/1     Running   0          75s
kube-system          etcd-kind-control-plane                      1/1     Running   0          81s
kube-system          kindnet-lmmwq                                1/1     Running   0          75s
kube-system          kube-apiserver-kind-control-plane            1/1     Running   0          81s
kube-system          kube-controller-manager-kind-control-plane   1/1     Running   0          81s
kube-system          kube-proxy-2j6zm                             1/1     Running   0          75s
kube-system          kube-scheduler-kind-control-plane            1/1     Running   0          81s
local-path-storage   local-path-provisioner-855c7b7774-r2vjt      1/1     Running   0          75s
```

</details>

### Расположение Ноды Kubernetes

```bash
docker ps -a
```

<details>
<summary>
Нода мастера/control-plane
</summary>

```log
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                       NAMES
cd506faa6b65   kindest/node:v1.36.1   "/usr/local/bin/entr…"   6 minutes ago   Up 5 minutes   127.0.0.1:40377->6443/tcp   kind-control-plane
```

</details>

### Доступ к контейнеру и взаимодействие с контейнером `kind-control-plane`

```bash
docker exec -it kind-control-plane bash
```

<details>
<summary>
взаимодействие из-под контейнера
</summary>

```log
[shoel@shoellin 1_modules_pods]$ docker exec -it kind-control-plane bash
root@kind-control-plane:/# hostname 
kind-control-plane
root@kind-control-plane:/# hostname -i
fc00:f853:ccd:e793::2 172.18.0.2
root@kind-control-plane:/# whoami
root
root@kind-control-plane:/# exit
exit
[shoel@shoellin 1_modules_pods]$
```

</details>

## ТЕстовый модуль Pod `busybox:latest`

### `Yaml`-файл описания модуля


<details>
<summary>
Yaml-файл описания модуля
</summary>

```bash
cat > busybox.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: core-k8s
  labels:
    role: den-test-exmpl
    app: my-test-app
    organization: my-test-org
    creator: denskv
spec:
  containers:
    - name: some-name-of-busybox
      image: docker.io/busybox:latest
      command:
        - sleep
        - "3600"
      ports:
        - name: some-app-port
          containerPort: 80
          protocol: TCP
EOF
```

</details>

### отслеживание количества процессов до и после запуска pod

```bash
ps ax | wc -l
```

<details>
<summary>
количество процессов до запуска pod
</summary>

```log
337
```

</details>


```
```


```bash
# Просмотр текущих удаленных репозиториев
git remote -v

# Проверка текущего локального состояния репозитория
git status

git rm -r --cached \
../../

git remote -v

# Добавляем ключи агенту ssh от репозитория gitflic и github
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_gitflic_2026_ed25519 \
&& ssh-add ~/.ssh/id_github_2026_ed25519 \
&& ssh-agent -c

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. ../.. \
&& git status

git diff \
&& git diff --staged

# Просмотр истории коммитов в кратком формате
git log --oneline

git commit -am 'some_word_add_module_1' \
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