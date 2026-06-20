# Для домашнего задания 19.1 `Системы мониторинга`

## commit_64, master Предварительная подготовка

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
https://github.com/netology-code/mnt-homeworks.git

# Удаление всех файлов и каталогов кроме каталога 10-monitoring-02-systems и его содержимого
find mnt-homeworks/ \
-mindepth 1 \
-not -path "*10-monitoring-02-systems*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 19_1
mv mnt-homeworks/10-monitoring-02-systems \
19_1

# Переход в каталог по последней переменной вывода последней команды (19_1)
cd !$
```

<details>
<summary>
cd в рабочую директорию
</summary>

```log
cd 19_1
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
<summary>
Удаление лишнего для Задания
</summary>

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
git commit -am 'commit_64_1, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```

## commit_1, `19_1-monitoring_base`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 19_1-monitoring_base

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
git commit -am 'commit1, 19_1-monitoring_base' \
&& git push \
--set-upstream \
study_fops39 \
19_1-monitoring_base \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
19_1-monitoring_base
```

## commit_2, `19_1-monitoring_base`

```bash
cd ~/

git clone https://github.com/influxdata/sandbox.git

cd sandbox

rm -rf .git

sudo systemctl start docker.service
```

```bash
stat -c '%g' /var/run/docker.sock
```

<details>
<summary>
Вывод id группы владельца /var/run/docker.sock
</summary>

```log
959
```

</details>

```bash
sed -i '/image: "telegraf"/a\    group_add:' \
docker-compose.yml

sed -i '/group_add:/a\      - 959' \
docker-compose.yml

sed -i '/perdevice = true/d' \
./telegraf/telegraf.conf

sed -i '/total = false/d' \
./telegraf/telegraf.conf

sed -i 's/container_names/container_name_include/' \
./telegraf/telegraf.conf
```

```bash
mkdir -p kapacitor/data

chmod 777 kapacitor/data

mkdir -p chronograf/data

chmod 777 chronograf/data/

mkdir -p chronograf/data/backup

chmod 777 chronograf/data/

./sandbox up

