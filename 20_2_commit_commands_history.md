# Для домашнего задания 20.2 `Микросервисы: принципы`

## commit_70, master Предварительная подготовка

```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master
```

<details>
<summary>
переход на master
</summary>

```log
Уже на «master»
```

</details>

```bash
# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/micros-homeworks.git

# Удаление всех файлов и каталогов кроме 11-microservices-02-principles
find micros-homeworks/ \
-mindepth 1 \
-not -path "*11-microservices-02-principles*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 20_2
mv -v micros-homeworks \
20_2

# Переход в каталог по последней переменной вывода последней команды (20_2)
cd !$
```

```bash
# Просмотр текущих удаленных репозиториев
git remote -v

# Добавление удаленного репозитория на sourcecraft.dev 
git remote \
add study-fops39_sc \
ssh://ssh.sourcecraft.dev/shoelacevip12/study-fops39.git

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
git commit -am 'commit_70, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master \
&& git push \
--set-upstream \
study-fops39_sc \
master
```
