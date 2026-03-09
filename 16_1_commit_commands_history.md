# Для домашнего задания 16.1
## commit_49, master Предварительная подготовка
```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master

# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/ter-homeworks.git

# Удаление всех файлов и каталогов кроме каталога 01 и его содержимого
find ter-homeworks/ \
-mindepth 1 \
-not -path "*01*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 16_1
mv ter-homeworks/01 16_1

# Переход в каталог по последней переменной вывода последней команды (16_1)
cd !$

# Удаление оставшейся оставшейся части клона репозитория
rm -rf \
../ter-homeworks

# Просмотр текущих удаленных репозиториев
git remote -v

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
git commit -am 'commit_49, master' \
&& git push \
--set-upstream \
altlinux \
main \
&& git push \
--set-upstream \
altlinux_gf \
main
```
