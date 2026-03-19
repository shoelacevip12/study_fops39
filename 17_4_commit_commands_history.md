# Для домашнего задания 17.4 `Работа с roles`
## commit_56, master Предварительная подготовка
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

# Удаление всех файлов и каталогов кроме каталога 08-ansible-04-role и его содержимого
find mnt-homeworks/ \
-mindepth 1 \
-not -path "*08-ansible-04-role*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 17_4
mv mnt-homeworks/08-ansible-04-role \
17_4

# Переход в каталог по последней переменной вывода последней команды (17_4)
cd !$

# создание каталогов под скриншоты
mkdir img

```
```
cd 17_4
```
```bash
# Удаление оставшейся оставшейся части клона репозитория
rm -rf \
../mnt-homeworks

# Просмотр текущих удаленных репозиториев
git remote -v

# Проверка текущего локального состояния репозитория
git status

git remote -v

# Генерация ключа для работы с gitflic
ssh-keygen -f ~/.ssh/id_gitflic_2026_ed25519 \
-t ed25519 \
-C "gitflic_2026"

# Удаление источника авторизации по https для gitflic
git remote rm \
study_fops39_gitflic_ru

# Добавление источника для авторизации на gitflic по ssh
git remote add \
study_fops39_gitflic_ru \
git@gitflic.ru:shoelacevip12/fops39.git

# Генерация ключа для работы с github
ssh-keygen -f ~/.ssh/id_github_2026_ed25519 \
-t ed25519 \
-C "github_2026"

# Через консоль gh добавляем публичный ключ для подключения
gh ssh-key \
add ~/.ssh/id_github_2026_ed25519.pub

# Удаление источника авторизации по https для github
git remote rm \
study_fops39

# Добавление источника для авторизации на github по ssh
git remote add \
study_fops39 \
git@github.com:shoelacevip12/study_fops39.git

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
git commit -am 'commit_56_upd2, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```
## commit_1, `17_4-ansible_role`
