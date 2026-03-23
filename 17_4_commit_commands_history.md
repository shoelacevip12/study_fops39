# Для домашнего задания 17.4 `Работа с roles`
## commit_56, master Предварительная подготовка
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

# Удаление всех файлов и каталогов кроме каталога 08-ansible-04-role и его содержимого
find mnt-homeworks/ \
-mindepth 1 \
-not -path "*08-ansible-04-role*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 17_4
mv mnt-homeworks/08-ansible-04-role \
17_4

# Переход в каталог по последней переменной вывода последней команды (17_4)
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

# Генерация ключа для работы с gitflic
ssh-keygen -f ~/.ssh/id_gitflic_2026_ed25519 \
-t ed25519 \
-C "gitflic_2026"

# Удаление источника авторизации по https для gitflic
git remote rm \
study_fops39_gitflic_ru

# Добавление источника для авторизации на gitflic по ssh
git remote add \
study_fops39_gitflic_ru \
git@gitflic.ru:shoelacevip12/fops39.git

# Генерация ключа для работы с github
ssh-keygen -f ~/.ssh/id_github_2026_ed25519 \
-t ed25519 \
-C "github_2026"

# Через консоль gh добавляем публичный ключ для подключения
gh ssh-key \
add ~/.ssh/id_github_2026_ed25519.pub

# Удаление источника авторизации по https для github
git remote rm \
study_fops39

