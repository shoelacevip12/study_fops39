# Для домашнего задания 9.7
### commit_15, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sflt-homeworks.git

rm -rf sflt-homeworks/{.git,1,1.md,2,2.md,4.md,README.md}

mv sflt-homeworks 9_7

cd 9_7

mv {3,README}.md

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_15, master' \
&& git push --set-upstream study_fops39 master

```