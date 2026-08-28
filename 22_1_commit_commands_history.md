# Для домашнего задания 22.1 `Организация сети`

## commit_85, master Предварительная подготовка

```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master
```

<details>
<summary>
переход на master
</summary>

```log
Уже на «master»
```

</details>

```bash
# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/clopro-homeworks.git


# Удаление всех файлов и каталогов кроме нужных
find clopro-homeworks/ \
-mindepth 1 \
-not -path "*15.1*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем
mv -v clopro-homeworks \
22_1

# Переход в каталог по последней переменной вывода последней команды
cd !$

# Переименование 
mv -v {15.1,README}.md
```

```bash
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
git commit -am 'commit_85, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master \
&& git push \
--set-upstream \
study-fops39_sc \
master
```

## commit_1, `22_1-cloud-org-network`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 22_1-cloud-org-network

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
git commit -am 'commit1, 22_1-cloud-org-network' \
&& git push \
--set-upstream \
study_fops39 \
22_1-cloud-org-network \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
22_1-cloud-org-network \
&& git push \
--set-upstream \
study-fops39_sc \
22_1-cloud-org-network
```

## commit_2,`22_1-cloud-org-network`

```bash
# генерация ключа ssh для подключения
ssh-keygen -f \
~/.ssh/id_lab22_1_fops40_ed25519 \
-t ed25519 -C "lab22_1_fops40"
```

<details>
<summary>
Лог генерации ключа ssh для подключения
</summary>

```log
Generating public/private ed25519 key pair.
Enter passphrase for "/home/shoel/.ssh/id_lab22_1_fops40_ed25519" (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/shoel/.ssh/id_lab22_1_fops40_ed25519
Your public key has been saved in /home/shoel/.ssh/id_lab22_1_fops40_ed25519.pub
The key fingerprint is:
SHA256:tVXUEqnE0BBE1chZsgpRf5hW9aqT2nZ8pKiZd8iGZDs lab22_1_fops40
The key's randomart image is:
+--[ED25519 256]--+
|        .+BO   =.|
|         . .B   o|
|        . . B   .|
|         o =.. . |
|              .  |
|                .|
|                 |
|                 |
|                 |
+----[SHA256]-----+
```

</details>

```bash
# Выставление прав на пару ключей
chmod -v 600 ~/.ssh/id_lab22_1_fops40_ed25519
chmod -v 644 ~/.ssh/id_lab22_1_fops40_ed25519.pub

# включаем агента-ssh
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_lab22_1_fops40_ed25519
```

<details>
<summary>
Добавление ключа ssh в агента-ssh
</summary>

```log
права доступа '/home/shoel/.ssh/id_lab22_1_fops40_ed25519' оставлены в виде 0600 (rw-------)
права доступа '/home/shoel/.ssh/id_lab22_1_fops40_ed25519.pub' оставлены в виде 0644 (rw-r--r--)

Agent pid 11469
Identity added: /home/shoel/.ssh/id_lab22_1_fops40_ed25519 (lab22_1_fops40)
```

</details>

### для archlinux установка terraform

```bash
# Установка из репозитория archlinux
sudo pacman \
-Syu \
terraform
```

<details>
<summary>
Проверка установленного terraform
</summary>

```log
...
предупреждение: terraform-1.15.9-1 не устарел -- переустанавливается
разрешение зависимостей...
проверка конфликтов...

Пакеты (1) terraform-1.15.9-1

Будет установлено:  113,93 MiB
Изменение размера:    0,00 MiB

:: Приступить к установке? [Y/n] Y
...
```

</details>

```bash
terraform -v
```

<details>
<summary>
Проверка установленного terraform
</summary>

```log
Terraform v1.15.9
on linux_amd64
```

</details>

### Подготовка для работы с yandex cloud
```bash
# Скачиваем скрипт для установки yandex console
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh \
| bash -x
```

<details>
<summary>
Лог установленного yandex console
</summary>

```log
+ set -euo pipefail
+ VERBOSE=
+ [[ '' != '' ]]
++ uname -s
+ SYSTEM=Linux
++ uname -m
+ MACHINE=x86_64
+ GOOS=
+ GOARCH=
+ CLI_BIN=yc
++ basename /usr/bin/bash
+ SHELL_NAME=bash
++ uname -a
+ CONTACT_SUPPORT_MESSAGE=$'If you think that this should not be, contact support and attach this message.\nSystem info: Linux shoellin 7.1.9-zen1-2-zen #1 ZEN SMP PREEMPT_DYNAMIC Fri, 21 Aug 2026 23:03:30 +0000 x86_64 GNU/Linux'
+ case ${SYSTEM} in
+ GOOS=linux
+ case ${MACHINE} in
+ GOARCH=amd64
+ DEFAULT_RC_PATH=/home/shoel/.bashrc
+ '[' bash '!=' bash ']'
+ '[' Linux = Darwin ']'
+ BASH_COMPLETION_AVAILABLE=
+ '[' bash = bash ']'
+ BASH_COMPLETION_AVAILABLE=yes
+ ZSH_COMPLETION_AVAILABLE=
+ '[' bash = zsh ']'
+ CLI_INSTALL_PATH=/home/shoel/yandex-cloud
+ RC_PATH=
+ NO_RC=
+ AUTO_RC=
+ getopts hi:r:na opt
++ curl --help
+ CURL_HELP=$'Usage: curl [options...] <url>\n -d, --data <data>            HTTP POST data\n -f, --fail                   Fail fast with no output on HTTP errors\n -I, --head                   Show document info only\n -H, --header <header/@file>  Pass custom header(s) to server\n -h, --help <subject>         Get help for commands\n -o, --output <file>          Write to file instead of stdout\n -O, --remote-name            Write output to file named as remote file\n -i, --show-headers           Show response headers in output\n -s, --silent                 Silent mode\n -T, --upload-file <file>     Transfer local FILE to destination\n -u, --user <user:password>   Server user and password\n -A, --user-agent <name>      Send User-Agent <name> to server\n -v, --verbose                Make the operation more talkative\n -V, --version                Show version number and quit\n\nThis is not the full help; this menu is split into categories.\nUse "--help category" to get an overview of all categories, which are:\nauth, connection, curl, deprecated, dns, file, ftp, global, http, imap, ldap, \noutput, pop3, post, proxy, scp, sftp, smtp, ssh, telnet, tftp, timeout, tls, \nupload, verbose.\nUse "--help all" to list all options'
+ CURL_OPTIONS=("-fS")
+ curl_has_option --retry
+ grep -e --retry
+ echo $'Usage: curl [options...] <url>\n -d, --data <data>            HTTP POST data\n -f, --fail                   Fail fast with no output on HTTP errors\n -I, --head                   Show document info only\n -H, --header <header/@file>  Pass custom header(s) to server\n -h, --help <subject>         Get help for commands\n -o, --output <file>          Write to file instead of stdout\n -O, --remote-name            Write output to file named as remote file\n -i, --show-headers           Show response headers in output\n -s, --silent                 Silent mode\n -T, --upload-file <file>     Transfer local FILE to destination\n -u, --user <user:password>   Server user and password\n -A, --user-agent <name>      Send User-Agent <name> to server\n -v, --verbose                Make the operation more talkative\n -V, --version                Show version number and quit\n\nThis is not the full help; this menu is split into categories.\nUse "--help category" to get an overview of all categories, which are:\nauth, connection, curl, deprecated, dns, file, ftp, global, http, imap, ldap, \noutput, pop3, post, proxy, scp, sftp, smtp, ssh, telnet, tftp, timeout, tls, \nupload, verbose.\nUse "--help all" to list all options'
+ curl_has_option --connect-timeout
+ echo $'Usage: curl [options...] <url>\n -d, --data <data>            HTTP POST data\n -f, --fail                   Fail fast with no output on HTTP errors\n -I, --head                   Show document info only\n -H, --header <header/@file>  Pass custom header(s) to server\n -h, --help <subject>         Get help for commands\n -o, --output <file>          Write to file instead of stdout\n -O, --remote-name            Write output to file named as remote file\n -i, --show-headers           Show response headers in output\n -s, --silent                 Silent mode\n -T, --upload-file <file>     Transfer local FILE to destination\n -u, --user <user:password>   Server user and password\n -A, --user-agent <name>      Send User-Agent <name> to server\n -v, --verbose                Make the operation more talkative\n -V, --version                Show version number and quit\n\nThis is not the full help; this menu is split into categories.\nUse "--help category" to get an overview of all categories, which are:\nauth, connection, curl, deprecated, dns, file, ftp, global, http, imap, ldap, \noutput, pop3, post, proxy, scp, sftp, smtp, ssh, telnet, tftp, timeout, tls, \nupload, verbose.\nUse "--help all" to list all options'
+ grep -e --connect-timeout
+ curl_has_option --retry-connrefused
+ echo $'Usage: curl [options...] <url>\n -d, --data <data>            HTTP POST data\n -f, --fail                   Fail fast with no output on HTTP errors\n -I, --head                   Show document info only\n -H, --header <header/@file>  Pass custom header(s) to server\n -h, --help <subject>         Get help for commands\n -o, --output <file>          Write to file instead of stdout\n -O, --remote-name            Write output to file named as remote file\n -i, --show-headers           Show response headers in output\n -s, --silent                 Silent mode\n -T, --upload-file <file>     Transfer local FILE to destination\n -u, --user <user:password>   Server user and password\n -A, --user-agent <name>      Send User-Agent <name> to server\n -v, --verbose                Make the operation more talkative\n -V, --version                Show version number and quit\n\nThis is not the full help; this menu is split into categories.\nUse "--help category" to get an overview of all categories, which are:\nauth, connection, curl, deprecated, dns, file, ftp, global, http, imap, ldap, \noutput, pop3, post, proxy, scp, sftp, smtp, ssh, telnet, tftp, timeout, tls, \nupload, verbose.\nUse "--help all" to list all options'
+ grep -e --retry-connrefused
+ SDK_STORAGE_URL=https://storage.yandexcloud.net/yandexcloud-yc
++ curl_with_retry -s https://storage.yandexcloud.net/yandexcloud-yc/release/stable
++ curl -fS -s https://storage.yandexcloud.net/yandexcloud-yc/release/stable
+ VERSION=1.30.0
+ '[' '!' -t 0 ']'
+ AUTO_RC=yes
+ echo 'Downloading yc 1.30.0'
Downloading yc 1.30.0
+ TMPDIR=/tmp
++ mktemp -d /tmp/yc-install.XXXXXXXXX
+ TMP_INSTALL_PATH=/tmp/yc-install.r6ffcfQ5G
+ trap cleanup EXIT
+ TMP_CLI=/tmp/yc-install.r6ffcfQ5G/yc
+ curl_with_retry https://storage.yandexcloud.net/yandexcloud-yc/release/1.30.0/linux/amd64/yc -o /tmp/yc-install.r6ffcfQ5G/yc
+ curl -fS https://storage.yandexcloud.net/yandexcloud-yc/release/1.30.0/linux/amd64/yc -o /tmp/yc-install.r6ffcfQ5G/yc
  % Total    % Received % Xferd  Average Speed  Time    Time    Time   Current
                                 Dload  Upload  Total   Spent   Left   Speed
100 163.6M 100 163.6M   0      0 10.91M      0   00:14   00:14         10.98M
+ chmod +x /tmp/yc-install.r6ffcfQ5G/yc
+ /tmp/yc-install.r6ffcfQ5G/yc version
Yandex Cloud CLI 1.30.0 linux/amd64
+ mkdir -p /home/shoel/yandex-cloud/bin
+ CLI_BIN_FULL_PATH=/home/shoel/yandex-cloud/bin/yc
+ mv -f /tmp/yc-install.r6ffcfQ5G/yc /home/shoel/yandex-cloud/bin/yc
+ mkdir -p /home/shoel/yandex-cloud/.install
+ case "${SHELL_NAME}" in
+ CLI_BASH_COMPLETION=/home/shoel/yandex-cloud/completion.bash.inc
+ '[' yes = yes ']'
+ /home/shoel/yandex-cloud/bin/yc completion bash
+ CLI_BASH_PATH=/home/shoel/yandex-cloud/path.bash.inc
+ '[' bash = bash ']'
+ cat
+ CLI_ZSH_COMPLETION=/home/shoel/yandex-cloud/completion.zsh.inc
+ '[' '' = yes ']'
+ '[' '' = yes ']'
+ '[' '' '!=' '' ']'
+ '[' yes = yes ']'
+ modify_rc /home/shoel/.bashrc
+ grep -Fq 'if [ -f '\''/home/shoel/yandex-cloud/path.bash.inc'\'' ]; then source '\''/home/shoel/yandex-cloud/path.bash.inc'\''; fi' /home/shoel/.bashrc
+ grep -Fq 'if [ -f '\''/home/shoel/yandex-cloud/completion.bash.inc'\'' ]; then source '\''/home/shoel/yandex-cloud/completion.bash.inc'\''; fi' /home/shoel/.bashrc
+ /home/shoel/yandex-cloud/bin/yc components post-update
+ echo ''
+ echo 'To complete installation, start a new shell (exec -l $SHELL) or type '\''source "/home/shoel/.bashrc"'\'' in the current one'
To complete installation, start a new shell (exec -l $SHELL) or type 'source "/home/shoel/.bashrc"' in the current one
+ exit 0
+ cleanup
+ rm -rf /tmp/yc-install.r6ffcfQ5G
```

</details>

```bash
# Применение новых переменных окружения в текущей сессии
. \
~/.bashrc
```

```bash
# Проверка установленной консоли
yc version
```

<details>
<summary>
Вывод установленной YC CLI
</summary>

```log
Yandex Cloud CLI 1.30.0 linux/amd64
```

</details>

```bash
# указываем источник (yandex cloud)
cat > ~/.terraformrc << 'EOF'
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
```

```bash
# Инициализация Terraform конфигурации
terraform init
```

<details>
<summary>
Вывод о работоспособности terraform
</summary>

```log
Terraform initialized in an empty directory!

