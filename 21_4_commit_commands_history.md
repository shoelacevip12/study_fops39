# Для домашнего задания 21.4 `Хранение в K8s`

## commit_78, master Предварительная подготовка

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

cd kuber-homeworks

git config \
--global \
--add safe.directory \
/home/shoel/nfs_git/gited/kuber-homeworks

git checkout shkuber-16

cd ..

# Удаление всех файлов и каталогов кроме нужных
find kuber-homeworks/ \
-mindepth 1 \
-not -path "*2.1*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем
mv -v kuber-homeworks \
21_4

# Переход в каталог по последней переменной вывода последней команды
cd !$

mv -v 2.1/* ./

# Удаление всех файлов и каталогов кроме нужных
find . \
-mindepth 1 \
-not -path "*2.1.md*" \
-delete

# Переименование 
mv -v {2.1,README}.md
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
git commit -am 'commit_78, master' \
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

## commit_1, `21_4-K8S-stor`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 21_4-K8S-stor

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
git commit -am 'commit1, 21_4-K8S-stor' \
&& git push \
--set-upstream \
study_fops39 \
21_4-K8S-stor \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_4-K8S-stor \
&& git push \
--set-upstream \
study-fops39_sc \
21_4-K8S-stor
```

## commit_2,`21_4-K8S-stor`

### `Yaml`-манифест deployment с emptyDir

<details>
<summary>
Yaml-манифест deployment с emptyDir
</summary>

```bash
cat > depl_busybox-init.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox-init
  labels:
    role: den-store-exch
    app: busybox-store-exch
    organization: netology-fops40
    creator: denskv
spec:
  replicas: 1
  minReadySeconds: 10
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: busybox-store-exch
  template:
    metadata:
      labels:
        app: busybox-store-exch
    spec:
      containers:
      - name: gen-data
        image: busybox:latest
        volumeMounts:
        - name: exch-vol
          mountPath: /exch-to
        command:
          - sh
          - -c
          - |
            while true; do
              for c in 1 2 3; do
              echo "$(date "+%b_%a_%d_%H:%M:%S")" | tee /exch-to/exch-data
              echo "Записано в файл $(find /exch-to -name exch-data)"
              sleep $c
              echo "$(date "+%b_%a_%d_%H:%M:%S")" | tee -a /exch-to/exch-data
              echo "Записано в файл $(find /exch-to -name exch-data)"
              sleep $c
              echo "$(date "+%b_%a_%d_%H:%M:%S")" | tee -a /exch-to/exch-data
              echo "Записано в файл $(find /exch-to -name exch-data)"
              sleep $c
              done
            done
      - name: data-consumer
        image: wbitt/network-multitool:latest
        volumeMounts:
        - name: exch-vol
          mountPath: /exch-from
        command:
          - tail
          - -f
          - /exch-from/exch-data
      volumes:
      - name: exch-vol
        emptyDir:
          sizeLimit: 1Mi
          medium: Memory
EOF
```

</details>

```bash
# Применение манифестов deployment и сервисов, просмотр подов
kubectl apply -f depl_busybox-init.yaml \
&& kubectl rollout status deployment -l creator=denskv -w \
&& kubectl get deployment busybox-init -o yaml \
| grep -A4 volumes:
```

<details>
<summary>
применение манифестов и просмотр подов
</summary>

```log
deployment.apps/busybox-init created
Waiting for deployment "busybox-init" rollout to finish: 0 of 1 updated replicas are available...
Waiting for deployment "busybox-init" rollout to finish: 0 of 1 updated replicas are available...
deployment "busybox-init" successfully rolled out
      volumes:
      - emptyDir:
          medium: Memory
          sizeLimit: 1Mi
        name: exch-vol
```

</details>

```bash
# Мониторинг подов и содержимого директории exch-from в контейнере data-consumer
watch -n1 -c \
"kubectl get pods -L role=den-store-exch \
&& echo ---===Gen-DATA-Логи-записи===--- \
&& kubectl logs deployments/busybox-init -c gen-data \
| tail -n8 \
&& echo ---===DATA-CONSUMER_чтение_файла-/exch-from/exch-data===--- \
&& kubectl exec -it  \
deployments/busybox-init \
-c data-consumer -- bash -c \
'ls -l /exch-from/exch-data \
&& tail /exch-from/exch-data'"
```

<details>
<summary>
мониторинг подов
</summary>

```log
NAME                            READY   STATUS    RESTARTS   AGE     ROLE=DEN-STORE-EXCH
busybox-init-5896676458-2vzw2   2/2     Running   0          3m11s
---===Gen-DATA-Логи-записи===---
Aug_Thu_20_12:55:43
Записано в файл /exch-to/exch-data
Aug_Thu_20_12:55:44
Записано в файл /exch-to/exch-data
Aug_Thu_20_12:55:46
Записано в файл /exch-to/exch-data
Aug_Thu_20_12:55:48
Записано в файл /exch-to/exch-data
---===DATA-CONSUMER_чтение_файла-/exch-from/exch-data===---
-rw-r--r--    1 root     root            60 Aug 20 12:55 /exch-from/exch-data
Aug_Thu_20_12:55:44
Aug_Thu_20_12:55:46
Aug_Thu_20_12:55:48
```

</details>

```bash
kubectl describe pods \
-l app=busybox-store-exch
```

<details>
<summary>
describe подов -l app=busybox-store-exch
</summary>

```log
Name:             busybox-init-5896676458-2vzw2
Namespace:        default
Priority:         0
Service Account:  default
Node:             skv-21-2-k8s-depl-worker2/172.18.0.3
Start Time:       Thu, 20 Aug 2026 15:52:39 +0300
Labels:           app=busybox-store-exch
                  pod-template-hash=5896676458
Annotations:      <none>
Status:           Running
IP:               10.244.2.10
IPs:
  IP:           10.244.2.10
Controlled By:  ReplicaSet/busybox-init-5896676458
Containers:
  gen-data:
    Container ID:  containerd://334fbfab3756581a2648416e7c25a6596b705fdef810d6bee2434d06b3ffc30e
    Image:         busybox:latest
    Image ID:      docker.io/library/busybox@sha256:dc2d74b28e4cf8984fa52af1f39bc7c3d9c73760b41a74d629f5d11b1ab28616
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      while true; do
        for c in 1 2 3; do
        echo "$(date "+%b_%a_%d_%H:%M:%S")" | tee /exch-to/exch-data
        echo "Записано в файл $(find /exch-to -name exch-data)"
        sleep $c
        echo "$(date "+%b_%a_%d_%H:%M:%S")" | tee -a /exch-to/exch-data
        echo "Записано в файл $(find /exch-to -name exch-data)"
        sleep $c
        echo "$(date "+%b_%a_%d_%H:%M:%S")" | tee -a /exch-to/exch-data
        echo "Записано в файл $(find /exch-to -name exch-data)"
        sleep $c
        done
      done
      
    State:          Running
      Started:      Thu, 20 Aug 2026 15:52:41 +0300
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /exch-to from exch-vol (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-mz6wr (ro)
  data-consumer:
    Container ID:  containerd://1bff88eb071f6c3054c42d936e40ef8bd25e2c25b06025b63bf3573686ecfdf9
    Image:         wbitt/network-multitool:latest
    Image ID:      docker.io/wbitt/network-multitool@sha256:db2810fe2c8d36db074eab5d98fbf861c8ed55e0786d648d3477b3de9135632e
    Port:          <none>
    Host Port:     <none>
    Command:
      tail
      -f
      /exch-from/exch-data
    State:          Running
      Started:      Thu, 20 Aug 2026 15:52:42 +0300
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /exch-from from exch-vol (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-mz6wr (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  exch-vol:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     Memory
    SizeLimit:  1Mi
  kube-api-access-mz6wr:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  11m   default-scheduler  Successfully assigned default/busybox-init-5896676458-2vzw2 to skv-21-2-k8s-depl-worker2
  Normal  Pulling    11m   kubelet            spec.containers{gen-data}: Pulling image "busybox:latest"
  Normal  Pulled     11m   kubelet            spec.containers{gen-data}: Successfully pulled image "busybox:latest" in 1.248s (1.248s including waiting). Image size: 2236931 bytes.
  Normal  Created    11m   kubelet            spec.containers{gen-data}: Container created
  Normal  Started    11m   kubelet            spec.containers{gen-data}: Container started
  Normal  Pulling    11m   kubelet            spec.containers{data-consumer}: Pulling image "wbitt/network-multitool:latest"
  Normal  Pulled     11m   kubelet            spec.containers{data-consumer}: Successfully pulled image "wbitt/network-multitool:latest" in 1.078s (1.078s including waiting). Image size: 96718848 bytes.
  Normal  Created    11m   kubelet            spec.containers{data-consumer}: Container created
  Normal  Started    11m   kubelet            spec.containers{data-consumer}: Container started
```

</details>

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 21_4-K8S-stor' \
&& git push \
--set-upstream \
study_fops39 \
21_4-K8S-stor \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_4-K8S-stor \
&& git push \
--set-upstream \
study-fops39_sc \
21_4-K8S-stor
```

## commit_3,`21_4-K8S-stor`

### `Yaml`-манифест Предварительного создания PV

<details>
<summary>
Yaml-манифест Предварительного создания PV
</summary>

```bash
cat > pv_node.yaml <<'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-node-store
  labels:
    role: den-store-exch
    type: hostpath
    organization: netology-fops40
    creator: denskv
spec:
  capacity:
    storage: 10Mi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain  # Политика сохранения PV после удаления PVC
  storageClassName: ""
  hostPath:
    path:  /mnt/data/pv-node-store
    type: DirectoryOrCreate
EOF
```

</details>

### `Yaml`-манифест привязка на создание PV (PVC)

<details>
<summary>
Yaml-манифест привязка на создание PV (PVC)
</summary>

```bash
cat > pvc_node.yaml <<'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-node-store
  labels:
    role: den-store-exch
    type: hostpath
    organization: netology-fops40
    creator: denskv
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Mi
  storageClassName: ""
EOF
```

</details>

### `Yaml`-манифест deployment c привязкой на созданный PV (PVC)

<details>
<summary>
Yaml-манифест deployment c привязкой на созданный PV (PVC)
</summary>

```bash
cat > depl_PVC_busybox.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox-store-exch
  labels:
    role: den-store-exch
    app: busybox-store-exch
    organization: netology-fops40
    creator: denskv
spec:
  replicas: 1
  minReadySeconds: 10
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: busybox-store-exch
  template:
    metadata:
      labels:
        app: busybox-store-exch
    spec:
      nodeName: skv-21-2-k8s-depl-worker2   # привязка к Ноде
      containers:
      - name: gen-data
        image: busybox:latest
        volumeMounts:
        - name: exch-vol-pv
          mountPath: /exch-to
        command:
          - sh
          - -c
          - |
            while true; do
              for c in 1 2 3; do
              echo "$(date "+%b_%a_%d_%H:%M:%S")" | tee /exch-to/exch-data
              echo "Записано в файл $(find /exch-to -name exch-data)"
              sleep $c
              echo "$(date "+%b_%a_%d_%H:%M:%S")" | tee -a /exch-to/exch-data
              echo "Записано в файл $(find /exch-to -name exch-data)"
              sleep $c
              echo "$(date "+%b_%a_%d_%H:%M:%S")" | tee -a /exch-to/exch-data
              echo "Записано в файл $(find /exch-to -name exch-data)"
              sleep $c
              done
            done
      - name: data-consumer
        image: wbitt/network-multitool:latest
        volumeMounts:
        - name: exch-vol-pv
          mountPath: /exch-from
        command:
          - tail
          - -f
          - /exch-from/exch-data
      volumes:
      - name: exch-vol-pv
        persistentVolumeClaim:
          claimName: pvc-node-store
EOF
```

</details>

```bash
# Применение манифестов deployment и PVC\PV, просмотр подов
kubectl apply -f pv_node.yaml \
&& sleep 5 \
&& kubectl apply -f pvc_node.yaml \
&& kubectl apply -f depl_PVC_busybox.yaml \
&& kubectl rollout status deployment -l creator=denskv -w \
&& kubectl get deployment busybox-store-exch -o yaml \
| grep -A4 volumes:
```

<details>
<summary>
применение манифестов и просмотр подов
</summary>

```log
persistentvolume/pv-node-store created
persistentvolumeclaim/pvc-node-store created
deployment.apps/busybox-store-exch created
Waiting for deployment "busybox-store-exch" rollout to finish: 0 of 1 updated replicas are available...
Waiting for deployment "busybox-store-exch" rollout to finish: 0 of 1 updated replicas are available...
deployment "busybox-store-exch" successfully rolled out
      volumes:
      - name: exch-vol-pv
        persistentVolumeClaim:
          claimName: pvc-node-store
```

</details>

```bash
# Мониторинг подов и содержимого директории exch-from в контейнере data-consumer
watch -n1 -c \
"kubectl get pods -L role=den-store-exch \
&& echo ---===Доступные_PV===--- \
&& kubectl get pv -l role=den-store-exch \
&& kubectl describe pv pv-node-store \
| tail -n14 \
&& echo ---===Запрошенные_PV\(PVC\)===--- \
&& kubectl get pvc -l role=den-store-exch \
&& kubectl describe pvc pvc-node-store \
| tail -n5 \
&& echo ---===Gen-DATA-Логи-записи===--- \
&& kubectl logs deployments/busybox-store-exch -c gen-data \
| tail -n8 \
&& echo ---===DATA-CONSUMER_чтение_файла-/exch-from/exch-data===--- \
&& kubectl exec -it  \
deployments/busybox-store-exch \
-c data-consumer -- bash -c \
'ls -l /exch-from/exch-data \
&& tail /exch-from/exch-data'"
```

<details>
<summary>
мониторинг подов и PV\PVC после создания
</summary>

```log
NAME                                  READY   STATUS    RESTARTS   AGE   ROLE=DEN-STORE-EXCH
busybox-store-exch-56ffc58698-8pcdm   2/2     Running   0          10s
---===Доступные_PV===---
NAME            CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                    STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pv-node-store   10Mi       RWO            Retain           Bound    default/pvc-node-store                  <unset>                          15s
StorageClass:
Status:          Bound
Claim:           default/pvc-node-store
Reclaim Policy:  Retain
Access Modes:    RWO
VolumeMode:      Filesystem
Capacity:        10Mi
Node Affinity:   <none>
Message:
Source:
    Type:          HostPath (bare host directory volume)
    Path:          /mnt/data/pv-node-store
    HostPathType:  DirectoryOrCreate
Events:            <none>
---===Запрошенные_PV(PVC)===---
NAME             STATUS   VOLUME          CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
pvc-node-store   Bound    pv-node-store   10Mi       RWO                           <unset>                 10s
Capacity:      10Mi
Access Modes:  RWO
VolumeMode:    Filesystem
Used By:       busybox-store-exch-56ffc58698-8pcdm
Events:        <none>
---===Gen-DATA-Логи-записи===---
Aug_Thu_20_15:07:23
Записано в файл /exch-to/exch-data
Aug_Thu_20_15:07:24
Записано в файл /exch-to/exch-data
Aug_Thu_20_15:07:26
Записано в файл /exch-to/exch-data
Aug_Thu_20_15:07:28
Записано в файл /exch-to/exch-data
---===DATA-CONSUMER_чтение_файла-/exch-from/exch-data===---
-rw-r--r--    1 root     root            60 Aug 20 15:07 /exch-from/exch-data
Aug_Thu_20_15:07:24
Aug_Thu_20_15:07:26
Aug_Thu_20_15:07:28
```

</details>

```bash
kubectl delete -f depl_PVC_busybox.yaml \
&& kubectl delete -f pvc_node.yaml \
&& kubectl rollout status deployment -l creator=denskv -w
```

<details>
<summary>
Удаление deployment и PVC
</summary>

```log
deployment.apps "busybox-store-exch" deleted from default namespace
persistentvolumeclaim "pvc-node-store" deleted from default namespace
No resources found in default namespace.
```

</details>

```bash
# Мониторинг подов и содержимого директории exch-from в контейнере data-consumer
watch -n1 -c \
"kubectl get pods -L role=den-store-exch \
&& echo ---===Доступные_PV===--- \
&& kubectl get pv -l role=den-store-exch \
&& kubectl describe pv pv-node-store \
| tail -n14 \
&& echo ---===Запрошенные_PV\(PVC\)===--- \
&& kubectl get pvc -l role=den-store-exch \
&& kubectl describe pvc pvc-node-store \
| tail -n5 \
&& echo ---===Gen-DATA-Логи-записи===--- \
&& kubectl logs deployments/busybox-store-exch -c gen-data \
| tail -n8 \
&& echo ---===DATA-CONSUMER_чтение_файла-/exch-from/exch-data===--- \
&& kubectl exec -it  \
deployments/busybox-store-exch \
-c data-consumer -- bash -c \
'ls -l /exch-from/exch-data \
&& tail /exch-from/exch-data'"
```

<details>
<summary>
мониторинг подов и PV\PVC после удаления deployment и PVC
</summary>

```log
No resources found in default namespace.
---===Доступные_PV===---
NAME            CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                    STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   A
GE
pv-node-store   10Mi       RWO            Retain           Released   default/pvc-node-store                  <unset>                          7
m17s
StorageClass:
Status:          Released
Claim:           default/pvc-node-store
Reclaim Policy:  Retain
Access Modes:    RWO
VolumeMode:      Filesystem
Capacity:        10Mi
Node Affinity:   <none>
Message:
Source:
    Type:          HostPath (bare host directory volume)
    Path:          /mnt/data/pv-node-store
    HostPathType:  DirectoryOrCreate
Events:            <none>
---===Запрошенные_PV(PVC)===---
No resources found in default namespace.
Error from server (NotFound): persistentvolumeclaims "pvc-node-store" not found
---===Gen-DATA-Логи-записи===---
error: error from server (NotFound): deployments.apps "busybox-store-exch" not found in namespace "default"
---===DATA-CONSUMER_чтение_файла-/exch-from/exch-data===---
Error from server (NotFound): deployments.apps "busybox-store-exch" not found
```

</details>

```bash
# привязкаа PV не в статусе  Available
kubectl apply -f pv_node.yaml \
&& kubectl apply -f pvc_node.yaml
```

```bash
# Мониторинг PV\PVC
watch -n1 -c \
"echo ---===Доступные_PV===--- \
&& kubectl get pv -l role=den-store-exch \
&& kubectl describe pv pv-node-store \
| tail -n14 \
&& echo ---===Запрошенные_PV\(PVC\)===--- \
&& kubectl get pvc -l role=den-store-exch \
&& kubectl describe pvc pvc-node-store \
| tail -n5"
```

<details>
<summary>
мониторинг PV\PVC при попытке привязки PV в статусе RELEASED
</summary>

```log
---===Доступные_PV===---
NAME            CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                    STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   A
GE
pv-node-store   10Mi       RWO            Retain           Released   default/pvc-node-store                  <unset>                          4
m36s
StorageClass:
Status:          Released
Claim:           default/pvc-node-store
Reclaim Policy:  Retain
Access Modes:    RWO
VolumeMode:      Filesystem
Capacity:        10Mi
Node Affinity:   <none>
Message:
Source:
    Type:          HostPath (bare host directory volume)
    Path:          /mnt/data/pv-node-store
    HostPathType:  DirectoryOrCreate
Events:            <none>
---===Запрошенные_PV(PVC)===---
NAME             STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
pvc-node-store   Pending                                                     <unset>                 3m16s
Used By:       <none>
Events:
  Type    Reason         Age                   From                         Message
  ----    ------         ----                  ----                         -------
  Normal  FailedBinding  11s (x14 over 3m16s)  persistentvolume-controller  no persistent volumes available for this claim and no storage class
is set
```

</details>

```bash
# Удаление Томов и привязок
kubectl delete -f pv_node.yaml \
&& kubectl delete -f pvc_node.yaml
```

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit3, 21_4-K8S-stor' \
&& git push \
--set-upstream \
study_fops39 \
21_4-K8S-stor \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_4-K8S-stor \
&& git push \
--set-upstream \
study-fops39_sc \
21_4-K8S-stor
```

## commit_4,`21_4-K8S-stor`

### `Yaml`-манифест Storage Class

```bash
# Вывод доступных PROVISIONER в класторе
kubectl get storageclass standard \
|| kubectl describe sc standard | grep -i provisioner:
```

```log
NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
standard (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  5d3h
#или
Provisioner:           rancher.io/local-path
```


<details>
<summary>
Yaml-манифест привязка на создание PV (PVC)
</summary>

```bash
cat > sc_node.yaml <<'EOF'
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: sc-node-hostpath
  labels:
    role: den-store-exch
    type: hostpath
    organization: netology-fops40
    creator: denskv
provisioner: "rancher.io/local-path"
volumeBindingMode: WaitForFirstConsumer # отложить выбор ноды до момента создания пода
reclaimPolicy: Retain
EOF
```

</details>

### `Yaml`-манифест привязка на создание PV (PVC) через StorageClass(SC)

<details>
<summary>
Yaml-манифест привязка на создание PV (PVC) через StorageClass(SC)
</summary>

```bash
cat > pvc-sc_node.yaml <<'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-sc-store
  labels:
    role: den-store-exch
    type: hostpath
    organization: netology-fops40
    creator: denskv
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Mi
  storageClassName: "sc-node-hostpath"
EOF
```

</details>

### `Yaml`-манифест deployment c привязкой на созданный PV (PVC) через SC

<details>
<summary>
Yaml-манифест deployment c привязкой на созданный PV (PVC) через SC
</summary>

```bash
cat > depl_PVC_SC_busybox.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox-sc-exch
  labels:
    role: den-store-exch
    app: busybox-sc-exch
    organization: netology-fops40
    creator: denskv
spec:
  replicas: 1
  minReadySeconds: 10
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: busybox-sc-exch
  template:
    metadata:
      labels:
        app: busybox-sc-exch
    spec:
      containers:
      - name: gen-data
        image: busybox:latest
        securityContext:
          runAsUser: 0
        volumeMounts:
        - name: exch-vol-sc
          mountPath: /exch-to
        command:
          - sh
          - -c
          - |
            while true; do
              for c in 1 2 3; do
              echo "$(date "+%b_%a_%d_%H:%M:%S")" | tee /exch-to/exch-data
              echo "Записано в файл $(find /exch-to -name exch-data)"
              sleep $c
              echo "$(date "+%b_%a_%d_%H:%M:%S")" | tee -a /exch-to/exch-data
              echo "Записано в файл $(find /exch-to -name exch-data)"
              sleep $c
              echo "$(date "+%b_%a_%d_%H:%M:%S")" | tee -a /exch-to/exch-data
              echo "Записано в файл $(find /exch-to -name exch-data)"
              sleep $c
              done
            done
      - name: data-consumer
        image: wbitt/network-multitool:latest
        securityContext:
          runAsUser: 0
        volumeMounts:
        - name: exch-vol-sc
          mountPath: /exch-from
        command:
          - tail
          - -f
          - /exch-from/exch-data
      volumes:
      - name: exch-vol-sc
        persistentVolumeClaim:                # ЗАпрос на Выдачу хранилища (PV) -> PVC -> SC 
          claimName: pvc-sc-store
EOF
```

</details>

```bash
# Применение манифестов deployment и PVC\SC, просмотр подов
kubectl apply -f sc_node.yaml \
&& kubectl apply -f pvc-sc_node.yaml \
&& kubectl apply -f depl_PVC_SC_busybox.yaml \
&& kubectl rollout status deployment -l creator=denskv -w \
&& kubectl get deployment busybox-sc-exch -o yaml \
| grep -A4 volumes: \
&& kubectl get pv -o yaml | sed -n '/spec:/,$p'
```

<details>
<summary>
применение манифестов и просмотр томов
</summary>

```log
storageclass.storage.k8s.io/sc-node-hostpath created
persistentvolumeclaim/pvc-sc-store created
deployment.apps/busybox-sc-exch created
Waiting for deployment "busybox-sc-exch" rollout to finish: 0 of 1 updated replicas are available...
Waiting for deployment "busybox-sc-exch" rollout to finish: 0 of 1 updated replicas are available...
deployment "busybox-sc-exch" successfully rolled out
      volumes:
      - name: exch-vol-sc
        persistentVolumeClaim:
          claimName: pvc-sc-store
status:
  spec:
    accessModes:
    - ReadWriteOnce
    capacity:
      storage: 5Mi
    claimRef:
      apiVersion: v1
      kind: PersistentVolumeClaim
      name: pvc-sc-store
      namespace: default
      resourceVersion: "218891"
      uid: ac2edca2-cfff-4979-a994-989b91e05c74
    hostPath:
      path: /var/local-path-provisioner/pvc-ac2edca2-cfff-4979-a994-989b91e05c74_default_pvc-sc-store
      type: DirectoryOrCreate
    nodeAffinity:
      required:
        nodeSelectorTerms:
        - matchExpressions:
          - key: kubernetes.io/hostname
            operator: In
            values:
            - skv-21-2-k8s-depl-worker
    persistentVolumeReclaimPolicy: Retain
    storageClassName: sc-node-hostpath
    volumeMode: Filesystem
  status:
    lastPhaseTransitionTime: "2026-08-20T18:53:53Z"
    phase: Bound
kind: List
metadata:
  resourceVersion: ""
```

</details>

```bash
# Скрипт мониторинга watch -n1 -c "..."
watch -n1 -c \
"echo ---===Поднятые_ПОДЫ===--- \
&& kubectl get pods -L role=den-store-exch \
&& echo \
&& echo ---===Созданные_ТОМА\(PV\)===--- \
&& kubectl get pv \
&& echo \
&& echo ---===Доступные_SC-provisioners===--- \
&& kubectl get sc -l role=den-store-exch \
&& kubectl describe sc sc-node-hostpath \
| tail -n7 \
&& echo \
&& echo ---===Запрошенные_PV\(PVC\)===--- \
&& kubectl get pvc -l role=den-store-exch \
&& kubectl describe pvc pvc-sc-store \
| tail -n5 \
&& echo \
&& echo ---===Gen-DATA-Логи-записи===--- \
&& kubectl logs deployments/busybox-sc-exch -c gen-data \
| tail -n8 \
&& echo ---===DATA-CONSUMER_чтение_файла-/exch-from/exch-data===--- \
&& kubectl exec -it  \
deployments/busybox-sc-exch \
-c data-consumer -- bash -c \
'ls -l /exch-from/exch-data \
&& tail /exch-from/exch-data'"
```

<details>
<summary>
мониторинг подов и PV\PVC после 1-ого создания
</summary>

```log
---===Поднятые_ПОДЫ===---
NAME                               READY   STATUS    RESTARTS   AGE   ROLE=DEN-STORE-EXCH
busybox-sc-exch-57d4ffff6d-57jhk   2/2     Running   0          52s

---===Созданные_ТОМА(PV)===---
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                  STORAGECLASS       VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-ac2edca2-cfff-4979-a994-989b91e05c74   5Mi        RWO            Retain           Bound    default/pvc-sc-store   sc-node-hostpath   <unset>                          49s

---===Доступные_SC-provisioners===---
NAME               PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
sc-node-hostpath   rancher.io/local-path   Retain          WaitForFirstConsumer   false                  54s
Provisioner:           rancher.io/local-path
Parameters:            <none>
AllowVolumeExpansion:  <unset>
MountOptions:          <none>
ReclaimPolicy:         Retain
VolumeBindingMode:     WaitForFirstConsumer
Events:                <none>

---===Запрошенные_PV(PVC)===---
NAME           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS       VOLUMEATTRIBUTESCLASS   AGE
pvc-sc-store   Bound    pvc-ac2edca2-cfff-4979-a994-989b91e05c74   5Mi        RWO            sc-node-hostpath   <unset>                 53s
  ----    ------                 ----  ----                                                                                                -------
  Normal  WaitForFirstConsumer   53s   persistentvolume-controller                                                                         waiting for first consumer to be created before binding
  Normal  ExternalProvisioning   53s   persistentvolume-controller                                                                         Waiting for a volume to be created either by the external provisioner 'rancher.io/local-path' or manuall
y by the system administrator. If volume creation is delayed, please verify that the provisioner is running and correctly registered.
  Normal  Provisioning           53s   rancher.io/local-path_local-path-provisioner-855c7b7774-rtwx6_f384d36b-0a01-41cd-af33-cedaea0956c6  External provisioner is provisioning volume for claim "default/pvc-sc-store"
  Normal  ProvisioningSucceeded  50s   rancher.io/local-path_local-path-provisioner-855c7b7774-rtwx6_f384d36b-0a01-41cd-af33-cedaea0956c6  Successfully provisioned volume pvc-ac2edca2-cfff-4979-a994-989b91e05c74

---===Gen-DATA-Логи-записи===---
Aug_Thu_20_18:54:35
Записано в файл /exch-to/exch-data
Aug_Thu_20_18:54:37
Записано в файл /exch-to/exch-data
Aug_Thu_20_18:54:39
Записано в файл /exch-to/exch-data
Aug_Thu_20_18:54:41
Записано в файл /exch-to/exch-data
---===DATA-CONSUMER_чтение_файла-/exch-from/exch-data===---
-rw-r--r--    1 root     root            20 Aug 20 18:54 /exch-from/exch-data
Aug_Thu_20_18:54:41
```

</details>

```bash
# Удаление deployment и pvc
kubectl delete -f depl_PVC_SC_busybox.yaml \
&& kubectl delete -f pvc-sc_node.yaml
```

```bash
# Скрипт мониторинга watch -n1 -c "..."
watch -n1 -c \
"echo ---===Поднятые_ПОДЫ===--- \
&& kubectl get pods -L role=den-store-exch \
&& echo \
&& echo ---===Созданные_ТОМА\(PV\)===--- \
&& kubectl get pv \
&& echo \
&& echo ---===Доступные_SC-provisioners===--- \
&& kubectl get sc -l role=den-store-exch \
&& kubectl describe sc sc-node-hostpath \
| tail -n7 \
&& echo \
&& echo ---===Запрошенные_PV\(PVC\)===--- \
&& kubectl get pvc -l role=den-store-exch \
&& kubectl describe pvc pvc-sc-store \
| tail -n5 \
&& echo \
&& echo ---===Gen-DATA-Логи-записи===--- \
&& kubectl logs deployments/busybox-sc-exch -c gen-data \
| tail -n8 \
&& echo ---===DATA-CONSUMER_чтение_файла-/exch-from/exch-data===--- \
&& kubectl exec -it  \
deployments/busybox-sc-exch \
-c data-consumer -- bash -c \
'ls -l /exch-from/exch-data \
&& tail /exch-from/exch-data'"
```

<details>
<summary>
мониторинг подов и PV\PVC после удаления deployment и pvc
</summary>

```log
---===Поднятые_ПОДЫ===---
No resources found in default namespace.

---===Созданные_ТОМА(PV)===---
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                  STORAGECLASS       VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-ac2edca2-cfff-4979-a994-989b91e05c74   5Mi        RWO            Retain           Released   default/pvc-sc-store   sc-node-hostpath   <unset>                          2m38s

---===Доступные_SC-provisioners===---
NAME               PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
sc-node-hostpath   rancher.io/local-path   Retain          WaitForFirstConsumer   false                  2m42s
Provisioner:           rancher.io/local-path
Parameters:            <none>
AllowVolumeExpansion:  <unset>
MountOptions:          <none>
ReclaimPolicy:         Retain
VolumeBindingMode:     WaitForFirstConsumer
Events:                <none>

---===Запрошенные_PV(PVC)===---
No resources found in default namespace.
Error from server (NotFound): persistentvolumeclaims "pvc-sc-store" not found

---===Gen-DATA-Логи-записи===---
error: error from server (NotFound): deployments.apps "busybox-sc-exch" not found in namespace "default"
---===DATA-CONSUMER_чтение_файла-/exch-from/exch-data===---
Error from server (NotFound): deployments.apps "busybox-sc-exch" not found
```

</details>

```bash
# Создание новых ресурсов на тех же манифестах
kubectl apply -f pvc-sc_node.yaml \
&&kubectl apply -f depl_PVC_SC_busybox.yaml \
```

```bash
# Скрипт мониторинга watch -n1 -c "..."
watch -n1 -c \
"echo ---===Поднятые_ПОДЫ===--- \
&& kubectl get pods -L role=den-store-exch \
&& echo \
&& echo ---===Созданные_ТОМА\(PV\)===--- \
&& kubectl get pv \
&& echo \
&& echo ---===Доступные_SC-provisioners===--- \
&& kubectl get sc -l role=den-store-exch \
&& kubectl describe sc sc-node-hostpath \
| tail -n7 \
&& echo \
&& echo ---===Запрошенные_PV\(PVC\)===--- \
&& kubectl get pvc -l role=den-store-exch \
&& kubectl describe pvc pvc-sc-store \
| tail -n5 \
&& echo \
&& echo ---===Gen-DATA-Логи-записи===--- \
&& kubectl logs deployments/busybox-sc-exch -c gen-data \
| tail -n8 \
&& echo ---===DATA-CONSUMER_чтение_файла-/exch-from/exch-data===--- \
&& kubectl exec -it  \
deployments/busybox-sc-exch \
-c data-consumer -- bash -c \
'ls -l /exch-from/exch-data \
&& tail /exch-from/exch-data'"
```

<details>
<summary>
мониторинг подов и PV\PVC после пересоздания deployment и pvc
</summary>

```log
---===Поднятые_ПОДЫ===---
NAME                               READY   STATUS    RESTARTS   AGE     ROLE=DEN-STORE-EXCH
busybox-sc-exch-57d4ffff6d-ht8rc   2/2     Running   0          2m34s

---===Созданные_ТОМА(PV)===---
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                  STORAGECLASS       VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-86af342d-7d85-422b-b932-b81f1e30f0cc   5Mi        RWO            Retain           Bound      default/pvc-sc-store   sc-node-hostpath   <unset>                          2m32s
pvc-ac2edca2-cfff-4979-a994-989b91e05c74   5Mi        RWO            Retain           Released   default/pvc-sc-store   sc-node-hostpath   <unset>                          6m50s

---===Доступные_SC-provisioners===---
NAME               PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
sc-node-hostpath   rancher.io/local-path   Retain          WaitForFirstConsumer   false                  6m54s
Provisioner:           rancher.io/local-path
Parameters:            <none>
AllowVolumeExpansion:  <unset>
MountOptions:          <none>
ReclaimPolicy:         Retain
VolumeBindingMode:     WaitForFirstConsumer
Events:                <none>

---===Запрошенные_PV(PVC)===---
NAME           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS       VOLUMEATTRIBUTESCLASS   AGE
pvc-sc-store   Bound    pvc-86af342d-7d85-422b-b932-b81f1e30f0cc   5Mi        RWO            sc-node-hostpath   <unset>                 2m34s
  ----    ------                 ----   ----                                                                                                -------
  Normal  WaitForFirstConsumer   2m34s  persistentvolume-controller                                                                         waiting for first consumer to be created before binding
  Normal  ExternalProvisioning   2m34s  persistentvolume-controller                                                                         Waiting for a volume to be created either by the external provisioner 'ran
cher.io/local-path' or manually by the system administrator. If volume creation is delayed, please verify that the provisioner is running and correctly registered.
  Normal  Provisioning           2m34s  rancher.io/local-path_local-path-provisioner-855c7b7774-rtwx6_f384d36b-0a01-41cd-af33-cedaea0956c6  External provisioner is provisioning volume for claim "default/pvc-sc-stor
e"
  Normal  ProvisioningSucceeded  2m32s  rancher.io/local-path_local-path-provisioner-855c7b7774-rtwx6_f384d36b-0a01-41cd-af33-cedaea0956c6  Successfully provisioned volume pvc-86af342d-7d85-422b-b932-b81f1e30f0cc

---===Gen-DATA-Логи-записи===---
Aug_Thu_20_19:00:40
Записано в файл /exch-to/exch-data
Aug_Thu_20_19:00:41
Записано в файл /exch-to/exch-data
Aug_Thu_20_19:00:42
Записано в файл /exch-to/exch-data
Aug_Thu_20_19:00:44
Записано в файл /exch-to/exch-data
---===DATA-CONSUMER_чтение_файла-/exch-from/exch-data===---
-rw-r--r--    1 root     root            40 Aug 20 19:00 /exch-from/exch-data
Aug_Thu_20_19:00:42
Aug_Thu_20_19:00:44
```

</details>

```bash
# Удаление ресурсов на основе использованных манифестов
kubectl delete -f depl_PVC_SC_busybox.yaml \
&& kubectl delete -f pvc-sc_node.yaml \
&& kubectl delete -f sc_node.yaml
```

```bash
# Оставшиеся ресурсы при политике для PV Retain
echo ---===Поднятые_ПОДЫ===--- \
&& kubectl get pods -L role=den-store-exch \
&& echo \
&& echo ---===Созданные_ТОМА\(PV\)===--- \
&& kubectl get pv \
&& echo \
&& echo ---===Доступные_SC-provisioners===--- \
&& kubectl get sc -l role=den-store-exch \
&& kubectl describe sc sc-node-hostpath \
| tail -n7 \
&& echo \
&& echo ---===Запрошенные_PV\(PVC\)===--- \
&& kubectl get pvc -l role=den-store-exch \
&& kubectl describe pvc pvc-sc-store \
| tail -n5
```

<details>
<summary>
мониторинг подов и PV\PVC после удаление ресурсов по манифестам
</summary>

```log
---===Поднятые_ПОДЫ===---
No resources found in default namespace.

---===Созданные_ТОМА(PV)===---
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                  STORAGECLASS       VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-86af342d-7d85-422b-b932-b81f1e30f0cc   5Mi        RWO            Retain           Released   default/pvc-sc-store   sc-node-hostpath   <unset>                          6m27s
pvc-ac2edca2-cfff-4979-a994-989b91e05c74   5Mi        RWO            Retain           Released   default/pvc-sc-store   sc-node-hostpath   <unset>                          10m

---===Доступные_SC-provisioners===---
No resources found
Error from server (NotFound): storageclasses.storage.k8s.io "sc-node-hostpath" not found

---===Запрошенные_PV(PVC)===---
No resources found in default namespace.
Error from server (NotFound): persistentvolumeclaims "pvc-sc-store" not found
```

</details>

```bash
# Удаление оставшихся PV
kubectl delete pv \
pvc-86af342d-7d85-422b-b932-b81f1e30f0cc \
pvc-ac2edca2-cfff-4979-a994-989b91e05c74
```

<details>
<summary>
мониторинг подов и PV\PVC после удаление ресурсов по манифестам
</summary>

```log
persistentvolume "pvc-86af342d-7d85-422b-b932-b81f1e30f0cc" deleted
persistentvolume "pvc-ac2edca2-cfff-4979-a994-989b91e05c74" deleted
```

</details>

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit4, 21_4-K8S-stor' \
&& git push \
--set-upstream \
study_fops39 \
21_4-K8S-stor \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_4-K8S-stor \
&& git push \
--set-upstream \
study-fops39_sc \
21_4-K8S-stor
```

## commit_79, master

```bash
git checkout master

git branch -v

git merge 21_4-K8S-stor

git branch -v

git status

git diff \
&& git diff \
--staged

git add . \
&& git status

git log --oneline

git push \
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
master --force \
&& git push \
--set-upstream \
study-fops39_sc \
master --force
```
