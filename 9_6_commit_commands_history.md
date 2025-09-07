# Для домашнего задания 9.6
### commit_13, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sflt-homeworks.git

rm -rf sflt-homeworks/{.git,1,1.md,3.md,4.md,README.md}

mv sflt-homeworks 9_6

cd 9_6

mv {2,README}.md

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_13, master' \
&& git push --set-upstream study_fops39 master

```