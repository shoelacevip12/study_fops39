# Для Курсового проекта
### commit_29, master
```bash
git checkout master

git branch -v

mkdir -p ./cours_p{,/img}

cd cours_p

git remote -v

git status

git diff && git diff --staged

git add . \
&& git status

git log --oneline

git commit -am 'commit_29, master' \
&& git push --set-upstream study_fops39 master
```
### commit_1, `cours_fops39_2025`
```bash
git log --oneline

git checkout -b cours_fops39_2025

git branch -v

git remote -v

git status

git log --oneline

git add .

git commit -am 'commit_1, cours_fops39_2025' \
&& git push --set-upstream study_fops39 cours_fops39_2025
```
### commit_2, `cours_fops39_2025`