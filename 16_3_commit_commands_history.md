# Для домашнего задания 16.3 `Управляющие конструкции в коде Terraform`
## commit_54, master Предварительная подготовка
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
https://github.com/netology-code/ter-homeworks.git

# Удаление всех файлов и каталогов кроме каталога 03 и его содержимого
find ter-homeworks/ \
-mindepth 1 \
-not -path "*03*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 16_3
mv ter-homeworks/03 16_3

# Переход в каталог по последней переменной вывода последней команды (16_3)
cd !$

# создание каталогов под скриншоты
mkdir img

# Подготовка отчета для сдачи
mv {hw-03,README}.md
```
```
cd 16_3
```
```bash
# Удаление оставшейся оставшейся части клона репозитория
rm -rf \
../ter-homeworks

# Просмотр текущих удаленных репозиториев
git remote -v

# Проверка текущего локального состояния репозитория
git status

git remote -v

# Просмотр различий в рабочей директории и индексов
git diff \
&& git diff --staged

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . \
&& git status
```
```
Текущая ветка: master
Эта ветка соответствует «study_fops39_gitflic_ru/master».

Изменения, которые будут включены в коммит:
  (используйте «git restore --staged <файл>...», чтобы убрать из индекса)
        новый файл:    demo/.gitignore
        ...
        новый файл:    src/variables.tf

Неотслеживаемые файлы:
  (используйте «git add <файл>...», чтобы добавить в то, что будет включено в коммит)
        ../16_3_commit_commands_history.md
```
```bash
git diff \
&& git diff --staged

# Просмотр истории коммитов в кратком формате
git log --oneline

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий
git commit -am 'commit_54, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```
## commit_1, `16_3-terr_construct`
```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 16_3-terr_construct

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . ../16_3_commit_commands_history.md \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am '16_3-terr_construct' \
&& git push \
--set-upstream \
study_fops39 \
16_3-terr_construct \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
16_3-terr_construct
```
## commit_2, `16_3-terr_construct`
```bash
# Дислокация кода для работы в репозитории
cd src

# Смена требований к версии terraform c 1.12.X, на 1.X
sed -i 's/1.12.0/1.12/' \
providers.tf

# Добавление переменных значений default к переменным cloud_id и folder_id
sed -i '/\/cloud\/get-id"/a\
  default     = "'"$YC_CLOUD_ID"'"
' variables.tf

sed -i '/\/folder\/get-id"/a\
  default     = "'"$YC_FOLDER_ID"'"
' variables.tf


# Проверка наличия файла авторизации
file ~/.authorized_key.json
```
```
/home/shoel/.authorized_key.json: JSON text data
```
```bash
# вывод о конфигурации работы с YC
yc config list
```
```
service-account-key:
  id: ajexxxxxxxxxxxx7o215
  service_account_id: ajexxxxxxxxxxxx3micr
  created_at: "2026-03-10T19:16:05.289441568Z"
  key_algorithm: RSA_2048
  public_key: |
    -----BEGIN PUBLIC KEY-----

    -----END PUBLIC KEY-----
  private_key: |
    PLEASE DO NOT REMOVE THIS LINE! Yandex.Cloud SA Key ID <ajexxxxxxxxxxxx7o215>
    -----BEGIN PRIVATE KEY-----

    -----END PRIVATE KEY-----
cloud-id: b1gkumrn87pei2831blp
folder-id: b1g7qviodfc9v4k81sr5
compute-default-zone: ru-central1-a
```

```bash
# замена авторизации по token на файл авторизации сервисного аккаунта
sed -i 's|token     = var.token|service_account_key_file = file("~/.authorized_key.json")|' \
providers.tf

# Удаление в variable.tf переменной token
# Где:
# /variable "token" {/ - находит начало блока
# ,/^}/ - указывает диапазон до строки, содержащей только закрывающую фигурную скобку }
sed -i '/variable "token" {/,/^}/d' \
variables.tf
```

```bash
# Инициализация Terraform конфигурации и авто-форматирование конфигов работы
terraform init \
&& terraform validate \
&& terraform fmt
```
```
Initializing the backend...
Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.191.0
...
Terraform has been successfully initialized!
...
Success! The configuration is valid.

providers.tf
security.tf
```
```bash
# создание файла плана запуска terraform
terraform plan -out=tfplan
```
```
# yandex_vpc_network.develop will be created
...
# yandex_vpc_security_group.example will be created
...
# yandex_vpc_subnet.develop will be created
...
Plan: 3 to add, 0 to change, 0 to destroy.
```
```bash
# Применение файла запуска terraform
terraform apply "tfplan"
```
```
yandex_vpc_network.develop: Creating...
yandex_vpc_network.develop: Creation complete after 2s [id=enpkp07cuvrvmcgjsiln]
yandex_vpc_subnet.develop: Creating...
yandex_vpc_security_group.example: Creating...
yandex_vpc_subnet.develop: Creation complete after 0s [id=e9br1c8fes5avhndifp2]
yandex_vpc_security_group.example: Creation complete after 2s [id=enp6b9a4ei2uuuu2s937]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```
```bash
cd ..

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . ../16_3_commit_commands_history.md \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am '16_3-terr_construct_3' \
&& git push \
--set-upstream \
study_fops39 \
16_3-terr_construct \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
16_3-terr_construct
```
## commit_3, `16_3-terr_construct`
```bash
cd -


```