The directory has no Terraform configuration files. You may begin working
with Terraform immediately by creating Terraform configuration files.
```

</details>

```bash
# инициализация подключения к уже созданному аккаунту yandex cloud
yc init
```

<details>
<summary>
Пример лога инициализации YC облака
</summary>

```log
Welcome! This command will take you through the configuration process.
Pick desired action:
 [1] Re-initialize this profile 'default' with new settings 
 [2] Create a new profile
 [3] Switch to and re-initialize existing profile: 'sa-profile'
Please enter your numeric choice: 1

You are going to be authenticated in Yandex Cloud.
After your successful authentication, you will be redirected to cloud console.

Press 'enter' to continue...
Please select cloud to use: 
 [1] cloud-shoelacevip12 (id = b1g46dhqv17rkjcoc9k7)
 [2] src-user-cloud-shoelacevip12 (id = b1goquaodj0lqrvojqcu)
Please enter your numeric choice: 1
Your current cloud has been set to 'cloud-shoelacevip12' (id = b1g46dhqv17rkjcoc9k7).
Please choose folder to use:
 [1] default (id = b1g9l0vgsvf6cegkvj1c)
 [2] Create a new folder
Please enter your numeric choice: 1
Your current folder has been set to 'default' (id = b1g9l0vgsvf6cegkvj1c).
Do you want to configure a default Compute zone? [Y/n] Y
Which zone do you want to use as a profile default?
 [1] ru-central1-a
 [2] ru-central1-b
 [3] ru-central1-d
 [4] ru-central1-e
 [5] ru-central1-k
 [6] Don't set default zone
