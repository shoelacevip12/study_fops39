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

```log
deployment.apps "nginx-mtool-init" deleted from default namespace
service "w8-svc-clip" deleted from default namespace
service "w8-svc-nopo" deleted from default namespace
```

### Скачивание манифеста ingress контроллера

```bash
git clone https://github.com/projectcontour/contour.git

find . \
-name ".git" \
-exec rm -vrf {} \;

kubectl apply \
-f ./contour/examples/contour
```

<details>
<summary>
Вывод развертывания contour
</summary>

```log
Клонирование в «contour»...
remote: Enumerating objects: 57875, done.
remote: Counting objects: 100% (1428/1428), done.
remote: Compressing objects: 100% (671/671), done.
remote: Total 57875 (delta 1176), reused 812 (delta 746), pack-reused 56447 (from 5)
Получение объектов: 100% (57875/57875), 39.55 MiB | 10.49 MiB/s, готово.
Определение изменений: 100% (43186/43186), готово.
Updating files: 100% (2992/2992), готово.

удалён './contour/.git/description'
удалён './contour/.git/hooks/post-update.sample'
удалён './contour/.git/hooks/pre-rebase.sample'
удалён './contour/.git/hooks/pre-commit.sample'
удалён './contour/.git/hooks/pre-receive.sample'
удалён './contour/.git/hooks/commit-msg.sample'
удалён './contour/.git/hooks/pre-push.sample'
удалён './contour/.git/hooks/applypatch-msg.sample'
удалён './contour/.git/hooks/pre-applypatch.sample'
удалён './contour/.git/hooks/update.sample'
удалён './contour/.git/hooks/fsmonitor-watchman.sample'
удалён './contour/.git/hooks/push-to-checkout.sample'
удалён './contour/.git/hooks/pre-merge-commit.sample'
удалён './contour/.git/hooks/sendemail-validate.sample'
удалён './contour/.git/hooks/prepare-commit-msg.sample'
удалён каталог './contour/.git/hooks'
удалён './contour/.git/info/exclude'
удалён каталог './contour/.git/info'
удалён './contour/.git/objects/pack/pack-38e2169f1d9ca8d3db9ca5e3e031db43b733f469.pack'
удалён './contour/.git/objects/pack/pack-38e2169f1d9ca8d3db9ca5e3e031db43b733f469.rev'
удалён './contour/.git/objects/pack/pack-38e2169f1d9ca8d3db9ca5e3e031db43b733f469.idx'
удалён каталог './contour/.git/objects/pack'
удалён каталог './contour/.git/objects/info'
удалён каталог './contour/.git/objects'
удалён './contour/.git/refs/heads/main'
удалён каталог './contour/.git/refs/heads'
удалён каталог './contour/.git/refs/tags'
удалён './contour/.git/refs/remotes/origin/HEAD'
удалён каталог './contour/.git/refs/remotes/origin'
удалён каталог './contour/.git/refs/remotes'
удалён каталог './contour/.git/refs'
удалён './contour/.git/packed-refs'
удалён './contour/.git/logs/refs/remotes/origin/HEAD'
удалён каталог './contour/.git/logs/refs/remotes/origin'
удалён каталог './contour/.git/logs/refs/remotes'
удалён './contour/.git/logs/refs/heads/main'
удалён каталог './contour/.git/logs/refs/heads'
удалён каталог './contour/.git/logs/refs'
удалён './contour/.git/logs/HEAD'
удалён каталог './contour/.git/logs'
удалён './contour/.git/HEAD'
удалён './contour/.git/config'
удалён './contour/.git/index'
удалён каталог './contour/.git'
find: «./contour/.git»: Нет такого файла или каталога

namespace/projectcontour created
serviceaccount/contour created
serviceaccount/envoy created
configmap/contour created
customresourcedefinition.apiextensions.k8s.io/contourconfigurations.projectcontour.io created
customresourcedefinition.apiextensions.k8s.io/contourdeployments.projectcontour.io created
customresourcedefinition.apiextensions.k8s.io/extensionservices.projectcontour.io created
customresourcedefinition.apiextensions.k8s.io/httpproxies.projectcontour.io created
customresourcedefinition.apiextensions.k8s.io/tlscertificatedelegations.projectcontour.io created
serviceaccount/contour-certgen created
rolebinding.rbac.authorization.k8s.io/contour created
role.rbac.authorization.k8s.io/contour-certgen created
job.batch/contour-certgen-main created
clusterrolebinding.rbac.authorization.k8s.io/contour created
rolebinding.rbac.authorization.k8s.io/contour-rolebinding created
clusterrole.rbac.authorization.k8s.io/contour created
role.rbac.authorization.k8s.io/contour created
service/contour created
service/envoy created
deployment.apps/contour created
daemonset.apps/envoy created
```

