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

### commit_2

echo -e "# Игнорировать все файлы .pyc\n*.pyc\n\n# Игнорировать всю папку cache\ncache/" > \.gitignore

git add .

git diff && git diff --staged

git commit -am 'commit_2' && git push study_fops39 master

### commit 3, dev

git checkout -b dev

git branch -v

```cat > 8_1/test.sh << 'EOF'
#!/bin/bash

# Random Password Generator
generate_password() {
    local length=${1:-12}
    tr -dc 'A-Za-z0-9!@#$%^&*()' < /dev/urandom | head -c "$length"
    echo
}

# Вызов функции с длиной пароля (по умолчанию 12)
generate_password "$@"
EOF```

git status

git diff && git diff --staged

git add .

git commit -am 'commit_3, dev' && git push study_fops39 dev

### commit 4, dev

git commit -am 'commit_4, dev' && git push study_fops39 dev

### commit 5, dev

git status

git diff && git diff --staged

git log --oneline

git commit -am 'commit_5, dev' && git push study_fops39 dev

### commit 6, dev

git status

git diff && git diff --staged

git log --oneline

git commit -am 'commit_6, fix commit_5, dev' && git push study_fops39 dev