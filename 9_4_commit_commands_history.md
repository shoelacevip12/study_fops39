# Для домашнего задания 9.4
### commit_9, master
```bash
git checkout master

git branch -v

cp -r 9_{3,4}

git clone https://github.com/netology-code/smon-homeworks.git

mv -p smon-homeworks/hw-04.md 9_4/README.md

rm -rf smon-homeworks \
9_4/img/* 

cd 9_4

ssh-keygen -f ~/.ssh/id_09-4_ed25519 -t ed25519 -C "9-04"

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

sed -i "8s|.*|      - $(cat ~/.ssh/id_09-3_ed25519.pub)|" cloud-init.yml

rm -rf ANS* \
templates \
tfplan

ansible-galaxy collection install prometheus.prometheus

git clone https://github.com/prometheus-community/ansible.git

rm -rf ansible/.git

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_9, master' \
&& git push --set-upstream study_fops39 master

```