# Для домашнего задания 17.5 `Тестирование roles`
## commit_58, master Предварительная подготовка
```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master
```
```
Уже на «master»
```
```bash
# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/mnt-homeworks.git

# Удаление всех файлов и каталогов кроме каталога 08-ansible-05-testing и его содержимого
find mnt-homeworks/ \
-mindepth 1 \
-not -path "*08-ansible-05-testing*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 17_5
mv mnt-homeworks/08-ansible-05-testing \
17_5

# Переход в каталог по последней переменной вывода последней команды (17_5)
cd !$

# создание каталогов под скриншоты
mkdir img
```
```
cd 17_4
```
```bash
# Удаление оставшейся оставшейся части клона репозитория
rm -rf \
../mnt-homeworks

# Просмотр текущих удаленных репозиториев
git remote -v

# Проверка текущего локального состояния репозитория
git status

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
git commit -am 'commit_58_, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```
## commit_1, `17_5-ansible_testing`
```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 17_5-ansible_testing

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

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit1_upd_1, 17_5-ansible_testing' \
&& git push \
--set-upstream \
study_fops39 \
17_5-ansible_testing \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
17_5-ansible_testing
```
## commit_2, `17_5-ansible_testing`
```bash
# Archlinux поиск и установка molecule
sudo pacman \
-Ss molecule
```
```
extra/molecule 26.3.0-1
    Aids in the development and testing of Ansible roles
```
```bash
# установка модуля тестирования ansible c необходимыми зависимостями
sudo pacman \
-Syu molecule
```
<details>
<summary>pacman installation molecule</summary>

```
....
Дополнительные зависимости для 'molecule'
    ansible: for the ansible verifier [установлено]
    ansible-navigator: to use navigator as playbook executor
    molecule-docker: for the docker driver
    molecule-podman: for the podman driver
    molecule-vagrant: for the vagrant driver
    python-pywinrm: for Windows support
    python-pytest-testinfra: for the testinfra verifier
....
```

</details>

```bash
# Запуск службы docker
sudo systemctl \
start \
docker.service

# Скачивание образов контейнеров для тестовых сред
docker pull \
antmelekhin/docker-systemd:ubuntu-24.04 

docker pull \
antmelekhin/docker-systemd:rockylinux-10



# установка зависимостей для docker драйвера через коллекцию
ansible-galaxy collection \
install \
community.docker
```
<details>
<summary>collection docker install</summary>

```
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Downloading https://galaxy.ansible.com/api/v3/plugin/ansible/content/published/collections/artifacts/community-docker-5.1.0.tar.gz to /home/shoel/.ansible/tmp/ansible-local-867976866382n/tmp2j6xhyre/community-docker-5.1.0-jsw7z59k
Installing 'community.docker:5.1.0' to '/home/shoel/.ansible/collections/ansible_collections/community/docker'
community.docker:5.1.0 was installed successfully
'community.library_inventory_filtering_v1:1.1.5' is already installed, skipping.
```

</details>

```bash
# установка зависимостей для podman драйвера через коллекцию
ansible-galaxy collection \
install \
containers.podman
```
<details>
<summary>collection podman install</summary>
```
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Downloading https://galaxy.ansible.com/api/v3/plugin/ansible/content/published/collections/artifacts/containers-podman-1.19.0.tar.gz to /home/shoel/.ansible/tmp/ansible-local-87821kl3162je/tmpytgq4z5v/containers-podman-1.19.0-xg6ri11o
Installing 'containers.podman:1.19.0' to '/home/shoel/.ansible/collections/ansible_collections/containers/podman'
containers.podman:1.19.0 was installed successfully
```
</details>

```bash
# Создание файла requirements для скачивания роли из указанного источника
cat > requirements.yml <<'EOF'
---
  - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
    scm: git
    version: "1.13"
    name: clickhouse

  - src: git@github.com:shoelacevip12/vector-role.git
    scm: git
    name: vector-role

  - src: git@github.com:shoelacevip12/lighthouse-role.git
    scm: git
    name: lighthouse-role
...
EOF

# Скачивание роли из источников requirements.yml
ansible-galaxy install \
-p roles \
-r requirements.yml
```
<details>
<summary>roles install</summary>

```
Starting galaxy role install process
- extracting clickhouse to /home/shoel/nfs_git/gited/17_5/roles/clickhouse
- clickhouse (1.13) was installed successfully
- extracting vector-role to /home/shoel/nfs_git/gited/17_5/roles/vector-role
- vector-role was installed successfully
- extracting lighthouse-role to /home/shoel/nfs_git/gited/17_5/roles/lighthouse-role
- lighthouse-role was installed successfully
```

</details>

