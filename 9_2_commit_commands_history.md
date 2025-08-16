# Для домашнего задания 9.2
### commit_7, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sys-pattern-homework.git

mv  sys-pattern-homework 9_2

rm -rf 9_2/.git

git clone https://github.com/netology-code/smon-homeworks.git

mv smon-homeworks/hw-02.md 9_2/

rm -rf smon-homeworks

cd 9_2

ssh-keygen -f ~/.ssh/id_09-2_ed25519 -t ed25519 -C "9-02"

terraform validate && terraform fmt  && terraform init --upgrade && terraform plan -out=tfplan

cat >cloud-init.yml<<'EOF'
#cloud-config
users:
  - name: skv
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
EOF

cat ~/.ssh/id_09-2_ed25519.pub | sed 's/ssh-/      - ssh-/' >> cloud-init.yml

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_7, master' \
&& git push --set-upstream study_fops39 master

```

### commit_1, 9_2-zabbix
```bash
cd 9_2

git log --oneline

git checkout -b 9_2-zabbix

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 9_2-zabbix' \
&& git push --set-upstream study_fops39 9_2-zabbix
```

### commit_2, 9_2-zabbix
```bash

cd 9_2

terraform validate \
&& terraform fmt  \
&& terraform init --upgrade \
&& terraform plan -out=tfplan

terraform apply "tfplan"

rm ~/.ssh/known_hosts \
; eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_09-2_ed25519 \
&& ssh -o StrictHostKeyChecking=no -i \
~/.ssh/id_09-2_ed25519 -A skv@$(awk 'NR==2' hosts.ini | cut -d' ' -f1) hostnamectl \
&& yc compute instance list

ansible-config init --disabled -t all > ansible.cfg

ansible-playbook test.yml

yc compute instance list

git branch -v \
&& git remote -v

git status

git add . .. \
&& git status

git commit -am 'commit_2, 9_2-zabbix' \
&& git push --set-upstream study_fops39 9_2-zabbix
```

### commit_3, 9_2-zabbix
```bash
cd 9_2

cat >> cloud-init.yml<<'EOF'
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
runcmd:
  - wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-2+ubuntu24.04_all.deb -O /tmp/zabbix-release.deb
  - dpkg -i /tmp/zabbix-release.deb
  - apt-get update
  - apt-get install -y zabbix-agent2 -t noble-backports
  - rm /tmp/zabbix-release.deb
EOF

terraform destroy

terraform validate \
&& terraform fmt  \
&& terraform init --upgrade \
&& terraform plan -out=tfplan

terraform apply "tfplan"

rm ~/.ssh/known_hosts \
; eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_09-2_ed25519 \
&& for d in {120..1}; do \
echo -n "Лучше подождать чем получить ошибку =): $d сек." \
; sleep 1 \
; echo -ne "\r"; done \
&& ssh -o StrictHostKeyChecking=no -i \
~/.ssh/id_09-2_ed25519 -A skv@$(awk 'NR==5' hosts.ini | cut -d' ' -f1) hostnamectl \
&& yc compute instance list

sed -i -e '/^[[:space:]]*\(#\|;\)/d' -e '/^[[:space:]]*$/d' ansible.cfg

ansible-playbook ANS_common.yml
ansible-playbook ANS_zabbix_server.yml
ansible-playbook ANS_zabbix_agent.yml

git branch -v \
&& git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_3, 9_2-zabbix' \
&& git push --set-upstream study_fops39 9_2-zabbix
```
### commit_8, master
```bash
git branch -v

git log --oneline

git status

git diff && git diff --staged

git add . .. \
&& git commit --amend --no-edit \
&& git push --set-upstream study_fops39 9_2-zabbix --force

git checkout master

git branch -v

git merge 9_2-zabbix

git commit

git commit -am 'commit_8, master & 9_2-zabbix merge' && git push study_fops39 master
```