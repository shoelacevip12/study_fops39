# Для домашнего задания 18.5 `Teamcity`
## commit_62, master Предварительная подготовка
```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master
```
<details>
<summary>переход на master</summary>

```log
Уже на «master»
```

</details>

```bash
# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/mnt-homeworks.git

# Удаление всех файлов и каталогов кроме каталога 09-ci-05-teamcity и его содержимого
find mnt-homeworks/ \
-mindepth 1 \
-not -path "*09-ci-05-teamcity*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 18_5
mv mnt-homeworks/09-ci-05-teamcity \
18_5

# Переход в каталог по последней переменной вывода последней команды (18_5)
cd !$
```

<details>
<summary>cd в рабочую директорию</summary>

```log
cd 18_5
```

</details>

```bash
# создание каталогов под скриншоты
mkdir img
```

```bash
# Удаление оставшейся оставшейся части клона репозитория
rm -rfv \
../mnt-homeworks
```

<details>
<summary>Удаление лишнего для Задания</summary>

```log
../mnt-homeworks
удалён каталог '../mnt-homeworks'
```

</details>

```bash
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
git commit -am 'commit_62_1, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```
## commit_1, `18_5-Teamcity`
```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 18_5-Teamcity

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавляем ключи агенту ssh от репозитория gitflic и github
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_gitflic_2026_ed25519 \
&& ssh-add ~/.ssh/id_github_2026_ed25519 \
&& ssh-agent -c

# Просмотр различий в рабочей директории и индексов
git diff \
&& git diff --staged

git rm -r --cached \
./ ../

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit1, 18_5-ansible-modules' \
&& git push \
--set-upstream \
study_fops39 \
18_5-ansible-modules \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
18_5-ansible-modules
```