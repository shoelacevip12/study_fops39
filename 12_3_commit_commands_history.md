# Для домашнего задания 12.6
## commit_23, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sdb-homeworks.git

find sdb-homeworks/ \
-mindepth 1 \
-not -name '12-06.md' -delete

mv sdb-homeworks 12_6

cd !$

mkdir img mysql_D

mv {12-06,README}.md

git remote -v

git config --global --add safe.directory /home/shoel/nfs_git/gited

git status

git diff \
&& git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_23, master' \
&& git push --set-upstream study_fops39 master
```