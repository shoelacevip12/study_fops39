# Для домашнего задания 21.5 `Helm`

## commit_81, master Предварительная подготовка

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
-not -path "*2.4*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем
mv -v kuber-homeworks \
21_6

# Переход в каталог по последней переменной вывода последней команды
cd !$

mv -v 2.4/* ./

# Удаление всех файлов и каталогов кроме нужных
find . \
-mindepth 1 \
-not -path "*2.4.md*" \
-delete

# Переименование 
mv -v {2.4,README}.md
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
git commit -am 'commit_81, master' \
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

## commit_1, `21_6-helm`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 21_6-helm

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
git commit -am 'commit1, 21_6-helm' \
&& git push \
--set-upstream \
study_fops39 \
21_6-helm \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_6-helm \
&& git push \
--set-upstream \
study-fops39_sc \
21_6-helm
```

## commit_2,`21_6-helm`

```bash
# Поиск пакетов в репозиториях archlinux
sudo pacman -Ss helm
```

<Details>
<Summary>
Поиск пакетов в репозиториях archlinux
</Summary>

```log
extra/datree 1.9.19-2
    CLI tool to ensure K8s manifests and Helm charts follow best practices as well as your organization’s policies
extra/gap-packages 4.16.0-2
    Extra packages for GAP
extra/helm 4.2.2-1
    The Kubernetes Package Manager
extra/helmfile 1.5.2-1
    Manage multiple helm charts with a single helmfile
extra/kube-linter 0.8.3-1
    Static analysis tool that checks Kubernetes YAML files and Helm charts
extra/texlive-mathscience 2026.1-1 (texlive)
    TeX Live - Mathematics, natural sciences, computer science packages
extra/vals 0.43.2-1
    Helm-like configuration values loader with support for various sources
```

</Details>

```bash
# Установка пакетов helm и kube-linter
sudo pacman -Syu \
helm \
kube-linter
```

<details>
<summary>
Установка пакетов helm и kube-linter
</summary>

```log
...
проверка конфликтов...

Пакеты (3) wine-11.16-1  helm-4.2.2-1  kube-linter-0.8.3-1

Будет загружено:    112,21 MiB
Будет установлено:  740,14 MiB
Изменение размера:  140,05 MiB

:: Приступить к установке? [Y/n] Y
:: Получение пакетов...
 kube-linter-0.8.3-1-x86_64   15,6 MiB   193 KiB/s 01:23 [#####################] 100%
 helm-4.2.2-1-x86_64          18,5 MiB   172 KiB/s 01:50 [#####################] 100%
 ...
```

</details>

```bash
helm version
```

<details>
<summary>
Вывод версии helm
</summary>

```log
version.BuildInfo{Version:"v4.2.2", GitCommit:"b05881cf967a5a09e19866799d0edfd40675803a", GitTreeState:"", GoVersion:"go1.26.4-X:nodwarf5", KubeClientVersion:"v1.36"}
```

</details>

```bash
# Создание структуры чарта
helm create skv-app-chart

cd !$

tree
```

<details>
<summary>
Вывод структуры чарта
</summary>

```log
Creating skv-app-chart

cd skv-app-chart

├── charts
├── Chart.yaml
├── templates
│   ├── deployment.yaml
│   ├── _helpers.tpl
│   ├── hpa.yaml
│   ├── httproute.yaml
│   ├── ingress.yaml
│   ├── NOTES.txt
│   ├── serviceaccount.yaml
│   ├── service.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml
```

</details>

```bash
# Чистка неиспользуемых файлов файлов
rm -rv \
./templates/{deployment,service,hpa,httproute,ingress,tests/test-connection}.yaml

tree
```

<Details>
<Summary>
Чистка неиспользуемых файлов файлов
</Summary>

```log
удалён './templates/deployment.yaml'
удалён './templates/service.yaml'
удалён './templates/hpa.yaml'
удалён './templates/httproute.yaml'
удалён './templates/ingress.yaml'
удалён './templates/tests/test-connection.yaml'

.
├── charts
├── Chart.yaml
├── templates
│   ├── _helpers.tpl
│   ├── NOTES.txt
│   ├── serviceaccount.yaml
│   └── tests
└── values.yaml

4 directories, 5 files
```

</Details>

### `Yaml`-values для шаблона с параметризацией

<details>
<summary>
Yaml-values для шаблона с параметризацией
</summary>

```bash
cat > values.yaml <<'EOF'
replicaCount: 3

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

# Конфигурация компонента Nginx
nginx:
  name: nginx
  image:
    repository: nginx
    pullPolicy: IfNotPresent
    tag: "denskv"
  service:
    type: ClusterIP
    port: 80
    targetPort: 80
  resources: {}

# Конфигурация компонента MultiTool
multitool:
  name: multitool
  image:
    repository: wbitt/network-multitool
    pullPolicy: IfNotPresent
    tag: "denskv"
  service:
    type: ClusterIP
    port: 8080
    targetPort: 8080
  env:
    - name: HTTP_PORT
      value: "8080"
  resources: {}

serviceAccount:
  create: true
  annotations: {}
  name: ""

podSecurityContext: {}
securityContext: {}
nodeSelector: {}
tolerations: []
affinity: {}
EOF
```

</details>

### создание `Yaml`-шаблона deployment с параметризацией

<details>
<summary>
Yaml-шаблон deployment с параметризацией
</summary>

```bash
cat > templates/deployments-denskv.yaml <<'EOF'
{{- range $componentName, $componentValues := dict "nginx" .Values.nginx "multitool" .Values.multitool }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "skv-app-chart.fullname" $ }}-{{ $componentName }}
  labels:
    {{- include "skv-app-chart.labels" $ | nindent 4 }}
    app.kubernetes.io/component: {{ $componentName }}
spec:
  replicas: {{ $.Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "skv-app-chart.selectorLabels" $ | nindent 6 }}
      app.kubernetes.io/component: {{ $componentName }}
  template:
    metadata:
      labels:
        {{- include "skv-app-chart.selectorLabels" $ | nindent 8 }}
        app.kubernetes.io/component: {{ $componentName }}
    spec:
      {{- with $.Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "skv-app-chart.serviceAccountName" $ }}
      securityContext:
        {{- toYaml $.Values.podSecurityContext | nindent 8 }}
      containers:
        - name: {{ $componentName }}
          securityContext:
            {{- toYaml $.Values.securityContext | nindent 12 }}
          image: "{{ $componentValues.image.repository }}:{{ $componentValues.image.tag }}"
          imagePullPolicy: {{ $componentValues.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ $componentValues.service.targetPort }}
              protocol: TCP
          {{- if $componentValues.env }}
          env:
            {{- toYaml $componentValues.env | nindent 12 }}
          {{- end }}
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            {{- toYaml $componentValues.resources | nindent 12 }}
      {{- with $.Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $.Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $.Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
---
{{- end }}
EOF
```

</details>

### создание `Yaml`-шаблона service с параметризацией

<details>
<summary>
Yaml-шаблон service с параметризацией
</summary>

```bash
cat > templates/services-denskv.yaml <<'EOF'
{{- range $componentName, $componentValues := dict "nginx" .Values.nginx "multitool" .Values.multitool }}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "skv-app-chart.fullname" $ }}-{{ $componentName }}
  labels:
    {{- include "skv-app-chart.labels" $ | nindent 4 }}
    app.kubernetes.io/component: {{ $componentName }}
spec:
  type: {{ $componentValues.service.type }}
  ports:
    - port: {{ $componentValues.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "skv-app-chart.selectorLabels" $ | nindent 4 }}
    app.kubernetes.io/component: {{ $componentName }}
---
{{- end }}
EOF
```

</details>


### Обновление информации о шаблонах в NOTES.txt

<details>
<summary>
Обновление информации о шаблонах в NOTES.txt
</summary>

```bash
cat > templates/NOTES.txt <<'EOF'
{{- range $componentName, $componentValues := dict "nginx" .Values.nginx "multitool" .Values.multitool }}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "skv-app-chart.fullname" $ }}-{{ $componentName }}
  labels:
    {{- include "skv-app-chart.labels" $ | nindent 4 }}
    app.kubernetes.io/component: {{ $componentName }}
spec:
  type: {{ $componentValues.service.type }}
  ports:
    - port: {{ $componentValues.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "skv-app-chart.selectorLabels" $ | nindent 4 }}
    app.kubernetes.io/component: {{ $componentName }}
---
{{- end }}
EOF
```

</details>

```bash
# Текущая структура чарта helm
tree

helm lint .
```

```log
.
├── charts
├── Chart.yaml
├── templates
│   ├── deployments-denskv.yaml
│   ├── _helpers.tpl
│   ├── NOTES.txt
│   ├── serviceaccount.yaml
│   ├── services-denskv.yaml
│   └── tests
└── values.yaml

4 directories, 7 files
==> Linting .
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
```

### Запуск Версии 1 в NameSpace app1

```bash
# Флаг --create-namespace говорит Helm создать NS, если его нет. 
helm install release-v1-app1 . \
--namespace app1 \
--create-namespace
```

<details>
<summary>
Вывод создание deployment через helm app1
</summary>

```log
NAME: release-v1-app1
LAST DEPLOYED: Sat Aug 22 17:31:57 2026
NAMESPACE: app1
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None
NOTES:
apiVersion: v1
kind: Service
metadata:
  name: release-v1-app1-skv-app-chart-multitool
  labels:
    helm.sh/chart: skv-app-chart-0.1.0
    app.kubernetes.io/name: skv-app-chart
    app.kubernetes.io/instance: release-v1-app1
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: multitool
spec:
  type: ClusterIP
  ports:
    - port: 8080
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: skv-app-chart
    app.kubernetes.io/instance: release-v1-app1
    app.kubernetes.io/component: multitool
---
apiVersion: v1
kind: Service
metadata:
  name: release-v1-app1-skv-app-chart-nginx
  labels:
    helm.sh/chart: skv-app-chart-0.1.0
    app.kubernetes.io/name: skv-app-chart
    app.kubernetes.io/instance: release-v1-app1
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: nginx
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: skv-app-chart
    app.kubernetes.io/instance: release-v1-app1
    app.kubernetes.io/component: nginx
---
```

</details>

### Запуск Версии 2 в NameSpace app1

```bash
helm install release-v2-app1 . \
--namespace app1 \
--create-namespace
```

<details>
<summary>
Вывод создание deployment другого релиза через helm в существующий app1
</summary>

```log
NAME: release-v2-app1
LAST DEPLOYED: Sat Aug 22 17:32:27 2026
NAMESPACE: app1
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None
NOTES:
apiVersion: v1
kind: Service
metadata:
  name: release-v2-app1-skv-app-chart-multitool
  labels:
    helm.sh/chart: skv-app-chart-0.1.0
    app.kubernetes.io/name: skv-app-chart
    app.kubernetes.io/instance: release-v2-app1
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: multitool
spec:
  type: ClusterIP
  ports:
    - port: 8080
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: skv-app-chart
    app.kubernetes.io/instance: release-v2-app1
    app.kubernetes.io/component: multitool
---
apiVersion: v1
kind: Service
metadata:
  name: release-v2-app1-skv-app-chart-nginx
  labels:
    helm.sh/chart: skv-app-chart-0.1.0
    app.kubernetes.io/name: skv-app-chart
    app.kubernetes.io/instance: release-v2-app1
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: nginx
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: skv-app-chart
    app.kubernetes.io/instance: release-v2-app1
    app.kubernetes.io/component: nginx
---
```

</details>

### Запуск Версии 3 в app2

```bash
helm install release-v3-app2 . \
--namespace app2 \
--create-namespace
```

<details>
<summary>
Вывод создание deployment через helm app2
</summary>

```log
NAME: release-v3-app2
LAST DEPLOYED: Sat Aug 22 17:35:54 2026
NAMESPACE: app2
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None
NOTES:
apiVersion: v1
kind: Service
metadata:
  name: release-v3-app2-skv-app-chart-multitool
  labels:
    helm.sh/chart: skv-app-chart-0.1.0
    app.kubernetes.io/name: skv-app-chart
    app.kubernetes.io/instance: release-v3-app2
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: multitool
spec:
  type: ClusterIP
  ports:
    - port: 8080
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: skv-app-chart
    app.kubernetes.io/instance: release-v3-app2
    app.kubernetes.io/component: multitool
---
apiVersion: v1
kind: Service
metadata:
  name: release-v3-app2-skv-app-chart-nginx
  labels:
    helm.sh/chart: skv-app-chart-0.1.0
    app.kubernetes.io/name: skv-app-chart
    app.kubernetes.io/instance: release-v3-app2
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: nginx
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: skv-app-chart
    app.kubernetes.io/instance: release-v3-app2
    app.kubernetes.io/component: nginx
---
```

</details>

#### Мониторинг Работы развертывания

```bash
# Мониторинг подов и сервисов deployment
watch -cn 1 \
"echo '--===\/=NAMESPACES=\/===---' \
; kubectl get namespaces app1 app2 \
; echo '--===/\=NAMESPACES=/\===---' \
; echo '--===\/=Deployments=\/===---' \
; kubectl get deployments -n app1 \
; kubectl get deployments -n app2 \
; echo '--===/\=Deployments=/\===---' \
; echo '--===\/=PODS=\/===---' \
; kubectl get pods -n app1 \
; kubectl get pods -n app2 \
; echo '--===/\=PODS=/\===---' \
; echo '--===\/=SERVICES=\/===---' \
; kubectl get svc -n app1 \
; kubectl get svc -n app2 \
; echo '--===/\=SERVICES=/\===---'"
```

<details>
<summary>
Мониторинг подов и сервисов deployment после запуска через helm
</summary>

```log
--===\/=NAMESPACES=\/===---
NAME   STATUS   AGE
app1   Active   26s
app2   Active   15s
--===/\=NAMESPACES=/\===---
--===\/=Deployments=\/===---
NAME                                      READY   UP-TO-DATE   AVAILABLE   AGE
release-v1-app1-skv-app-chart-multitool   3/3     3            3           26s
release-v1-app1-skv-app-chart-nginx       3/3     3            3           26s
release-v2-app1-skv-app-chart-multitool   3/3     3            3           21s
release-v2-app1-skv-app-chart-nginx       3/3     3            3           21s
NAME                                      READY   UP-TO-DATE   AVAILABLE   AGE
release-v3-app2-skv-app-chart-multitool   3/3     3            3           15s
release-v3-app2-skv-app-chart-nginx       3/3     3            3           15s
--===/\=Deployments=/\===---
--===\/=PODS=\/===---
NAME                                                       READY   STATUS    RESTARTS   AGE
release-v1-app1-skv-app-chart-multitool-669b6f9ccf-6d6fv   1/1     Running   0          26s
release-v1-app1-skv-app-chart-multitool-669b6f9ccf-wjttz   1/1     Running   0          26s
release-v1-app1-skv-app-chart-multitool-669b6f9ccf-zgc7h   1/1     Running   0          26s
release-v1-app1-skv-app-chart-nginx-7656f9f6-24lf4         1/1     Running   0          26s
release-v1-app1-skv-app-chart-nginx-7656f9f6-8dxhv         1/1     Running   0          26s
release-v1-app1-skv-app-chart-nginx-7656f9f6-fs25c         1/1     Running   0          26s
release-v2-app1-skv-app-chart-multitool-7bdcdb64bd-crwmx   1/1     Running   0          21s
release-v2-app1-skv-app-chart-multitool-7bdcdb64bd-gpxdk   1/1     Running   0          21s
release-v2-app1-skv-app-chart-multitool-7bdcdb64bd-p8k79   1/1     Running   0          21s
release-v2-app1-skv-app-chart-nginx-694fdfc747-45fv4       1/1     Running   0          21s
release-v2-app1-skv-app-chart-nginx-694fdfc747-fckx7       1/1     Running   0          21s
release-v2-app1-skv-app-chart-nginx-694fdfc747-sqkgt       1/1     Running   0          21s
NAME                                                      READY   STATUS    RESTARTS   AGE
release-v3-app2-skv-app-chart-multitool-5c9b76d8d-cfnv7   1/1     Running   0          15s
release-v3-app2-skv-app-chart-multitool-5c9b76d8d-fskks   1/1     Running   0          15s
release-v3-app2-skv-app-chart-multitool-5c9b76d8d-wqnwr   1/1     Running   0          15s
release-v3-app2-skv-app-chart-nginx-66c46fc795-kvspg      1/1     Running   0          15s
release-v3-app2-skv-app-chart-nginx-66c46fc795-tvxvz      1/1     Running   0          15s
release-v3-app2-skv-app-chart-nginx-66c46fc795-z5xph      1/1     Running   0          15s
--===/\=PODS=/\===---
--===\/=SERVICES=\/===---
NAME                                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
release-v1-app1-skv-app-chart-multitool   ClusterIP   10.96.179.176   <none>        8080/TCP   26s
release-v1-app1-skv-app-chart-nginx       ClusterIP   10.96.103.5     <none>        80/TCP     26s
release-v2-app1-skv-app-chart-multitool   ClusterIP   10.96.133.58    <none>        8080/TCP   21s
release-v2-app1-skv-app-chart-nginx       ClusterIP   10.96.151.171   <none>        80/TCP     21s
NAME                                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
release-v3-app2-skv-app-chart-multitool   ClusterIP   10.96.59.5      <none>        8080/TCP   15s
release-v3-app2-skv-app-chart-nginx       ClusterIP   10.96.176.181   <none>        80/TCP     15s
--===/\=SERVICES=/\===---
```

</details>

### создание пакет-архива и утилита анализа чарта-архива

```bash
# Удаление deployment через helm
helm uninstall release-v1-app1 --namespace app1
helm uninstall release-v2-app1 --namespace app1
helm uninstall release-v3-app2 --namespace app2

kubectl delete namespace app1
kubectl delete namespace app2

cd ..

helm package skv-app-chart

kube-linter lint skv-app-chart-0.1.0.tgz
```

<details>
<summary>
удаление deployment через helm и создание пакет-архива
</summary>

```log
release "release-v1-app1" uninstalled
release "release-v2-app1" uninstalled
release "release-v3-app2" uninstalled
namespace "app1" deleted
namespace "app2" deleted

Successfully packaged chart and saved it to: /home/shoel/nfs_git/gited/21_6/skv-app-chart-0.1.0.tgz

KubeLinter development

/home/shoel/nfs_git/gited/21_6/skv-app-chart-0.1.0.tgz/skv-app-chart/templates/deployments-denskv.yaml: (object: <no namespace>/test-release-skv-app-chart-multitool apps/v1, Kind=Deployment) object has 3 replicas but does not specify inter pod anti-affinity (check: no-anti-affinity, remediation: Specify anti-affinity in your pod specification to ensure that the orchestrator attempts to schedule replicas on different nodes. Using podAntiAffinity, specify a labelSelector that matches pods for the deployment, and set the topologyKey to kubernetes.io/hostname. Refer to https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity for details.)

/home/shoel/nfs_git/gited/21_6/skv-app-chart-0.1.0.tgz/skv-app-chart/templates/deployments-denskv.yaml: (object: <no namespace>/test-release-skv-app-chart-multitool apps/v1, Kind=Deployment) container "multitool" does not have a read-only root file system (check: no-read-only-root-fs, remediation: Set readOnlyRootFilesystem to true in the container securityContext.)

/home/shoel/nfs_git/gited/21_6/skv-app-chart-0.1.0.tgz/skv-app-chart/templates/deployments-denskv.yaml: (object: <no namespace>/test-release-skv-app-chart-multitool apps/v1, Kind=Deployment) container "multitool" is not set to runAsNonRoot (check: run-as-non-root, remediation: Set runAsUser to a non-zero number and runAsNonRoot to true in your pod or container securityContext. Refer to https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ for details.)

/home/shoel/nfs_git/gited/21_6/skv-app-chart-0.1.0.tgz/skv-app-chart/templates/deployments-denskv.yaml: (object: <no namespace>/test-release-skv-app-chart-multitool apps/v1, Kind=Deployment) container "multitool" has cpu request 0 (check: unset-cpu-requirements, remediation: Set CPU requests for your container based on its requirements. Refer to https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits for details.)

/home/shoel/nfs_git/gited/21_6/skv-app-chart-0.1.0.tgz/skv-app-chart/templates/deployments-denskv.yaml: (object: <no namespace>/test-release-skv-app-chart-multitool apps/v1, Kind=Deployment) container "multitool" has memory limit 0 (check: unset-memory-requirements, remediation: Set memory limits for your container based on its requirements. Refer to https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits for details.)

/home/shoel/nfs_git/gited/21_6/skv-app-chart-0.1.0.tgz/skv-app-chart/templates/deployments-denskv.yaml: (object: <no namespace>/test-release-skv-app-chart-nginx apps/v1, Kind=Deployment) object has 3 replicas but does not specify inter pod anti-affinity (check: no-anti-affinity, remediation: Specify anti-affinity in your pod specification to ensure that the orchestrator attempts to schedule replicas on different nodes. Using podAntiAffinity, specify a labelSelector that matches pods for the deployment, and set the topologyKey to kubernetes.io/hostname. Refer to https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity for details.)

/home/shoel/nfs_git/gited/21_6/skv-app-chart-0.1.0.tgz/skv-app-chart/templates/deployments-denskv.yaml: (object: <no namespace>/test-release-skv-app-chart-nginx apps/v1, Kind=Deployment) container "nginx" does not have a read-only root file system (check: no-read-only-root-fs, remediation: Set readOnlyRootFilesystem to true in the container securityContext.)

/home/shoel/nfs_git/gited/21_6/skv-app-chart-0.1.0.tgz/skv-app-chart/templates/deployments-denskv.yaml: (object: <no namespace>/test-release-skv-app-chart-nginx apps/v1, Kind=Deployment) container "nginx" is not set to runAsNonRoot (check: run-as-non-root, remediation: Set runAsUser to a non-zero number and runAsNonRoot to true in your pod or container securityContext. Refer to https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ for details.)

/home/shoel/nfs_git/gited/21_6/skv-app-chart-0.1.0.tgz/skv-app-chart/templates/deployments-denskv.yaml: (object: <no namespace>/test-release-skv-app-chart-nginx apps/v1, Kind=Deployment) container "nginx" has cpu request 0 (check: unset-cpu-requirements, remediation: Set CPU requests for your container based on its requirements. Refer to https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits for details.)

/home/shoel/nfs_git/gited/21_6/skv-app-chart-0.1.0.tgz/skv-app-chart/templates/deployments-denskv.yaml: (object: <no namespace>/test-release-skv-app-chart-nginx apps/v1, Kind=Deployment) container "nginx" has memory limit 0 (check: unset-memory-requirements, remediation: Set memory limits for your container based on its requirements. Refer to https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits for details.)

Error: found 10 lint errors
```

</details>

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 21_6-helm' \
&& git push \
--set-upstream \
study_fops39 \
21_6-helm \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_6-helm \
&& git push \
--set-upstream \
study-fops39_sc \
21_6-helm
```

## commit_82, master