Please enter your numeric choice: 1
Your profile default Compute zone has been set to 'ru-central1-a'.
```

</details>

```bash
# Для вывода Id облака yandex cloud, что будет использоваться для взаимодействия через terraform
yc config get \
cloud-id
```

<details>
<summary>
cloud id
</summary>

```log
b1g46dhqv17rkjcoc9k7
```

</details>

```bash
# Для вывода Id каталога yandex cloud, что будет использоваться для взаимодействия через terraform
yc config get \
folder-id
```

<details>
<summary>
folder id
</summary>

```log
b1g9l0vgsvf6cegkvj1c
```

</details>

```bash
# Создание сервисного аккаунта по ранее подключенному yandex cloud
yc iam \
service-account \
create \
--name servacca
```

<details>
<summary>
Лог созданного service account
</summary>

```log
id: ajexxxxxxxxxxxx4auv7
folder_id: b1g9l0vgsvf6cegkvj1c
created_at: "2026-06-08T13:29:34Z"
name: servacca
```

</details>

```bash
# Добавление сервисного аккаунта в заранее созданную группу с правами admin на организацию
# Где:
# --id — идентификатор группы с выданными правами admin. Обязательный параметр.
# --organization-id — идентификатор организации. Обязательный параметр.
# --subject-id — идентификатор участника (servacca), которого добавляют в группу.

