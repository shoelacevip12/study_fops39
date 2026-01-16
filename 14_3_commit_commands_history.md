# Для домашнего задания 14.3
## commit_41, master
```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git switch \
master

# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/sysadm-homeworks.git

# Удаление всех файлов и каталогов кроме 02-git-03-branching и его содержимого
find sysadm-homeworks/ \
-mindepth 1 \
-not -path "*02-git-03-branching*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 14_3
mv sysadm-homeworks/02-git-03-branching 14_3

# Переход в каталог по последней переменной вывода последней команды (14_3)
cd !$

# Удаление оставшейся оставшейся части клона репозитория
rm -rf \
../sysadm-homeworks

# Просмотр текущих удаленных репозиториев
git remote -v

cat > merge.sh <<'EOF'
#!/bin/bash
# display command line options

count=1
for param in "$*"; do
    echo "\$* Parameter #$count = $param"
    count=$(( $count + 1 ))
done
EOF

cp merge.sh \
rebase.sh

git remote -v

git status

git diff \
&& git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_41, master' \
&& git push --set-upstream study_fops39 master
```