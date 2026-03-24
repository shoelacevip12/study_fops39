# Ansible Role: lighthouse-role

Роль для автоматизированной установки и настройки [**Lighthouse**](https://github.com/VKCOM/lighthouse) — веб-интерфейса для работы с ClickHouse с поддержкой проксирования запросов и базовой аутентификации.

## Описание

Роль выполняет:
- Установку и настройку **nginx** в качестве веб-сервера и reverse-proxy
- Загрузку исходников Lighthouse из репозитория [**VKCOM**](https://github.com/VKCOM/lighthouse)
- Развёртывание файлов приложения в `/var/www/lighthouse`
- Генерацию конфигурации nginx с поддержкой:
  - Проксирования запросов к ClickHouse
  - Basic HTTP-аутентификации (опционально)
  - Защитных заголовков и логирования
- Настройку прав доступа и владельца файлов
- Валидацию конфигурации и проверку работоспособности сервиса

## Структура роли

```
lighthouse-role/
├── defaults/main.yml          # Переменные по умолчанию (nginx, source, clickhouse, auth)
├── tasks/
│   ├── main.yml               # Собирательная задача исполнения роли
│   ├── lh_inst.yml            # Установка пакетов и загрузка исходников
│   ├── lh_dir.yml             # Копирование файлов и настройка nginx
│   ├── lh_serv.yml            # Запуск и включение службы nginx
│   └── lh_verif.yml           # Проверки доступности и интеграции
├── templates/
│   └── lighthouse.conf.j2     # Шаблон nginx-конфигурации
├── handlers/main.yml          # Обработчики для перезагрузки nginx
└── README.md                  # Этот файл
```

## Переменные

Основные группы переменных в `defaults/main.yml`:

### Веб-сервер (nginx)
```yaml
lighthouse_config:
  nginx:
    listen_port: 80
    server_name: "_"
    root_dir: /var/www/lighthouse
    config_path: /etc/nginx/sites-available/lighthouse
    enabled_link: /etc/nginx/sites-enabled/lighthouse
```

### Источник файлов
```yaml
  source:
    repo_url: https://github.com/VKCOM/lighthouse/archive/refs/heads/master.tar.gz
    version: master
    dest_archive: /tmp/lighthouse.tar.gz
    extract_path: /tmp/lighthouse-extract
    final_path: /var/www/lighthouse
```

### 🗄 Подключение к ClickHouse
```yaml
  clickhouse:
    host: "192.168.0.100"
    port: 8123
    endpoint: "http://192.168.0.100:8123"
    user: skv
    password: test1qaz
    database: skvvectordb
```

### Аутентификация
```yaml
  auth:
    enabled: true
    type: basic
    htpasswd_path: /etc/nginx/.htpasswd
    users:
      - name: admin
        password: lighthouse_admin_pass  # ⚠️ Используйте vault!
```

### Проксирование и CORS
```yaml
  proxy:
    enabled: true
    timeout_connect: 60s
    timeout_send: 60s
    timeout_read: 60s
```

> **Важно**: Чувствительные данные (пароли, endpoint'ы) рекомендуется шифровать через **Ansible Vault** или передавать через защищённые переменные хостов/групп.

## Теги

Роль поддерживает выборочное выполнение задач:

| Тег | Описание |
|-----|----------|
| `install` | Установка пакетов и загрузка исходников Lighthouse |
| `config` | Копирование файлов, генерация nginx-конфига, настройка прав |
| `service` | Запуск и включение службы nginx |
| `verify` | Проверка статуса службы и доступности веб-интерфейса |
| `lighthouse` | Общий тег для всех задач роли |

Пример:
```bash
# Только конфигурация
ansible-playbook playbook_lighthouse.yaml --tags config

# Установка + проверка
ansible-playbook playbook_lighthouse.yaml --tags install,verify
```

## Быстрый старт

1. Добавьте роль в playbook:
```yaml
- name: Установка Lighthouse
  hosts: lighthouse
  become: true
  roles:
    - lighthouse-role
```

2. Переопределите переменные под вашу инфраструктуру:
```yaml
# group_vars/lighthouse.yml
lighthouse_config:
  clickhouse:
    endpoint: "https://clickhouse.prod.internal:8443"
    user: "{{ vault_ch_user }}"
    password: "{{ vault_ch_password }}"
  auth:
    users:
      - name: analyst
        password: "{{ vault_lh_password }}"
```

3. Запустите:
```bash
ansible-playbook playbook_lighthouse.yaml
```

## Проверка установки

```bash
# Статус nginx
systemctl status nginx

# Тест конфигурации
nginx -t

# Проверка доступности интерфейса
curl -I http://localhost/

# Проверка прокси к ClickHouse
curl -u admin:password "http://localhost/clickhouse?query=SELECT%201"

# Логи nginx
tail -f /var/log/nginx/lighthouse_access.log
```

## Доступ к интерфейсу

После успешного развёртывания:

```
🔹 Веб-интерфейс:
   http://<host>:80/

🔹 Параметры подключения (передаются в UI):
   • Host: {{ lighthouse_config.clickhouse.endpoint }}
   • User: {{ lighthouse_config.clickhouse.user }}
   • DB:   {{ lighthouse_config.clickhouse.database }}

🔹 Быстрая ссылка:
   http://<host>/?user=skv&password=test1qaz&host=http://192.168.89.100:8123
```

## Безопасность

### Рекомендации:
- Используйте **HTTPS** (настройте SSL в nginx отдельно)
- Храните пароли в **Ansible Vault**:
  ```bash
  ansible-vault encrypt_string 'secret_pass' \
    --name 'lighthouse_config.auth.users[0].password'
  ```
- Ограничьте доступ к `/clickhouse` через `allow/deny` в nginx
- Настройте RBAC в ClickHouse (отдельные пользователи с минимальными правами)
- Не передавайте учётные данные в URL-параметрах в продакшене

### Пример защиты директории:
```nginx
# В lighthouse.conf.j2
location / {
    allow 192.168.0.0/16;
    allow 10.0.0.0/8;
    deny all;
    # ... остальная конфигурация
}
```

## Обновление Lighthouse

Для обновления версии:

1. Измените `repo_url` и `version` в `defaults/main.yml` или переменных хоста:
   ```yaml
   lighthouse_config:
     source:
       repo_url: https://github.com/VKCOM/lighthouse/archive/refs/tags/v2.5.0.tar.gz
       version: v2.5.0
   ```

2. Запустите роль с тегом `config` (файлы будут обновлены):
   ```bash
   ansible-playbook playbook_lighthouse.yaml --tags config
   ```

3. При необходимости очистите кеш браузера или добавьте версию к статике.

## Требования

- **Ansible** ≥ 2.9
- **Целевая ОС**: Debian/Ubuntu (используется `apt`)
- **Доступ к интернету** для загрузки исходников (или подготовленный артефакт)
- **Порты**: 80 (HTTP) или настроенный `listen_port`

## Интеграция с vector-role

Данная роль предназначена для работы в паре с `vector-role`:

```
[Источники логов] → Vector → ClickHouse → Lighthouse (веб-интерфейс)
```

Убедитесь, что:
- Параметры подключения к ClickHouse в обеих ролях согласованы
- Сетевая доступность между хостами настроена корректно
- Пользователь ClickHouse имеет права на чтение целевых таблиц

## Лицензия

MIT

---

> **Примечание**: Роль развёртывает Lighthouse как статическое SPA-приложение. Все запросы к ClickHouse проксируются через nginx для обхода CORS-ограничений браузера. Для продакшена рекомендуется настроить TLS-терминацию и вынести аутентификацию на уровень API-gateway или Identity Provider.