</details>

```bash
# проверка подов в namespace projectcontour
kubectl get pods -n projectcontour -o wide
```

<details>
<summary>
Проверка созданных ресурсов
</summary>

```log
NAME                       READY   STATUS    RESTARTS   AGE   IP           NODE                        NOMINATED NODE   READINESS GATES
contour-5595b97775-n88js   1/1     Running   0          87s   10.244.2.4   skv-21-2-k8s-depl-worker2   <none>           <none>
contour-5595b97775-psd4d   1/1     Running   0          87s   10.244.1.4   skv-21-2-k8s-depl-worker    <none>           <none>
envoy-mb6vz                2/2     Running   0          87s   10.244.1.5   skv-21-2-k8s-depl-worker    <none>           <none>
envoy-zpxfp                2/2     Running   0          87s   10.244.2.5   skv-21-2-k8s-depl-worker2   <none>           <none>
```

</details>

### `Yaml`-манифест deployment depl-front

<details>
<summary>
Yaml-манифест deployment depl-front
</summary>

```bash
cat > depl-front.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: depl-front
  labels:
    role: den-ingress
    app: front-app
    organization: netology-fops40
    creator: denskv
spec:
  replicas: 2
  minReadySeconds: 10
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: app-front
  template:
    metadata:
      labels:
        app: app-front
    spec:
      initContainers:
      - name: w8-4-svc-front
        image: busybox:latest
        command:
          - sh
          - -c
          - |
            until nslookup svc-front.default.svc.cluster.local; do
              echo "Waiting for Service svc-front..."
              sleep 2
            done
            echo "Service svc-front is UP!"
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
EOF
```

</details>

### `Yaml`-манифест frontend сервиса для deployment depl-front

<details>
<summary>
Yaml-манифест frontend сервиса для deployment depl-front
</summary>

```bash
cat > svc-front.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: svc-front
  labels:
    role: den-ingress
    app: front-app
    organization: netology-fops40
    creator: denskv
spec:
  type: ClusterIP
  selector:
    app: app-front
  ports:
  - name: http
    port: 80
    targetPort: 80
    protocol: TCP
EOF
```

</details>

### `Yaml`-манифест deployment depl-back

<details>
<summary>
Yaml-манифест deployment depl-back
</summary>

```bash
cat > depl-back.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: depl-back
  labels:
    role: den-ingress
    app: back-app
    organization: netology-fops40
    creator: denskv
spec:
  replicas: 2
  minReadySeconds: 10
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: app-back
  template:
    metadata:
      labels:
        app: app-back
    spec:
      initContainers:
      - name: w8-4-svc-back
        image: busybox:latest
        command:
          - sh
          - -c
          - |
            until nslookup svc-back.default.svc.cluster.local; do
              echo "Waiting for Service svc-back..."
              sleep 2
            done
            echo "Service svc-back is UP!"
      containers:
      - name: multitool
        image: wbitt/network-multitool:latest
        env:
        - name: HTTP_PORT
          value: "8080"
        ports:
        - containerPort: 8080
EOF
```

</details>

### `Yaml`-манифест backend сервиса для deployment depl-back

<details>
<summary>
Yaml-манифест backend сервиса для deployment depl-back
</summary>

```bash
cat > svc-back.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: svc-back
  labels:
    role: den-ingress
    app: back-app
    organization: netology-fops40
    creator: denskv
spec:
  type: ClusterIP
  selector:
    app: app-back
  ports:
  - name: http
    port: 8080
    targetPort: 8080
    protocol: TCP
EOF
```

</details>

### Создание ingress ресурса

<details>
<summary>
Yaml-манифест ingress сервиса для deployment depl-front и depl-back
</summary>

```bash
cat > svc_ingress.yaml <<'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: fops-ingress
  labels:
    role: den-ingress
    app: ingress-svc-front-back
    organization: netology-fops40
    creator: denskv
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  ingressClassName: contour
  rules:
  - host: fops.local
    http:
      paths:
      - path: /api(/|$)(.*)
        pathType: Prefix
        backend:
          service:
            name: svc-back
            port:
              number: 8080
      - path: /
        pathType: Prefix
        backend:
          service:
            name: svc-front
            port:
              number: 80
EOF
```

