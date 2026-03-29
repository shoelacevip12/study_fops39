# Для домашнего задания 17.6 `Создание собственных модулей`
## commit_60, master Предварительная подготовка
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

# Удаление всех файлов и каталогов кроме каталога 08-ansible-06-module и его содержимого
find mnt-homeworks/ \
-mindepth 1 \
-not -path "*08-ansible-06-module*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 17_6
mv mnt-homeworks/08-ansible-06-module \
17_6

# Переход в каталог по последней переменной вывода последней команды (17_6)
cd !$

# создание каталогов под скриншоты
mkdir img
```
```
cd 17_6
```
```bash
# Удаление оставшейся оставшейся части клона репозитория
rm -rf \
../mnt-homeworks

# Просмотр текущих удаленных репозиториев
git remote -v

# Проверка текущего локального состояния репозитория
git status

git rm -r --cached \
../

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
git commit -am 'commit_60_1, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```
## commit_1, `17_6-ansible-modules`
```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 17_6-ansible-modules

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

git rm -r --cached \
./ ../

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit1, 17_6-ansible-modules' \
&& git push \
--set-upstream \
study_fops39 \
17_6-ansible-modules \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
17_6-ansible-modules
```
## commit_2, `17_6-ansible-modules`
```bash
# Ansible Release
wget https://github.com/ansible/ansible/archive/refs/tags/v2.20.4.tar.gz

# извлечение архива
tar -xvf v2.20.4.tar.gz

rm v2.20.4.tar.gz

# переименование папки
mv ansible{-2.20.4,}

cd ansible

# Создание виртуального окружения python
python3 -m venv venv

# Активация виртуального окружения
source venv/bin/activate

# Установка зависимостей
pip install -vr \
requirements.txt

# Запуск настройки окружения
source hacking/env-setup
```

<details>
<summary>Успешность установки окружения</summary>

```
Setting up Ansible to run out of checkout...

PATH=/home/shoel/nfs_git/gited/17_6/ansible/bin:/home/shoel/nfs_git/gited/17_6/ansible/venv/bin:/home/shoel/yandex-cloud/bin:/usr/lib/code-server/lib/vscode/bin/remote-cli:/home/shoel/yandex-cloud/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
PYTHONPATH=/home/shoel/nfs_git/gited/17_6/ansible/test/lib:/home/shoel/nfs_git/gited/17_6/ansible/lib
MANPATH=/home/shoel/nfs_git/gited/17_6/ansible/docs/man:/usr/local/man:/usr/local/share/man:/usr/share/man

Remember, you may wish to specify your host file with -i

Done!
```
</details>

```bash
# Выход из виртуального окружения
deactivate

# Запуск настроенного окружения для работы с модулями ansible
source venv/bin/activate \
&& source hacking/env-setup
```
### Модуль Ansible на основе шаблона
```bash
cat > lib/ansible/module/text_file.py <<'EOF'
#!/usr/bin/python

# GNU General Public License v3.0+

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: text_file

short_description: Создание текстового файла с указанным содержимым

version_added: "1.0.0"

description:
    - Создает текстовый файл на удаленном хосте. 
    - Если файл существует, он будет перезаписан только в том случае, если его содержимое отличается от исходного..

options:
    path:
        description:
            - Полный путь к файлу для создания.
        required: true
        type: str
    content:
        description:
            - Текстовое содержание для записи в файл.
        required: true
        type: str

author:
    - shoelacevip12@gmail.com
'''

EXAMPLES = r'''
- name: Create a text file
  text_file:
    path: /tmp/example.txt
    content: "Hello, Ansible!"
'''

RETURN = r'''
changed:
    description: Если файл создан или изменен.
    type: bool
    returned: always
path:
    description: Полный Путь к файлу.
    type: str
    returned: always
'''

import os
from ansible.module_utils.basic import AnsibleModule


def run_module():
    module_args = dict(
        path=dict(type='str', required=True),
        content=dict(type='str', required=True)
    )

    result = dict(
        changed=False,
        failed=False,
        path=''
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    path = module.params['path']
    content = module.params['content']

    result['path'] = path

    file_exists = os.path.exists(path)
    current_content = ''
 
    if file_exists:
        try:
            with open(path, 'r') as f:
                current_content = f.read()
        except Exception as e:
            module.fail_json(msg=f"Failed to read existing file: {e}", **result)

    if not file_exists or current_content != content:
        result['changed'] = True

        if module.check_mode:
            module.exit_json(**result)

        try:
            with open(path, 'w') as f:
                f.write(content)
        except Exception as e:
            module.fail_json(msg=f"Failed to write file: {e}", **result)

    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
EOF
```
### Тестирование модуля python
#### Самим python
```bash
# создание json с аргументами модуля
cat > payload.json <<'EOF'
{
    "ANSIBLE_MODULE_ARGS": {
        "path": "/tmp/test.txt",
        "content": "test1"
    }
}
EOF
```
```bash
# Вызов модуля python через json payload
python -m ansible.modules.text_file \
payload.json
```

