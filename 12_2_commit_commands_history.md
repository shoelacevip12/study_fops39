# Для домашнего задания 12.2
### commit_22, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sdb-homeworks.git

find sdb-homeworks/ \
-mindepth 1 \
-not -name '12-02.md' -delete

mv sdb-homeworks 12_2

cd !$

mkdir img mysql_D

mv {12-02,README}.md

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_22, master' \
&& git push --set-upstream study_fops39 master
```

### commit_1, `12_2-DDL/DML`
```bash
git log --oneline

git checkout -b 12_2-DDL/DML

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 12_2-DDL/DML' \
&& git push --set-upstream study_fops39 12_2-DDL/DML
```