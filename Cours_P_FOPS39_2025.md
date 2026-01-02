# Для Курсового проекта
### commit_29, master
```bash
git checkout master

git branch -v

mkdir -p ./cours_p{,/img}

cd cours_p

git remote -v

git status

git diff && git diff --staged

git add . \
&& git status

git log --oneline

git commit -am 'commit_29, master' \
&& git push --set-upstream study_fops39 master
```
### commit_1, `cours_fops39_2025`
```bash
git log --oneline

git checkout -b cours_fops39_2025

git branch -v

git remote -v

git status

git log --oneline

git add .

git commit -am 'commit_1, cours_fops39_2025' \
&& git push --set-upstream study_fops39 cours_fops39_2025
```
### commit_2, `cours_fops39_2025` Подготовка и запуск стенда
```bash
# вход в папку проекта
cd cours_p

# генерация ключа ssh для подключения через bastion
ssh-keygen -f \
~/.ssh/id_cours_fops39_2025_ed25519 \
-t ed25519 -C "cours_fops39_2025"

# включаем агента-ssh
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_cours_fops39_2025_ed25519

# содержимое файла cloud-init
cat >cloud-init.yml<<'EOF'
#cloud-config
users:
  - name: skv
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ssh-ed25519
    lock_passwd: false
package_update: true
package_upgrade: true
packages:
  - wget
  - curl
  - gnupg
  - software-properties-common
  - python3-psycopg2
  - acl
  - locales-all
EOF

# Добавляем содержимое публичного ключа в cloud-init.yml
sed -i "8s|.*|      - $(cat ~/.ssh/id_cours_fops39_2025_ed25519.pub)|" cloud-init.yml
```
```bash
git branch -v

git remote -v

git status

git log --oneline

git add . .. \
&& git status

git commit -am 'commit_2, cours_fops39_2025' \
&& git push --set-upstream study_fops39 cours_fops39_2025
```
### commit_3, `cours_fops39_2025` Подготовка и запуск стенда
```bash
```