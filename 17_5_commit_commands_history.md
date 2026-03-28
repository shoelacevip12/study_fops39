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
antmelekhin/docker-systemd:debian-13

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

  - src: git@github.com:shoelacevip12/vector.git
    scm: git
    name: vector

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
- extracting vector to /home/shoel/nfs_git/gited/17_5/roles/vector
- vector was installed successfully
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

# смена расположения в каталог с ролью vector
cd roles/vector

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

### Создание файлов для заглушки
```bash
echo 'collections: []' > collections.yml

echo '[]' > requirements.yml

mkdir -p molecule/default/roles/

cd molecule/default/roles/

ln -s ../../.. \
./vector

cd -

ll molecule/default/roles/vector \
| cut -d ' ' -f9-11
```
```
molecule/default/roles/vector -> ../../..
```
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
### Добавление сценария default
```bash
cat >  molecule/default/molecule.yml <<'EOF'
---
dependency:
  name: galaxy
  enabled: false

driver:
  name: docker

platforms:
  - name: instance-ubuntu
    dockerfile: 24.04.Dockerfile
    image: molecule-vector-ubuntu:24.04
    command: /lib/systemd/systemd
    privileged: true
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
    cgroupns_mode: host
    tmpfs:
      - /tmp
      - /run
      - /run/lock
  
  - name: instance-debian
    dockerfile: 13.Dockerfile
    image: molecule-vector-debian:13
    command: /lib/systemd/systemd
    privileged: true
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
    cgroupns_mode: host
    tmpfs:
      - /tmp
      - /run
      - /run/lock

provisioner:
  name: ansible
  ansible_args:
    - --skip-tags=service,verify
  inventory:
    host_vars:
      instance-ubuntu:
        ansible_connection: community.docker.docker
        ansible_user: root
        ansible_python_interpreter: /usr/bin/python3
      instance-debian:
        ansible_connection: community.docker.docker
        ansible_user: root
        ansible_python_interpreter: /usr/bin/python3
verifier:
  name: ansible
lint: |
  set -e
  yamllint .
  ansible-lint
...
EOF
```
### Для шага converge
```bash
cat > molecule/default/converge.yml <<'EOF'
---
- name: Converge
  hosts: all
  gather_facts: true
  tasks:
    - name: Применить тестируемую роль
      include_role:
        name: "vector"
...
EOF
```
### Для шага create
```bash
cat > molecule/default/create.yml <<'EOF'
---
- name: Create
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - name: Создание образов
      community.docker.docker_image:
        name: "{{ item.image }}"
        build:
          path: "{{ molecule_scenario_directory }}"
          dockerfile: "{{ item.dockerfile }}"
        source: build
      loop: "{{ molecule_yml.platforms }}"

    - name: Создание контейнеров
      community.docker.docker_container:
        name: "{{ item.name }}"
        image: "{{ item.image }}"
        state: started
        command: "{{ item.command }}"
        privileged: "{{ item.privileged }}"
        volumes: "{{ item.volumes }}"
        tmpfs: "{{ item.tmpfs }}"
        cgroupns_mode: "{{ item.cgroupns_mode }}"
        detach: true
      loop: "{{ molecule_yml.platforms }}"
...
EOF
```
### Для шага destroy
```bash
cat > molecule/default/destroy.yml <<'EOF'
---
- name: Destroy
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - name: Уничтожение контейнера
      community.docker.docker_container:
        name: "{{ item.name }}"
        state: absent
        force_kill: true
      loop: "{{ molecule_yml.platforms }}"
  
    - name: Удаление Образов
      community.docker.docker_image:
        name: "{{ item.image }}"
        state: absent
        force_absent: true
      loop: "{{ molecule_yml.platforms }}"
      ignore_errors: true
...
EOF
```
### Для шага verify
```bash
cat > molecule/default/verify.yml <<'EOF'
---
- name: Проверка роли vector
  hosts: all
  gather_facts: false

  tasks:
    - name: Проверка наличия исполняемого файла
      stat:
        path: /usr/bin/vector
      register: bin_stat

    - name: Подтверждение наличия исполняемого файла vector
      assert:
        that:
          - bin_stat.stat.exists
        fail_msg: "Vector binary not found at /usr/bin/vector"

    - name: Существует ли конфигурация vector
      stat:
        path: /etc/vector/vector.yaml
      register: cfg_stat

    - name: Подтверждение наличия vector config
      assert:
        that:
          - cfg_stat.stat.exists
          - cfg_stat.stat.size | int > 0
        fail_msg: "Vector config /etc/vector/vector.yaml missing or empty"

    - name: Проверка синтаксиса конфигурации vector
      command: /usr/bin/vector validate /etc/vector/vector.yaml
      register: validate_result
      changed_when: false
      failed_when: false

    - name: Вывод проверки результата
      debug:
        msg: "Valid = {{ 'yes' if validate_result.rc == 0 else 'no' }} (rc={{ validate_result.rc }})"
...
EOF
```
### Вывод получившихся шагов
```bash
molecule matrix test
```
<details>
<summary>Molecule Test matrix</summary>