```bash
# смена расположения в каталог с ролью clickhouse
cd roles/clickhouse/

# Создание виртуального окружения Python и установка нужных драйверов
python -m venv .venv
source .venv/bin/activate
pip install -U pip
pip install molecule molecule-docker ansible molecule molecule-podman

# вывод доступных драйверов
(.venv) molecule drivers
```
```
podman
default
docker
```
```bash
# Запуск одного из сценариев molecule роли clickhouse
molecule test -s ubuntu_focal
```
<details>
<summary>Molecule test</summary>

```
WARNING  Driver docker does not provide a schema.
ERROR    Failed to validate /home/shoel/nfs_git/gited/17_5/roles/clickhouse/molecule/ubuntu_focal/molecule.yml
```
</details>

```bash
# завершения работы с виртуальным окружением Python в roles/clickhouse
deactivate

# Выход в корневой каталог работы
cd ../..

# Создание виртуального окружения Python
python -m venv .venv

# 
source .venv/bin/activate

# Обновление пакетного репозитория
pip install -U pip

# установка нужных драйверов
pip install \
molecule \
molecule-docker \
ansible \
molecule \
molecule-podman

# смена расположения в каталог с ролью vector-role
cd roles/vector-role

# Создание сценария тестирования default
molecule init \
scenario \
default
```

<details>
<summary>Molecule init default</summary>

```
INFO     default ➜ init: Initializing new scenario default...

PLAY [Create a new molecule scenario] ******************************************

TASK [Check if destination folder exists] **************************************
changed: [localhost]

TASK [Check if destination folder is empty] ************************************
ok: [localhost]

TASK [Fail if destination folder is not empty] *********************************
skipping: [localhost]

TASK [Expand templates] ********************************************************
changed: [localhost] => (item=molecule/default/converge.yml)
changed: [localhost] => (item=molecule/default/create.yml)
changed: [localhost] => (item=molecule/default/destroy.yml)
changed: [localhost] => (item=molecule/default/molecule.yml)
changed: [localhost] => (item=molecule/default/verify.yml)

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```

</details>

```bash
# Создание сценария тестирования для ubuntu 24.04
molecule init \
scenario \
ubuntu-2404
```

<details>
<summary>Molecule init ubuntu</summary>

```
INFO     ubuntu-2404 ➜ init: Initializing new scenario ubuntu-2404...

PLAY [Create a new molecule scenario] ******************************************

TASK [Check if destination folder exists] **************************************
changed: [localhost]

TASK [Check if destination folder is empty] ************************************
ok: [localhost]

TASK [Fail if destination folder is not empty] *********************************
skipping: [localhost]

TASK [Expand templates] ********************************************************
changed: [localhost] => (item=molecule/ubuntu-2404/converge.yml)
changed: [localhost] => (item=molecule/ubuntu-2404/molecule.yml)
changed: [localhost] => (item=molecule/ubuntu-2404/create.yml)
changed: [localhost] => (item=molecule/ubuntu-2404/verify.yml)
changed: [localhost] => (item=molecule/ubuntu-2404/destroy.yml)

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     ubuntu-2404 ➜ init: Initialized scenario in /home/shoel/nfs_git/gited/17_5/roles/vector-role/molecule/ubuntu-2404 successfully.
```

</details>

```bash
# Создание сценария тестирования для rockylinux-10
molecule init \
scenario \
rockylinux-10
```

<details>
<summary>Molecule init ubuntu</summary>

```
INFO     rockylinux-10 ➜ init: Initializing new scenario rockylinux-10...

PLAY [Create a new molecule scenario] ******************************************

TASK [Check if destination folder exists] **************************************
changed: [localhost]

TASK [Check if destination folder is empty] ************************************
ok: [localhost]

TASK [Fail if destination folder is not empty] *********************************
skipping: [localhost]

TASK [Expand templates] ********************************************************
changed: [localhost] => (item=molecule/rockylinux-10/converge.yml)
changed: [localhost] => (item=molecule/rockylinux-10/molecule.yml)
changed: [localhost] => (item=molecule/rockylinux-10/create.yml)
changed: [localhost] => (item=molecule/rockylinux-10/verify.yml)
changed: [localhost] => (item=molecule/rockylinux-10/destroy.yml)

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     rockylinux-10 ➜ init: Initialized scenario in /home/shoel/nfs_git/gited/17_5/roles/vector-role/molecule/rockylinux-10 successfully.
```

</details>

## commit_2, `17_5-ansible_testing`
```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 17_5-ansible_testing

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

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. ../.. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 17_5-ansible_testing' \
&& git push \
--set-upstream \
study_fops39 \
17_5-ansible_testing \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
17_5-ansible_testing
```
## commit_3 `17_5-ansible_testing`
```bash

```