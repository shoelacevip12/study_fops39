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