```
Test matrix
-----------
default
  ├─ dependency Missing playbook (remove from test_sequence to suppress)
  ├─ cleanup Missing playbook (remove from test_sequence to suppress)
  ├─ destroy /home/shoel/nfs_git/gited/17_5/roles/vector/molecule/default/destroy.yml
  ├─ syntax Missing playbook (remove from test_sequence to suppress)
  ├─ create /home/shoel/nfs_git/gited/17_5/roles/vector/molecule/default/create.yml
  ├─ prepare Missing playbook (remove from test_sequence to suppress)
  ├─ converge /home/shoel/nfs_git/gited/17_5/roles/vector/molecule/default/converge.yml
  ├─ idempotence Missing playbook (remove from test_sequence to suppress)
  ├─ side_effect Missing playbook (remove from test_sequence to suppress)
  ├─ verify /home/shoel/nfs_git/gited/17_5/roles/vector/molecule/default/verify.yml
  ├─ cleanup Missing playbook (remove from test_sequence to suppress)
  └─ destroy /home/shoel/nfs_git/gited/17_5/roles/vector/molecule/default/destroy.yml
```

</details>

### Запуск проверок
```bash
# несколько запусков для обхода отработки обработчиков роли
molecule test --destroy=never \
; molecule converge \
&& molecule verify \
&& molecule destroy
```
<details>
<summary>Molecule Test matrix</summary>

