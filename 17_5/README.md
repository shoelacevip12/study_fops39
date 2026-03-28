# Домашнее задание к занятию 5 «`Тестирование roles`» `Скворцов Денис`

## Подготовка к выполнению

1. Установите molecule и его драйвера: `pip3 install "molecule molecule_docker molecule_podman`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s ubuntu_xenial` (или с любым другим сценарием, не имеет значения) внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками или не отработать вовсе, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу И из чего может состоять сценарий тестирования.

```bash
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

2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.

```bash
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

#### Создание файлов для заглушки
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
3. Добавьте несколько разных дистрибутивов (oraclelinux:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.

[Основной сценарий Default](./roles/vector/molecule/default/molecule.yml)

4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 


[Для шага create](./roles/vector/molecule/default/create.yml )

[Для шага converge](./roles/vector/molecule/default/converge.yml)

[Для шага Для шага destroy](./roles/vector/molecule/default/destroy.yml)

5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

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

6. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.


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
```

---


### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.