./sandbox up
```

<details>
<summary>
Лог Запуска стека
</summary>

```log
Using latest, stable releases
Spinning up Docker Images...
If this is your first time starting sandbox this might take a minute...
WARN[0000] /home/shoel/nfs_git/gited/19_1/sandbox/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Building 1.5s (38/38) FINISHED                                                                                     
 => [internal] load local bake definitions                                                                        0.0s
 => => reading from stdin 2.76kB                                                                                  0.0s
 => [documentation internal] load build definition from Dockerfile                                                0.1s
 => => transferring dockerfile: 251B                                                                              0.0s
 => [telegraf internal] load build definition from Dockerfile                                                     0.0s
 => => transferring dockerfile: 83B                                                                               0.0s
 => WARN: InvalidDefaultArgInFrom: Default value for ARG telegraf:$TELEGRAF_TAG results in empty or invalid base  0.0s
 => [chronograf internal] load build definition from Dockerfile                                                   0.1s
 => => transferring dockerfile: 199B                                                                              0.0s
 => WARN: InvalidDefaultArgInFrom: Default value for ARG chronograf:$CHRONOGRAF_TAG results in empty or invalid   0.1s
 => [kapacitor internal] load build definition from Dockerfile                                                    0.1s
 => => transferring dockerfile: 85B                                                                               0.0s
 => [influxdb internal] load build definition from Dockerfile                                                     0.1s
 => => transferring dockerfile: 83B                                                                               0.0s
 => WARN: InvalidDefaultArgInFrom: Default value for ARG influxdb:$INFLUXDB_TAG results in empty or invalid base  0.1s
 => [telegraf internal] load metadata for docker.io/library/telegraf:latest                                       0.0s
 => [telegraf internal] load .dockerignore                                                                        0.1s
 => => transferring context: 2B                                                                                   0.0s
 => [documentation internal] load metadata for docker.io/library/alpine:3.12                                      0.6s
 => [chronograf internal] load metadata for docker.io/library/chronograf:latest                                   0.6s
 => [kapacitor internal] load metadata for docker.io/library/kapacitor:latest                                     0.0s
 => [kapacitor internal] load .dockerignore                                                                       0.0s
 => => transferring context: 2B                                                                                   0.0s
 => [influxdb internal] load metadata for docker.io/library/influxdb:1.8                                          0.6s
 => CACHED [telegraf 1/1] FROM docker.io/library/telegraf:latest                                                  0.0s
 => CACHED [kapacitor 1/1] FROM docker.io/library/kapacitor:latest                                                0.0s
 => [telegraf] exporting to image                                                                                 0.0s
 => => exporting layers                                                                                           0.0s
 => => writing image sha256:694aa6fcff51e6292cb0e51172b530a6b9957d0f8288630469ec08bfbd44bcb0                      0.0s
 => => naming to docker.io/library/telegraf                                                                       0.0s
 => [kapacitor] exporting to image                                                                                0.0s
 => => exporting layers                                                                                           0.0s
 => => writing image sha256:33144325007788463bccb32c44f8ee01272bee442fe68187da2eebb3ddad7de4                      0.0s
 => => naming to docker.io/library/kapacitor                                                                      0.0s
 => [telegraf] resolving provenance for metadata file                                                             0.0s
 => [kapacitor] resolving provenance for metadata file                                                            0.0s
 => [documentation internal] load .dockerignore                                                                   0.0s
 => => transferring context: 2B                                                                                   0.0s
 => [chronograf internal] load .dockerignore                                                                      0.0s
 => => transferring context: 2B                                                                                   0.0s
 => [influxdb internal] load .dockerignore                                                                        0.1s
 => => transferring context: 2B                                                                                   0.0s
 => [documentation 1/4] FROM docker.io/library/alpine:3.12@sha256:c75ac27b49326926b803b9ed43bf088bc220d22556de1b  0.0s
 => [documentation internal] load build context                                                                   0.1s
 => => transferring context: 2.51kB                                                                               0.0s
 => [chronograf 1/3] FROM docker.io/library/chronograf:latest@sha256:2aa9fb24f733b4d04e164d25f5ef96980c3b581ddab  0.0s
 => [chronograf internal] load build context                                                                      0.0s
 => => transferring context: 69B                                                                                  0.0s
 => CACHED [influxdb 1/1] FROM docker.io/library/influxdb:1.8@sha256:299ebda2c7e308dbef42e26ac9b8fd1d9b3bcb8a0ae  0.0s
 => CACHED [documentation 2/4] RUN mkdir -p /documentation                                                        0.0s
 => CACHED [documentation 3/4] COPY builds/documentation /documentation/                                          0.0s
 => CACHED [documentation 4/4] COPY static/ /documentation/static                                                 0.0s
 => [influxdb] exporting to image                                                                                 0.1s
 => => exporting layers                                                                                           0.0s
 => => writing image sha256:a27adbf968bbc851469d6527569ac8f726412e5140902797e9be6d2faeb78d79                      0.0s
 => => naming to docker.io/library/influxdb                                                                       0.0s
 => [documentation] exporting to image                                                                            0.1s
 => => exporting layers                                                                                           0.0s
 => => writing image sha256:3c869cc6121d616ed52b5b511c5ff967bd1a4d19fb8d8116c79f2ac512cf9564                      0.0s
 => => naming to docker.io/library/sandbox-documentation                                                          0.0s
 => CACHED [chronograf 2/3] ADD ./sandbox.src ./usr/share/chronograf/resources/                                   0.0s
 => CACHED [chronograf 3/3] ADD ./sandbox-kapa.kap ./usr/share/chronograf/resources/                              0.0s
 => [chronograf] exporting to image                                                                               0.1s
 => => exporting layers                                                                                           0.0s
 => => writing image sha256:e24966b9b5c5debc104d648308759ec552d883a2408e229d7fbf2d689837e77d                      0.0s
 => => naming to docker.io/library/chrono_config                                                                  0.0s
 => [documentation] resolving provenance for metadata file                                                        0.1s
 => [influxdb] resolving provenance for metadata file                                                             0.0s
 => [chronograf] resolving provenance for metadata file                                                           0.0s
[+] up 10/10
 ✔ Image sandbox-documentation       Built                                                                         1.6s
 ✔ Image influxdb                    Built                                                                         1.6s
 ✔ Image telegraf                    Built                                                                         1.6s
 ✔ Image kapacitor                   Built                                                                         1.6s
 ✔ Image chrono_config               Built                                                                         1.6s
 ✔ Container sandbox-documentation-1 Running                                                                       0.0s
 ✔ Container sandbox-influxdb-1      Started                                                                       0.2s
 ✔ Container sandbox-kapacitor-1     Started                                                                       0.4s
 ✔ Container sandbox-telegraf-1      Started                                                                       0.4s
 ✔ Container sandbox-chronograf-1    Started                                                                       0.2s
Opening tabs in browser...
(node:209837) [DEP0169] DeprecationWarning: `url.parse()` behavior is not standardized and prone to errors that have security implications. Use the WHATWG URL API instead. CVEs are not issued for `url.parse()` vulnerabilities.
(Use `node --trace-deprecation ...` to show where the warning was created)
(node:209871) [DEP0169] DeprecationWarning: `url.parse()` behavior is not standardized and prone to errors that have security implications. Use the WHATWG URL API instead. CVEs are not issued for
```

</details>


```bash
sudo chmod 777 -R ./
sudo chmod 777 -R ./

./sandbox docker-clean

./sandbox delete-data

```

```bash
cd ../../../gited

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
./

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 19_1-monitoring_base' \
&& git push \
--set-upstream \
study_fops39 \
19_1-monitoring_base \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
19_1-monitoring_base
```