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