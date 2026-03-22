Ansible Role:Vector datadog
=========

Описание
------------

Развертывание Vector, высокопроизводительного инструмент для сбора метрик

Role Variables
--------------

|Переменная                                                 |Значение по умолчанию (defaults/main.yml)                   |Постоянное значение (vars/main.yml)|Описание                                                             |
|-----------------------------------------------------------|------------------------------------------------------------|-----------------------------------|---------------------------------------------------------------------|
|vector_config.sources.var_logs.host_key                    |hostname                                                    |—                                  |Ключ для идентификации хоста в логах                                 |
|vector_config.sources.var_logs.include                     |["/var/log/**/*.log", "/var/log/*.log"]                     |—                                  |Маски файлов для сбора логов                                         |
|vector_config.sources.var_logs.line_delimiter              |"\n"                                                        |—                                  |Разделитель строк при чтении логов                                   |
|vector_config.sources.var_logs.read_from                   |beginning                                                   |—                                  |Начальная позиция чтения файла                                       |
|vector_config.sources.var_logs.rotate_wait_secs            |9223372                                                     |—                                  |Время ожидания при ротации логов (сек)                               |
|vector_config.sources.var_logs.type                        |—                                                           |file                               |Тип источника данных                                                 |
|vector_config.sources.var_logs.data_dir                    |—                                                           |/var/local/lib/vector/             |Директория для хранения состояния Vector                             |
|vector_config.sources.var_logs.file_key                    |—                                                           |file                               |Ключ для идентификации файла в метаданных                            |
|vector_config.sources.var_logs.glob_minimum_cooldown_ms    |—                                                           |1000                               |Минимальная задержка между проверками новых файлов (мс)              |
|vector_config.sources.var_logs.ignore_older_secs           |—                                                           |600                                |Игнорировать файлы, не изменявшиеся дольше (сек)                     |
|vector_config.sources.var_logs.max_line_bytes              |—                                                           |102400                             |Максимальный размер одной строки лога (байт)                         |
|vector_config.sources.var_logs.max_read_bytes              |—                                                           |2048                               |Максимальный объем данных за одно чтение (байт)                      |
|vector_config.sinks.var_logs_clickhouse.type               |clickhouse                                                  |—                                  |Тип назначения (sink)                                                |
|vector_config.sinks.var_logs_clickhouse.inputs             |["skv_file_test"]                                           |—                                  |Список входных источников для sink                                   |
|vector_config.sinks.var_logs_clickhouse.database           |skvvectordb                                                 |mydatabase                         |Имя базы данных ClickHouse                                           |
|vector_config.sinks.var_logs_clickhouse.endpoint           |http://localhost:8123                                       |—                                  |Endpoint ClickHouse HTTP-интерфейса                                  |
|vector_config.sinks.var_logs_clickhouse.table              |mytable                                                     |—                                  |Целевая таблица для записи данных                                    |
|vector_config.sinks.var_logs_clickhouse.auth               |{strategy: basic, user: 'skv', password: 'test1qaz'}        |—                                  |Параметры аутентификации в ClickHouse                                |
|vector_config.sinks.var_logs_clickhouse.buffer             |[{type: disk, max_size: 1073741824, when_full: drop_newest}]|—                                  |Настройки буфера: тип, макс. размер (1 GiB), поведение при заполнении|
|vector_config.sinks.var_logs_clickhouse.compression        |—                                                           |gzip                               |Тип сжатия данных при отправке                                       |
|vector_config.sinks.var_logs_clickhouse.format             |—                                                           |json_each_row                      |Формат данных для отправки в ClickHouse                              |
|vector_config.sinks.var_logs_clickhouse.skip_unknown_fields|—                                                           |true                               |Пропускать неизвестные поля при вставке                              |


Звисимость
------------
Роль подготовлена для работы с другой ролью
```yaml
---
- src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
  scm: git
  version: "1.13"
  name: clickhouse
...
```
Установка
```bash
ansible-galaxy install \
-p roles \
-r requirements.yml
```

Пример Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: vector-role }

License
-------

Пока не понял, но очень интересно

От автора
------------------

Предварительное описание для работы стека 

│ Vector(сбор данных) │ ▶ │ ClickHouse(хранение) │ ◀ │ Lighthouse (просмотр) │