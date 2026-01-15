# Для домашнего задания 14.2
## commit_36, master
```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git switch \
master

# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/sysadm-homeworks.git

# Удаление всех файлов и каталогов кроме 02-git-02-base и его содержимого
find sysadm-homeworks/ \
-mindepth 1 \
-not -path "*02-git-02-base*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 14_2
mv sysadm-homeworks/02-git-02-base 14_2

# Переход в каталог по последней переменной вывода последней команды (14_2)
cd !$

# Удаление оставшейся оставшейся части клона репозитория
rm -rf \
../sysadm-homeworks

# Просмотр текущих удаленных репозиториев
git remote -v

# Добавление нового удаленного репозитория gitlab
git remote add \
study_fops39_gitlab \
https://gitlab.com/shoelacevip12-group/study_fops39.git

# Добавление нового удаленного репозитория https://gitflic.ru
git remote add \
study_fops39_gitflic_ru \
https://gitflic.ru/project/shoelacevip12/fops39.git

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

# Создание коммита со всеми изменениями и отправка в удаленные репозиторий
git commit -am 'commit_36_update2, master' \
&& git push --set-upstream study_fops39 master \
&& git push --set-upstream study_fops39_gitlab master \
&& git push --set-upstream study_fops39_gitflic_ru master
```
## commit_37, master
```bash
#  Легковесный тег v0.0
git tag \
v0.0

git commit -am 'commit_37, master' \
&& git push --set-upstream study_fops39 master \
&& git push --set-upstream study_fops39_gitlab master \
&& git push --set-upstream study_fops39_gitflic_ru master
```