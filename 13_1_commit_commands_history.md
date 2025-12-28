# Для домашнего задания 13.1
### commit_26, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sdb-homeworks.git

find sdb-homeworks/ \
-mindepth 1 \
-not -name '13-01.md' -delete

mv sdb-homeworks 13_1

cd !$

mkdir img

mv {13-01,README}.md

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_26, master' \
&& git push --set-upstream study_fops39 master
```

### commit_1, `13_1-explo_and_atta`
```bash
git log --oneline

git checkout -b 13_1-explo_and_atta

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 13_1-explo_and_atta' \
&& git push --set-upstream study_fops39 13_1-explo_and_atta
```

### commit_2, `13_1-explo_and_atta`
```bash

```