<details>
<summary>Первый вывод запуска модуля</summary>

```json
{"changed": true, "failed": false, "path": "/tmp/test.txt", "uid": 1000, "gid": 1000, "owner": "shoel", "group": "shoel", "mode": "0644", "state": "file", "size": 5, "invocation": {"module_args": {"path": "/tmp/test.txt", "content": "test1"}}}
```

</details>

<details>
<summary>Второй вывод запуска модуля</summary>

```json
{"changed": false, "failed": false, "path": "/tmp/test.txt", "uid": 1000, "gid": 1000, "owner": "shoel", "group": "shoel", "mode": "0644", "state": "file", "size": 5, "invocation": {"module_args": {"path": "/tmp/test.txt", "content": "test1"}}}

echo "$(cat /tmp/test.txt)"
```
test1
```
```

</details>

#### Создание Тестового playbook
```bash
cat > playbook_test_module.yaml <<'EOF'
#!/usr/bin/env ansible-playbook
---
- name: Тестирование созданного модуля
  hosts: localhost
  become: false
  gather_facts: false
  tasks:
    - name: Создание файла с текстом
      text_file:
        path: /home/shoel/nfs_git/gited/17_6/test_play.txt
        content: |
          Разговор двух программистов:
          - Что пишешь?
          - Сейчас запустим - узнаем!
...
EOF

# Делаем исполняемым для использования #!(шебанг) 
chmod +x ./playbook_test_module.yaml 
```

#### Проверки playbook
```bash
./*.yaml --syntax-check
```
```
playbook: ./playbook_test_module.yaml
```
```bash
ansible-lint ./*.yaml
```

<details>
<summary>вывод об неудовлетворенных требованиях</summary>

```
fqcn[action-core]: Use FQCN for builtin module actions (text_file).
playbook_test_module.yaml:9:7 Use `ansible.builtin.text_file` or `ansible.legacy.text_file` instead.

Read documentation for instructions on how to ignore specific rule violations.

# Rule Violation Summary

  1 fqcn profile:production tags:formatting

Failed: 1 failure(s), 0 warning(s) in 1 files processed of 1 encountered. Last profile that met the validation criteria was 'shared'. Rating: 4/5 star
```

</details>

```bash
yamllint ./*.yaml
```

#### Запуск playbook с тестовым модулем
```bash
# ЗАпуск playbook
./playbook_test_module.yaml -v
```

<details>
<summary>Первый вывод запуска playbook</summary>

```json
No config file found; using defaults

PLAY [Тестирование созданного модуля] ******************************************************************************************

TASK [Создание файла с текстом] ************************************************************************************************
changed: [localhost] => {"changed": true, "gid": 100, "group": "100", "mode": "0777", "owner": "1024", "path": "/home/shoel/nfs_git/gited/17_6/test_play.txt", "size": 125, "state": "file", "uid": 1024}

PLAY RECAP *********************************************************************************************************************
localhost                  : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

</details>

```bash
# Вывод содержимого созданного файла
echo "$(cat ../test_play.txt)"
```
```
Разговор двух программистов:
- Что пишешь?
- Сейчас запустим - узнаем!
```

<details>
<summary>Второй вывод запуска playbook</summary>

```json
No config file found; using defaults

PLAY [Тестирование созданного модуля] ******************************************************************************************

TASK [Создание файла с текстом] ************************************************************************************************
ok: [localhost] => {"changed": false, "gid": 100, "group": "100", "mode": "0777", "owner": "1024", "path": "/home/shoel/nfs_git/gited/17_6/test_play.txt", "size": 125, "state": "file", "uid": 1024}

PLAY RECAP *********************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

</details>

### Инициализация новой collection
```bash
# выход из виртуального окружения
deactivate

# создание директории под коллекцию
mkdir ../ans_col

cd !$
```
```
cd ../ans_col
```

```bash
# инициализация коллекции
ansible-galaxy collection \
init \
shoelacevip12.test_text_file

cd shoelacevip12/test_text_file

# Создание каталога для модулей коллекции
mkdir plugins/modules

# Перенос созданного модуля в соответствующий каталог коллекции
mv ../../../ansible/lib/ansible/modules/text_file.py \
./plugins/modules/
```
### Создание роли внутри коллекции из одной task
```bash
# Создание роли text_file и ее базовой структуры 
mkdir -p roles/text_file/{defaults,tasks,meta,vars}

touch roles/text_file/README.md
```
#### Создание переменных по умолчанию 
```bash
cat > roles/text_file/defaults/main.yml <<'EOF'
---
text_file_path: /tmp/temp.txt
text_file_content: "Я здесь, за эту улицу стою!"
...
EOF
```
#### Описание единственной задачи
```bash
cat > roles/text_file/tasks/main.yml <<'EOF'
---
- name: Создание файла с текстом в /tmp
  text_file:
    path: "{{ text_file_path }}"
    content: "{{ text_file_content }}"
...
EOF
```

