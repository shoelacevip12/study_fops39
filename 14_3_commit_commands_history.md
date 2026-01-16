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

git commit -am 'commit_41_update1, master, prepare for merge and rebase' \
&& git push --set-upstream study_fops39 master
```
## commit_1, git-merge
```bash
git switch -c \
git-merge

cat > merge.sh <<'EOF'
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "\$@ Parameter #$count = $param"
    count=$(( $count + 1 ))
done
EOF

git branch -v

git remote -v

git status

git diff \
&& git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_1, git-merge, merge: @ instead *' \
&& git push \
--set-upstream \
study_fops39 \
git-merge
```
## commit_2, git-merge
```bash
cat > merge.sh <<'EOF'
#!/bin/bash
# display command line options

count=1
while [[ -n "$1" ]]; do
    echo "Parameter #$count = $1"
    count=$(( $count + 1 ))
    shift
done
EOF

git branch -v

git remote -v

git status

git diff \
&& git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_2, git-merge, merge: use shift' \
&& git push \
--set-upstream \
study_fops39 \
git-merge
```
## commit_42, master
```bash
git switch \
master

cat > rebase.sh <<'EOF'
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "\$@ Parameter #$count = $param"
    count=$(( $count + 1 ))
done

echo "====="
EOF

git branch -v

git remote -v

git status

git diff \
&& git diff --staged

git add . .. \
&& git status

git commit -am 'commit_42, master' \
&& git push --set-upstream study_fops39 master
```
## commit_1, git-rebase
```bash
git log --oneline

git checkout \
6c59f83

git switch -c \
git-rebase

cat > rebase.sh <<'EOF'
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "Parameter: $param"
    count=$(( $count + 1 ))
done

echo "====="
EOF

git branch -v

git remote -v

git status

git diff \
&& git diff --staged

git add . .. \
&& git status

git commit -am 'commit_1, git-rebase' \
&& git push --set-upstream study_fops39 git-rebase
```
## commit_2, git-rebase
```bash
sed -i 's/Parameter/Next parameter/' \
rebase.sh

git branch -v

git remote -v

git status

git diff \
&& git diff --staged

git add . .. \
&& git status

git commit -am 'commit_2, git-rebase' \
&& git push --set-upstream study_fops39 git-rebase
```
## commit_43, master_git-merge
```bash
git switch \
master

git branch -v

git merge \
git-merge

git add . .. \
&& git status

git commit -am 'commit_43, master & git-merge' \
&& git push study_fops39 master
```