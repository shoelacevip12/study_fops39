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

```tf
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

### `TF-манифест` переменных для terraform

<details>
<summary>
TF-манифест переменных для terraform
</summary>

```tf
cat > ./variables.tf <<'EOF'
variable "lab22_1" {
  description = "Название лабораторной работы"
  type        = string
  default     = "lab22-1-skv"
}

variable "cloud_id" {
  description = "ID облака"
  type        = string
  default     = "b1g46dhqv17rkjcoc9k7"
}

variable "folder_id" {
  description = "ID папки в облаке"
  type        = string
  default     = "b1g9l0vgsvf6cegkvj1c"
}

variable "default_zone" {
  description = "Зона размещения по умолчанию"
  type        = string
  default     = "ru-central1-a"
}

variable "platform_id" {
  description = "Платформа CPU для всех создаваемых ВМ"
  type        = string
  default     = "standard-v2"
}

variable "disk" {
  description = "Загрузочный диск для всех создаваемых ВМ"
  type        = map(any)
  default = {
    type = "network-hdd"
    size = 20
  }
}

variable "ssh_key_file" {
  description = "Путь к публичному SSH-ключу на компьютере, загружаемому во все ВМ"
  type        = string
  default     = "~/.ssh/id_lab22_1_fops40_ed25519.pub"
}

variable "host" {
  description = "Ресурсы для всех создаваемых ВМ"
  type        = map(number)
  default = {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }
}
EOF
```

</details>

### `TF-манифест` описания сети

<details>
<summary>
TF-манифест описания сети
</summary>

```tf
cat > ./network.tf <<'EOF'
resource "yandex_vpc_network" "skv" {
  description = "Сетевой блок VPC skv-fops40-${var.lab22_1}"
  name        = "skv-fops40-${var.lab22_1}"
}

resource "yandex_vpc_subnet" "public" {
  description    = "Подсеть с правом выхода в WAN"
  name           = "skv-fops-${var.lab22_1}-public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "private" {
  description    = "Подсеть Без права выхода в WAN напрямую"
  name           = "skv-fops-${var.lab22_1}-private"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.route.id
}