# Добавление источника для авторизации на github по ssh
git remote add \
study_fops39 \
git@github.com:shoelacevip12/study_fops39.git

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
git commit -am 'commit_56_upd2, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```
## commit_1, `17_4-ansible_role`
```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 17_4-ansible_role

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
git commit -am 'commit1_upd_8, 17_4-ansible_role' \
&& git push \
--set-upstream \
study_fops39 \
17_4-ansible_role \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
17_4-ansible_role
```
## commit_2, `17_4-ansible_role`
```bash
# Директории для работы
cd 17_4

# Создание файла requirements для скачивания роли из указанного источника
cat > requirements.yml <<'EOF'
---
  - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
    scm: git
    version: "1.13"
    name: clickhouse
...
EOF

# Скачивание роли из git репозитория источника 
ansible-galaxy install \
-p roles \
-r requirements.yml
```
```
Starting galaxy role install process
- extracting clickhouse to /home/shoel/nfs_git/gited/17_4/roles/clickhouse
- clickhouse (1.13) was installed successfully
```
```bash
# Новая структура с ролью vector-role
ansible-galaxy role \
init \
roles/vector-role
```
```
- Role vector-role was created successfully
```
## Создание настроек работы ansible для текущего проекта в каталоге 
```bash
cat > ansible.cfg <<'EOF'
[defaults]
home=./
inventory=./hosts.ini
roles_path=./roles
collections_paths=./collections
# vault_password_file=./va_pa
host_key_checking=False
interpreter_python=auto_silent
deprecation_warnings=False
retry_files_enabled=False
callback_enabled=profile_tasks

[privilege_escalation]
become = true
become_method = sudo

[connection]
ssh_agent=auto

[paramiko_connection]
host_key_checking=False

[ssh_connection]
host_key_checking=False
EOF

# Для nfs сетевого хранилища и отключения сообщения
# "Ansible is being run in a world writable directory ...
# ignoring it as an ansible.cfg source"
export ANSIBLE_CONFIG=./ansible.cfg
```
## РАспределение значений переменных по умолчанию
```bash
# создание общего словаря vector_config переменных по умолчанию
cat > roles/vector-role/defaults/main.yml <<'EOF'
---
vector_config:
  sources:
    var_logs:
      host_key: hostname
      include: ["/var/log/**/*.log", "/var/log/*.log"]
      line_delimiter: '\n'
      read_from: beginning
      rotate_wait_secs: 9223372
      type: file
      data_dir: /var/lib/vector/
      file_key: file
      glob_minimum_cooldown_ms: 1000
      ignore_older_secs: 600
      max_line_bytes: 102400
      max_read_bytes: 2048

  sinks:
    var_logs_clickhouse:
      type: clickhouse
      inputs: [var_logs]
      database: skvvectordb
      endpoint: http://192.168.89.104:8123
      table: mytable
      auth:
        strategy: basic
        user: skv
        password: 'test1qaz'
      compression: gzip
      format: json_each_row
      skip_unknown_fields: true
      buffer:
        - type: disk
          max_size: 1073741824 # 1GiB.
          when_full: drop_newest
...
EOF
```
## Формирование шаблонов для роли vector datadog
### основной конфиг
```bash
cat > roles/vector-role/templates/vector.yaml.j2 <<'EOF'
---
# === ИСТОЧНИКИ ===
sources:
  var_logs:
    type: {{ vector_config.sources.var_logs.type }}
    data_dir: {{ vector_config.sources.var_logs.data_dir }}
    file_key: {{ vector_config.sources.var_logs.file_key }}
    glob_minimum_cooldown_ms: {{ vector_config.sources.var_logs.glob_minimum_cooldown_ms }}
    host_key: {{ vector_config.sources.var_logs.host_key }}
    ignore_older_secs: {{ vector_config.sources.var_logs.ignore_older_secs }}
    include: {{ vector_config.sources.var_logs.include }}
    line_delimiter: {{ vector_config.sources.var_logs.line_delimiter }}
    max_line_bytes: {{ vector_config.sources.var_logs.max_line_bytes }}
    max_read_bytes: {{ vector_config.sources.var_logs.max_read_bytes }}
    read_from: {{ vector_config.sources.var_logs.read_from }}
    rotate_wait_secs: {{ vector_config.sources.var_logs.rotate_wait_secs }}

# ==== ПРИЁМНИК ====
sinks:
  var_logs_clickhouse:
    type: {{ vector_config.sinks.var_logs_clickhouse.type }}
    inputs: {{ vector_config.sinks.var_logs_clickhouse.inputs }}
    compression: {{ vector_config.sinks.var_logs_clickhouse.compression }}
    database: {{ vector_config.sinks.var_logs_clickhouse.database }}
    endpoint: {{ vector_config.sinks.var_logs_clickhouse.endpoint }}
    format: {{ vector_config.sinks.var_logs_clickhouse.format }}
    table: {{ vector_config.sinks.var_logs_clickhouse.table }}
    auth: {{ vector_config.sinks.var_logs_clickhouse.auth }}
    buffer: {{ vector_config.sinks.var_logs_clickhouse.buffer }}
...
EOF
```
### служба для vector
```bash
cat > roles/vector-role/templates/vector.service.j2 <<'EOF'
[Unit]
Description=Vector
Documentation=https://vector.dev
After=network-online.target
Requires=network-online.target

[Service]
User=root
Group=root
ExecStartPre=/usr/bin/vector validate
ExecStart=/usr/bin/vector
ExecReload=/usr/bin/vector validate --no-environment
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
AmbientCapabilities=CAP_NET_BIND_SERVICE
EnvironmentFile=-/etc/default/vector
# Since systemd 229, should be in [Unit] but in order to support systemd <229,
# it is also supported to have it here.
StartLimitInterval=10
StartLimitBurst=5
[Install]
WantedBy=multi-user.target
EOF
```
## Формирование Tasks Для vector datadog
```bash
# Задачи установки ПО
cat > roles/vector-role/tasks/upd_inst.yml <<'EOF'
---
- name: Установка для загрузки Vector
  apt:
    name:
      - curl
      - ca-certificates
    update_cache: true

- name: Скачать Vector tar.gz
  ansible.builtin.get_url:
    url: "https://packages.timber.io/vector/0.54.0/vector-0.54.0-x86_64-unknown-linux-gnu.tar.gz"
    dest: "/tmp/vector-install.tar.gz"
    mode: '0644'
    
- name: Распаковать Vector в /opt
  unarchive:
    src: /tmp/vector-install.tar.gz
    dest: /opt
    remote_src: true
    creates: /opt/vector-x86_64-unknown-linux-gnu

- name: Создать symlink
  file:
    src: /opt/vector-x86_64-unknown-linux-gnu/bin/vector
    dest: /usr/bin/vector
    state: link
    force: true
...
EOF
```
```bash
# Задачи по созданию нужных каталогов и файлов
cat > roles/vector-role/tasks/upd_dir.yml <<'EOF'
---
- name: Директория для конфигурации Vector datadog
  file:
    path: /etc/vector
    state: directory
    mode: '0755'
    owner: root
    group: root

- name: Директория для дискового буФЕРА Vector datadog
  file:
    path: "{{ vector_config.sources.var_logs.data_dir }}"
    state: directory
    mode: '0755'
    owner: root
    group: root
  ignore_errors: false

- name: Первое Развертывание из шаблона
  template:
    src: vector.yaml.j2
    dest: /etc/vector/vector.yaml
    mode: '0640'
    owner: root
    group: root
  notify: Перезапустить Vector

- name: Повторное Развертывание из шаблона с валидацией
  template:
    src: vector.yaml.j2
    dest: /etc/vector/vector.yaml
    mode: '0640'
    owner: root
    group: root
    backup: true
    validate: /usr/bin/vector validate --no-environment %s
  notify: Перезапустить Vector
  when: vector_config_validated | default(false)
...
EOF
```
```bash
# Задачи по запуску службы
cat > roles/vector-role/tasks/upd_serv.yml <<'EOF'
---
- name: Создать systemd unit-файл для Vector
  template:
    src: vector.service.j2
    dest: /etc/systemd/system/vector.service
    mode: '0644'
    owner: root
    group: root
  notify: Перезагрузить systemd и перезапустить Vector

- name: Активировать и запустить службу Vector
  systemd:
    name: vector
    state: started
    enabled: true
    masked: false
    daemon_reload: true
...
EOF
```
```bash
# Проверка работы службы в рамках отдельных задач
cat > roles/vector-role/tasks/upd_verif.yml <<'EOF'
---
- name: Проверка статуса службы Vector
  systemd:
    name: vector

- name: Проверка конфигурации Vector (валидация)
  command: /usr/bin/vector validate /etc/vector/vector.yaml
  register: vector_validate
  changed_when: false
  failed_when: vector_validate.rc != 0

- name: Результат валидации конфига
  debug:
    msg: "Конфигурация Vector валидна"
  when: vector_validate.rc == 0
...
EOF
```
## Создание playbook роли vector
```bash
cat > playbook_vector.yaml <<'EOF'
#!/usr/bin/env ansible-playbook
---
- name: Установка и развертывание vector
  hosts: vector
  become: true
  gather_facts: true

  roles:
    - vector-role
...
EOF
```
## Развертывание тестового стенда из playbook для lxc
```bash
# для вывода в yaml формате
export ANSIBLE_CALLBACK_RESULT_FORMAT=yaml

# Запуск формирования стенда
./containers.yml -b -K -v
```
```bash
# вывод получившихся Ip
scripts/ip_check.sh
```
```
clickhouse - 192.168.89.104
lighthouse - 192.168.89.105
vector - 192.168.89.106
```
## Создание инвентаря хостов для взаимодействия
```bash
# выход из каталога с развертыванием тестового стенда
cd ..

# запуск подготовленного скрипта для формирования статичного списка
./ansible-local-stand/scripts/hosts_ini_gen.sh

cat hosts.ini
```
```
[clickhouse]
192.168.89.104

[lighthouse]
192.168.89.105

[vector]
192.168.89.106

[stack_log:children]
clickhouse
lighthouse
vector
```
## Создание общих переменной между ролями
```bash
# каталог для переопределения переменных
mkdir group_vars

# Создание файла переопределения переменных для группы clickhouse
cat > group_vars/clickhouse.yaml <<'EOF'
---
clickhouse_users_custom:
      - { name: "skv",
          password: "test1qaz",
          networks: {192.168.89.0/24},
          profile: "default",
          quota: "default",
          dbs: [skvvectordb] ,
          comment: "classic user with multi dbs and multi-custom network allow password"}

clickhouse_listen_host_custom:
  - "192.168.89.104"
...
EOF
```
```bash
# создание файла общих переменной для всех групп
cat > group_vars/all.yml <<'EOF'
---
# включаем(true)\выключаем(false) задачи роли
install_clickhouse: true  # установка clickhouse
install_lighthouse: false  # установка lighthouse
install_vector: true     # установка vector

# Для предварительно настроенных хостов с доступом по ключу
ansible_user: root
ansible_ssh_private_key_file: "~/.ssh/id_kvm_host_to_vms"
...
EOF
```
## Проверка подключения
```bash
# Регистрация прописанного в переменных ключа
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_kvm_host_to_vms

# для вывода информации в yaml формате
export ANSIBLE_CALLBACK_RESULT_FORMAT=yaml

# Запуск подготовленного скрипта создания hosts.ini
./ansible-local-stand/scripts/hosts_ini_gen.sh

# запуск тестового модуля ping с текущей конфигурацией и статическим списком
ansible stack_log -v \
-m ping \
-i hosts.ini
```
```
Using /home/shoel/nfs_git/gited/17_4/ansible.cfg as config file
192.168.89.105 | SUCCESS => 
    ansible_facts:
        discovered_interpreter_python: /usr/bin/python3.12
    changed: false
    ping: pong
192.168.89.104 | SUCCESS => 
    ansible_facts:
        discovered_interpreter_python: /usr/bin/python3.12
    changed: false
    ping: pong
192.168.89.106 | SUCCESS => 
    ansible_facts:
        discovered_interpreter_python: /usr/bin/python3.12
    changed: false
    ping: pong
```
## Создание общего playbook для вызова ролей
```bash
cat > playbook_main.yaml <<'EOF'
#!/usr/bin/env ansible-playbook
#!/usr/bin/env ansible-playbook
---
- name: Развертывание стэка сбора телеметрии
  hosts: stack_log
  become: true
  gather_facts: true
  vars_files:
    - group_vars/all.yml # Здесь параметры включения\выключения ролей

- name: Установка и развертывание clickhouse
  import_playbook: playbook_clickhouse.yaml
  when: install_clickhouse | bool

- name: Установка и развертывание lighthouse
  import_playbook: playbook_lighthouse.yaml
  when: install_lighthouse | bool

- name: Установка и развертывание vector
  import_playbook: playbook_vector.yaml
  when: install_vector | bool
...
EOF
```
## Создание playbook для роли clickhouse
```bash
cat >playbook_clickhouse.yaml <<'EOF'
#!/usr/bin/env ansible-playbook
---
- name: Установка и развертывание clickhouse
  hosts: clickhouse
  become: yes
  gather_facts: yes

  roles:
  - clickhouse
...
EOF
```
## Создание playbook для роли vector
```bash
cat >playbook_vector.yaml <<'EOF'
#!/usr/bin/env ansible-playbook
---
- name: Установка и развертывание vector
  hosts: vector
  become: yes
  gather_facts: yes

  roles:
  - vector-role
...
EOF
```
## Запуск установки на стенде clickhouse и vector
```bash
# Для исключения
# "Ansible is being run in a world writable directory ...
# ignoring it as an ansible.cfg source"
export ANSIBLE_CONFIG=./ansible.cfg

# Для вывода playbook с первым уровнем детализации в yaml формате
export ANSIBLE_CALLBACK_RESULT_FORMAT=yaml

# Запуск Playbook как sh скрипт из-за "#!/usr/bin/env" ansible-playbook в начале файла
./playbook_main.yaml -v
```
```
....
TASK [vector-role : Проверка конфигурации Vector (валидация)] **************
ok: [192.168.89.106] => 
    changed: false
    cmd:
    - /usr/bin/vector
    - validate
    - /etc/vector/vector.yaml
    delta: '0:00:00.063028'
    end: '2026-03-23 18:53:34.952960'
    failed_when_result: false
    msg: ''
    rc: 0
    start: '2026-03-23 18:53:34.889932'
    stderr: ''
    stderr_lines: <omitted>
    stdout: |-
        √ Loaded ["/etc/vector/vector.yaml"]
        √ Component configuration
        √ Health check "var_logs_clickhouse"
        ------------------------------------
                                   Validated
    stdout_lines: <omitted>

TASK [vector-role : Результат валидации конфига] **********
ok: [192.168.89.106] => 
    msg: Конфигурация Vector валидна
....
PLAY RECAP *************
192.168.89.104  : ok=28   changed=10   unreachable=0    failed=0    skipped=10   rescued=0    ignored=0   
192.168.89.105  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
192.168.89.106  : ok=20   changed=10   unreachable=0    failed=0    skipped=1    rescued=0    ignored=0 
```
cat > <<'EOF'
EOF


## Создание playbook для роли lighthouse
```bash
cat >playbook_lighthouse.yaml <<'EOF'
#!/usr/bin/env ansible-playbook
---
- name: Установка и развертывание lighthouse
  hosts: lighthouse
  become: yes
  gather_facts: yes

  roles:
  - lighthouse-role
...
EOF
```
```bash
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
git commit -am 'commit2_upd4, 17_4-ansible_role' \
&& git push \
--set-upstream \
study_fops39 \
17_4-ansible_role \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
17_4-ansible_role
```

cat > <<'EOF'
EOF

ansible-playbook *.yaml --syntax-check \
&& ansible-lint *.yaml \
&& yamllint *.yaml \
ansible-inventory all -i hosts.ini
