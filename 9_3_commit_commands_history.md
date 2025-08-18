# Для домашнего задания 9.2
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