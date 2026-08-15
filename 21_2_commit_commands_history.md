# Для домашнего задания 21.2 `Запуск приложений в K8S`

## commit_75, master Предварительная подготовка

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
-not -path "*1.3*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем
mv -v kuber-homeworks \
21_2

# Переход в каталог по последней переменной вывода последней команды
cd !$

mv -v 1.3/* ./

# Удаление всех файлов и каталогов кроме нужных
find . \
-mindepth 1 \
-not -path "*1.3*" \
-delete

# Переименование 
mv -v {1.3,README}.md
```

```bash
# Удаление кластера kind из предыдущего задания
kind delete cluster \
--name="$(kind get clusters |head -n1)"
```

<details>
<summary>
удаление кластера kind
</summary>

```log
Deleting cluster "kind" ...
Deleted nodes: ["kind-control-plane"]
```

</details>
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
git commit -am 'commit_75, master' \
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

## commit_1, `21_2-K8S-Depl`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 21_2-K8S-Depl

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
git commit -am 'commit1, 21_2-K8S-Depl' \
&& git push \
--set-upstream \
study_fops39 \
21_2-K8S-Depl \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_2-K8S-Depl \
&& git push \
--set-upstream \
study-fops39_sc \
21_2-K8S-Depl
```

## commit_2,`21_2-K8S-Depl`

### `Yaml`-файл kind кластера

<details>
<summary>
Yaml-файл описания кластера
</summary>

```bash
cat > kind-config_exposed_3_nodes.yaml <<'EOF'
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "0.0.0.0"  # Слушать на всех интерфейсах хоста
  apiServerPort: 6443          # Использовать стандартный порт 6443
nodes:
- role: control-plane
- role: worker
- role: worker
kubeadmConfigPatches:
- |
  kind: ClusterConfiguration
  apiServer:
    certSANs:
    - "localhost"
    - "127.0.0.1"
    - "0.0.0.0"
    - "192.168.89.193"        # IP основного хоста
EOF
```

</details>

```bash
# Создание кластера kind с тремя нодами из конфигурационного файла
kind create cluster \
--config kind-config_exposed_3_nodes.yaml \
--name skv-21-2-k8s-depl
```

<details>
<summary>
создание кластера kind skv-21-2-k8s-depl
</summary>

```log
Creating cluster "skv-21-2-k8s-depl" ...
 ✓ Ensuring node image (kindest/node:v1.36.1) 🖼
 ✓ Preparing nodes 📦 📦 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
 ✓ Joining worker nodes 🚜
Set kubectl context to "kind-skv-21-2-k8s-depl"
You can now use your cluster with:

kubectl cluster-info --context kind-skv-21-2-k8s-depl

Thanks for using kind! 😊
```

</details>

```bash
# Просмотр docker контейнеров кластера kind
docker ps
```

<details>
<summary>
просмотр docker контейнеров кластера
</summary>

```log
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                    NAMES
c91e9fed7690   kindest/node:v1.36.1   "/usr/local/bin/entr…"   2 minutes ago   Up 2 minutes                            skv-21-2-k8s-depl-worker2
8c75df7c6246   kindest/node:v1.36.1   "/usr/local/bin/entr…"   2 minutes ago   Up 2 minutes                            skv-21-2-k8s-depl-worker
d39560940f1b   kindest/node:v1.36.1   "/usr/local/bin/entr…"   2 minutes ago   Up 2 minutes   0.0.0.0:6443->6443/tcp   skv-21-2-k8s-depl-control-plane
```

</details>

```bash
# Просмотр нод кластера kind
kubectl get nodes
```

<details>
<summary>
просмотр нод кластера kind
</summary>

```log
NAME                              STATUS   ROLES           AGE     VERSION
skv-21-2-k8s-depl-control-plane   Ready    control-plane   3m40s   v1.36.1
skv-21-2-k8s-depl-worker          Ready    <none>          3m25s   v1.36.1
skv-21-2-k8s-depl-worker2         Ready    <none>          3m25s   v1.36.1
```

</details>

```bash
# Экспорт конфигурации kubectl для кластера для использования в Lens
kind get kubeconfig --name "$(kind get clusters |head -n1)" \
> remote-lens-config.yaml

# Удаление сертификата CA из конфигурации kubectl
sed -i '/certificate-authority-data/d' \
remote-lens-config.yaml

# Указание IP адреса хоста control-node в конфигурации kubectl
sed -i 's/0.0.0.0/192.168.89.193/' \
remote-lens-config.yaml

# Указание пропуска проверки Доверенности SSL в конфигурации kubectl
sed -i '/6443/a\    insecure-skip-tls-verify: true' \
remote-lens-config.yaml

# В Lens
## KUBERNETES CLUSTER -> Local Kubeconfigs -> Add kubeconfig -> From filesystem
# или
## KUBERNETES CLUSTER -> Local Kubeconfigs -> Add kubeconfig -> Paste (скопировать содержимое файла remote-lens-config.yaml)
```

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 21_2-K8S-Depl' \
&& git push \
--set-upstream \
study_fops39 \
21_2-K8S-Depl \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_2-K8S-Depl \
&& git push \
--set-upstream \
study-fops39_sc \
21_2-K8S-Depl
```

## commit_3,`21_2-K8S-Depl`

### `Yaml`-манифест deployment

<details>
<summary>
Yaml-манифест deployment
</summary>

```bash
cat > 4_fix_deploy_2_containers_1_pod.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: skv-deploy-4-fix
  labels:
    role: den-4-fix
    app: 4-fix
    organization: netology-fops40
    creator: denskv
spec:
  replicas: 3
  minReadySeconds: 10
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nginx-multitool
  template:
    metadata:
      labels:
        app: nginx-multitool
    spec:
      containers:
      - name: nginx-app
        image: nginx:latest
      - name: multitool-app
        image: wbitt/network-multitool:latest
EOF
```

</details>

```bash
# Применение манифеста deployment
kubectl apply -f ./4_fix_deploy_2_containers_1_pod.yaml
```

<details>
<summary>
применение манифеста deployment
</summary>

```log
deployment.apps/skv-deploy-4-fix created
```

</details>

```bash
# Просмотр состояния подов deployment
kubectl get po -l app=4-fix -w
```

<details>
<summary>
просмотр состояния подов
</summary>

```log
NAME                                READY   STATUS             RESTARTS        AGE
skv-deploy-4-fix-7cb796f95d-9wxpg   1/2     CrashLoopBackOff   6 (4m58s ago)   10m
skv-deploy-4-fix-7cb796f95d-t677t   1/2     CrashLoopBackOff   6 (4m40s ago)   10m
skv-deploy-4-fix-7cb796f95d-tb5x9   1/2     CrashLoopBackOff   6 (4m41s ago)   10m
```

</details>

```bash
# Проверка статуса rollout deployment
kubectl rollout status deployment skv-deploy-4-fix
```

<details>
<summary>
проверка статуса rollout
</summary>

```log
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
```

</details>

```bash
# Удаление deployment из манифеста
kubectl delete -f ./4_fix_deploy_2_containers_1_pod.yaml
```

<details>
<summary>
удаление deployment
</summary>

```log
deployment.apps "skv-deploy-4-fix" deleted from default namespace
```

</details>

### Исправленный `Yaml`-манифест deployment

<details>
<summary>
Yaml-манифест deployment с Фиксом
</summary>

```bash
cat > fixed_deploy_2_containers_1_pod.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: skv-deploy-4-fix
  labels:
    role: den-4-fix
    app: 4-fix
    organization: netology-fops40
    creator: denskv
spec:
  replicas: 3
  minReadySeconds: 10
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nginx-multitool
  template:
    metadata:
      labels:
        app: nginx-multitool
    spec:
      containers:
      - name: nginx-app
        image: nginx:latest
      - name: multitool-app
        image: wbitt/network-multitool:latest
        env:
        - name: HTTP_PORT
          value: "1180"
        - name: HTTPS_PORT
          value: "11443"
        ports:
        - containerPort: 1180
          name: http-mtool
        - containerPort: 11443
          name: https-mtool
EOF
```

</details>

```bash
# Применение исправленного манифеста deployment
kubectl apply -f ./fixed_deploy_2_containers_1_pod.yaml
```

<details>
<summary>
применение исправленного манифеста deployment
</summary>

```log
deployment.apps/skv-deploy-4-fix created
```

</details>

```bash
# Просмотр состояния подов исправленного deployment
watch kubectl get po
```

<details>
<summary>
просмотр состояния подов
</summary>

```log
NAME                                READY   STATUS    RESTARTS   AGE
skv-deploy-4-fix-6578658f56-6x6jg   2/2     Running   0          5m23s
skv-deploy-4-fix-6578658f56-cjb4l   2/2     Running   0          5m23s
skv-deploy-4-fix-6578658f56-gss5h   2/2     Running   0          5m23s
```

</details>

```bash
# Проверка статуса rollout исправленного deployment
kubectl rollout status deployment skv-deploy-4-fix
```

<details>
<summary>
проверка статуса rollout
</summary>

```log
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 1 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 2 of 3 updated replicas are available...
deployment "skv-deploy-4-fix" successfully rolled out
```

</details>

```bash
# Масштабирование deployment до 5 реплик
kubectl scale deployment skv-deploy-4-fix --replicas=5
```

<details>
<summary>
масштабирование deployment
</summary>

```log
deployment.apps/skv-deploy-4-fix scaled
```

</details>

```bash
# Просмотр состояния подов после масштабирования
watch kubectl get po
```

<details>
<summary>
просмотр состояния подов
</summary>

```log
NAME                                READY   STATUS    RESTARTS   AGE
skv-deploy-4-fix-6578658f56-cjb4l   2/2     Running   0          21m
skv-deploy-4-fix-6578658f56-sfd5s   2/2     Running   0          11m
```

</details>

```bash
# Проверка статуса rollout после масштабирования
kubectl rollout status deployment skv-deploy-4-fix
```

<details>
<summary>
проверка статуса rollout
</summary>

```log
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 2 of 3 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 2 of 3 updated replicas are available...
Waiting for deployment spec update to be observed...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 2 of 4 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 2 of 4 updated replicas are available...
Waiting for deployment spec update to be observed...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 4 out of 5 new replicas have been updated...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 4 out of 5 new replicas have been updated...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 2 of 5 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 3 of 5 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 3 of 5 updated replicas are available...
Waiting for deployment spec update to be observed...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 3 of 5 updated replicas are available...
Waiting for deployment "skv-deploy-4-fix" rollout to finish: 3 of 5 updated replicas are available...
deployment "skv-deploy-4-fix" successfully rolled out
```

</details>

### `Yaml`-манифест службы kubernetes с доступом до приложений

<details>
<summary>
Yaml-манифест с доступом до приложений
</summary>

```bash
cat > svc_2_containers_1_pod.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: skv-deploy-4-fix-svc
  labels:
    role: den-4-fix
    app: 4-fix
    organization: netology-fops40
    creator: denskv
spec:
  type: ClusterIP
  selector:
    app: nginx-multitool
  ports:
    - name: nginx
      protocol: TCP
      port: 80
      targetPort: 80

    - name: multitool-http
      protocol: TCP
      port: 1180
      targetPort: 1180

    - name: multitool-https
      protocol: TCP
      port: 11443
      targetPort: 11443
EOF
```

</details>

```bash
# Применение манифеста службы kubernetes
kubectl apply -f svc_2_containers_1_pod.yaml
```

<details>
<summary>
применение манифеста службы
</summary>

```log
service/skv-deploy-4-fix-svc created
```

</details>

```bash
# Просмотр сервисов с организацией netology-fops40
kubectl get svc -L organization=netology-fops40
```

<details>
<summary>
просмотр сервисов с организацией
</summary>

```log
NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                     AGE    ORGANIZATION=NETOLO
GY-FOPS40
kubernetes             ClusterIP   10.96.0.1       <none>        443/TCP                     3h1m
skv-deploy-4-fix-svc   ClusterIP   10.96.221.185   <none>        80/TCP,1180/TCP,11443/TCP   31m
```

</details>

```bash
# Проброс портов сервиса skv-deploy-4-fix-svc
kubectl port-forward svc/skv-deploy-4-fix-svc 8080:80 1180:1180 11443:11443
```

<details>
<summary>
проброс портов сервиса
</summary>

```log
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Forwarding from 127.0.0.1:1180 -> 1180
Forwarding from [::1]:1180 -> 1180
Forwarding from 127.0.0.1:11443 -> 11443
Forwarding from [::1]:11443 -> 11443
Handling connection for 11443
Handling connection for 8080
Handling connection for 1180
Handling connection for 11443
Handling connection for 8080
Handling connection for 1180
Handling connection for 11443
```

</details>

```bash
# Циклическая проверка доступности портов сервиса через curl
while true; \
do for cu in 8080 1180 11443; \
do curl -s http://localhost:$cu; \
sleep 2; \
done; \
done
```

<details>
<summary>
проверка портов сервиса через curl
</summary>

```log
curl: (7) Failed to connect to localhost:8080 after 0 ms: Could not connect to server
curl: (7) Failed to connect to localhost:1180 after 0 ms: Could not connect to server
<html>
<head><title>400 The plain HTTP request was sent to HTTPS port</title></head>
<body>
<center><h1>400 Bad Request</h1></center>
<center>The plain HTTP request was sent to HTTPS port</center>
<hr><center>nginx/1.28.0</center>
</body>
</html>
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, nginx is successfully installed and working.
Further configuration is required for the web server, reverse proxy,
API gateway, load balancer, content cache, or other features.</p>

<p>For online documentation and support please refer to
<a href="https://nginx.org/">nginx.org</a>.<br/>
To engage with the community please visit
<a href="https://community.nginx.org/">community.nginx.org</a>.<br/>
For enterprise grade support, professional services, additional
security features and capabilities please refer to
<a href="https://f5.com/nginx">f5.com/nginx</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
WBITT Network MultiTool (with NGINX) - skv-deploy-4-fix-6578658f56-cjb4l - 10.244.1.4 - HTTP: 1180 , HTTPS: 11443 . (Formerly praqma/network-multitool)
<html>
<head><title>400 The plain HTTP request was sent to HTTPS port</title></head>
<body>
<center><h1>400 Bad Request</h1></center>
<center>The plain HTTP request was sent to HTTPS port</center>
<hr><center>nginx/1.28.0</center>
</body>
</html>
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, nginx is successfully installed and working.
Further configuration is required for the web server, reverse proxy,
API gateway, load balancer, content cache, or other features.</p>
```

</details>

### `Yaml`-манифест пода для тестов

<details>
<summary>
Yaml-манифест пода для теста
</summary>

```bash
cat > multitool-test-pod.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: multitool-test
  labels:
    role: test
    app: multitool-test
    organization: netology-fops40
    creator: denskv
spec:
  containers:
  - name: multitool
    image: wbitt/network-multitool:latest
    command: ["sleep", "3600"]
EOF
```

</details>

```bash
# Применение манифеста тестового пода
kubectl apply -f multitool-test-pod.yaml
```

<details>
<summary>
применение манифеста тестового пода
</summary>

```log
pod/multitool-test created
```

</details>

```bash
# Просмотр состояния тестового пода
kubectl get pod -l app=multitool-test -w
```

<details>
<summary>
просмотр состояния тестового пода
</summary>

```log
NAME             READY   STATUS              RESTARTS   AGE
multitool-test   0/1     ContainerCreating   0          1s
multitool-test   1/1     Running             0          2s
multitool-test   1/1     Terminating         0          28s
multitool-test   1/1     Terminating         0          28s
multitool-test   0/1     Error               0          58s
multitool-test   0/1     Error               0          59s
multitool-test   0/1     Error               0          59s
```

</details>

```bash
# Проверка доступности портов сервиса из тестового пода
for cu in 80 1180 11443; \
do kubectl exec -it multitool-test -- curl -s http://skv-deploy-4-fix-svc:$cu \
| head -n 5; \
sleep 2; \
echo "======--ТЕСТ ПОРТА $cu--====="; \
done;
```

<details>
<summary>
проверка доступности портов сервиса из тестового пода
</summary>

```log
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
======--ТЕСТ ПОРТА 80--=====
WBITT Network MultiTool (with NGINX) - skv-deploy-4-fix-6578658f56-sfd5s - 10.244.1.5 - HTTP: 1180 , HTTPS: 11443 . (Formerly praqma/network-multitool)
======--ТЕСТ ПОРТА 1180--=====
<html>
<head><title>400 The plain HTTP request was sent to HTTPS port</title></head>
<body>
<center><h1>400 Bad Request</h1></center>
<center>The plain HTTP request was sent to HTTPS port</center>
======--ТЕСТ ПОРТА 11443--=====

Error from server (NotFound): pods "multitool-test" not found
======--ТЕСТ ПОРТА 80--=====
Error from server (NotFound): pods "multitool-test" not found
======--ТЕСТ ПОРТА 1180--=====
Error from server (NotFound): pods "multitool-test" not found
```

</details>

```bash
# Удаление тестового пода
kubectl delete -f multitool-test-pod.yaml
```

<details>
<summary>
удаление тестового пода
</summary>

```log
pod "multitool-test" deleted from default namespace
```

</details>

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit3, 21_2-K8S-Depl' \
&& git push \
--set-upstream \
study_fops39 \
21_2-K8S-Depl \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_2-K8S-Depl \
&& git push \
--set-upstream \
study-fops39_sc \
21_2-K8S-Depl
```

## commit_4,`21_2-K8S-Depl`