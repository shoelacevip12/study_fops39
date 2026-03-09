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