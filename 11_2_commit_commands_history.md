# Для домашнего задания 11.2
### commit_16, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sdb-homeworks.git

find sdb-homeworks/ -mindepth 1 -not -name '11-02.md' -delete

mv sdb-homeworks 11_2

cd 11_2

mv {11-02,README}.md

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_16, master' \
&& git push --set-upstream study_fops39 master
```