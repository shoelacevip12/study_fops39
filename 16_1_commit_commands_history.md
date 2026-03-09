# Для домашнего задания 16.1
## commit_49, master Предварительная подготовка
```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master

# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/ter-homeworks.git

# Удаление всех файлов и каталогов кроме каталога 01 и его содержимого
find ter-homeworks/ \
-mindepth 1 \
-not -path "*01*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 16_1
mv ter-homeworks/01 16_1

# Переход в каталог по последней переменной вывода последней команды (16_1)
cd !$

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
git add . .. \
&& git status

git diff \
&& git diff --staged

# Просмотр истории коммитов в кратком формате
git log --oneline

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий
git commit -am 'commit_49, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```
## commit_50, `cours_fops39_2025` Подготовка 
### для archlinux установка terraform
```bash
# Установка из репозитория archlinux
sudo pacman \
-Syu \
terraform
```
```bash
terraform -v
```
```
Terraform v1.14.6
on linux_amd64
```
### для altlinux установка terraform
```bash
# вход под суперпользователем
su -

# Скрипт установки последнего доступного terraform с зеркала yandex cloud
cat > terraform_for_altlinux.sh <<'EOF'
#!/bin/bash -x

# CREATED:
# vitaliy.natarov@yahoo.com
# Unix/Linux blog:
# http://linux-notes.org
# Vitaliy Natarov

# RECREATED:
# ArtamonovKA
# For AltLinux

#MODED:
#17.12.25
#Shoelacevip12
#For AltLinux p11 workstation

function install_terraform () {
        #
        if [ -f /etc/altlinux-release ] || [ -f /etc/redhat-release ] ; then
                #update OS
                apt-get update &> /dev/null -y && apt-get dist-upgrade &> /dev/null -y
                #
                if ! type -path "wget" > /dev/null 2>&1; then apt-get install wget &> /dev/null -y; fi
                if ! type -path "curl" > /dev/null 2>&1; then apt-get install curl &> /dev/null -y; fi
                if ! type -path "unzip" > /dev/null 2>&1; then apt-get install unzip &> /dev/null -y; fi
        OS=$(lsb_release -ds|cut -d '"' -f2|awk '{print $1}')
        OS_MAJOR_VERSION=$(sed -rn 's/.*([0-9]).[0-9].*/\1/p' /etc/redhat-release)
                OS_MINOR_VERSION=$(cat /etc/redhat-release | cut -d"." -f2| cut -d " " -f1)
                Bit_OS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
                echo "$OS-$OS_MAJOR_VERSION.$OS_MINOR_VERSION with $Bit_OS bit arch"
                #
                site="https://hashicorp-releases.yandexcloud.net/terraform/"
        Latest_terraform_version=$(curl -s "$site" --list-only | grep -E "terraform_" | grep -Ev "beta|alpha" | head -n1| cut -d ">" -f2| cut -d "<" -f1 | cut -d"_" -f2)
        URL_with_latest_terraform_package=$site$Latest_terraform_version
                #
                if [ "`uname -m`" == "x86_64" ]; then
                        Latest_terraform_package=$(curl -s "$URL_with_latest_terraform_package/" --list-only |grep -E "terraform_" | grep -E "linux_amd64"|cut -d ">" -f2| cut -d "<" -f1)
                        Current_link_to_archive=$URL_with_latest_terraform_package/$Latest_terraform_package
                elif [ "`uname -m`" == "i386|i686" ]; then
                        Latest_terraform_package=$(curl -s "$URL_with_latest_terraform_package/" --list-only |grep -E "terraform_" | grep -Ev "(SHA256SUMS|windows)"| grep -E "linux_386"|cut -d ">" -f2| cut -d "<" -f1)
                        Current_link_to_archive=$URL_with_latest_terraform_package/$Latest_terraform_package
                fi
                echo $Current_link_to_archive
                mkdir -p /usr/local/src/ && cd /usr/local/src/ && wget $Current_link_to_archive &> /dev/null
                unzip -o $Latest_terraform_package
                rm -rf /usr/local/src/$Latest_terraform_package*
                yes|mv -f /usr/local/src/terraform /usr/local/bin/terraform
                chmod +x /usr/local/bin/terraform
        else
        OS=$(uname -s)
        VER=$(uname -r)
        echo 'OS=' $OS 'VER=' $VER
        fi
}
install_terraform
echo "========================================================================================================";
echo "================================================FINISHED================================================";
echo "========================================================================================================";
terraform -version
EOF
```
```bash
# Делаем скрипт исполняемым
chmod +x terraform_for_altlinux.sh

# Запуск скрипта установки
./terraform_for_altlinux.sh
```
```
+ install_terraform
+ '[' -f /etc/altlinux-release ']'
+ apt-get update -y
+ apt-get dist-upgrade -y
+ type -path wget
+ type -path curl
+ type -path unzip
++ lsb_release -ds
++ cut -d '"' -f2
++ awk '{print $1}'
./terraform_for_altlinux.sh: line 27: lsb_release: command not found
+ OS=
++ sed -rn 's/.*([0-9]).[0-9].*/\1/p' /etc/redhat-release
+ OS_MAJOR_VERSION=1
++ cat /etc/redhat-release
++ cut -d. -f2
++ cut -d ' ' -f1
+ OS_MINOR_VERSION=1
++ uname -m
++ sed 's/x86_//;s/i[3-6]86/32/'
+ Bit_OS=64
+ echo '-1.1 with 64 bit arch'
-1.1 with 64 bit arch
+ site=https://hashicorp-releases.yandexcloud.net/terraform/
++ curl -s https://hashicorp-releases.yandexcloud.net/terraform/ --list-only
++ grep -E terraform_
++ grep -Ev 'beta|alpha'
++ head -n1
++ cut -d '>' -f2
++ cut -d '<' -f1
++ cut -d_ -f2
+ Latest_terraform_version=1.14.6
+ URL_with_latest_terraform_package=https://hashicorp-releases.yandexcloud.net/terraform/1.14.6
++ uname -m
+ '[' x86_64 == x86_64 ']'
++ curl -s https://hashicorp-releases.yandexcloud.net/terraform/1.14.6/ --list-only
++ grep -E terraform_
++ grep -E linux_amd64
++ cut -d '>' -f2
++ cut -d '<' -f1
+ Latest_terraform_package=terraform_1.14.6_linux_amd64.zip
+ Current_link_to_archive=https://hashicorp-releases.yandexcloud.net/terraform/1.14.6/terraform_1.14.6_linux_amd64.zip
+ echo https://hashicorp-releases.yandexcloud.net/terraform/1.14.6/terraform_1.14.6_linux_amd64.zip
https://hashicorp-releases.yandexcloud.net/terraform/1.14.6/terraform_1.14.6_linux_amd64.zip
+ mkdir -p /usr/local/src/
+ cd /usr/local/src/
+ wget https://hashicorp-releases.yandexcloud.net/terraform/1.14.6/terraform_1.14.6_linux_amd64.zip
+ unzip -o terraform_1.14.6_linux_amd64.zip
Archive:  terraform_1.14.6_linux_amd64.zip
  inflating: LICENSE.txt             
  inflating: terraform               
+ rm -rf /usr/local/src/terraform_1.14.6_linux_amd64.zip
+ yes
+ mv -f /usr/local/src/terraform /usr/local/bin/terraform
+ chmod +x /usr/local/bin/terraform
+ echo ========================================================================================================
========================================================================================================
+ echo ================================================FINISHED================================================
================================================FINISHED================================================
+ echo ========================================================================================================
========================================================================================================
+ terraform -version
Terraform v1.14.6
on linux_amd64
```
```bash
# Проверка текущего локального состояния репозитория
git status

git remote -v

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
git commit -am 'commit_50, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```
## commit_1, `16_1-terr_vved`
```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 16_1-terr_vved

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am '16_1-terr_vved' \
&& git push \
--set-upstream \
study_fops39 \
16_1-terr_vved \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
16_1-terr_vved
```
## commit_2, `16_1-terr_vved`
```bash
# Переименование файла описания
mv {hw-01,README}.md

# переход в каталог с домашним Примером
cd src

# вывод версии terraform программы на устройстве
terraform -v
```
```
Terraform v1.14.6
on linux_amd64
```
```bash
# Смена требований к версии terraform c 1.2.X, на 1.X
sed -i 's/1.12.0/1.12/' \
main.tf

# Инициализация Terraform конфигурации в root каталоге проекта
terraform init
```
```
Initializing the backend...
Initializing provider plugins...
- Finding latest version of kreuzwerker/docker...
- Finding latest version of hashicorp/random...
- Installing kreuzwerker/docker v3.6.2...
- Installed kreuzwerker/docker v3.6.2 (unauthenticated)
- Installing hashicorp/random v3.8.1...
- Installed hashicorp/random v3.8.1 (unauthenticated)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

╷
│ Warning: Incomplete lock file information for providers
│ 
│ Due to your customized provider installation methods, Terraform was forced to calculate lock file checksums locally for the following providers:
│   - hashicorp/random
│   - kreuzwerker/docker
│ 
│ The current .terraform.lock.hcl file only includes checksums for linux_amd64, so Terraform running on another platform will fail to install these providers.
│ 
│ To calculate additional checksums for another platform, run:
│   terraform providers lock -platform=linux_amd64
│ (where linux_amd64 is the platform to generate)
╵
Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
```bash
# Проверка tf файлов проекта и создание файла запуска terraform
terraform init --upgrade \
&& terraform validate \
&& terraform fmt \
&& terraform plan -out=tfplan
```
```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_password.random_string will be created
  + resource "random_password" "random_string" {
      + bcrypt_hash = (sensitive value)
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 1
      + min_numeric = 1
      + min_special = 0
      + min_upper   = 1
      + number      = true
      + numeric     = true
      + result      = (sensitive value)
      + special     = false
      + upper       = true
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"
```
```bash
# Применение файла запуска terraform
terraform apply "tfplan"
```
```
random_password.random_string: Creating...
random_password.random_string: Creation complete after 0s [id=none]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
```bash
# Вывод результата типа блока ресурса random_password
grep -A22 \
random_password \
terraform.tfstate \
| grep -E \
'name|bcrypt_hash|result'
```
```
      "name": "random_string",
            "bcrypt_hash": "$2a$10$1HntMyTlfI8WRvYLQogxkuYVn8fBKWHNvqP2oeQTwlUpr8ULpv8Ka",
            "result": "gV6HGYIKvmW0CZgG",
```
```bash
# Запуск службы докер в системе
sudo systemctl \
start \
docker

# Удаление знаков многострочных комментариев tf после 20 строки файла main.tf
sed -i '20,$ { s|/\*||g; s|\*/||g }' \
main.tf

# Проверка tf файлов проекта
terraform validate
```
```
╷
│ Error: Missing name for resource
│ 
│   on main.tf line 23, in resource "docker_image":
│   23: resource "docker_image" {
│ 
│ All resource blocks must have 2 labels (type, name).
╵
╷
│ Error: Invalid resource name
│ 
│   on main.tf line 28, in resource "docker_container" "1nginx":
│   28: resource "docker_container" "1nginx" {
│ 
│ A name must start with a letter or underscore and may contain only letters, digits, underscores, and dashes.
```
```bash
# Добавление label name ресурсу "docker_image"
sed -i 's|ge" {|ge" "nginx" {|' \
main.tf

# исправляем HCL синтаксис name Должен начинаться с буквы или нижнего подчеркивания 
sed -i 's/1ng/n1g/' \
main.tf

# Исправление ошибок обращения к наименованию ресурса "random_password" и HCL синтаксис обращению к выводу аттрибута result 
sed -i 's|_FAKE.resulT|.result|' \
main.tf


# Проверка tf файлов проекта
terraform validate
```
```
Success! The configuration is valid.
```
```bash
# Проверка tf файлов проекта и создание файла запуска terraform
terraform init --upgrade \
&& terraform validate \
&& terraform fmt \
&& terraform plan -out=tfplan
```
```
Initializing the backend...
Initializing provider plugins...
- Finding latest version of kreuzwerker/docker...
- Finding latest version of hashicorp/random...
- Using previously-installed kreuzwerker/docker v3.6.2
- Using previously-installed hashicorp/random v3.8.1

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Success! The configuration is valid.

random_password.random_string: Refreshing state... [id=none]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # docker_container.n1ginx will be created
  + resource "docker_container" "n1ginx" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (known after apply)
      + exit_code                                   = (known after apply)
      + hostname                                    = (known after apply)
      + id                                          = (known after apply)
      + image                                       = (known after apply)
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + must_run                                    = true
      + name                                        = (sensitive value)
      + network_data                                = (known after apply)
      + network_mode                                = "bridge"
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "no"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + healthcheck (known after apply)

      + labels (known after apply)

      + ports {
          + external = 9090
          + internal = 80
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }
    }

  # docker_image.nginx will be created
  + resource "docker_image" "nginx" {
      + id           = (known after apply)
      + image_id     = (known after apply)
      + keep_locally = true
      + name         = "nginx:latest"
      + repo_digest  = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"
```
```bash
# Применение файла запуска terraform
terraform apply "tfplan"
```
```
docker_image.nginx: Creating...
docker_image.nginx: Still creating... [00m10s elapsed]
docker_image.nginx: Creation complete after 13s [id=sha256:fd204fe2f75024354b1f979d38cc43def9e049cc2df1cda45074d1b84c4f9b3enginx:latest]
docker_container.n1ginx: Creating...
docker_container.n1ginx: Creation complete after 0s [id=0edfa19878901c80eae6931a4d01bb7638b155cbc9136badb508a49bdb1f5561]
```
```bash
# вывод созданного docker контейнера
docker ps -a
```
```
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
0edfa1987890   fd204fe2f750   "/docker-entrypoint.…"   7 seconds ago   Up 6 seconds   0.0.0.0:9090->80/tcp   example_gV6HGYIKvmW0CZgG
```
```bash
# Замена замена идентификатора name в блоке ресурса "docker_container" для смены имени контейнера
sed -i 's|"example_${[^}]*}"$|"hello_world"|g' \
main.tf

# Автоматическое подтверждение внесенных изменений
terraform validate \
&& terraform apply \
-auto-approve
```
```
Success! The configuration is valid.

random_password.random_string: Refreshing state... [id=none]
docker_image.nginx: Refreshing state... [id=sha256:fd204fe2f75024354b1f979d38cc43def9e049cc2df1cda45074d1b84c4f9b3enginx:latest]
docker_container.n1ginx: Refreshing state... [id=0edfa19878901c80eae6931a4d01bb7638b155cbc9136badb508a49bdb1f5561]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # docker_container.n1ginx must be replaced
-/+ resource "docker_container" "n1ginx" {
      + bridge                                      = (known after apply)
      ~ command                                     = [
          - "nginx",
          - "-g",
          - "daemon off;",
        ] -> (known after apply)
      + container_logs                              = (known after apply)
      - cpu_shares                                  = 0 -> null
      - dns                                         = [] -> null
      - dns_opts                                    = [] -> null
      - dns_search                                  = [] -> null
      ~ entrypoint                                  = [
          - "/docker-entrypoint.sh",
        ] -> (known after apply)
      ~ env                                         = [] -> (known after apply)
      + exit_code                                   = (known after apply)
      - group_add                                   = [] -> null
      ~ hostname                                    = "0edfa1987890" -> (known after apply)
      ~ id                                          = "0edfa19878901c80eae6931a4d01bb7638b155cbc9136badb508a49bdb1f5561" -> (known after apply)
      ~ init                                        = false -> (known after apply)
      ~ ipc_mode                                    = "private" -> (known after apply)
      ~ log_driver                                  = "json-file" -> (known after apply)
      - log_opts                                    = {} -> null
      - max_retry_count                             = 0 -> null
      - memory                                      = 0 -> null
      - memory_swap                                 = 0 -> null
      # Warning: this attribute value will no longer be marked as sensitive
      # after applying this change.
      ~ name                                        = (sensitive value) # forces replacement
      ~ network_data                                = [
          - {
              - gateway                   = "172.17.0.1"
              - global_ipv6_prefix_length = 0
              - ip_address                = "172.17.0.2"
              - ip_prefix_length          = 16
              - mac_address               = "9e:4a:30:fd:2b:c6"
              - network_name              = "bridge"
                # (2 unchanged attributes hidden)
            },
        ] -> (known after apply)
      - privileged                                  = false -> null
      - publish_all_ports                           = false -> null
      ~ runtime                                     = "runc" -> (known after apply)
      ~ security_opts                               = [] -> (known after apply)
      ~ shm_size                                    = 64 -> (known after apply)
      ~ stop_signal                                 = "SIGQUIT" -> (known after apply)
      ~ stop_timeout                                = 0 -> (known after apply)
      - storage_opts                                = {} -> null
      - sysctls                                     = {} -> null
      - tmpfs                                       = {} -> null
        # (21 unchanged attributes hidden)

      ~ healthcheck (known after apply)

      ~ labels (known after apply)

        # (1 unchanged block hidden)
    }

Plan: 1 to add, 0 to change, 1 to destroy.
docker_container.n1ginx: Destroying... [id=0edfa19878901c80eae6931a4d01bb7638b155cbc9136badb508a49bdb1f5561]
docker_container.n1ginx: Destruction complete after 0s
docker_container.n1ginx: Creating...
docker_container.n1ginx: Creation complete after 0s [id=470be3b8812fb5d871bb3a20b3426113c0e5817202c087cea7e8a419d36bd30b]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
```
```bash
# вывод созданного docker контейнера
docker ps -a
```
```
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                  NAMES
470be3b8812f   fd204fe2f750   "/docker-entrypoint.…"   59 seconds ago   Up 58 seconds   0.0.0.0:9090->80/tcp   hello_world
```
```bash
# Уничтожение проекта
terraform destroy
```
```
random_password.random_string: Refreshing state... [id=none]
docker_image.nginx: Refreshing state... [id=sha256:fd204fe2f75024354b1f979d38cc43def9e049cc2df1cda45074d1b84c4f9b3enginx:latest]
docker_container.n1ginx: Refreshing state... [id=470be3b8812fb5d871bb3a20b3426113c0e5817202c087cea7e8a419d36bd30b]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # docker_container.n1ginx will be destroyed
  - resource "docker_container" "n1ginx" {
      - attach                                      = false -> null
      - command                                     = [
          - "nginx",
          - "-g",
          - "daemon off;",
        ] -> null
      - container_read_refresh_timeout_milliseconds = 15000 -> null
      - cpu_shares                                  = 0 -> null
      - dns                                         = [] -> null
      - dns_opts                                    = [] -> null
      - dns_search                                  = [] -> null
      - entrypoint                                  = [
          - "/docker-entrypoint.sh",
        ] -> null
      - env                                         = [] -> null
      - group_add                                   = [] -> null
      - hostname                                    = "470be3b8812f" -> null
      - id                                          = "470be3b8812fb5d871bb3a20b3426113c0e5817202c087cea7e8a419d36bd30b" -> null
      - image                                       = "sha256:fd204fe2f75024354b1f979d38cc43def9e049cc2df1cda45074d1b84c4f9b3e" -> null
      - init                                        = false -> null
      - ipc_mode                                    = "private" -> null
      - log_driver                                  = "json-file" -> null
      - log_opts                                    = {} -> null
      - logs                                        = false -> null
      - max_retry_count                             = 0 -> null
      - memory                                      = 0 -> null
      - memory_swap                                 = 0 -> null
      - must_run                                    = true -> null
      - name                                        = "hello_world" -> null
      - network_data                                = [
          - {
              - gateway                   = "172.17.0.1"
              - global_ipv6_prefix_length = 0
              - ip_address                = "172.17.0.2"
              - ip_prefix_length          = 16
              - mac_address               = "c6:a1:a9:be:5f:32"
              - network_name              = "bridge"
                # (2 unchanged attributes hidden)
            },
        ] -> null
      - network_mode                                = "bridge" -> null
      - privileged                                  = false -> null
      - publish_all_ports                           = false -> null
      - read_only                                   = false -> null
      - remove_volumes                              = true -> null
      - restart                                     = "no" -> null
      - rm                                          = false -> null
      - runtime                                     = "runc" -> null
      - security_opts                               = [] -> null
      - shm_size                                    = 64 -> null
      - start                                       = true -> null
      - stdin_open                                  = false -> null
      - stop_signal                                 = "SIGQUIT" -> null
      - stop_timeout                                = 0 -> null
      - storage_opts                                = {} -> null
      - sysctls                                     = {} -> null
      - tmpfs                                       = {} -> null
      - tty                                         = false -> null
      - wait                                        = false -> null
      - wait_timeout                                = 60 -> null
        # (7 unchanged attributes hidden)

      - ports {
          - external = 9090 -> null
          - internal = 80 -> null
          - ip       = "0.0.0.0" -> null
          - protocol = "tcp" -> null
        }
    }

  # docker_image.nginx will be destroyed
  - resource "docker_image" "nginx" {
      - id           = "sha256:fd204fe2f75024354b1f979d38cc43def9e049cc2df1cda45074d1b84c4f9b3enginx:latest" -> null
      - image_id     = "sha256:fd204fe2f75024354b1f979d38cc43def9e049cc2df1cda45074d1b84c4f9b3e" -> null
      - keep_locally = true -> null
      - name         = "nginx:latest" -> null
      - repo_digest  = "nginx@sha256:0236ee02dcbce00b9bd83e0f5fbc51069e7e1161bd59d99885b3ae1734f3392e" -> null
    }

  # random_password.random_string will be destroyed
  - resource "random_password" "random_string" {
      - bcrypt_hash = (sensitive value) -> null
      - id          = "none" -> null
      - length      = 16 -> null
      - lower       = true -> null
      - min_lower   = 1 -> null
      - min_numeric = 1 -> null
      - min_special = 0 -> null
      - min_upper   = 1 -> null
      - number      = true -> null
      - numeric     = true -> null
      - result      = (sensitive value) -> null
      - special     = false -> null
      - upper       = true -> null
    }

Plan: 0 to add, 0 to change, 3 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

random_password.random_string: Destroying... [id=none]
random_password.random_string: Destruction complete after 0s
docker_container.n1ginx: Destroying... [id=470be3b8812fb5d871bb3a20b3426113c0e5817202c087cea7e8a419d36bd30b]
docker_container.n1ginx: Destruction complete after 0s
docker_image.nginx: Destroying... [id=sha256:fd204fe2f75024354b1f979d38cc43def9e049cc2df1cda45074d1b84c4f9b3enginx:latest]
docker_image.nginx: Destruction complete after 0s

Destroy complete! Resources: 3 destroyed.
```
```bash
# Вывод состояния проекта tf
cat terraform.tfstate
```
```
{
  "version": 4,
  "terraform_version": "1.14.6",
  "serial": 12,
  "lineage": "0f8010ce-138c-ccb6-98cf-1f29524c8949",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```
```bash
cd ..

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am '16_1-terr_vved_1' \
&& git push \
--set-upstream \
study_fops39 \
16_1-terr_vved \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
16_1-terr_vved
```
## commit_3, `16_1-terr_vved` Задание 2*
### Подготовка. Создание пары ключей ssh
```bash
# Каталог для 2ого здания
mkdir tf_2 

cd !$

# генерация ключа ssh для подключения
ssh-keygen -f \
~/.ssh/id_lab16_1_fops39_ed25519 \
-t ed25519 -C "lab16_1_fops39"
```
```
Generating public/private ed25519 key pair.
Enter passphrase for "/home/shoel/.ssh/id_lab16_1_fops39_ed25519" (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/shoel/.ssh/id_lab16_1_fops39_ed25519
Your public key has been saved in /home/shoel/.ssh/id_lab16_1_fops39_ed25519.pub
The key fingerprint is:
SHA256: ----------------------------- lab16_1_fops39
The key's randomart image is:
+--[ED25519 256]--+
|              o6o|
|              .po|
|            + E.=|
|         . o X.@+|
|         S +o.@.O|
|           o.o.@*|
|           .o .+=|
|          .*.o ..|
|          *==.o. |
+----[SHA256]-----+
```
```bash
# Выставление прав на пару ключей
chmod 600 ~/.ssh/id_lab16_1_fops39_ed25519
chmod 644 ~/.ssh/id_lab16_1_fops39_ed25519.pub

# включаем агента-ssh
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_lab16_1_fops39_ed25519
```
### Подготовка для работы с yandex cloud
```bash
# Скачиваем скрипт для установки yandex console
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh \
| bash
```
```
Downloading yc 0.198.0
  % Total    % Received % Xferd  Average Speed  Time    Time    Time   Current
                                 Dload  Upload  Total   Spent   Left   Speed
100 170.8M 100 170.8M   0      0 10.63M      0   00:16   00:16         10.85M
Yandex Cloud CLI 0.198.0 linux/amd64
To complete installation, start a new shell (exec -l $SHELL) or type 'source "/home/shoel/.bashrc"' in the current one
```
```bash
# Применение новых переменных окружения в текущей сессии
source \
~/.bashrc

# указываем источник (yandex cloud)
cat > .terraformrc << 'EOF'
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
EOF

# Инициализация Terraform конфигурации
terraform init
```
```
Terraform initialized in an empty directory!

The directory has no Terraform configuration files. You may begin working
with Terraform immediately by creating Terraform configuration files.
```
```bash
# инициализация подключения к уже созданному аккаунту yandex cloud
yc init
```
```
Welcome! This command will take you through the configuration process.
Pick desired action:
 [1] Re-initialize this profile 'default' with new settings 
 [2] Create a new profile
 [3] Switch to and re-initialize existing profile: 'fops-netology'
Please enter your numeric choice: 1
Please go to https://oauth.yandex.ru/authorize?response_type=token&client_id=xxxxxxxxxxxxxxxxxxxxxxxxxx in order to obtain OAuth token.
 Please enter OAuth token: [y0__xCB1IknG***************************cYlNq_VVM4Ku] y0__xCB1IknGxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
You have one cloud available: 'cloud-shoelacevip12' (id = b1gkumrn87pei2831blp). It is going to be used by default.
Please choose folder to use:
 [1] fops39 (id = b1g7qviodfc9v4k81sr5)
 [2] Create a new folder
Please enter your numeric choice: 1
Your current folder has been set to 'fops39' (id = b1g7qviodfc9v4k81sr5).
Do you want to configure a default Compute zone? [Y/n] Y
Which zone do you want to use as a profile default?
 [1] ru-central1-a
 [2] ru-central1-b
 [3] ru-central1-d
 [4] ru-central1-k
 [5] Don't set default zone
Please enter your numeric choice: 1
Your profile default Compute zone has been set to 'ru-central1-a'.
```
```bash
# Для вывода Id облака yandex cloud, что будет использоваться для взаимодействия с terraform
yc config get \
cloud-id
```
```
b1gkumrn87pei2831blp
```
```bash
# Для вывода Id каталога yandex cloud, что будет использоваться для взаимодействия с terraform
yc config get \
folder-id
```
```
b1g7qviodfc9v4k81sr5
```
### Создание TF конфига
#### Описание провайдера для работы с yandex-cloud
```bash
cat > providers.tf <<'EOF'
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "<зона_доступности_по_умолчанию>"
}
EOF
```
#### Описание некоторых переменных для создания VM
```bash
cat > variables.tf <<'EOF'
variable "lab16_1" {
  type    = string
  default = "lab61-1-skv"
}

variable "cloud_id" {
  type    = string
  default = "b1gkumrn87pei2831blp"
}

variable "folder_id" {
  type    = string
  default = "b1g7qviodfc9v4k81sr5"
}

variable "host" {
  type = map(number)
  default = {
    cores         = 4
    memory        = 4
    core_fraction = 5
  }
}
EOF
```
#### Описание WAN и NAT маршрутизации
```bash
cat > network.tf <<'EOF'
# Общая облачная сеть
resource "yandex_vpc_network" "skv" {
  name = "skv-fops39-${var.lab16_1}"
}

# Подсеть zone A
resource "yandex_vpc_subnet" "skv-locnet-a" {
  name           = "skv-fops-${var.lab16_1}-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["10.10.10.192/26"]
  route_table_id = yandex_vpc_route_table.route.id
}

# Сеть под NAT для исходящего трафика
resource "yandex_vpc_gateway" "nat-gateway" {
  name = "fops-gateway-${var.lab16_1}"
  shared_egress_gateway {}
}

# Шлюз для выхода в WAN
resource "yandex_vpc_route_table" "route" {
  name       = "fops-route-table-${var.lab16_1}"
  network_id = yandex_vpc_network.skv.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat-gateway.id
  }
}
EOF
```
#### Описание security group для публичной сети с разграничением доступа по портам и протоколам
```bash
cat > security_groups.tf <<'EOF'
# Security Group для хоста docker
# Security Group для LAN (внутреннее взаимодействие между сервисами)
resource "yandex_vpc_security_group" "LAN" {
  name       = "LAN-${var.lab16_1}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить весь трафик из внутренней сети"
    protocol       = "ANY"
    v4_cidr_blocks = ["10.10.10.192/26"]
    from_port      = 0
    to_port        = 65535
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "host_sg" {
  name       = "host-sg-${var.lab16_1}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить SSH доступ из интернета на порт 22"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
EOF
```
#### Главный файл terraform описания создания виртуальной машины
```bash
cat > vms.tf <<'EOF'
# Данные об образе ОС
data "yandex_compute_image" "ubuntu_2404_lts" {
  family = "ubuntu-2404-lts"
}

# Docker Host
resource "yandex_compute_instance" "docker-host" {
  name        = "docker"
  hostname    = "docker"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${file("~/.ssh/id_lab16_1_fops39_ed25519.pub")}"
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-a.id
    nat        = true
    ip_address = "10.10.10.254"
    security_group_ids = [
      yandex_vpc_security_group.host_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Файл hosts для проброса скрипта запуска проекта
resource "local_file" "hosts_docker" {
  content  = <<-EOT
    #!/bin/bash -x
    > ~/.ssh/known_hosts
    # Копирование скрипта запуска лабораторной работы
    rsync -vP -e "ssh \
    -o StrictHostKeyChecking=accept-new \
    -i ~/.ssh/id_lab16_1_fops39_ed25519" \
    lab16_1.sh \
    skv@${yandex_compute_instance.docker-host.network_interface.0.nat_ip_address}:~/

    # Запуск скрипта выполнения работы
    ssh -t -p 22 \
    -o StrictHostKeyChecking=accept-new \
    -i ~/.ssh/id_lab16_1_fops39_ed25519 \
    skv@${yandex_compute_instance.docker-host.network_interface.0.nat_ip_address} \
    "chmod +x lab16_1.sh \
    && bash -c "./lab16_1.sh""
EOT
  filename = "./hosts_docker.sh"
}
EOF
```
#### cloud-init для проброса публичного ключа
```bash
cat >cloud-init.yml<<'EOF'
#cloud-config
users:
  - name: skv
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ssh-ed25519 
EOF

# Добавляем содержимое публичного ключа в cloud-init.yml
sed -i "8s|.*|      - $(cat ~/.ssh/id_lab16_1_fops39_ed25519.pub \
                      | tr -d '\n\r')|" \
cloud-init.yml
```
#### Создание Скрипта для установки docker на удаленном сервере
```bash
cat > lab16_1.sh <<'EOT'
#!/bin/bash

# добавление репозитория docker
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

# Установка docker и и плагинов
sudo apt install -y \
docker-ce \
docker-ce-cli \
containerd.io \
docker-buildx-plugin \
docker-compose-plugin

# Добавление пользователя в группу docker
sudo usermod -aG \
docker \
skv

echo -e "\nсостояние запуска docker:"
sudo systemctl is-active docker
EOT
```
### ЗАпуск docker ВМ в облаке
```bash
# Проверка tf файлов проекта
terraform init --upgrade \
&& terraform validate
```
```
Initializing the backend...
Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.191.0...
- Installed yandex-cloud/yandex v0.191.0 (unauthenticated)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

╷
│ Warning: Incomplete lock file information for providers
│ 
│ Due to your customized provider installation methods, Terraform was forced to calculate lock file checksums locally for the following providers:
│   - yandex-cloud/yandex
│ 
│ The current .terraform.lock.hcl file only includes checksums for linux_amd64, so Terraform running on another platform will fail to install these providers.
│ 
│ To calculate additional checksums for another platform, run:
│   terraform providers lock -platform=linux_amd64
│ (where linux_amd64 is the platform to generate)
╵
Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Success! The configuration is valid.
```
```bash

# Авто-форматирование конфига и создание файла запуска terraform
terraform fmt \
&& terraform plan -out=tfplan
```
```
data.yandex_compute_image.ubuntu_2404_lts: Reading...
data.yandex_compute_image.ubuntu_2404_lts: Read complete after 0s [id=fd8bnpa9t8d5cql6rfdl]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.hosts_docker will be created
  + resource "local_file" "hosts_docker" {
      + content              = (known after apply)
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "../hosts_docker.sh"
      + id                   = (known after apply)
    }

  # yandex_compute_instance.docker-host will be created
  + resource "yandex_compute_instance" "docker-host" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hardware_generation       = (known after apply)
      + hostname                  = "docker"
      + id                        = (known after apply)
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "ssh-keys"           = <<-EOT
                ubuntu:ssh-ed25519 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx lab16_1_fops39
            EOT
          + "user-data"          = <<-EOT
                #cloud-config
                users:
                  - name: skv
                    groups: sudo
                    shell: /bin/bash
                    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
                    ssh_authorized_keys:
                      - ssh-ed25519 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx lab16_1_fops39
            EOT
        }
      + name                      = "docker"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8bnpa9t8d5cql6rfdl"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options (known after apply)

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "10.10.10.254"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy (known after apply)

      + resources {
          + core_fraction = 5
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy (known after apply)
    }

  # yandex_vpc_gateway.nat-gateway will be created
  + resource "yandex_vpc_gateway" "nat-gateway" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "fops-gateway-lab16-1-skv"

      + shared_egress_gateway {}
    }

  # yandex_vpc_network.skv will be created
  + resource "yandex_vpc_network" "skv" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "skv-fops39-lab16-1-skv"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_route_table.route will be created
  + resource "yandex_vpc_route_table" "route" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "fops-route-table-lab16-1-skv"
      + network_id = (known after apply)

      + static_route {
          + destination_prefix = "0.0.0.0/0"
          + gateway_id         = (known after apply)
            # (1 unchanged attribute hidden)
        }
    }

  # yandex_vpc_security_group.LAN will be created
  + resource "yandex_vpc_security_group" "LAN" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "LAN-lab16-1-skv"
      + network_id = (known after apply)
      + status     = (known after apply)

      + egress {
          + description       = "Разрешить весь исходящий трафик"
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + protocol          = "ANY"
          + to_port           = 65535
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }

      + ingress {
          + description       = "Разрешить весь трафик из внутренней сети"
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + protocol          = "ANY"
          + to_port           = 65535
          + v4_cidr_blocks    = [
              + "10.10.10.192/26",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
    }

  # yandex_vpc_security_group.host_sg will be created
  + resource "yandex_vpc_security_group" "host_sg" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "host-sg-lab16-1-skv"
      + network_id = (known after apply)
      + status     = (known after apply)

      + egress {
          + description       = "Разрешить весь исходящий трафик"
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + protocol          = "ANY"
          + to_port           = 65535
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }

      + ingress {
          + description       = "Разрешить SSH доступ из интернета на порт 22"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 22
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
    }

  # yandex_vpc_subnet.skv-locnet-a will be created
  + resource "yandex_vpc_subnet" "skv-locnet-a" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "skv-fops-lab16-1-skv-ru-central1-a"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "10.10.10.192/26",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 8 to add, 0 to change, 0 to destroy.

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"
```
```bash
# Применение файла запуска terraform
terraform apply "tfplan"
```
```
yandex_vpc_network.skv: Creating...
yandex_vpc_gateway.nat-gateway: Creating...
yandex_vpc_gateway.nat-gateway: Creation complete after 1s [id=enpkq1fdnv3huhbfjpaf]
yandex_vpc_network.skv: Creation complete after 3s [id=enp9psj3b1pm2pqgbhi1]
yandex_vpc_route_table.route: Creating...
yandex_vpc_security_group.LAN: Creating...
yandex_vpc_security_group.host_sg: Creating...
yandex_vpc_route_table.route: Creation complete after 1s [id=enp0o3ibjd0qo33hsi15]
yandex_vpc_subnet.skv-locnet-a: Creating...
yandex_vpc_subnet.skv-locnet-a: Creation complete after 0s [id=e9bu1hfr585s0chs4sqc]
yandex_vpc_security_group.LAN: Creation complete after 2s [id=enpc1fv437gjeojcd53f]
yandex_vpc_security_group.host_sg: Creation complete after 5s [id=enpibequj73jnskcmrr2]
yandex_compute_instance.docker-host: Creating...
yandex_compute_instance.docker-host: Still creating... [00m10s elapsed]
yandex_compute_instance.docker-host: Still creating... [00m20s elapsed]
yandex_compute_instance.docker-host: Still creating... [00m30s elapsed]
yandex_compute_instance.docker-host: Still creating... [00m40s elapsed]
yandex_compute_instance.docker-host: Still creating... [00m50s elapsed]
yandex_compute_instance.docker-host: Still creating... [01m00s elapsed]
yandex_compute_instance.docker-host: Creation complete after 1m7s [id=fhm6t69hr0o48p0ialfc]
local_file.hosts_docker: Creating...
local_file.hosts_docker: Creation complete after 0s [id=a0767096bf5e1dedb1a004205ec3e61bc7428d23]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.
```

![](/16_1/img/2.png)

```bash
# Вывод структуры запущенного проекта на terraform относительно Root папки
tree -a
```
```
.
├── cloud-init.yml
├── hosts_docker.sh
├── lab16_1.sh
├── network.tf
├── providers.tf
├── security_groups.tf
├── .terraform
│   └── providers
│       └── registry.terraform.io
│           ├── hashicorp
│           │   └── local
│           │       └── 2.7.0
│           │           └── linux_amd64
│           │               ├── LICENSE.txt
│           │               └── terraform-provider-local_v2.7.0_x5
│           └── yandex-cloud
│               └── yandex
│                   └── 0.191.0
│                       └── linux_amd64
│                           ├── CHANGELOG.md
│                           ├── LICENSE
│                           ├── README.md
│                           └── terraform-provider-yandex_v0.191.0
├── .terraform.lock.hcl
├── .terraformrc
├── terraform.tfstate
├── tfplan
├── variables.tf
└── vms.tf
```
```bash
# Чистка известных хостов для подключения по ssh
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_lab16_1_fops39_ed25519

> ~/.ssh/known_hosts

# Удаленный контекст установки docker через ssh
./hosts_docker.sh
```
```
+ rsync -vP -e 'ssh -o StrictHostKeyChecking=accept-new -i ~/.ssh/id_lab16_1_fops39_ed25519' lab16_1.sh 'skv@62.84.125.162:~/'
Warning: Permanently added '62.84.125.162' (ED25519) to the list of known hosts.
lab16_1.sh
            923 100%    0,00kB/s    0:00:00 (xfr#1, to-chk=0/1)

sent 1.011 bytes  received 35 bytes  418,40 bytes/sec
total size is 923  speedup is 0,88
+ ssh -t -p 22 -o StrictHostKeyChecking=accept-new -i ~/.ssh/id_lab16_1_fops39_ed25519 skv@62.84.125.162 'chmod +x lab16_1.sh && bash -c ./lab16_1.sh'
.....
Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /usr/lib/systemd/system/containerd.service.
Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /usr/lib/systemd/system/docker.service.
Created symlink /etc/systemd/system/sockets.target.wants/docker.socket → /usr/lib/systemd/system/docker.socket.
Processing triggers for man-db (2.12.0-4build2) ...
Processing triggers for libc-bin (2.39-0ubuntu8.7) ...
Scanning processes...                                                                                                                                                                           
Scanning linux images...                                                                                                                                                                        

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.

состояние запуска docker:
active
Connection to 62.84.125.162 closed.
```
```bash
cd ..

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am '16_1-terr_vved_2_1' \
&& git push \
--set-upstream \
study_fops39 \
16_1-terr_vved \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
16_1-terr_vved
```
### Формирование удаленного контекста remote docker через terraform
#### Обновление списка провайдеров
```bash
cat > providers.tf <<'EOF'
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "<зона_доступности_по_умолчанию>"
}

provider "docker" {
  host = "ssh://skv@${yandex_compute_instance.docker-host.network_interface.0.nat_ip_address}"
  ssh_opts = ["-o", "StrictHostKeyChecking=accept-new", "-i", "~/.ssh/id_lab16_1_fops39_ed25519"]
}
EOF

# Переинициализация провайдеров
terraform init --upgrade
```
```
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/random...
- Finding latest version of yandex-cloud/yandex...
- Finding latest version of hashicorp/local...
- Finding latest version of kreuzwerker/docker...
- Installing hashicorp/random v3.8.1...
- Installed hashicorp/random v3.8.1 (unauthenticated)
- Using previously-installed yandex-cloud/yandex v0.191.0
- Using previously-installed hashicorp/local v2.7.0
- Installing kreuzwerker/docker v3.6.2...
- Installed kreuzwerker/docker v3.6.2 (unauthenticated)
Terraform has made some changes to the provider dependency selections recorded
in the .terraform.lock.hcl file. Review those changes and commit them to your
version control system if they represent changes you intended to make.

╷
│ Warning: Incomplete lock file information for providers
│ 
│ Due to your customized provider installation methods, Terraform was forced to calculate lock file checksums locally for the following providers:
│   - hashicorp/random
│   - kreuzwerker/docker
│ 
│ The current .terraform.lock.hcl file only includes checksums for linux_amd64, so Terraform running on another platform will fail to install these providers.
│ 
│ To calculate additional checksums for another platform, run:
│   terraform providers lock -platform=linux_amd64
│ (where linux_amd64 is the platform to generate)
╵
Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
#### Добавление новых часто повторяемых переменных переменных
```bash
cat >> variables.tf <<'EOF'

variable "password_strong" {
  type = map(number)
  default = {
    length        = 16
    min_lower     = 1
    min_upper     = 1
    min_numeric   = 1
  }
}
EOF
```
#### TF файл конфигурации для MySQL контейнера
```bash
cat > mysql.tf <<'EOF'
# Генерация паролей
resource "random_password" "mysql_root_password" {
  length      = var.password_strong.length
  special     = true
  min_lower   = var.password_strong.min_lower
  min_upper   = var.password_strong.min_upper
  min_numeric = var.password_strong.min_numeric
}

resource "random_password" "mysql_password" {
  length      = var.password_strong.length
  special     = true
  min_lower   = var.password_strong.min_lower
  min_upper   = var.password_strong.min_upper
  min_numeric = var.password_strong.min_numeric
}

# MySQL контейнер
resource "docker_image" "mysql" {
  name         = "mysql:8"
  keep_locally = true
}

resource "docker_container" "mysql" {
  name     = "db-skv"
  image    = docker_image.mysql.image_id
  must_run = true

  ports {
    internal = 3306
    external = 3306
    ip       = "127.0.0.1"
    protocol = "tcp"
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root_password.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_password.result}",
    "MYSQL_ROOT_HOST=%"
  ]

  restart = "always"
}

