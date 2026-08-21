# Для домашнего задания 21.5 `Настройка приложений и управление доступом в Kubernetes`

## commit_80, master Предварительная подготовка

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
-not -path "*2.3*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем
mv -v kuber-homeworks \
21_5

# Переход в каталог по последней переменной вывода последней команды
cd !$

mv -v 2.3/* ./

# Удаление всех файлов и каталогов кроме нужных
find . \
-mindepth 1 \
-not -path "*2.3.md*" \
-delete

# Переименование 
mv -v {2.3,README}.md
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
git commit -am 'commit_80, master' \
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

## commit_1, `21_5-K8S-conf-app`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 21_5-K8S-conf-app

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
git commit -am 'commit1, 21_5-K8S-conf-app' \
&& git push \
--set-upstream \
study_fops39 \
21_5-K8S-conf-app \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_5-K8S-conf-app \
&& git push \
--set-upstream \
study-fops39_sc \
21_5-K8S-conf-app
```

## commit_2,`21_5-K8S-conf-app`

### Ручной проброс Контейнеров в кластер Kind как локальные

```bash
# Скачивание образов и присвоение дополнительного тега denskv
docker pull \
nginx:latest

docker tag \
nginx:latest \
nginx:denskv

docker pull \
wbitt/network-multitool:latest

docker tag \
wbitt/network-multitool:latest \
wbitt/network-multitool:denskv

docker pull \
busybox:latest

docker tag \
busybox:latest \
busybox:denskv

```

<details>
<summary>
Скачивание контейерных образов
</summary>

```log
nginx:latest
latest: Pulling from library/nginx
26c307b5e35a: Pull complete 
746b934a8960: Pull complete 
5508f6432d3e: Pull complete 
5d480233f531: Pull complete 
f530c3e421fc: Pull complete 
128fcc7b23b0: Pull complete 
7eb55399d6de: Pull complete 
Digest: sha256:8f029c543423e3eac6b08254718bc31eb75633b1e448026b6616927baa7d4bfe
Status: Downloaded newer image for nginx:latest
docker.io/library/nginx:latest

latest: Pulling from wbitt/network-multitool
2d35ebdb57d9: Already exists 
106e2d3f4331: Pull complete 
ededf688eedd: Pull complete 
161472afd5cd: Pull complete 
04da513cb5c7: Pull complete 
68fb4c9e5297: Pull complete 
Digest: sha256:db2810fe2c8d36db074eab5d98fbf861c8ed55e0786d648d3477b3de9135632e
Status: Downloaded newer image for wbitt/network-multitool:latest
docker.io/wbitt/network-multitool:latest

busybox:latest
latest: Pulling from library/busybox
b05093807bb0: Pull complete 
Digest: sha256:dc2d74b28e4cf8984fa52af1f39bc7c3d9c73760b41a74d629f5d11b1ab28616
Status: Downloaded newer image for busybox:latest
docker.io/library/busybox:latest
```

</details>

```bash
# Просмотр списка имен кластеров для загрузки
kubectl config get-clusters
```

<details>
<summary>
Просмотр списка имен доступных кластеров
</summary>

```log
NAME
kind-skv-21-2-k8s-depl
```

</details>

```bash
# Загрузка образов контейнеров в кластер на ноды в KIND
kind load docker-image \
nginx:denskv \
--name skv-21-2-k8s-depl

kind load docker-image \
wbitt/network-multitool:denskv \
--name skv-21-2-k8s-depl

kind load docker-image \
busybox:denskv \
--name skv-21-2-k8s-depl
```

<details>
<summary>
Сообщение что образы уже загружены в кластер KIND
</summary>

```log
Image: "nginx:denskv" with ID "sha256:f075e3f9498646fffa374cbd2a781eec14d8e788304a2c40a7f2355996a2146a" found to be already present on all nodes.

Image with ID: sha256:f4f4b4b4dd953a35486839ef36481c59e0628155494fead5fdcc0a9875752ec8 already present on the node skv-21-2-k8s-depl-worker2 but is missing the tag docker.io/wbitt/network-multitool:denskv. re-tagging...
Image with ID: sha256:f4f4b4b4dd953a35486839ef36481c59e0628155494fead5fdcc0a9875752ec8 already present on the node skv-21-2-k8s-depl-worker but is missing the tag docker.io/wbitt/network-multitool:denskv. re-tagging...
Image with ID: sha256:f4f4b4b4dd953a35486839ef36481c59e0628155494fead5fdcc0a9875752ec8 already present on the node skv-21-2-k8s-depl-control-plane but is missing the tag docker.io/wbitt/network-multitool:denskv. re-tagging...

Image with ID: sha256:c6348fa86ba0fb2108c9334f5fe913ddc6d853313e655891f133a0127c30099f already present on the node skv-21-2-k8s-depl-worker2 but is missing the tag docker.io/library/busybox:denskv. re-tagging...
Image with ID: sha256:c6348fa86ba0fb2108c9334f5fe913ddc6d853313e655891f133a0127c30099f already present on the node skv-21-2-k8s-depl-worker but is missing the tag docker.io/library/busybox:denskv. re-tagging...
Image: "busybox:denskv" with ID "sha256:c6348fa86ba0fb2108c9334f5fe913ddc6d853313e655891f133a0127c30099f" not yet present on node "skv-21-2-k8s-depl-control-plane", loading...
```

</details>

### `Yaml`-манифест deployment с init контейнером

<details>
<summary>
Yaml-манифест deployment с init контейнером
</summary>

```bash
cat > depl_svc_clip_nopo_nginx-mtool-init.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: w8-svc-clip
  labels:
    role: den-clip-nopo
    app: nginx-clip-nopo
    organization: netology-fops40
    creator: denskv
spec:
  type: ClusterIP
  selector:
    app: nginx-clip-nopo
  ports:
  - name: nginx
    port: 9001
    targetPort: 80
    protocol: TCP
  - name: multitool
    port: 9002
    targetPort: 8080
    protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: w8-svc-nopo
  labels:
    role: den-clip-nopo
    app: nginx-clip-nopo
    organization: netology-fops40
    creator: denskv
spec:
  type: NodePort
  selector:
    app: nginx-clip-nopo
  ports:
  - name: nginx
    port: 80
    targetPort: 80
    nodePort: 30080
    protocol: TCP
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-mtool-init
  labels:
    role: den-clip-nopo
    app: nginx-clip-nopo
    organization: netology-fops40
    creator: denskv
spec:
  replicas: 3
  minReadySeconds: 10
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nginx-clip-nopo
  template:
    metadata:
      labels:
        app: nginx-clip-nopo
    spec:
      initContainers:
      - name: w8-4-svc-clip
        image: busybox:denskv
        imagePullPolicy: Never  # Использовать ранее использованные или выгруженные в кластер образы
        command:
          - sh
          - -c
          - |
            until nslookup w8-svc-clip.default.svc.cluster.local || nslookup w8-svc-nopo.default.svc.cluster.local; do
              echo "Waiting for Service w8-svc-clip or w8-svc-nopo..."
              sleep 2
            done
            echo "Service w8-svc is UP!"
      containers:
      - name: nginx
        image: nginx:denskv
        imagePullPolicy: Never  # Использовать ранее использованные или выгруженные в кластер образы
        ports:
        - containerPort: 80
        volumeMounts:
          - name: nginx-html
            mountPath: /usr/share/nginx/html/index.html  # полный путь монтирования для опции subPath
            subPath: index.html # Подмонтировать только index.html (для обновления пересоздать pod)
            readOnly: true
      - name: multitool
        image: wbitt/network-multitool:denskv
        imagePullPolicy: Never  # Использовать ранее использованные или выгруженные в кластер образы
        env:
        - name: HTTP_PORT
          value: "8080"
        ports:
        - containerPort: 8080
      volumes:
        - name: nginx-html
          configMap:
            name: nginx-html-file
EOF
```

</details>

### `Yaml`-манифест configmaps для index.html

<details>
<summary>
Yaml-манифест config-map
</summary>

```bash
cat > cm_nginx-html.yaml <<'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-html-file
  labels:
    role: den-clip-nopo
    app: nginx-clip-nopo
    organization: netology-fops40
    creator: denskv
data:
  index.html: |
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>Страница из volumeMounts</title>
      <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        .joke { background-color: #f0f0f0; padding: 15px; border-radius: 8px; margin-top: 20px; }
      </style>
    </head>
    <body>
      <h1>Привет из ПОДА Kubernetes!</h1>
      <p>Эта страница подгружена из ConfigMap в volumeMounts.</p>
      
      <div class="joke">
        <h3>Из окружения DevOps:</h3>
        <p>- Почему разработчик не стал чинить прод?<br>
        - Потому что в локальной среде всё работало!</p>
      </div>
    </body>
    </html>

EOF
```

</details>


```bash
# Просмотр IP-адресов нод и подов кластера
watch -c 'kubectl get no -o wide \
| awk "{print \$1 \"\n\" \$6}" \
&& kubectl get pods -o wide \
&& echo -e "\n---===ВЫВОД-ТЕКУЩЕЙ-СТРАНИЦЫ-ПОДОВ==---" \
&& kubectl describe nodes \
| awk "/InternalIP/ {print \$2}" \
| xargs -I {} curl -s {}:30080 \
| grep -E -A3 "<h1>Welcome to nginx!</h1>|DevOps"'
```

<details>
<summary>
просмотр IP-адресов нод и подов
</summary>

```log
```

</details>

```bash
kubectl apply \
-f cm_nginx-html.yaml \
-f depl_svc_clip_nopo_nginx-mtool-init.yaml \
&& kubectl rollout status deployment -l creator=denskv
```

```bash
# Принудительный Перезапуск подов ориентирование по labels
kubectl rollout restart deployment -l organization=netology-fops40 \
|| kubectl delete pod -l app=nginx-clip-nopo \
&& kubectl rollout status deployment -l role=den-clip-nopo
```

<details>

<summary>
Лог перезапуска подов
</summary>

```log
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 out of 3 new replicas have been updated...
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 out of 3 new replicas have been updated...
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 out of 3 new replicas have been updated...
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 out of 3 new replicas have been updated...
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 out of 3 new replicas have been updated...
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "nginx-mtool-init" rollout to finish: 1 of 3 updated replicas are available...
deployment "nginx-mtool-init" successfully rolled out

#ИЛИ

pod "nginx-mtool-init-54d877bc7c-kqzfn" deleted from default namespace
pod "nginx-mtool-init-54d877bc7c-qxdnh" deleted from default namespace
pod "nginx-mtool-init-54d877bc7c-tbzxf" deleted from default namespace
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 of 3 updated replicas are available...
deployment "nginx-mtool-init" successfully rolled out
```

</details>

```bash
# Мониторинг кластера 
echo -e "\nСписок IP-адресов кластера:" \
&& kubectl describe nodes \
| awk '/InternalIP/ {print $2}' \
&& echo \
&& kubectl describe nodes \
| awk '/InternalIP/ {print $2}' \
| xargs -I {} curl -s {}:30080 \
| grep -E -A3 "<h1>Welcome to nginx!</h1>|DevOps"
```

<summary>
Лог мониторинга кластера
</summary>

```log
NAME
INTERNAL-IP
skv-21-2-k8s-depl-control-plane
172.18.0.3
skv-21-2-k8s-depl-worker
172.18.0.2
skv-21-2-k8s-depl-worker2
172.18.0.4
NAME                                READY   STATUS    RESTARTS   AGE   IP            NODE                        NOMINA
TED NODE   READINESS GATES
nginx-mtool-init-79b889b7cb-7kk4l   2/2     Running   0          26s   10.244.1.65   skv-21-2-k8s-depl-worker    <none>
           <none>
nginx-mtool-init-79b889b7cb-nflpj   2/2     Running   0          26s   10.244.2.45   skv-21-2-k8s-depl-worker2   <none>
           <none>
nginx-mtool-init-79b889b7cb-zcssg   2/2     Running   0          26s   10.244.1.64   skv-21-2-k8s-depl-worker    <none>
           <none>

---===ВЫВОД-ТЕКУЩЕЙ-СТРАНИЦЫ-ПОДОВ==---
    <h3>Из окружения DevOps:</h3>
    <p>- Почему разработчик не стал чинить прод?<br>
    - Потому что в локальной среде всё работало!</p>
  </div>
--
    <h3>Из окружения DevOps:</h3>
    <p>- Почему разработчик не стал чинить прод?<br>
    - Потому что в локальной среде всё работало!</p>
  </div>
--
    <h3>Из окружения DevOps:</h3>
    <p>- Почему разработчик не стал чинить прод?<br>
    - Потому что в локальной среде всё работало!</p>
  </div>
```

</details>

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 21_5-K8S-conf-app' \
&& git push \
--set-upstream \
study_fops39 \
21_5-K8S-conf-app \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_5-K8S-conf-app \
&& git push \
--set-upstream \
study-fops39_sc \
21_5-K8S-conf-app
```

## commit_3,`21_5-K8S-conf-app`