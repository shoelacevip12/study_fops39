# Для домашнего задания 19.1 `Системы мониторинга`

## commit_66, master Предварительная подготовка

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
https://github.com/netology-code/mnt-homeworks.git

# Удаление всех файлов и каталогов кроме каталога 10-monitoring-03-grafana
find mnt-homeworks/ \
-mindepth 1 \
-not -path "*10-monitoring-03-grafana*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 19_2
mv mnt-homeworks/10-monitoring-03-grafana \
19_2

# Переход в каталог по последней переменной вывода последней команды (19_2)
cd !$

rms -rfv help
```

<details>
<summary>
cd в рабочую директорию
</summary>

```log
cd 19_2
```

</details>

```bash
# создание каталогов под скриншоты
mkdir -v img
```

<details>
<summary>
Создание каталога для изображений
</summary>

```log
mkdir: создан каталог 'img'
```

</details>

```bash
# Удаление оставшейся оставшейся части клона репозитория
rm -rfv \
../mnt-homeworks
```

<details>
<summary>
Удаление лишнего для Задания
</summary>

```log
../mnt-homeworks
удалён каталог '../mnt-homeworks'
```

</details>

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
git commit -am 'commit_66_1, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```

## commit_1, `19_2-monitoring_prom_graf`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 19_2-monitoring_prom_graf

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

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий
git commit -am 'commit1, 19_2-monitoring_prom_graf' \
&& git push \
--set-upstream \
study_fops39 \
19_2-monitoring_prom_graf \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
19_2-monitoring_prom_graf
```

## commit_2, `19_2-monitoring_prom_graf`

```bash
ssh-keygen \
-f ~/.ssh/id_19-2_ed25519 \
-t ed25519 -C "19-02"
```

<details>
<summary>
Генерация ключу для работы
</summary>

```log
Generating public/private ed25519 key pair.
Enter passphrase for "/home/shoel/.ssh/id_19-2_ed25519" (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/shoel/.ssh/id_19-2_ed25519
Your public key has been saved in /home/shoel/.ssh/id_19-2_ed25519.pub
The key fingerprint is:
SHA256:avRJjDVk5pUZtS289cjrFPZyrf1nYCGxE3WYWsjJ4uc 19-02
The key's randomart image is:
+--[ED25519 256]--+
|        + oB.+.o.|
|       = .+.Bo+. |
|        +. .+*o  |
|       + .. *=.o |
|      o S  o.o=..|
|     . + .  E.o+.|
|      o o    .+.+|
|     .       o =o|
|              o.=|
+----[SHA256]-----+
```

</details>

```bash
mkdir -v tf

cd !$

cat >cloud-init.yml<<'EOF'
#cloud-config
users:
  - name: skv
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ssh-ed25519
    lock_passwd: false
package_update: true
package_upgrade: true
packages:
  - wget
  - curl
  - gnupg
  - software-properties-common
  - python3-psycopg2
  - acl
  - locales-all
EOF

sed -i "8s|.*|      - $(cat ~/.ssh/id_19-2_ed25519.pub)|" cloud-init.yml
```

```bash
ansible-galaxy collection \
install \
prometheus.prometheus --force
```

<details>
<summary>
Обновление модулей коллекции prometheus
</summary>

```log
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Downloading https://galaxy.ansible.com/api/v3/plugin/ansible/content/published/collections/artifacts/prometheus-prometheus-0.30.0.tar.gz to /home/shoel/.ansible/tmp/ansible-local-22497fydy0vw_/tmp7kjx95pm/prometheus-prometheus-0.30.0-s2tjjxmn
Installing 'prometheus.prometheus:0.30.0' to '/home/shoel/.ansible/collections/ansible_collections/prometheus/prometheus'
prometheus.prometheus:0.30.0 was installed successfully
'community.general:13.0.1' is already installed, skipping.
```

</details>

```bash
git clone \
https://github.com/prometheus-community/ansible.git

rm -rfv ansible/.git
```

<details>
<summary>
удаление кеша git проекта
</summary>

```log
удалён 'ansible/.git/description'
удалён 'ansible/.git/hooks/post-update.sample'
удалён 'ansible/.git/hooks/pre-rebase.sample'
удалён 'ansible/.git/hooks/pre-commit.sample'
удалён 'ansible/.git/hooks/pre-receive.sample'
удалён 'ansible/.git/hooks/commit-msg.sample'
удалён 'ansible/.git/hooks/pre-push.sample'
удалён 'ansible/.git/hooks/applypatch-msg.sample'
удалён 'ansible/.git/hooks/pre-applypatch.sample'
удалён 'ansible/.git/hooks/update.sample'
удалён 'ansible/.git/hooks/fsmonitor-watchman.sample'
удалён 'ansible/.git/hooks/push-to-checkout.sample'
удалён 'ansible/.git/hooks/pre-merge-commit.sample'
удалён 'ansible/.git/hooks/sendemail-validate.sample'
удалён 'ansible/.git/hooks/prepare-commit-msg.sample'
удалён каталог 'ansible/.git/hooks'
удалён 'ansible/.git/info/exclude'
удалён каталог 'ansible/.git/info'
удалён 'ansible/.git/objects/pack/pack-82d0b30c5d6e31e6ae590f368ac6e8df7a99d0b8.pack'
удалён 'ansible/.git/objects/pack/pack-82d0b30c5d6e31e6ae590f368ac6e8df7a99d0b8.rev'
удалён 'ansible/.git/objects/pack/pack-82d0b30c5d6e31e6ae590f368ac6e8df7a99d0b8.idx'
удалён каталог 'ansible/.git/objects/pack'
удалён каталог 'ansible/.git/objects/info'
удалён каталог 'ansible/.git/objects'
удалён 'ansible/.git/refs/heads/main'
удалён каталог 'ansible/.git/refs/heads'
удалён каталог 'ansible/.git/refs/tags'
удалён 'ansible/.git/refs/remotes/origin/HEAD'
удалён каталог 'ansible/.git/refs/remotes/origin'
удалён каталог 'ansible/.git/refs/remotes'
удалён каталог 'ansible/.git/refs'
удалён 'ansible/.git/packed-refs'
удалён 'ansible/.git/logs/refs/remotes/origin/HEAD'
удалён каталог 'ansible/.git/logs/refs/remotes/origin'
удалён каталог 'ansible/.git/logs/refs/remotes'
удалён 'ansible/.git/logs/refs/heads/main'
удалён каталог 'ansible/.git/logs/refs/heads'
удалён каталог 'ansible/.git/logs/refs'
удалён 'ansible/.git/logs/HEAD'
удалён каталог 'ansible/.git/logs'
удалён 'ansible/.git/HEAD'
удалён 'ansible/.git/config'
удалён 'ansible/.git/index'
удалён каталог 'ansible/.git'
```

</details>

```bash
pushd ../..

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
./

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 19_2-monitoring_prom_graf' \
&& git push \
--set-upstream \
study_fops39 \
19_2-monitoring_prom_graf \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
19_2-monitoring_prom_graf
```