```
INFO     default ➜ discovery: scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     default ➜ prerun: Performing prerun with role_name_check=0...
INFO     default ➜ dependency: Executing
INFO     default ➜ dependency: Executed: 2 disabled
INFO     default ➜ cleanup: Executing
INFO     default ➜ destroy: Executing
INFO     default ➜ destroy: Executed: Successful
INFO     default ➜ syntax: Executing
INFO     Sanity checks: 'docker'

playbook: /home/shoel/nfs_git/gited/17_5/roles/vector/molecule/default/converge.yml
INFO     default ➜ syntax: Executed: Successful
INFO     default ➜ create: Executing

PLAY [Create] ******************************************************************

TASK [Создание образов] ********************************************************
changed: [localhost] => (item={'cgroupns_mode': 'host', 'command': '/lib/systemd/systemd', 'dockerfile': '24.04.Dockerfile', 'image': 'molecule-vector-ubuntu:24.04', 'name': 'instance-ubuntu', 'privileged': True, 'tmpfs': ['/tmp', '/run', '/run/lock'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:rw']})
changed: [localhost] => (item={'cgroupns_mode': 'host', 'command': '/lib/systemd/systemd', 'dockerfile': '13.Dockerfile', 'image': 'molecule-vector-debian:13', 'name': 'instance-debian', 'privileged': True, 'tmpfs': ['/tmp', '/run', '/run/lock'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:rw']})

TASK [Создание контейнеров] ****************************************************
changed: [localhost] => (item={'cgroupns_mode': 'host', 'command': '/lib/systemd/systemd', 'dockerfile': '24.04.Dockerfile', 'image': 'molecule-vector-ubuntu:24.04', 'name': 'instance-ubuntu', 'privileged': True, 'tmpfs': ['/tmp', '/run', '/run/lock'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:rw']})
changed: [localhost] => (item={'cgroupns_mode': 'host', 'command': '/lib/systemd/systemd', 'dockerfile': '13.Dockerfile', 'image': 'molecule-vector-debian:13', 'name': 'instance-debian', 'privileged': True, 'tmpfs': ['/tmp', '/run', '/run/lock'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:rw']})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     default ➜ create: Executed: Successful
INFO     default ➜ prepare: Executing
INFO     default ➜ converge: Executing

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [Применить тестируемую роль] **********************************************
included: vector for instance-debian, instance-ubuntu

TASK [vector : Обновление и установка основных пакетов] ************************
included: /home/shoel/nfs_git/gited/17_5/roles/vector/tasks/upd_inst.yml for instance-debian, instance-ubuntu

TASK [vector : Установка для загрузки Vector] **********************************
changed: [instance-debian]
changed: [instance-ubuntu]

TASK [vector : Скачать Vector tar.gz] ******************************************
changed: [instance-ubuntu]
changed: [instance-debian]

TASK [vector : Распаковать Vector в /opt] **************************************
changed: [instance-debian]
changed: [instance-ubuntu]

TASK [vector : Создать symlink] ************************************************
changed: [instance-debian]
changed: [instance-ubuntu]

TASK [vector : Обновление и создание необходимых каталогов и файлов] ***********
included: /home/shoel/nfs_git/gited/17_5/roles/vector/tasks/upd_dir.yml for instance-debian, instance-ubuntu

TASK [vector : Директория для конфигурации Vector datadog] *********************
changed: [instance-debian]
changed: [instance-ubuntu]

TASK [vector : Директория для дискового буФЕРА Vector datadog] *****************
changed: [instance-debian]
changed: [instance-ubuntu]

TASK [vector : Первое Развертывание из шаблона] ********************************
changed: [instance-debian]
changed: [instance-ubuntu]

TASK [vector : Повторное Развертывание из шаблона с валидацией] ****************
skipping: [instance-debian]
skipping: [instance-ubuntu]

RUNNING HANDLER [vector : Перезапустить Vector] ********************************
[ERROR]: Task failed: Module failed: Could not find the requested service vector: host
Origin: /home/shoel/nfs_git/gited/17_5/roles/vector/handlers/main.yml:2:3

1 ---
2 - name: Перезапустить Vector
    ^ column 3

fatal: [instance-debian]: FAILED! => 
    changed: false
    msg: 'Could not find the requested service vector: host'
fatal: [instance-ubuntu]: FAILED! => 
    changed: false
    msg: 'Could not find the requested service vector: host'

PLAY RECAP *********************************************************************
instance-debian            : ok=11   changed=7    unreachable=0    failed=1    skipped=1    rescued=0    ignored=0
instance-ubuntu            : ok=11   changed=7    unreachable=0    failed=1    skipped=1    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ansible-playbook --inventory /home/shoel/.ansible/tmp/molecule.sNUc.default/inventory --skip-tags molecule-notest,notest --skip-tags=service,verify /home/shoel/nfs_git/gited/17_5/roles/vector/molecule/default/converge.yml
ERROR    default ➜ converge: Executed: Failed
ERROR    Ansible return code was 2, command was: ansible-playbook --inventory /home/shoel/.ansible/tmp/molecule.sNUc.default/inventory --skip-tags molecule-notest,notest --skip-tags=service,verify /home/shoel/nfs_git/gited/17_5/roles/vector/molecule/default/converge.yml
INFO     default ➜ discovery: scenario test matrix: dependency, create, prepare, converge
INFO     default ➜ prerun: Performing prerun with role_name_check=0...
INFO     default ➜ dependency: Executing
INFO     default ➜ dependency: Executed: 2 disabled
INFO     default ➜ create: Executing
INFO     default ➜ create: Executed: Skipped (Skipping, instances already created.)
INFO     default ➜ prepare: Executing
INFO     default ➜ converge: Executing
INFO     Sanity checks: 'docker'

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [Применить тестируемую роль] **********************************************
included: vector for instance-debian, instance-ubuntu

TASK [vector : Обновление и установка основных пакетов] ************************
included: /home/shoel/nfs_git/gited/17_5/roles/vector/tasks/upd_inst.yml for instance-debian, instance-ubuntu

TASK [vector : Установка для загрузки Vector] **********************************
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [vector : Скачать Vector tar.gz] ******************************************
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [vector : Распаковать Vector в /opt] **************************************
skipping: [instance-ubuntu]
skipping: [instance-debian]

TASK [vector : Создать symlink] ************************************************
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [vector : Обновление и создание необходимых каталогов и файлов] ***********
included: /home/shoel/nfs_git/gited/17_5/roles/vector/tasks/upd_dir.yml for instance-debian, instance-ubuntu

TASK [vector : Директория для конфигурации Vector datadog] *********************
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [vector : Директория для дискового буФЕРА Vector datadog] *****************
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [vector : Первое Развертывание из шаблона] ********************************
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [vector : Повторное Развертывание из шаблона с валидацией] ****************
skipping: [instance-debian]
skipping: [instance-ubuntu]

PLAY RECAP *********************************************************************
instance-debian            : ok=10   changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
instance-ubuntu            : ok=10   changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     default ➜ converge: Executed: Successful
INFO     default ➜ discovery: scenario test matrix: verify
INFO     default ➜ prerun: Performing prerun with role_name_check=0...
INFO     default ➜ verify: Executing
INFO     Sanity checks: 'docker'

PLAY [Проверка роли vector] ****************************************************

TASK [Проверка наличия исполняемого файла] *************************************
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [Подтверждение наличия исполняемого файла vector] *************************
ok: [instance-debian] => 
    changed: false
    msg: All assertions passed
ok: [instance-ubuntu] => 
    changed: false
    msg: All assertions passed

TASK [Существует ли конфигурация vector] ***************************************
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [Подтверждение наличия vector config] *************************************
ok: [instance-debian] => 
    changed: false
    msg: All assertions passed
ok: [instance-ubuntu] => 
    changed: false
    msg: All assertions passed

TASK [Проверка синтаксиса конфигурации vector] *********************************
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [Вывод проверки результата] ***********************************************
ok: [instance-debian] => 
    msg: Valid = no (rc=78)
ok: [instance-ubuntu] => 
    msg: Valid = no (rc=78)

PLAY RECAP *********************************************************************
instance-debian            : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
instance-ubuntu            : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     default ➜ verify: Executed: Successful
INFO     Molecule executed 1 scenario (1 successful)
INFO     default ➜ discovery: scenario test matrix: dependency, cleanup, destroy
INFO     default ➜ prerun: Performing prerun with role_name_check=0...
INFO     default ➜ dependency: Executing
INFO     default ➜ dependency: Executed: 2 disabled
INFO     default ➜ cleanup: Executing
INFO     default ➜ destroy: Executing
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Уничтожение контейнера] **************************************************
changed: [localhost] => (item={'cgroupns_mode': 'host', 'command': '/lib/systemd/systemd', 'dockerfile': '24.04.Dockerfile', 'image': 'molecule-vector-ubuntu:24.04', 'name': 'instance-ubuntu', 'privileged': True, 'tmpfs': ['/tmp', '/run', '/run/lock'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:rw']})
changed: [localhost] => (item={'cgroupns_mode': 'host', 'command': '/lib/systemd/systemd', 'dockerfile': '13.Dockerfile', 'image': 'molecule-vector-debian:13', 'name': 'instance-debian', 'privileged': True, 'tmpfs': ['/tmp', '/run', '/run/lock'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:rw']})

TASK [Удаление Образов] ********************************************************
changed: [localhost] => (item={'cgroupns_mode': 'host', 'command': '/lib/systemd/systemd', 'dockerfile': '24.04.Dockerfile', 'image': 'molecule-vector-ubuntu:24.04', 'name': 'instance-ubuntu', 'privileged': True, 'tmpfs': ['/tmp', '/run', '/run/lock'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:rw']})
changed: [localhost] => (item={'cgroupns_mode': 'host', 'command': '/lib/systemd/systemd', 'dockerfile': '13.Dockerfile', 'image': 'molecule-vector-debian:13', 'name': 'instance-debian', 'privileged': True, 'tmpfs': ['/tmp', '/run', '/run/lock'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:rw']})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     default ➜ destroy: Executed: Successful
INFO     default ➜ scenario: Pruning extra files from scenario ephemeral directory
```

