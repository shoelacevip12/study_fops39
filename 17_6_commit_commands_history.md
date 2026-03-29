# Для домашнего задания 17.6 `Создание собственных модулей`
## commit_60, master Предварительная подготовка
```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master
```
```
Уже на «master»
```
```bash
# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/mnt-homeworks.git

# Удаление всех файлов и каталогов кроме каталога 08-ansible-06-module и его содержимого
find mnt-homeworks/ \
-mindepth 1 \
-not -path "*08-ansible-06-module*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 17_6
mv mnt-homeworks/08-ansible-06-module \
17_6

# Переход в каталог по последней переменной вывода последней команды (17_6)
cd !$

# создание каталогов под скриншоты
mkdir img
```
```
cd 17_6
```
```bash
# Удаление оставшейся оставшейся части клона репозитория
rm -rf \
../mnt-homeworks

# Просмотр текущих удаленных репозиториев
git remote -v

# Проверка текущего локального состояния репозитория
git status

git rm -r --cached \
../

git remote -v

# Добавляем ключи агенту ssh от репозитория gitflic и github
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_gitflic_2026_ed25519 \
&& ssh-add ~/.ssh/id_github_2026_ed25519 \
&& ssh-agent -c

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
git commit -am 'commit_60_, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```
## commit_1, `17_6-ansible-modules`
```bash
