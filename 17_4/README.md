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

---

[перменные по умолчанию роли vector](roles/vector-role/defaults)



---
5. Перенести нужные шаблоны конфигов в `templates`.
---

[шаблоны роли vector](roles/vector-role/templates/)

---
6. Опишите в `README.md` обе роли и их параметры. Пример качественной документации ansible role [по ссылке](https://github.com/cloudalchemy/ansible-prometheus).

---

[Описание созданной роли Vector Datadog](roles/vector-role/README.md)

---

7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.

---

[переменные по умолчанию роли lighthouse](roles/lighthouse-role/defaults)

[шаблоны роли lighthouse](roles/lighthouse-role/templates/)

[Описание созданной роли lighthouse](roles/lighthouse-role/README.md)

---

8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.

[Отдельный репозиторий роли vector](https://github.com/shoelacevip12/vector-role)

[Отдельный репозиторий роли lighthouse](https://github.com/shoelacevip12/lighthouse-role)

```bash
cat > requirements.yml <<'EOF'
---
  - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
    scm: git
    version: "1.13"
    name: clickhouse

  - src: git@github.com:shoelacevip12/vector-role.git
    scm: git
    # version: "v0.1"
    name: vector-role

  - src: git@github.com:shoelacevip12/lighthouse-role.git
    scm: git
    # version: "v0.1"
    name: lighthouse-role
EOF
```

9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.

### Создание общего playbook для вызова ролей
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
### Создание playbook для роли clickhouse
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
### Создание playbook для роли vector
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

10. Выложите playbook в репозиторий.

[ГЛАВНЫЙ playbook](https://github.com/shoelacevip12/study_fops39/blob/17_4-ansible_role/17_4/playbook_main.yaml)

[playbook clickhouse](https://github.com/shoelacevip12/study_fops39/blob/17_4-ansible_role/17_4/playbook_clickhouse.yaml)

[playbook vector](https://github.com/shoelacevip12/study_fops39/blob/17_4-ansible_role/17_4/playbook_vector.yaml)

[playbook lighthouse](https://github.com/shoelacevip12/study_fops39/blob/17_4-ansible_role/17_4/playbook_lighthouse.yaml)

[Общий проект ansible](https://github.com/shoelacevip12/study_fops39/tree/17_4-ansible_role/17_4)

11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