</details>

```bash
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
git add . .. ../.. ../../.. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit3_upd1, 17_5-ansible_testing' \
&& git push \
--set-upstream \
study_fops39 \
17_5-ansible_testing \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
17_5-ansible_testing
```
## commit_4 `17_5-ansible_testing`
```bash
rsync -arvP \
./ \
../../../../gh_vector_role/
```

<details>
<summary>rsync log</summary>

```
sending incremental file list
./
README.md
          5.535 100%    0,00kB/s    0:00:00 (xfr#1, to-chk=31/33)
collections.yml
             16 100%   15,62kB/s    0:00:00 (xfr#2, to-chk=30/33)
requirements.yml
              3 100%    2,93kB/s    0:00:00 (xfr#3, to-chk=29/33)
defaults/
defaults/main.yml
            854 100%  104,25kB/s    0:00:00 (xfr#4, to-chk=21/33)
handlers/
handlers/main.yml
            501 100%   61,16kB/s    0:00:00 (xfr#5, to-chk=20/33)
meta/
meta/.galaxy_install_info
             77 100%    9,40kB/s    0:00:00 (xfr#6, to-chk=19/33)
meta/main.yml
            375 100%   45,78kB/s    0:00:00 (xfr#7, to-chk=18/33)
molecule/
molecule/default/
molecule/default/13.Dockerfile
            631 100%   77,03kB/s    0:00:00 (xfr#8, to-chk=16/33)
molecule/default/24.04.Dockerfile
            630 100%   76,90kB/s    0:00:00 (xfr#9, to-chk=15/33)
molecule/default/converge.yml
            174 100%   18,88kB/s    0:00:00 (xfr#10, to-chk=14/33)
molecule/default/create.yml
            836 100%   90,71kB/s    0:00:00 (xfr#11, to-chk=13/33)
molecule/default/destroy.yml
            548 100%   59,46kB/s    0:00:00 (xfr#12, to-chk=12/33)
molecule/default/molecule.yml
          1.147 100%  124,46kB/s    0:00:00 (xfr#13, to-chk=11/33)
molecule/default/verify.yml
          1.262 100%  136,94kB/s    0:00:00 (xfr#14, to-chk=10/33)
molecule/default/roles/
tasks/
tasks/main.yml
            529 100%   57,40kB/s    0:00:00 (xfr#15, to-chk=7/33)
tasks/upd_dir.yml
          1.046 100%  113,50kB/s    0:00:00 (xfr#16, to-chk=6/33)
tasks/upd_inst.yml
          1.094 100%  118,71kB/s    0:00:00 (xfr#17, to-chk=5/33)
tasks/upd_serv.yml
            465 100%   50,46kB/s    0:00:00 (xfr#18, to-chk=4/33)
tasks/upd_verif.yml
            485 100%   52,63kB/s    0:00:00 (xfr#19, to-chk=3/33)
templates/
templates/vector.service.j2
            590 100%   64,02kB/s    0:00:00 (xfr#20, to-chk=2/33)
templates/vector.yaml.j2
          1.524 100%  165,36kB/s    0:00:00 (xfr#21, to-chk=1/33)
vars/
vars/main.yml
              8 100%    0,78kB/s    0:00:00 (xfr#22, to-chk=0/33)

sent 20.219 bytes  received 484 bytes  41.406,00 bytes/sec
total size is 18.338  speedup is 0,89
```

</details>

```bash
cd !$
```
```
cd ../../../../gh_vector_role/
```
```bash
# Вывод списка удаленных репозиториев
git remote -v

git remote \
remove \
origin

git remote \
add \
origin \
git@github.com:shoelacevip12/vector.git

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
git add . \
&& git status

# Создание Аннотированного тега v0.1
git tag \
-a v0.2 \
-m 'skv_ansible_vector_role'

# отображение всех тегов начинающихся с "v"
git tag \
-l "v*"
```
```
v0.1
v0.2
```
```bash
# Внесение изменений в текущий коммит
git add . \
&& git commit --amend --no-edit \
&& git push \
--set-upstream \
origin main --tags --force

cd -
```