yc organization-manager group add-members \
--id ajexxxxxxxxxxxxxsuj87 \
--organization-id bpxxxxxxxxxxxxxxxc9u \
--subject-id ajexxxxxxxxxxxx4auv7
```

```bash
# Вывод списка участников группы с правами admin на организацию
yc organization-manager group \
list-members \
ajexxxxxxxxxxxxxsuj87

# Созданные service-account для folder_id b1g9l0vgsvf6cegkvj1c
yc iam service-account \
--folder-id $YC_FOLDER_ID \
list
```

<details>
<summary>
Вывод списка участников группы с правами admin на организацию и service-account для folder_id
</summary>

```log
+----------------+----------------------+
|  SUBJECT TYPE  |      SUBJECT ID      |
+----------------+----------------------+
| userAccount    | ajexxxxxxxxxxxxxuafi |
| serviceAccount | ajexxxxxxxxxxxx4auv7 |
+----------------+----------------------+

+----------------------+----------+--------+---------------------+-----------------------+
|          ID          |   NAME   | LABELS |     CREATED AT      | LAST AUTHENTICATED AT |
+----------------------+----------+--------+---------------------+-----------------------+
| ajexxxxxxxxxxxx4auv7 | servacca |        | 2026-06-08 13:29:34 | 2026-06-08 13:50:00   |
+----------------------+----------+--------+---------------------+-----------------------+
```

</details>

```bash
# Создание json ключа к сервисному аккаунту c использованием переменных в ~/.bashrc Для YC
yc iam key create \
--service-account-name $(yc iam \
                        service-account \
                        --folder-id  $YC_FOLDER_ID list \
                        | awk '/servacca/{print $4}') \