# Для вывода паролей через output
output "mysql_root_password" {
  value     = random_password.mysql_root_password.result
  sensitive = true
}

output "mysql_password" {
  value     = random_password.mysql_password.result
  sensitive = true
}

output "container_name" {
  value     = docker_container.mysql.name
  sensitive = true
}
EOF
```
### Применение в структуру существующего проекта terraform
```bash
# Инициализация Terraform, Проверка конфигурации, Авто-Форматирование конфигов, вывод плана в отдельный файл tfplan
terraform init --upgrade \
&& terraform validate \
&& terraform fmt \
&& terraform plan -out=tfplan
```
```
Success! The configuration is valid.

mysql.tf
data.yandex_compute_image.ubuntu_2404_lts: Reading...
yandex_vpc_gateway.nat-gateway: Refreshing state... [id=enpkq1fdnv3huhbfjpaf]
yandex_vpc_network.skv: Refreshing state... [id=enp9psj3b1pm2pqgbhi1]
data.yandex_compute_image.ubuntu_2404_lts: Read complete after 0s [id=fd8bnpa9t8d5cql6rfdl]
yandex_vpc_route_table.route: Refreshing state... [id=enp0o3ibjd0qo33hsi15]
yandex_vpc_security_group.host_sg: Refreshing state... [id=enpibequj73jnskcmrr2]
yandex_vpc_security_group.LAN: Refreshing state... [id=enpc1fv437gjeojcd53f]
yandex_vpc_subnet.skv-locnet-a: Refreshing state... [id=e9bu1hfr585s0chs4sqc]
yandex_compute_instance.docker-host: Refreshing state... [id=fhm6t69hr0o48p0ialfc]
local_file.hosts_docker: Refreshing state... [id=b4b8e5ec9e4d5df59a3b9e380b0a45dbf17cd153]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # docker_container.mysql will be created
  + resource "docker_container" "mysql" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (sensitive value)
      + exit_code                                   = (known after apply)
      + hostname                                    = (known after apply)
      + id                                          = (known after apply)
      + image                                       = (known after apply)
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + must_run                                    = true
      + name                                        = (sensitive value)
      + network_data                                = (known after apply)
      + network_mode                                = "bridge"
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "always"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + healthcheck (known after apply)

      + labels (known after apply)

      + ports {
          + external = 3306
          + internal = 3306
          + ip       = "127.0.0.1"
          + protocol = "tcp"
        }
    }

  # docker_image.mysql will be created
  + resource "docker_image" "mysql" {
      + id           = (known after apply)
      + image_id     = (known after apply)
      + keep_locally = true
      + name         = "mysql:8"
      + repo_digest  = (known after apply)
    }

  # random_password.mysql_password will be created
  + resource "random_password" "mysql_password" {
      + bcrypt_hash = (sensitive value)
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 1
      + min_numeric = 1
      + min_special = 0
      + min_upper   = 1
      + number      = true
      + numeric     = true
      + result      = (sensitive value)
      + special     = true
      + upper       = true
    }

  # random_password.mysql_root_password will be created
  + resource "random_password" "mysql_root_password" {
      + bcrypt_hash = (sensitive value)
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 1
      + min_numeric = 1
      + min_special = 0
      + min_upper   = 1
      + number      = true
      + numeric     = true
      + result      = (sensitive value)
      + special     = true
      + upper       = true
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + container_name      = (sensitive value)
  + mysql_password      = (sensitive value)
  + mysql_root_password = (sensitive value)

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"
```
```bash
# Применение
terraform apply "tfplan"
```
```
docker_container.mysql: Creating...
docker_container.mysql: Creation complete after 1s [id=0f284fc59fca9542adba8c5712839766e152b9186fd2fe668e39c42bc1626d4d]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

container_name = <sensitive>
mysql_password = <sensitive>
mysql_root_password = <sensitive>
```
```bash
# Структура файлов рабочего проекта
tree -a
.
├── cloud-init.yml
├── hosts_docker.sh
├── lab16_1.sh
├── mysql.tf
├── network.tf
├── providers.tf
├── security_groups.tf
├── .terraform
│   └── providers
│       └── registry.terraform.io
│           ├── hashicorp
│           │   ├── local
│           │   │   └── 2.7.0
│           │   │       └── linux_amd64
│           │   │           ├── LICENSE.txt
│           │   │           └── terraform-provider-local_v2.7.0_x5
│           │   └── random
│           │       └── 3.8.1
│           │           └── linux_amd64
│           │               ├── LICENSE.txt
│           │               └── terraform-provider-random_v3.8.1_x5
│           ├── kreuzwerker
│           │   └── docker
│           │       └── 3.6.2
│           │           └── linux_amd64
│           │               ├── CHANGELOG.md
│           │               ├── LICENSE
│           │               ├── README.md
│           │               └── terraform-provider-docker_v3.6.2
│           └── yandex-cloud
│               └── yandex
│                   └── 0.191.0
│                       └── linux_amd64
│                           ├── CHANGELOG.md
│                           ├── LICENSE
│                           ├── README.md
│                           └── terraform-provider-yandex_v0.191.0
├── .terraform.lock.hcl
├── .terraformrc
├── terraform.tfstate
├── terraform.tfstate.backup
├── tfplan
├── variables.tf
└── vms.tf

19 directories, 26 files
```
### Проверка вывода переменных
```bash
terraform output  container_name
```
```
"db-skv"
```
```bash
terraform output mysql_password
```
```
"x]UEx{LR-K7_51c7"
```
```bash
terraform output mysql_root_password
```
```
"Kx5K%zNzMJ:f&[vr"
```
```bash
# Проверка работы по ssh
ssh -t -p 22 \
-o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_lab16_1_fops39_ed25519 \
skv@$(yc compute instance list \
     | grep docker \
     | awk '{print $10}') \
"docker ps -a"
```
```
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                 NAMES
0f284fc59fca   a2d126916bc2   "docker-entrypoint.s…"   18 minutes ago   Up 18 minutes   127.0.0.1:3306->3306/tcp, 33060/tcp   db-skv
Connection to 62.84.125.162 closed.
```
```bash
ssh -t -p 22 \
-o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_lab16_1_fops39_ed25519 \
skv@$(yc compute instance list \
     | grep docker \
     | awk '{print $10}') \
"docker exec -ti \
db-skv \
env"
```
```
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=0f284fc59fca
TERM=xterm
MYSQL_ROOT_HOST=%
MYSQL_ROOT_PASSWORD=Kx5K%zNzMJ:f&[vr
MYSQL_PASSWORD=x]UEx{LR-K7_51c7
MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress
GOSU_VERSION=1.19
MYSQL_MAJOR=8.4
MYSQL_VERSION=8.4.8-1.el9
MYSQL_SHELL_VERSION=8.4.8-1.el9
HOME=/root
Connection to 62.84.125.162 closed.
```
```bash
cd ..

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am '16_1-terr_vved_2_2' \
&& git push \
--set-upstream \
study_fops39 \
16_1-terr_vved \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
16_1-terr_vved
```
## commit_51, master
```bash
cd ~/nfs_git/gited/16_1

git checkout master

git branch -v

git merge 16_1-terr_vved


git branch -v

git status

git diff \
&& git diff \
--staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_51, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master

cd tf_2
terraform destroy

git add . .. \
&& git status \
&& git commit --amend --no-edit \
&& git push \
--set-upstream \
study_fops39 \
master --force \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master --force
```