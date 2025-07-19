### Начало работы
```bash
git init

git add README.md

touch commit_commands_history

git config --global user.email "shoelacevip21@gmail.com"

git config --global user.name "shoelacevip12"
```
### Форк ДЗ-8_1
```bash
git clone https://github.com/netology-code/sys-pattern-homework.git

mkdir  8_1

mv sys-pattern-homework/* 8_1/

rm  -rf sys-pattern-homework

git diff && git diff --staged

git add .
```
### commit_1
```bash
git commit -m 'Конфиг без VerConSys не существующий конфиг'

git branch -M master

git remote add study_fops39 https://github.com/shoelacevip12/study_fops39.git

git remote -v

git diff && git diff --staged

git add .

git commit --amend --no-edit

git push --set-upstream study_fops39 master
```
### commit_2
```bash
echo -e "# Игнорировать все файлы .pyc\n*.pyc\n\n# Игнорировать всю папку cache\ncache/" > \.gitignore

git add .

git diff && git diff --staged

git commit -am 'commit_2' && git push study_fops39 master
```
### commit_3, master
```bash
git checkout master

git branch -v

cat > 8_1/main.sh << 'EOF'
#!/bin/bash

#Обновление Arch и очистка кеша pacman

if [ "$(id -u)" -ne 0 ]; then
    echo "Запустить от суперпользователя"
    exit 1
fi

echo "Обновление базы данных пакетов..."
pacman -Sy

echo "Запуск полного обновления системы..."
pacman -Su --noconfirm

echo "Очистка кеша pacman..."
pacman -Sc --noconfirm

echo  "Дополнительная очистка (удаляет ВСЕ пакеты из кеша)"
pacman -Scc --noconfirm

echo "Удаление неиспользуемых зависимостей..."
pacman -Rns $(pacman -Qdtq) --noconfirm 2>/dev/null

echo "Обновление и очистка завершены!"
EOF

cat >> .gitignore << 'EOF'

# Игнорировать файл истории команд
commit_commands_history.md
EOF

git status

git diff && git diff --staged

git add .

git log --oneline

git commit -am 'commit_3, master' && git push study_fops39 master
```

### commit_4, master
```bash
git branch -v

git log --oneline

git status

git diff && git diff --staged

git add . && git commit --amend --no-edit

git push --force study_fops39 master

git merge dev --no-commit

git reset -- commit_commands_history.md

git checkout -- commit_commands_history.md

git commit

git commit -am 'commit_4, master&dev merge' && git push study_fops39 master
```