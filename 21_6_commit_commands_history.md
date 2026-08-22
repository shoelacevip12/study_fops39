# Для домашнего задания 21.5 `Helm`

## commit_81, master Предварительная подготовка

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
https://github.com/netology-code/kuber-homeworks.git

cd kuber-homeworks

git config \
--global \
--add safe.directory \
/home/shoel/nfs_git/gited/kuber-homeworks

git checkout shkuber-16

cd ..

# Удаление всех файлов и каталогов кроме нужных
find kuber-homeworks/ \
-mindepth 1 \
-not -path "*2.4*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем
mv -v kuber-homeworks \
21_6

# Переход в каталог по последней переменной вывода последней команды
cd !$

mv -v 2.4/* ./

# Удаление всех файлов и каталогов кроме нужных
find . \
-mindepth 1 \
-not -path "*2.4.md*" \
-delete

# Переименование 
mv -v {2.4,README}.md
```

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
git commit -am 'commit_81, master' \
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

## commit_1, `21_6-helm`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 21_6-helm

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
git commit -am 'commit1, 21_6-helm' \
&& git push \
--set-upstream \
study_fops39 \
21_6-helm \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_6-helm \
&& git push \
--set-upstream \
study-fops39_sc \
21_6-helm
```

## commit_2,`21_6-helm`

```bash
# Поиск пакетов в репозиториях archlinux
sudo pacman -Ss helm
```

<Details>
<Summary>
Поиск пакетов в репозиториях archlinux
</Summary>

```log
extra/datree 1.9.19-2
    CLI tool to ensure K8s manifests and Helm charts follow best practices as well as your organization’s policies
extra/gap-packages 4.16.0-2
    Extra packages for GAP
extra/helm 4.2.2-1
    The Kubernetes Package Manager
extra/helmfile 1.5.2-1
    Manage multiple helm charts with a single helmfile
extra/kube-linter 0.8.3-1
    Static analysis tool that checks Kubernetes YAML files and Helm charts
extra/texlive-mathscience 2026.1-1 (texlive)
    TeX Live - Mathematics, natural sciences, computer science packages
extra/vals 0.43.2-1
    Helm-like configuration values loader with support for various sources
```

</Details>

```bash
# Установка пакетов helm и kube-linter
sudo pacman -Syu \
helm \
kube-linter
```

<details>
<summary>
Установка пакетов helm и kube-linter
</summary>

```log
...
проверка конфликтов...

Пакеты (3) wine-11.16-1  helm-4.2.2-1  kube-linter-0.8.3-1

Будет загружено:    112,21 MiB
Будет установлено:  740,14 MiB
Изменение размера:  140,05 MiB

:: Приступить к установке? [Y/n] Y
:: Получение пакетов...
 kube-linter-0.8.3-1-x86_64   15,6 MiB   193 KiB/s 01:23 [#####################] 100%
 helm-4.2.2-1-x86_64          18,5 MiB   172 KiB/s 01:50 [#####################] 100%
 ...
```

</details>

```bash
helm version
```

<details>
<summary>
Вывод версии helm
</summary>

```log
version.BuildInfo{Version:"v4.2.2", GitCommit:"b05881cf967a5a09e19866799d0edfd40675803a", GitTreeState:"", GoVersion:"go1.26.4-X:nodwarf5", KubeClientVersion:"v1.36"}
```

</details>