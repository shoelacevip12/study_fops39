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
## РАспределение значений переменных по умолчанию и постоянных
```bash
# создание общего словаря vector_config переменных по умолчанию
cat > roles/vector-role/defaults/main.yml <<'EOF'
---
vector_config:
  # Словарь переменных по умолчанию для получения данных
  sources:
    var_logs:
      host_key: hostname
      include: [ "/var/log/**/*.log", "/var/log/*.log" ]
      line_delimiter: "\n"
      read_from: beginning
      rotate_wait_secs: 9223372

  # Словарь переменных по умолчанию доставки ДО сервиса
  sinks:
    var_logs_clickhouse:
      type: clickhouse
      inputs: [ skv_file_test ]
      database: skvvectordb
      endpoint: http://192.168.89.113:8123
      table: mytable
      auth: 
        strategy: basic
        user: skv
        password: 'test1qaz'
      buffer:
        - type: disk
          max_size: 1073741824 # 1GiB.
          when_full: drop_newest
...
EOF
```
```bash
# создание общего словаря vector_config ПОСТОЯННЫХ переменных
cat > roles/vector-role/vars/main.yml <<'EOF'
---
vector_config:
  # Словарь постоянных переменных для получения данных
  sources:
  var_logs:
    type: file
    data_dir: /var/local/lib/vector/
    file_key: file
    glob_minimum_cooldown_ms: 1000
    ignore_older_secs: 600
    max_line_bytes: 102400
    max_read_bytes: 2048

  # Словарь постоянных переменных доставки ДО сервиса
  sinks:
  var_logs_clickhouse:
    compression: gzip
    database: mydatabase
    format: json_each_row
    skip_unknown_fields: true
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
Description=Vector Log Aggregator
Wants=network-online.target
After=network-online.target

[Service]
User=vector
Group=vector
ExecStart=/usr/bin/vector --config /etc/vector/vector.yaml
Restart=on-failure
RestartSec=10s

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

- name: Скачать и установить Vector с оф. ресурса
  shell: |
    curl --proto '=https' --tlsv1.2 -sSf https://sh.vector.dev | sh -s -- -y
  args:
    creates: /usr/bin/vector
...
EOF

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
    owner: vector
    group: vector
  ignore_errors: true

- name: Развертывание из шаблона
  template:
    src: vector.yaml.j2
    dest: /etc/vector/vector.yaml
    mode: '0644'
    owner: root
    group: root
    backup: true
    validate: /usr/bin/vector validate --no-environment %s  # проверка синтаксиса
  notify: Перезапустить Vector
...
EOF

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
  tags: [service, vector]

- name: Активировать и запустить службу Vector
  systemd:
    name: vector
    state: started
    enabled: yes
    masked: no
    daemon_reload: yes
  tags: [service, vector]
...
EOF

# Проверка работы службы в рамках отдельных задач
cat > roles/vector-role/tasks/upd_verif.yml <<'EOF'
---
- name: Проверка статуса службы Vector
  command: /usr/bin/vector top --no-color
  register: vector_status
  changed_when: false
  failed_when: false  # не прерывать если команда недоступна
  tags: [verify, vector]

- name: Статус Vector
  debug:
    msg: "Vector запущен: {{ if vector_status.rc == 0 else }}"
  when: vector_status is defined
  tags: [verify, vector]
...
EOF

# Основной файл запуска роли
cat > roles/vector-role/tasks/main.yml <<'EOF'
---
- name: Обновление и установка основных пакетов
  include_tasks:
    file: upd_inst.yml
  tags: [install, vector]

- name: Обновление и создание необходимых каталогов и файлов
  include_tasks:
    file: upd_dir.yml
  tags: [config, vector]

- name: Запуск службы
  include_tasks:
    file: upd_serv.yml
  tags: [service, vector]

- name: Проверки Vector
  include_tasks:
    file: upd_verif.yml
  tags: [verify, vector]
...
EOF
```
```bash

```
cat > <<'EOF'
EOF
## Создание инвентаря хостов взаимодействия
### Вывод информации о запущенных машиных
```bash
ansible-local-stand/scripts/ip_check.sh 
```
```
clickhouse - 192.168.89.113
lighthouse - 192.168.89.114
vector - 192.168.89.115
```
### Создание файла инвентаря
```bash
cat > hosts.ini <<'EOF'
[clickhouse]
192.168.89.113

[lighthouse]
192.168.89.114

[vector]
192.168.89.115

[stack_log:children]
clickhouse
lighthouse
vector
EOF
```

## Создание общих переменной между ролями
```bash
# каталог для переопределения переменных
mkdir group_vars

# Создание файла переопределения переменных для группы clickhouse
cat > group_vars/clickhouse.yaml <<'EOF'
---
clickhouse_users_custom:
  name: skv
  password: test1qaz
  networks:
    - 192.168.89.113
...
EOF
```
```bash
# создание файла общих переменной для всех групп
cat > group_vars/all.yml <<'EOF'
---
# включаем(true)\выключаем(false) задачи роли
install_clickhouse: false  # установка clickhouse
install_lighthouse: false  # установка lighthouse
install_vector: false     # установка vector

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
192.168.89.113 | SUCCESS => 
    ansible_facts:
        discovered_interpreter_python: /usr/bin/python3.12
    changed: false
    ping: pong
192.168.89.115 | SUCCESS => 
    ansible_facts:
        discovered_interpreter_python: /usr/bin/python3.12
    changed: false
    ping: pong
192.168.89.114 | SUCCESS => 
    ansible_facts:
        discovered_interpreter_python: /usr/bin/python3.12
    changed: false
    ping: pong
```
## Создание общего playbook для вызова ролей
```bash
cat > playbook_main.yaml <<'EOF'
#!/usr/bin/env ansible-playbook
---
- name: Развертывание стэка сбора телеметрии
  hosts: stack_log
  become: yes
  gatther_facts: yes
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
git commit -am 'commit2_upd3, 17_4-ansible_role' \
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
