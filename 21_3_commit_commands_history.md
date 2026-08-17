# Для домашнего задания 21.3 `Сетевое взаимодействие в Kubernetes`

## commit_76, master Предварительная подготовка

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
-not -path "*1.4*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем
mv -v kuber-homeworks \
21_3

# Переход в каталог по последней переменной вывода последней команды
cd !$

mv -v 1.4/* ./

# Удаление всех файлов и каталогов кроме нужных
find . \
-mindepth 1 \
-not -path "*1.4*" \
-delete

# Переименование 
mv -v {1.4,README}.md
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
git commit -am 'commit_76, master' \
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

## commit_1, `21_3-K8S-netw`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 21_3-K8S-netw

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
git commit -am 'commit1, 21_3-K8S-netw' \
&& git push \
--set-upstream \
study_fops39 \
21_3-K8S-netw \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_3-K8S-netw \
&& git push \
--set-upstream \
study-fops39_sc \
21_3-K8S-netw
```

## commit_2,`21_3-K8S-netw`

### `Yaml`-манифест deployment с init контейнером

<details>
<summary>
Yaml-манифест deployment с init контейнером
</summary>

```bash
cat > depl_nginx-mtool-init.yaml <<'EOF'
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
        image: busybox:latest
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
        image: nginx:latest
        ports:
        - containerPort: 80
      - name: multitool
        image: wbitt/network-multitool:latest
        env:
        - name: HTTP_PORT
          value: "1180"
        ports:
        - containerPort: 1180
EOF
```

</details>

### `Yaml`-манифест с ClusterIP

<details>
<summary>
Yaml-манифест ClusterIP для deployment nginx-mtool-init
</summary>

```bash
cat > svc_clip_nginx-mtool-init.yaml <<'EOF'
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
    targetPort: 1180
    protocol: TCP
EOF
```

</details>

### `Yaml`-манифест с NodePort

<details>
<summary>
Yaml-манифест NodePort для deployment nginx-mtool-init
</summary>

```bash
cat > svc_nopo_nginx-mtool-init.yaml <<'EOF'
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
EOF
```

</details>

```bash
# Применение манифестов deployment и сервисов, просмотр подов
kubectl apply -f depl_nginx-mtool-init.yaml \
&& kubectl apply -f svc_clip_nginx-mtool-init.yaml \
&& kubectl apply -f svc_nopo_nginx-mtool-init.yaml \
&& kubectl get po -L role=den-clip-nopo -w
```

<details>
<summary>
применение манифестов и просмотр подов
</summary>

```log
deployment.apps/nginx-mtool-init created
service/w8-svc-clip created
service/w8-svc-nopo created
NAME                                READY   STATUS     RESTARTS   AGE   ROLE=DEN-CLIP-NOPO
nginx-mtool-init-6c87b875fd-4fpn9   0/2     Init:0/1   0          1s
nginx-mtool-init-6c87b875fd-9zzwv   0/2     Init:0/1   0          1s
nginx-mtool-init-6c87b875fd-mc6qk   0/2     Init:0/1   0          1s
nginx-mtool-init-6c87b875fd-9zzwv   0/2     Init:0/1   0          2s
nginx-mtool-init-6c87b875fd-4fpn9   0/2     Init:0/1   0          2s
nginx-mtool-init-6c87b875fd-9zzwv   0/2     PodInitializing   0          2s
nginx-mtool-init-6c87b875fd-4fpn9   0/2     PodInitializing   0          3s
nginx-mtool-init-6c87b875fd-mc6qk   0/2     Init:0/1          0          3s
nginx-mtool-init-6c87b875fd-mc6qk   0/2     PodInitializing   0          4s
nginx-mtool-init-6c87b875fd-9zzwv   2/2     Running           0          5s
nginx-mtool-init-6c87b875fd-4fpn9   2/2     Running           0          5s
nginx-mtool-init-6c87b875fd-mc6qk   2/2     Running           0          6s
```

</details>

```bash
# Мониторинг подов и сервисов deployment
watch -c \
"kubectl get pods -L role=den-clip-nopo \
&& echo ---------==================-------- \
&& kubectl get svc -l role=den-clip-nopo"
```

<details>
<summary>
мониторинг подов и сервисов
</summary>

```log
NAME                                READY   STATUS    RESTARTS   AGE     ROLE=DEN
-CLIP-NOPO
nginx-mtool-init-6c87b875fd-4fpn9   2/2     Running   0          2m24s
nginx-mtool-init-6c87b875fd-9zzwv   2/2     Running   0          2m24s
nginx-mtool-init-6c87b875fd-mc6qk   2/2     Running   0          2m24s
---------==================--------
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
w8-svc-clip   ClusterIP   10.96.52.229    <none>        9001/TCP,9002/TCP   2m23s
w8-svc-nopo   NodePort    10.96.220.228   <none>        80:30080/TCP        2m23s
```

</details>

```bash
# Проверка статуса rollout deployment
kubectl rollout status deployment -l role=den-clip-nopo -w
```

<details>
<summary>
проверка статуса rollout deployment
</summary>

```log
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "nginx-mtool-init" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "nginx-mtool-init" rollout to finish: 2 of 3 updated replicas are available...
deployment "nginx-mtool-init" successfully rolled out
```

</details>

```bash
# Проверка доступности сервиса ClusterIP из временного пода
echo "$(kubectl run test-pod --image=wbitt/network-multitool --rm -it -- curl w8-svc-clip:9001)" | head -n 7 \
&& echo ---------==================-------- \
&& sleep 5 \
&& echo "$(kubectl run test-pod --image=wbitt/network-multitool --rm -it -- curl w8-svc-clip:9002)" | head -n 7
```

<details>
<summary>
проверка доступности сервиса ClusterIP
</summary>

```log
All commands and output from this session will be recorded in container logs, including credentials and sensitive information passed through the command prompt.
If you don't see a command prompt, try pressing enter.
warning: couldn't attach to pod/test-pod, falling back to streaming logs: unable to upgrade connection: container test-pod not found in pod test-pod_default
The directory /usr/share/nginx/html is not mounted.
Therefore, over-writing the default index.html file with some useful information:
WBITT Network MultiTool (with NGINX) - test-pod - 10.244.2.43 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
---------==================--------
All commands and output from this session will be recorded in container logs, including credentials and sensitive information passed through the command prompt.
If you don't see a command prompt, try pressing enter.
warning: couldn't attach to pod/test-pod, falling back to streaming logs: Internal error occurred: Internal error occurred: error attaching to container: failed to load task: no running task found: task 16a15a74321cc0d748e36caefd56128a7fbe40bd026ed1d8c966a1f5058b3009 not found
The directory /usr/share/nginx/html is not mounted.
Therefore, over-writing the default index.html file with some useful information:
WBITT Network MultiTool (with NGINX) - test-pod - 10.244.2.44 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
WBITT Network MultiTool (with NGINX) - nginx-mtool-init-6c87b875fd-mc6qk - 10.244.1.14 - HTTP: 1180 , HTTPS: 443 . (Formerly praqma/network-multitool)
The directory /usr/share/nginx/html is not mounted.
Therefore, over-writing the default index.html file with some useful information:
WBITT Network MultiTool (with NGINX) - test-pod - 10.244.2.44 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
```

</details>

```bash
# Проверка доступности сервиса NodePort через node worker
curl 172.18.0.3:30080 | head -n 7 \
&& echo ---------==================-------- \
&& sleep 2 \
&& curl 172.18.0.4:30080 | head -n 7
```

<details>
<summary>
проверка доступности сервиса NodePort
</summary>

```log
  % Total    % Received % Xferd  Average Speed  Time    Time    Time   Current
                                 Dload  Upload  Total   Spent   Left   Speed
100    896 100    896   0      0 401.5k      0                              0
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
---------==================--------
  % Total    % Received % Xferd  Average Speed  Time    Time    Time   Current
                                 Dload  Upload  Total   Spent   Left   Speed
100    896 100    896   0      0 584.8k      0                              0
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
```

</details>

```bash
# Просмотр IP-адресов нод и подов кластера
kubectl get no -o wide | awk '{print $1 "\n" $6}' && kubectl get pods -o wide -w
```

<details>
<summary>
просмотр IP-адресов нод и подов
</summary>

```log
NAME
INTERNAL-IP
skv-21-2-k8s-depl-control-plane
172.18.0.2
skv-21-2-k8s-depl-worker
172.18.0.3
skv-21-2-k8s-depl-worker2
172.18.0.4
NAME                                READY   STATUS    RESTARTS   AGE   IP            NODE                        NOMINATED NODE   READINESS GATES
nginx-mtool-init-6c87b875fd-4fpn9   2/2     Running   0          76m   10.244.1.15   skv-21-2-k8s-depl-worker    <none>           <none>
nginx-mtool-init-6c87b875fd-9zzwv   2/2     Running   0          76m   10.244.2.8    skv-21-2-k8s-depl-worker2   <none>           <none>
nginx-mtool-init-6c87b875fd-mc6qk   2/2     Running   0          76m   10.244.1.14   skv-21-2-k8s-depl-worker    <none>           <none>
test-pod                            0/1     Pending   0          0s    <none>        <none>                      <none>           <none>
test-pod                            0/1     Pending   0          0s    <none>        skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            0/1     ContainerCreating   0          0s    <none>        skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            0/1     ContainerCreating   0          0s    <none>        skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            1/1     Running             0          2s    10.244.2.43   skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            1/1     Terminating         0          2s    10.244.2.43   skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            0/1     Terminating         0          2s    10.244.2.43   skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            1/1     Terminating         1 (1s ago)   3s    10.244.2.43   skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            0/1     Completed           1 (1s ago)   3s    10.244.2.43   skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            0/1     Completed           1 (2s ago)   4s    10.244.2.43   skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            0/1     Completed           1 (2s ago)   4s    10.244.2.43   skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            0/1     Pending             0            0s    <none>        <none>                      <none>           <none>
test-pod                            0/1     Pending             0            0s    <none>        skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            0/1     ContainerCreating   0            0s    <none>        skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            0/1     ContainerCreating   0            0s    <none>        skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            1/1     Running             0            1s    10.244.2.44   skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            1/1     Terminating         0            1s    10.244.2.44   skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            0/1     Terminating         0            2s    10.244.2.44   skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            1/1     Terminating         1 (2s ago)   3s    10.244.2.44   skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            0/1     Completed           1 (2s ago)   3s    10.244.2.44   skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            0/1     Completed           1 (3s ago)   4s    10.244.2.44   skv-21-2-k8s-depl-worker2   <none>           <none>
test-pod                            0/1     Completed           1 (3s ago)   4s    10.244.2.44   skv-21-2-k8s-depl-worker2   <none>           <none>
```

</details>


```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 21_3-K8S-netw' \
&& git push \
--set-upstream \
study_fops39 \
21_3-K8S-netw \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_3-K8S-netw \
&& git push \
--set-upstream \
study-fops39_sc \
21_3-K8S-netw
```

## commit_3,`21_3-K8S-netw`



```bash
kubectl delete -f depl_nginx-mtool-init.yaml \
&& kubectl delete -f svc_clip_nginx-mtool-init.yaml \
&& kubectl delete -f svc_nopo_nginx-mtool-init.yaml
```