</details>



```bash
# добавление записи в /etc/hosts и проверка backend и frontend сервисов
echo "172.18.0.4 fops.local" \
| sudo tee -a /etc/hosts

cat /etc/hosts
```

<details>
<summary>
Проверка resolving имен на хосте сервера kubernetes
</summary>

```log
172.18.0.4 fops.local

# Static table lookup for hostnames.
# See hosts(5) for details.
# Static table lookup for hostnames.
# See hosts(5) for details.
127.0.0.1        localhost
::1              localhost
172.18.0.4 fops.local
```

</details>


```bash
ping -c 2 fops.local
```

<details>
<summary>
Проверка resolving имен на хосте сервера kubernetes
</summary>

```log
PING fops.local (172.18.0.4) 56(84) bytes of data.
64 bytes from fops.local (172.18.0.4): icmp_seq=1 ttl=64 time=0.042 ms
64 bytes from fops.local (172.18.0.4): icmp_seq=2 ttl=64 time=0.053 ms

--- fops.local ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1059ms
rtt min/avg/max/mdev = 0.042/0.047/0.053/0.005 ms                                                                                            15:53:34
```

</details>


```bash
# Применение манифестов deployment и сервисов, просмотр подов
kubectl apply -f depl-front.yaml \
&& kubectl apply -f depl-back.yaml \
&& kubectl apply -f svc-back.yaml \
&& kubectl apply -f svc-front.yaml \
&& kubectl apply -f svc_ingress.yaml \
&& kubectl get po -L creator=denskv -w
```

<details>
<summary>
применение манифестов и просмотр подов
</summary>

```log
deployment.apps/depl-front created
deployment.apps/depl-back created
service/svc-back created
service/svc-front created
ingress.networking.k8s.io/fops-ingress created
NAME                          READY   STATUS     RESTARTS   AGE   CREATOR=DENSKV
depl-back-5b8b6b5fc4-49rxz    0/1     Init:0/1   0          0s    
depl-back-5b8b6b5fc4-hkw67    0/1     Init:0/1   0          0s    
depl-front-744b56968d-qr9m2   0/1     Init:0/1   0          1s    
depl-front-744b56968d-qst6r   0/1     Init:0/1   0          1s    
depl-front-744b56968d-qst6r   0/1     Init:0/1   0          2s    
depl-front-744b56968d-qr9m2   0/1     Init:0/1   0          2s    
depl-front-744b56968d-qr9m2   0/1     PodInitializing   0          3s    
depl-front-744b56968d-qst6r   0/1     PodInitializing   0          3s    
depl-back-5b8b6b5fc4-hkw67    0/1     Init:0/1          0          2s    
depl-back-5b8b6b5fc4-49rxz    0/1     Init:0/1          0          2s    
depl-front-744b56968d-qst6r   1/1     Running           0          4s    
depl-back-5b8b6b5fc4-hkw67    0/1     PodInitializing   0          3s    
depl-back-5b8b6b5fc4-49rxz    0/1     PodInitializing   0          3s    
depl-back-5b8b6b5fc4-49rxz    1/1     Running           0          4s    
depl-front-744b56968d-qr9m2   1/1     Running           0          5s    
depl-back-5b8b6b5fc4-hkw67    1/1     Running           0          5s 
```

</details>


```bash
# Мониторинг подов и сервисов deployment
watch -cn 1 \
"kubectl get pods -L creator=denskv \
&& echo ---------==================-------- \
&& kubectl get svc -l creator=denskv \
&& echo ---------==================-------- \
&& kubectl get ing -l creator=denskv \
&& echo ---------==================-------- \
&& ping -c 1 fops.local | head -n2"

```

<details>
<summary>
мониторинг подов и сервисов
</summary>

```log
NAME                          READY   STATUS    RESTARTS   AGE   CREATOR=DEN
SKV
depl-back-5b8b6b5fc4-49rxz    1/1     Running   0          85s
depl-back-5b8b6b5fc4-hkw67    1/1     Running   0          85s
depl-front-744b56968d-qr9m2   1/1     Running   0          86s
depl-front-744b56968d-qst6r   1/1     Running   0          86s
---------==================--------
NAME        TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
svc-back    ClusterIP   10.96.243.75   <none>        8080/TCP   85s
svc-front   ClusterIP   10.96.198.80   <none>        80/TCP     85s
---------==================--------
NAME           CLASS     HOSTS        ADDRESS   PORTS   AGE
fops-ingress   contour   fops.local             80      86s
---------==================--------
PING fops.local (172.18.0.4) 56(84) bytes of data.
64 bytes from fops.local (172.18.0.4): icmp_seq=1 ttl=64 time=0.050 ms
```

