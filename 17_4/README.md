# Домашнее задание к занятию 4 «`Работа с roles`»`Скворцов Денис`

## Подготовка к выполнению

1. * Необязательно. Познакомьтесь с [LightHouse](https://youtu.be/ymlrNlaHzIY?t=929).
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю на GitHub.

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.13"
       name: clickhouse 
   ```
```bash
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
```
2. При помощи `ansible-galaxy` скачайте себе эту роль.
```bash
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
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
```bash
# Новая структура с ролью vector-role в папке roles
ansible-galaxy role \
init \
roles/vector-role 
```
```
- Role vector-role was created successfully
```
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`.
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
      endpoint: http://localhost:8123
      table: mytable
      auth: { strategy: basic, user: 'skv', password: 'test1qaz' }
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
```
5. Перенести нужные шаблоны конфигов в `templates`.
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
6. Опишите в `README.md` обе роли и их параметры. Пример качественной документации ansible role [по ссылке](https://github.com/cloudalchemy/ansible-prometheus).

---

[Описание созданной роли](roles/vector-role/README.md)

---

7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
