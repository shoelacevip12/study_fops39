# Для домашнего задания 14.1
### commit_32, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sysadm-homeworks.git

find sysadm-homeworks/ \
-mindepth 1 \
-not -path "*02-git-01-vcs*" \
-delete

mv sysadm-homeworks/02-git-01-vcs 14_1

cd !$

rm -rf \
../sysadm-homeworks

git remote -v

git remote add \
study_fops39 \
https://github.com/shoelacevip12/study_fops39.git

git status

git remote -v

git diff \
&& git diff --staged

git add . .. \
&& git status

git diff \
&& git diff --staged

git log --oneline

git commit -am 'commit_32, master' \
&& git push --set-upstream study_fops39 master
```
