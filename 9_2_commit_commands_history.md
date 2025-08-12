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