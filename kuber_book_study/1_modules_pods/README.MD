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

### Создание тестового модуля Pod `busybox:latest`

```bash
kubectl create -f  ./busybox.yaml
```


<details>
<summary>
лог создания Pod
</summary>

```log
pod/core-k8s created
```

</details>


```bash
ps ax | wc -l
```

<details>
<summary>
количество процессов после запуска pod
</summary>

```log
338
```

</details>


### Получение списка всех модулей Pod в кластере

```bash
kubectl get pods --all-namespaces
```

<details>
<summary>
Получение списка всех подов
</summary>

```log
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE
default              core-k8s                                     1/1     Running   0          2m23s
kube-system          coredns-589f44dc88-bfc7d                     1/1     Running   0          42m
kube-system          coredns-589f44dc88-f7tlh                     1/1     Running   0          42m
kube-system          etcd-kind-control-plane                      1/1     Running   0          42m
kube-system          kindnet-lmmwq                                1/1     Running   0          42m
kube-system          kube-apiserver-kind-control-plane            1/1     Running   0          42m
kube-system          kube-controller-manager-kind-control-plane   1/1     Running   0          42m
kube-system          kube-proxy-2j6zm                             1/1     Running   0          42m
kube-system          kube-scheduler-kind-control-plane            1/1     Running   0          42m
local-path-storage   local-path-provisioner-855c7b7774-r2vjt      1/1     Running   0          42m
```

</details>

### Исследование информации о модуле Pod `core-k8s`

```bash
kubectl get -o yaml pods
```

<details>
<summary>
Получение полной информации о модуле Pod `core-k8s`
</summary>

```yaml
apiVersion: v1
items:
- apiVersion: v1
  kind: Pod
  metadata:
    creationTimestamp: "2026-07-26T17:36:10Z"
    generation: 1
    labels:
      app: my-test-app
      creator: denskv
      organization: my-test-org
      role: den-test-exmpl
    name: core-k8s
    namespace: default
    resourceVersion: "3866"
    uid: d0ae856a-fd71-4309-9340-d0c68371b7f9
  spec:
    containers:
    - command:
      - sleep
      - "3600"
      image: docker.io/busybox:latest
      imagePullPolicy: Always
      name: some-name-of-busybox
      ports:
      - containerPort: 80
        name: some-app-port
        protocol: TCP
      resources: {}
      terminationMessagePath: /dev/termination-log
      terminationMessagePolicy: File
      volumeMounts:
      - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
        name: kube-api-access-h8q77
        readOnly: true
    dnsPolicy: ClusterFirst
    enableServiceLinks: true
    nodeName: kind-control-plane
    preemptionPolicy: PreemptLowerPriority
    priority: 0
    restartPolicy: Always
    schedulerName: default-scheduler
    securityContext: {}
    serviceAccount: default
    serviceAccountName: default
    terminationGracePeriodSeconds: 30
    tolerations:
    - effect: NoExecute
      key: node.kubernetes.io/not-ready
      operator: Exists
      tolerationSeconds: 300
    - effect: NoExecute
      key: node.kubernetes.io/unreachable
      operator: Exists
      tolerationSeconds: 300
    volumes:
    - name: kube-api-access-h8q77
      projected:
        defaultMode: 420
        sources:
        - serviceAccountToken:
            expirationSeconds: 3607
            path: token
        - configMap:
            items:
            - key: ca.crt
              path: ca.crt
            name: kube-root-ca.crt
        - downwardAPI:
            items:
            - fieldRef:
                apiVersion: v1
                fieldPath: metadata.namespace
              path: namespace
  status:
    conditions:
    - lastProbeTime: null
      lastTransitionTime: "2026-07-26T17:36:10Z"
      observedGeneration: 1
      status: "True"
      type: PodReadyToStartContainers
    - lastProbeTime: null
      lastTransitionTime: "2026-07-26T17:36:10Z"
      observedGeneration: 1
      status: "True"
      type: Initialized
    - lastProbeTime: null
      lastTransitionTime: "2026-07-26T17:36:13Z"
      observedGeneration: 1
      status: "True"
      type: Ready
    - lastProbeTime: null
      lastTransitionTime: "2026-07-26T17:36:13Z"
      observedGeneration: 1
      status: "True"
      type: ContainersReady
    - lastProbeTime: null
      lastTransitionTime: "2026-07-26T17:36:10Z"
      observedGeneration: 1
      status: "True"
      type: PodScheduled
    containerStatuses:
    - containerID: containerd://dda6d8fabfaeeba1544c6e0a277badf73c89835844b6be5958bac438448600ba
      image: docker.io/library/busybox:latest
      imageID: docker.io/library/busybox@sha256:fd8d9aa63ba2f0982b5304e1ee8d3b90a210bc1ffb5314d980eb6962f1a9715d
      lastState: {}
      name: some-name-of-busybox
      ready: true
      resources: {}
      restartCount: 0
      started: true
      state:
        running:
          startedAt: "2026-07-26T17:36:13Z"
      user:
        linux:
          gid: 0
          supplementalGroups:
          - 0
          - 10
          uid: 0
      volumeMounts:
      - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
        name: kube-api-access-h8q77
        readOnly: true
        recursiveReadOnly: Disabled
    hostIP: 172.18.0.2
    hostIPs:
    - ip: 172.18.0.2
    observedGeneration: 1
    phase: Running
    podIP: 10.244.0.5
    podIPs:
    - ip: 10.244.0.5
    qosClass: BestEffort
    resources: {}
    startTime: "2026-07-26T17:36:10Z"
kind: List
metadata:
  resourceVersion: ""
```

</details>

#### Фильтрация вывода файла-состояния

```bash
kubectl get pods  -o=jsonpath='{.items[0].status.phase}' \
&& kubectl get pods  -o=jsonpath='{.items[0].status.podIP}' \
&& kubectl get pods  -o=jsonpath='{.items[0].status.hostIP}' \
&& ip -br a | grep br | grep -i up
```

<details>
<summary>
Фильтрованный вывод и ip адресов физической машины\Ноды kubernetes
</summary>

```log
Running
10.244.0.5
172.18.0.2
br0              UP  192.168.89.193/24 metric 1024 fe80::f832:c0ff:fe95:76f/64 
br-9dd488316d7d  UP  172.18.0.1/16 fc00:f853:ccd:e793::1/64 fe80::c42:ddff:fe8d:485e/64 
```

</details>


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

git add . .. ../.. \
&& git status \
&& git commit -am 'some_word_add_module_1' \
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