#### Создание playbook для роли
```bash
cat > playbook_to_tmp_example.yaml <<'EOF'
#!/usr/bin/env ansible-playbook
---
- name: Создание некоторого текстового файла
  hosts: localhost
  become: false
  gather_facts: false

  roles:
    - text_file
...
EOF
```

#### Проверки playbook с ролью
```bash
# Предварительно экспортируем переменную с расположением нового модуля
export ANSIBLE_LIBRARY=./plugins/modules

# для вывода информации в yaml формате
export ANSIBLE_CALLBACK_RESULT_FORMAT=yaml


./*.yaml --syntax-check
```
```
playbook: ./playbook_to_tmp_example.yaml
```
```bash
ansible-lint ./*.yaml
```

<details>
<summary>вывод об неудовлетворенных требованиях</summary>

```json
Passed: 0 failure(s), 0 warning(s) in 3 files processed of 3 encountered. Last profile that met the validation criteria was 'production'
```

</details>

```bash
yamllint ./*.yaml
```

#### Запуск playbook с тестовым модулем
```bash
# для вывода информации в yaml формате
export ANSIBLE_CALLBACK_RESULT_FORMAT=yaml

# ЗАпуск playbook
./playbook_to_tmp_example.yaml -v
```

<details>
<summary>Вывод работы playbook</summary>

```yaml
No config file found; using defaults

PLAY [Создание некоторого текстового файла] ************************************************************************************

TASK [text_file : Создание файла с текстом в /tmp] *****************************************************************************
changed: [localhost] => 
    changed: true
    gid: 1000
    group: shoel
    mode: '0644'
    owner: shoel
    path: /tmp/temp.txt
    size: 47
    state: file
    uid: 1000

PLAY RECAP *********************************************************************************************************************
localhost                  : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

</details>

```bash
# Вывод содержимого отработанного playbook
echo "$(cat /tmp/temp.txt)"
```
```
Я здесь, за эту улицу стою!
```
### Создание архива коллекции 
```bash
# создание архива из-под каталога коллекции shoelacevip12/test_text_file
ansible-galaxy collection build
```
```
Created collection for shoelacevip12.test_text_file at /home/shoel/nfs_git/gited/17_6/ans_col/shoelacevip12/test_text_file/shoelacevip12-test_text_file-0.1.0.tar.gz
```
### Создание каталога с тестовым play
```bash
# создание каталога для playbook теста модуля
mkdir ../../../single_play_test

cd !$
```
```
cd ../../../single_play_test
```
```bash
# Перенос тестового запроса json
mv ../ansible/payload.json ./

# Перенос тестового playbook
mv ../ansible/playbook_test_module.yaml ./

# Перенос архива роли
mv ../ans_col/shoelacevip12/test_text_file/shoelacevip12-test_text_file-0.1.0.tar.gz \
./

# Локальная установка созданной роли
ansible-galaxy collection \
install \
shoelacevip12-test_text_file-0.1.0.tar.gz
```

<details>
<summary>Вывод установки созданной роли</summary>

```bash
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Installing 'shoelacevip12.test_text_file:0.1.0' to '/home/shoel/.ansible/collections/ansible_collections/shoelacevip12/test_text_file'
shoelacevip12.test_text_file:0.1.0 was installed successfully
```

</details>

```bash
# изменение файла под работу с модулем установленной коллекции
sed -i 's/text_file:/shoelacevip12.test_text_file.text_file:/' \
./playbook_test_module.yaml
```

```bash
# ЗАпуск установки с установленными модулем коллекции
./playbook_test_module.yaml -v
```

<details>
<summary>Вывод работы Playbook с установленной ролью</summary>

```yaml
No config file found; using defaults
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Тестирование созданного модуля] ************************************************************************************************

TASK [Создание файла с текстом] ******************************************************************************************************
changed: [localhost] => 
    changed: true
    gid: 100
    group: '100'
    mode: '0777'
    owner: '1024'
    path: /home/shoel/nfs_git/gited/17_6/test_play.txt
    size: 125
    state: file
    uid: 1024

PLAY RECAP ***************************************************************************************************************************
localhost                  : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

</details>

```bash
# Вывод содержимого созданного файла
echo "$(cat ../test_play.txt)"
```
```
Разговор двух программистов:
- Что пишешь?
- Сейчас запустим - узнаем!
```
```bash
cd ..

# Удаление ansible каталога и созданного окружения venv
rm -rf ansible


# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 17_6-ansible-modules

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

git rm -r --cached \
./ ../

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 17_6-ansible-modules' \
&& git push \
--set-upstream \
study_fops39 \
17_6-ansible-modules \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
17_6-ansible-modules
```