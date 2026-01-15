# Для домашнего задания 14.1
## commit_32, master
```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master

# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/sysadm-homeworks.git

# Удаление всех файлов и каталогов кроме 02-git-01-vcs и его содержимого
find sysadm-homeworks/ \
-mindepth 1 \
-not -path "*02-git-01-vcs*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 14_1
mv sysadm-homeworks/02-git-01-vcs 14_1

# Переход в каталог по последней переменной вывода последней команды (14_1)
cd !$

# Удаление оставшейся оставшейся части клона репозитория
rm -rf \
../sysadm-homeworks

# Просмотр текущих удаленных репозиториев
git remote -v

# Добавление нового удаленного репозитория
study_fops39 \
https://github.com/shoelacevip12/study_fops39.git

# Проверка текущего локального состояния репозитория
git status

git remote -v

# Просмотр различий в рабочей директории и индексов
git diff \
&& git diff --staged

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status


git diff \
&& git diff --staged

# Просмотр истории коммитов в кратком формате
git log --oneline

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий
git commit -am 'commit_32, master' \
&& git push --set-upstream study_fops39 master
```
## commit_33, master
```bash
# Создание файла .gitignore в родительском каталоге репозитория
cat > ../.gitignore <<'EOF'
# Игнорировать всю папку:
cache/
.vagrant/
__pycache__/
mysql_D/
master/db/
slave/db/
.terraform/
collections/
galaxy_cache/
tmp/
.vscode/

# игнорировать расширения и файлы:
*.deb
authorized_key.json
.terraform.lock.hcl
tfplan
terraform.tfstate
terraform.tfstate.backup
cloud-init.yml
.terraform.*

# Исключения
!9_*/cloud-init.yml
EOF

git branch -v \
&& git remote -v

git status

echo "$(git log --oneline)" \
| head

git add . .. \
&& git status

git diff \
&& git diff --staged

git commit -am 'commit_33, master' \
&& git push --set-upstream study_fops39 master
```
## commit_34, master
```bash

echo "will_be_deleted" \
> will_be_deleted.txt

echo "will_be_moved" \
> will_be_moved.txt

git add . .. \
&& git status

git commit -am 'commit_34, master, Prepare to delete and move' \
&& git push --set-upstream study_fops39 master
```