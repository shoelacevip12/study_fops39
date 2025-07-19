### Начало работы
git init

git add README.md

touch commit_commands_history

git config --global user.email "shoelacevip21@gmail.com"

git config --global user.name "shoelacevip12"

### Форк ДЗ-8_1
git clone https://github.com/netology-code/sys-pattern-homework.git

mkdir  8_1

mv sys-pattern-homework/* 8_1/

rm  -rf sys-pattern-homework

git diff && git diff --staged

git add .

### commit_1
git commit -m 'Конфиг без VerConSys не существующий конфиг'

git branch -M master

git remote add study_fops39 https://github.com/shoelacevip12/study_fops39.git

git remote -v

git diff && git diff --staged

git add .

git commit --amend --no-edit

git push --set-upstream study_fops39 master