# Для домашнего задания 16.2
## commit_52, master Предварительная подготовка
```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master
```
```
Уже на «master»
Эта ветка соответствует «study_fops39_gitflic_ru/master».
```
```bash
# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/ter-homeworks.git

# Удаление всех файлов и каталогов кроме каталога 02 и его содержимого
find ter-homeworks/ \
-mindepth 1 \
-not -path "*02*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 16_2
mv ter-homeworks/02 16_2

# Переход в каталог по последней переменной вывода последней команды (16_2)
cd !$
```
```
cd 16_2
```
```bash
# Удаление оставшейся оставшейся части клона репозитория
rm -rf \
../ter-homeworks

# Просмотр текущих удаленных репозиториев
git remote -v

# Проверка текущего локального состояния репозитория
git status
```
```
Текущая ветка: master
Эта ветка соответствует «study_fops39_gitflic_ru/master».

Изменения, которые не в индексе для коммита:
  (используйте «git add/rm <файл>...», чтобы добавить или удалить файл из индекса)
  (используйте «git restore <файл>...», чтобы отменить изменения в рабочем каталоге)
        удалено:       ../16_1/tf_2/hosts_docker.sh

Неотслеживаемые файлы:
  (используйте «git add <файл>...», чтобы добавить в то, что будет включено в коммит)
        ./
        ../16_2_commit_commands_history.md

индекс пуст (используйте «git add» и/или «git commit -a»)
```
```bash
# для отмены изменений в каталоге
git restore \
./16_1/tf_2/hosts_docker.sh

# Проверка что что файл прошлой работы hosts_docker.sh был исключен для изменений
git status
```
```
Текущая ветка: master
Эта ветка соответствует «study_fops39_gitflic_ru/master».

Неотслеживаемые файлы:
  (используйте «git add <файл>...», чтобы добавить в то, что будет включено в коммит)
        ./
        ../16_2_commit_commands_history.md

индекс пуст, но есть неотслеживаемые файлы
(используйте «git add», чтобы проиндексировать их)
```
```bash
git remote -v

# Просмотр различий в рабочей директории и индексов
git diff \
&& git diff --staged

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . \
&& git status
```
```
Текущая ветка: master
Эта ветка соответствует «study_fops39_gitflic_ru/master».

Изменения, которые будут включены в коммит:
  (используйте «git restore --staged <файл>...», чтобы убрать из индекса)
        новый файл:    demo/demostration1.tf
        новый файл:    demo/demostration2.tf
        новый файл:    demo/providers.tf
        новый файл:    hw-02.md
        новый файл:    src/.gitignore
        новый файл:    src/.terraformrc
        новый файл:    src/console.tf
        новый файл:    src/locals.tf
        новый файл:    src/main.tf
        новый файл:    src/outputs.tf
        новый файл:    src/providers.tf
        новый файл:    src/variables.tf

Неотслеживаемые файлы:
  (используйте «git add <файл>...», чтобы добавить в то, что будет включено в коммит)
        ../16_2_commit_commands_history.md
```
```bash
git diff \
&& git diff --staged

# Просмотр истории коммитов в кратком формате
git log --oneline

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий
git commit -am 'commit_52, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```
## commit_1, `16_2-terr_osnovy`
```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 16_2-terr_osnovy

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . ../16_2_commit_commands_history.md \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am '16_2-terr_osnovy' \
&& git push \
--set-upstream \
study_fops39 \
16_2-terr_osnovy \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
16_2-terr_osnovy
```
## commit_2, `16_2-terr_osnovy`