resource "yandex_vpc_gateway" "nat-gateway" {
  description = "NAT-шлюз для выхода в WAN из private подсети"
  name        = "fops-gateway-${var.lab22_1}"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "route" {
  description = "Таблица маршрутизации для skv-fops-${var.lab22_1}"
  name        = "fops-route-table-${var.lab22_1}"
  network_id  = yandex_vpc_network.skv.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat-gateway.id
  }
}
EOF
```

</details>

### `TF-манифест` Security Group для terraform

<details>
<summary>
TF-манифест Security Group для terraform
</summary>

```tf
cat > ./security_groups.tf <<'EOF'
resource "yandex_vpc_security_group" "LAN" {
  name       = "LAN-${var.lab22_1}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить весь трафик из внутренних подсетей"
    protocol       = "ANY"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
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
  name       = "host-sg-${var.lab22_1}"
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

</details>

### `TF-манифест` вычислительных ресурсов для terraform

<details>
<summary>
TF-манифест описания ВМ для terraform
</summary>

```tf
cat > ./vms.tf <<'EOF'
data "yandex_compute_image" "ubuntu_2404_lts" {
  family = "ubuntu-2404-lts-oslogin"
}

# Общие метаданные для всех ВМ через locals
locals {
  description = "Указание метаданных через locals до ssh ключа"
  common_metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:${file(var.ssh_key_file)}"
  }
}

resource "yandex_compute_instance" "public-vm" {
  name        = "public-vm"
  hostname    = "public-vm"
  platform_id = var.platform_id
  zone        = var.default_zone

  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = var.disk.type
      size     = var.disk.size
    }
  }

  metadata = local.common_metadata

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat        = true
    security_group_ids = [
      yandex_vpc_security_group.LAN.id,
      yandex_vpc_security_group.host_sg.id
    ]
  }

  allow_stopping_for_update = true

}

resource "yandex_compute_instance" "private-vm" {
  description = "ВМ без прямого выхода в интернет"
  name        = "private-vm"
  hostname    = "private-vm"
  platform_id = var.platform_id
  zone        = var.default_zone

  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = var.disk.type
      size     = var.disk.size
    }
  }

  metadata = local.common_metadata

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    ip_address         = "192.168.20.254"
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id]
  }

  allow_stopping_for_update = true

}
EOF
```

</details>

### `yaml-манифест` cloud-init файла

<details>
<summary>
Yaml-манифест шаблона создания пользователя в группе sudo
</summary>

```yaml
cat > ./cloud-init.yml <<'EOF'
#cloud-config
users:
  - name: skv
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ssh-ed25519 
EOF
```

</details>

```bash
# Добавляем содержимое публичного ключа в cloud-init.yml
sed -i "8s|.*|      - $(cat ~/.ssh/id_lab22_1_fops40_ed25519.pub \
                      | tr -d '\n\r')|" \
cloud-init.yml
```

```bash
# Добавляем в ssh-agent
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_lab22_1_fops40_ed25519
```

<details>
<summary>
Вывод о добавление ssh ключа в агента-ssh
</summary>

```log
Agent pid 50274
Identity added: /home/shoel/.ssh/id_lab22_1_fops40_ed25519 (lab22_1_fops40)
```

</details>

### Запуск terraform проекта

```bash
# Проверка tf файлов проекта
terraform init --upgrade \
&& terraform validate
```

<details>
<summary>
Лог об успешности проверок terraform и tf-файлов
</summary>

```log
Initializing the backend...

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Using previously-installed yandex-cloud/yandex v0.224.0


Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Success! The configuration is valid.
```

</details>

```bash
# Авто-форматирование конфига и создание файла запуска terraform
terraform fmt \
&& terraform plan -out=tfplan
```

<details>
<summary>
Лог об успешности создания файла запуска terraform
</summary>

```log
data.yandex_compute_image.ubuntu_2404_lts: Reading...
data.yandex_compute_image.ubuntu_2404_lts: Read complete after 0s [id=fd819nnsamg64h4gup91]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.private-vm will be created
  + resource "yandex_compute_instance" "private-vm" {
      + created_at                = (known after apply)
      + description               = "ВМ без прямого выхода в интернет"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hardware_generation       = (known after apply)
      + hostname                  = "private-vm"
      + id                        = (known after apply)
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "ssh-keys"           = <<-EOT
                ubuntu:ssh-ed25519 AAAAxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxJ4I lab22_1_fops40
            EOT
        }
      + name                      = "private-vm"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + reserved_instance_pool_id = (known after apply)
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
              + image_id    = "fd819nnsamg64h4gup91"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options (known after apply)

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "192.168.20.254"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy (known after apply)

      + resources {
          + core_fraction = 20
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy (known after apply)
    }

  # yandex_compute_instance.public-vm will be created
  + resource "yandex_compute_instance" "public-vm" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hardware_generation       = (known after apply)
      + hostname                  = "public-vm"
      + id                        = (known after apply)
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "ssh-keys"           = <<-EOT
                ubuntu:ssh-ed25519 AAAAxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxJ4I lab22_1_fops40
            EOT
        }
      + name                      = "public-vm"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + reserved_instance_pool_id = (known after apply)
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
              + image_id    = "fd819nnsamg64h4gup91"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options (known after apply)

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "192.168.10.254"
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
          + core_fraction = 20
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy (known after apply)
    }

  # yandex_vpc_gateway.nat-gateway will be created
  + resource "yandex_vpc_gateway" "nat-gateway" {
      + created_at  = (known after apply)
      + description = "NAT-шлюз для выхода в WAN из private подсети"
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + labels      = (known after apply)
      + name        = "fops-gateway-lab22-1-skv"

      + shared_egress_gateway {}
    }

  # yandex_vpc_network.skv will be created
  + resource "yandex_vpc_network" "skv" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + description               = "Сетевой блок VPC skv-fops40-lab22-1-skv"
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "skv-fops40-lab22-1-skv"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_route_table.route will be created
  + resource "yandex_vpc_route_table" "route" {
      + created_at  = (known after apply)
      + description = "Таблица маршрутизации для skv-fops-lab22-1-skv"
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + labels      = (known after apply)
      + name        = "fops-route-table-lab22-1-skv"
      + network_id  = (known after apply)

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
      + name       = "LAN-lab22-1-skv"
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
          + description       = "Разрешить весь трафик из внутренних подсетей"
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + protocol          = "ANY"
          + to_port           = 65535
          + v4_cidr_blocks    = [
              + "192.168.10.0/24",
              + "192.168.20.0/24",
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
      + name       = "host-sg-lab22-1-skv"
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

  # yandex_vpc_subnet.private will be created
  + resource "yandex_vpc_subnet" "private" {
      + created_at     = (known after apply)
      + description    = "Подсеть Без права выхода в WAN напрямую"
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "skv-fops-lab22-1-skv-private"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.20.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.public will be created
  + resource "yandex_vpc_subnet" "public" {
      + created_at     = (known after apply)
      + description    = "Подсеть с правом выхода в WAN"
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "skv-fops-lab22-1-skv-public"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 9 to add, 0 to change, 0 to destroy.
```

</details>

```bash
# Запуск Создания ресурсов на YC
terraform apply "tfplan"
```

<details>
<summary>
Ход создания ресурсов на YC
</summary>

```log
yandex_vpc_gateway.nat-gateway: Creating...
yandex_vpc_network.skv: Creating...
yandex_vpc_gateway.nat-gateway: Creation complete after 1s [id=enpkq1jlcvlb6iofareo]
yandex_vpc_network.skv: Creation complete after 2s [id=enpg2jii5afnfktqrqt6]
yandex_vpc_route_table.route: Creating...
yandex_vpc_subnet.public: Creating...
yandex_vpc_security_group.LAN: Creating...
yandex_vpc_security_group.host_sg: Creating...
yandex_vpc_subnet.public: Creation complete after 0s [id=e9bpquqkru20qaj1lom9]
yandex_vpc_security_group.host_sg: Creation complete after 1s [id=enpg32ctjjru6qm7n4kj]
yandex_vpc_route_table.route: Creation complete after 1s [id=enpamd9ip0dksrhrkj3o]
yandex_vpc_subnet.private: Creating...
yandex_vpc_subnet.private: Creation complete after 1s [id=e9btu42kbaln886ou0dq]
yandex_vpc_security_group.LAN: Creation complete after 3s [id=enprib1iqm70qou1v096]
yandex_compute_instance.private-vm: Creating...
yandex_compute_instance.public-vm: Creating...
yandex_compute_instance.private-vm: Creation complete after 41s [id=fhmvlml14kcgc4ogvt7k]
yandex_compute_instance.public-vm: Creation complete after 44s [id=fhm79ea7mrf345d8iuji]
```

</details>

### Информация после развертывания

```bash
# Чтение об IP адресации из terraform.tfstate
terraform show | grep -B8  nat_ip_address
```

<details>
<summary>
Чтение об IP адресации из terraform.tfstate
</summary>

```log
    network_interface {
        index              = 0
        ip_address         = "192.168.20.254"
        ipv4               = true
        ipv6               = false
        ipv6_address       = null
        mac_address        = "d0:0d:1f:ad:aa:12"
        nat                = false
        nat_ip_address     = null
--
    network_interface {
        index              = 0
        ip_address         = "192.168.10.254"
        ipv4               = true
        ipv6               = false
        ipv6_address       = null
        mac_address        = "d0:0d:74:b9:47:b6"
        nat                = true
        nat_ip_address     = "51.250.64.44"
```

</details>

```bash
# Вывод информации о вычислительных ресурсах
yc compute instance list
```

<details>
<summary>
Вывод информации о вычислительных ресурсах
</summary>

```log
+----------------------+------------+---------------+---------+--------------+----------------+
|          ID          |    NAME    |    ZONE ID    | STATUS  | EXTERNAL IP  |  INTERNAL IP   |
+----------------------+------------+---------------+---------+--------------+----------------+
| fhm79ea7mrf345d8iuji | public-vm  | ru-central1-a | RUNNING | 51.250.64.44 | 192.168.10.254 |
| fhmvlml14kcgc4ogvt7k | private-vm | ru-central1-a | RUNNING |              | 192.168.20.254 |
+----------------------+------------+---------------+---------+--------------+----------------+
```

</details>

```bash
# Вывод информации о созданных сетях
yc vpc subnet list
```

<details>
<summary>
Вывод информации о созданных сетях
</summary>

```log
+----------------------+------------------------------+----------------------+----------------------+---------------+-------------------+
|          ID          |             NAME             |      NETWORK ID      |    ROUTE TABLE ID    |     ZONE      |       RANGE       |
+----------------------+------------------------------+----------------------+----------------------+---------------+-------------------+
| e9bpquqkru20qaj1lom9 | skv-fops-lab22-1-skv-public  | enpg2jii5afnfktqrqt6 |                      | ru-central1-a | [192.168.10.0/24] |
| e9btu42kbaln886ou0dq | skv-fops-lab22-1-skv-private | enpg2jii5afnfktqrqt6 | enpamd9ip0dksrhrkj3o | ru-central1-a | [192.168.20.0/24] |
+----------------------+------------------------------+----------------------+----------------------+---------------+-------------------+
```

</details>

```bash
# Вывод базовой информации о таблицы маршрутизации
yc vpc route-table list
```

<details>
<summary>
Вывод базовой информации о таблицы маршрутизации
</summary>

```log
+----------------------+------------------------------+--------------------------------+----------------------+
|          ID          |             NAME             |          DESCRIPTION           |      NETWORK-ID      |
+----------------------+------------------------------+--------------------------------+----------------------+
| enpamd9ip0dksrhrkj3o | fops-route-table-lab22-1-skv | Таблица маршрутизации для      | enpg2jii5afnfktqrqt6 |
|                      |                              | skv-fops-lab22-1-skv           |                      |
+----------------------+------------------------------+--------------------------------+----------------------+
```

</details>

```bash
# Вывод информации о созданных шлюзах
yc vpc gateway list
```

<details>
<summary>
Вывод информации о созданных шлюзах
</summary>

```log
+----------------------+--------------------------+--------------------------------+
|          ID          |           NAME           |          DESCRIPTION           |
+----------------------+--------------------------+--------------------------------+
| enpkq1jlcvlb6iofareo | fops-gateway-lab22-1-skv | NAT-шлюз для выхода в WAN из   |
|                      |                          | private подсети                |
+----------------------+--------------------------+--------------------------------+
```

</details>

### Проверки опроса IP WAN

```bash
# Скрипт запроса IP выхода в WAN сеть из public сети
ssh -t \
-o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_lab22_1_fops40_ed25519 skv@51.250.64.44 \
"for d in {1..7}; do \
echo \"Проверка NAT из PUBLIC сети- \$d\" \
&& sleep 3 \
&& curl -s 2ip.io; done"
```

<details>
<summary>
Проверка ip-NAT выхода из ВМ с интерфейсом nat = true
</summary>

```log
Warning: Permanently added '51.250.64.44' (ED25519) to the list of known hosts.
Проверка NAT из PUBLIC сети- 1
51.250.64.44
Проверка NAT из PUBLIC сети- 2
51.250.64.44
Проверка NAT из PUBLIC сети- 3
51.250.64.44
Проверка NAT из PUBLIC сети- 4
51.250.64.44
Проверка NAT из PUBLIC сети- 5
51.250.64.44
Проверка NAT из PUBLIC сети- 6
51.250.64.44
Проверка NAT из PUBLIC сети- 7
51.250.64.44
Connection to 51.250.64.44 closed.
```

</details>

```bash
# Скрипт запроса IP выхода в WAN сеть из private сети
ssh -t \
-o StrictHostKeyChecking=accept-new \
-o "ProxyCommand ssh -o StrictHostKeyChecking=accept-new -W %h:%p -i ~/.ssh/id_lab22_1_fops40_ed25519 skv@51.250.64.44" \
-i ~/.ssh/id_lab22_1_fops40_ed25519 \
-o IdentitiesOnly=yes \
skv@192.168.20.254 \
"for d in {1..7}; do \
echo \"Проверка шлюза NAT из privat сети- \$d\" \
&& sleep 3 \
&& curl -s 2ip.io; done"
```

<details>
<summary>
Проверка ip-NAT выхода из ВМ из private сети через шлюз-> NAT-gateway
</summary>

```log
Warning: Permanently added '192.168.20.254' (ED25519) to the list of known hosts.
Проверка шлюза NAT из privat сети- 1
51.250.124.42
Проверка шлюза NAT из privat сети- 2
178.154.236.25
Проверка шлюза NAT из privat сети- 3
51.250.124.25
Проверка шлюза NAT из privat сети- 4
51.250.53.36
Проверка шлюза NAT из privat сети- 5
51.250.53.41
Проверка шлюза NAT из privat сети- 6
51.250.124.4
Проверка шлюза NAT из privat сети- 7
178.154.236.118
Connection to 192.168.20.254 closed.
```

</details>

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit3, 22_1-cloud-org-network' \
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