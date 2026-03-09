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