</details>

```bash
# Проверка статуса rollout deployment
kubectl rollout status deployment \
-l creator=denskv -w
```

<details>
<summary>
проверка статуса rollout deployment
</summary>

```log
Waiting for deployment "depl-back" rollout to finish: 0 of 2 updated replicas are available...
Waiting for deployment "depl-back" rollout to finish: 0 of 2 updated replicas are available...
Waiting for deployment "depl-back" rollout to finish: 0 of 2 updated replicas are available...
deployment "depl-back" successfully rolled out
deployment "depl-front" successfully rolled out
```

</details>


```bash
# Обновление команды просмотра логов из backend и frontend deployment
watch -c -n1 \
"echo ----------======BACK========------------------- \
&& kubectl logs deployments/depl-back | tail -n5 \
&& echo ----------====FRONTEND======-------------------  \
&& kubectl logs deployments/depl-front | tail -n5"
```

<details>
<summary>
проверка Проверка логов deployment
</summary>

```log
----------======BACK========-------------------
Found 2 pods, using pod/depl-back-5b8b6b5fc4-9nwt8
Defaulted container "multitool" out of: multitool, w8-4-svc-back (init)
10.244.1.3 - - [18/Aug/2026:20:14:33 +0000] "GET /api HTTP/1.1" 404 153 "-" "curl/8.21.0" "172.18.0.
1"
2026/08/18 20:14:35 [error] 24#24: *4 open() "/usr/share/nginx/html/api" failed (2: No such file or
directory), client: 10.244.1.3, server: localhost, request: "GET /api HTTP/1.1", host: "fops.local"
10.244.1.3 - - [18/Aug/2026:20:14:35 +0000] "GET /api HTTP/1.1" 404 153 "-" "curl/8.21.0" "172.18.0.
1"
10.244.1.3 - - [18/Aug/2026:20:14:37 +0000] "GET /api HTTP/1.1" 404 153 "-" "curl/8.21.0" "172.18.0.
1"
2026/08/18 20:14:37 [error] 24#24: *18 open() "/usr/share/nginx/html/api" failed (2: No such file or
 directory), client: 10.244.1.3, server: localhost, request: "GET /api HTTP/1.1", host: "fops.local"
----------====FRONTEND======-------------------
Found 2 pods, using pod/depl-front-744b56968d-6zcdf
Defaulted container "nginx" out of: nginx, w8-4-svc-front (init)
10.244.1.3 - - [18/Aug/2026:20:14:26 +0000] "GET / HTTP/1.1" 200 896 "-" "curl/8.21.0" "172.18.0.1"
10.244.1.3 - - [18/Aug/2026:20:14:30 +0000] "GET / HTTP/1.1" 200 896 "-" "curl/8.21.0" "172.18.0.1"
10.244.1.3 - - [18/Aug/2026:20:14:31 +0000] "GET / HTTP/1.1" 200 896 "-" "curl/8.21.0" "172.18.0.1"
10.244.1.3 - - [18/Aug/2026:20:14:34 +0000] "GET / HTTP/1.1" 200 896 "-" "curl/8.21.0" "172.18.0.1"
10.244.1.3 - - [18/Aug/2026:20:14:36 +0000] "GET / HTTP/1.1" 200 896 "-" "curl/8.21.0" "172.18.0.1"
```

</details>

```bash
# Скрипт опроса сервисов
while true; do \
echo "||||BACKEND||||" \
&& curl -s http://fops.local/api \
&& sleep 1 \
&& echo "||||FRONTEND||||" \
&& curl -s http://fops.local/ \
| head -n12; \
done
```

<details>
<summary>
вывод скрипта опроса сервисов
</summary>

```log
||||BACKEND||||
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.28.0</center>
</body>
</html>
||||FRONTEND||||
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
```

</details>

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit3, 21_3-K8S-netw' \
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

## commit_77, master

```bash
# Удаление манифестов deployment и сервисов, просмотр подов
kubectl delete -f depl-front.yaml \
&& kubectl delete -f depl-back.yaml \
&& kubectl delete -f svc-back.yaml \
&& kubectl delete -f svc-front.yaml \
&& kubectl delete -f svc_ingress.yaml
```