--output ~/.authorized_key.json \
--folder-id $YC_FOLDER_ID
```

<details>
<summary>
Создание json ключа для использования service-account на локальной машине
</summary>

```log
id: ajexxxxxxxxxxxxxagrp
service_account_id: ajexxxxxxxxxxxxxauv7
created_at: "2026-08-28T14:56:20.904007746Z"
key_algorithm: RSA_2048
```

</details>

```bash
# Список всех профилей и активного
yc config profile list
```

<details>
<summary>
Вывод активного профиля YC на рабочей машине
</summary>

```log
default ACTIVE
sa-profile
```

</details>

```bash
# Информация о ткущем пользователе YC
yc config list
```

<details>
<summary>
Информация о ткущем пользователе YC
</summary>

```log
subject-id: ajexxxxxxxxxxxxxuafi
cloud-id: b1g46dhqv17rkjcoc9k7
folder-id: b1g9l0vgsvf6cegkvj1c
compute-default-zone: ru-central1-a
```

</details>

```bash
# Переключение на профиль service-account
yc config profile \
activate \
sa-profile
```

<details>
<summary>
Переключение на профиль service-account
</summary>

```log
Profile 'sa-profile' activated
```

</details>

```bash
# Список всех профилей и активного сейчас
yc config profile list
```

<details>
<summary>
Вывод активного профиля YC на рабочей машине
</summary>

```log
default
sa-profile ACTIVE
```

</details>

```bash
# Указываем для текущего профиля (SA) compute-default-zone
yc config set \
compute-default-zone \
ru-central1-a
```

```bash
# Информация о ткущем пользователе YC (SA)
yc config list
```

<details>
<summary>
Информация о ткущем пользователе YC (SA)
</summary>

```log
service-account-key:
  id: ajexxxxxxxxxxxxxqk6o
  service_account_id: ajexxxxxxxxxxxxxauv7
  created_at: "2026-06-08T13:46:31.659299318Z"
  key_algorithm: RSA_2048
  public_key: |
    -----BEGIN PUBLIC KEY-----
...
    -----END PUBLIC KEY-----
  private_key: |
    PLEASE DO NOT REMOVE THIS LINE! Yandex.Cloud SA Key ID <ajexxxxxxxxxxxxxqk6o>
    -----BEGIN PRIVATE KEY-----
...
    -----END PRIVATE KEY-----
cloud-id: b1g46dhqv17rkjcoc9k7
folder-id: b1g9l0vgsvf6cegkvj1c
compute-default-zone: ru-central1-a
```

</details>

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 22_1-cloud-org-network' \
&& git push \
--set-upstream \
study_fops39 \
22_1-cloud-org-network \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
22_1-cloud-org-network \
&& git push \
--set-upstream \
study-fops39_sc \
22_1-cloud-org-network
```

## commit_3,`22_1-cloud-org-network`

```bash
# Создание каталога для проекта terraform
mkdir -pv ./tf

cd !$
```

<details>
<summary>
каталога для проекта terraform
</summary>

```log
mkdir: создан каталог './tf'

cd ./tf
```

</details>

### `TF-манифест` провайдера YC и файла авторизации YC service account

<details>
<summary>
TF-манифест провайдера YC
</summary>

```terraform
cat > ./providers.tf <<'EOF'
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file = file("~/.authorized_key.json")
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
}
EOF
```

</details>

```bash
#

```

<details>
<summary>

</summary>

```log

```

</details>


```bash
cd 22_1/tf
terraform init --upgrade
terraform validate
terraform fmt
terraform plan -out=tfplan
terraform apply "tfplan"
```


## commit_86, master

```bash
git checkout master

git branch -v

git merge 22_1-cloud-org-network

git branch -v

git status

git diff \
&& git diff \
--staged

git add . \
&& git status

git log --oneline

git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master \
&& git push \
--set-upstream \
study-fops39_sc \
master

git add . \
&& git status \
&& git commit --amend --no-edit \
&& git push \
--set-upstream \
study_fops39 \
master --force \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master --force \
&& git push \
--set-upstream \
study-fops39_sc \
master --force
```