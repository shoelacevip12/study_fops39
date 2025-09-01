# Для домашнего задания 9.5
### commit_10, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sflt-homeworks.git

rm -rf sflt-homeworks/{.git,2,2.md,3.md,4.md,README.md}

mv sflt-homeworks 9_5

cd 9_5

mv 1/hsrp_advanced.pkt .

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_10, master' \
&& git push --set-upstream study_fops39 master

```

### commit_1, 9_5-FHRP_VRRP
```bash
git log --oneline

git checkout -b 9_5-FHRP_VRRP

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 9_5-FHRP_VRRP' \
&& git push --set-upstream study_fops39 9_5-FHRP_VRRP