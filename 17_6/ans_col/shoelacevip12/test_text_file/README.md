# Ansible Collection: shoelacevip12.test_text_file

Данная коллекция предназначена для демонстрации создания модулей и ролей в Ansible. Основной функционал заключается в управлении текстовыми файлами на удаленных хостах.

## Состав коллекции

Коллекция содержит:
- **Модуль `text_file`**: Позволяет создавать текстовый файл с заданным содержимым.
- **Роль `text_file`**: Обертка над одноименным модулем с предустановленными значениями по умолчанию.

---

## Установка

### Из локального архива
Если у вас есть файл `.tar.gz`, созданный с помощью `ansible-galaxy collection build`:
```bash
ansible-galaxy collection install shoelacevip12-test_text_file-0.1.0.tar.gz
```

### Из репозитория GitHub 
```bash
ansible-galaxy collection install git+https://github.com/shoelacevip12/ansib_collec_skv.git
```

---

## Использование

### 1. Использование модуля `shoelacevip12.test_text_file.text_file`

Модуль принимает два обязательных параметра: путь к файлу и его содержимое.

**Пример в playbook:**
```yaml
- name: Тестирование созданного модуля
  hosts: localhost
  tasks:
    - name: Создание файла с текстом
      shoelacevip12.test_text_file.text_file:
        path: /tmp/example.txt
        content: |
          Привет!
          Это тестовое содержимое файла.
```

#### Параметры модуля:
| Параметр | Тип | Обязателен | Описание |
| :--- | :--- | :---: | :--- |
| `path` | `str` | Да | Полный путь к файлу для создания. |
| `content` | `str` | Да | Текстовое содержание для записи в файл. |

#### Возвращаемые значения:
- `changed`: `bool` — `true`, если файл был создан или изменен.
- `path`: `str` — путь к созданному файлу.

---

### 2. Использование роли `shoelacevip12.test_text_file.text_file`

Роль позволяет быстро создать файл, используя переменные по умолчанию.

**Пример в playbook:**
```yaml
- name: Использование роли для создания файла
  hosts: localhost
  roles:
    - shoelacevip12.test_text_file.text_file
```

#### Переменные роли (Defaults):
Вы можете переопределить эти переменные в вашем playbook или `group_vars`:

| Переменная | Значение по умолчанию | Описание |
| :--- | :--- | :--- |
| `text_file_path` | `/tmp/temp.txt` | Путь к файлу. |
| `text_file_content` | `"Я здесь, за эту улицу стою!"` | Содержимое файла. |

**Пример переопределения переменных:**
```yaml
- name: Таска с Ролью
  hosts: localhost
  vars:
    text_file_path: "/tmp/custom_role_file.txt"
    text_file_content: "текст через роль"
  roles:
    - shoelacevip12.test_text_file.text_file
```

---

## Разработка и тестирование

### Тестирование модуля через Python
Модуль можно протестировать напрямую, передав JSON-файл с аргументами:
```bash
# Создание payload.json
echo '{"ANSIBLE_MODULE_ARGS": {"path": "/tmp/test.txt", "content": "test1"}}' > payload.json

# Запуск в окружении Ansible
python -m ansible.modules.text_file payload.json
```

### Проверка качества кода
Для проверки синтаксиса и соответствия стандартам используются:
- `ansible-lint` — проверка стиля Playbook и модулей.
- `yamllint` — проверка синтаксиса YAML файлов.

---

## Лицензия
Данный проект распространяется под лицензией **GNU General Public License v3.0+**.

**Автор:** `shoelacevip12@gmail.com`

---