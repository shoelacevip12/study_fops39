# Для домашнего задания 15.4
## commit_46, master
```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git switch \
master

# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/virtd-homeworks.git

# Удаление всех файлов и каталогов кроме 02-git-03-branching и его содержимого
find virtd-homeworks/ \
-mindepth 1 \
-not -path "*05-virt-03-docker-intro*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 14_3
mv virtd-homeworks/05-virt-03-docker-intro 15_4

# Переход в каталог по последней переменной вывода последней команды (14_3)
cd !$

# Удаление оставшейся оставшейся части клона репозитория
rm -rf \
../virtd-homeworks

# Просмотр текущих удаленных репозиториев
git remote -v

git remote remove \
study_fops39_gitlab

git status

git diff \
&& git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_45, master' \
&& git push --set-upstream study_fops39 master \
&& git push --set-upstream study_fops39_gitflic_ru master
```