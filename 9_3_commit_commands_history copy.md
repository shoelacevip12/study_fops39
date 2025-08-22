# Для домашнего задания 9.3
### commit_8, master
```bash
git checkout master

git branch -v

cp -r 9_{2,3}

git clone https://github.com/netology-code/smon-homeworks.git

mv smon-homeworks/hw-03.md 9_3/README.md

rm -rf smon-homeworks \
9_3/img/* 

cd 9_3

ssh-keygen -f ~/.ssh/id_09-3_ed25519 -t ed25519 -C "9-03"

sed -i "8s/.*/      - $(cat ~/.ssh/id_09-3_ed25519.pub)/" cloud-init.yml

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_8, master' \
&& git push --set-upstream study_fops39 master

```

### commit_1, 9_3-zabbix
```bash
cd 9_3

git log --oneline

git checkout -b 9_3-zabbix

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 9_3-zabbix' \
&& git push --set-upstream study_fops39 9_3-zabbix
```

### commit_2, 9_3-zabbix
```bash

cd 9_3

terraform validate \
&& terraform fmt  \
&& terraform init --upgrade \
&& terraform plan -out=tfplan

terraform apply "tfplan"

rm ~/.ssh/known_hosts \
; eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_09-3_ed25519 \
&& for d in {120..1}; do \
echo -n "Лучше подождать чем получить ошибку =): $d сек." \
; sleep 1 \
; echo -ne "\r"; done \
&& ssh -o StrictHostKeyChecking=no -i \
~/.ssh/id_09-2_ed25519 -A skv@$(awk 'NR==5' hosts.ini | cut -d' ' -f1) hostnamectl \
&& yc compute instance list

ansible-playbook ANS_common.yml
ansible-playbook ANS_zabbix_server.yml
ansible-playbook ANS_zabbix_agent.yml
&& yc compute instance list

git branch -v \
&& git remote -v

git status

git add . .. \
&& git status

git commit -am 'commit_2, 9_3-zabbix' \
&& git push --set-upstream study_fops39 9_3-zabbix
```

### commit_9, master
```bash
terraform destroy

git branch -v

git log --oneline

git status

git diff && git diff --staged

git add . .. \
&& git commit --amend --no-edit \
&& git push --set-upstream study_fops39 9_3-zabbix --force

git checkout master

git branch -v

git merge 9_3-zabbix

git commit -am 'commit_9, master & 9_3-zabbix merge' && git push study_fops39 master