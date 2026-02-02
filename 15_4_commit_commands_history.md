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

git commit -am 'commit_46, master' \
&& git push --set-upstream study_fops39 master \
&& git push --set-upstream study_fops39_gitflic_ru master
```
## commit_47, master
### Задача 1
```bash
# Запуск службы docker
sudo systemctl start \
docker

# Скачивание образа nginx
docker pull \
nginx:1.29-alpine3.23

# Создание Docker файла
cat > Dockerfile.nginx <<'EOF'
FROM nginx:1.29-alpine3.23
WORKDIR /usr/share/nginx/html/
EXPOSE 8080
COPY ./index.html .
EOF

# Запуск сборки и присвоение тега
docker build \
-t shoelacevip12/custom-nginx-skv-fops39:1.0.0 \
-f Dockerfile.nginx \
.

# Запуск контейнера
docker run \
-p 8080:80 \
shoelacevip12/custom-nginx-skv-fops39:1.0.0

# Авторизация в Docker Hub
docker login

# Команда отправки образа 
docker push \
shoelacevip12/custom-nginx-skv-fops39:1.0.0
```
### Задача 2
```bash
docker ps -aq

# Запуск контейнера с именем Skvortosv_DV-custom-nginx-t2
docker run -d --name \
Skvortosv_DV-custom-nginx-t2 \
-p 127.0.0.1:8080:80 \
shoelacevip12/custom-nginx-skv-fops39:1.0.0

docker ps -a

# Переименование контейнера
docker rename \
Skvortosv_DV-custom-nginx-t2 \
custom-nginx-t2

docker ps -a

date +"%d-%m-%Y %T.%N %Z" \
; sleep 0.150 \
; docker ps \
; ss -tlpn \
| grep 127.0.0.1:8080 \
; docker logs custom-nginx-t2 -n1 \
; docker exec -it custom-nginx-t2 base64 \
/usr/share/nginx/html/index.html

curl -l \
127.0.0.1:8080
```
### Задача 3
```bash
docker ps -a

# Подключиться к STDIN контейнера
docker attach \
custom-nginx-t2

docker ps -a

# Повторный запуск контейнера
docker start \
custom-nginx-t2

# Зайдите в интерактивный терминал контейнера alpine sh
docker exec -it \
custom-nginx-t2 \
sh

# Установка пакетов внутри контейнера
apk add nano

apk add vim

sed -i \
's/listen       80;/listen       81;/' \
/etc/nginx/conf.d/default.conf

vim /etc/nginx/conf.d/default.conf

nginx -s reload

curl http://127.0.0.1:80 \
; curl http://127.0.0.1:81

exit

ss -tlpn \
| grep 127.0.0.1:8080

docker port \
custom-nginx-t2

curl -L \
http://127.0.0.1:8080

# Остановим контейнер
docker stop \
custom-nginx-t2

docker ps -a

# Запустите новый контейнер с тем же именем, но с новым портом
# старый контейнер должен быть выключен
docker run -d \
--name custom-nginx-t2 \
-p 127.0.0.1:8080:81 \
shoelacevip12/custom-nginx-skv-fops39:1.0.0

docker ps -a

docker port \
custom-nginx-t2

docker rm -f \
custom-nginx-t2
```
## для github и gitflic
```bash
sudo systemctl stop \
docker

git remote -v

git remote remove \
study_fops39_gitlab

git status

git diff \
&& git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_47, master' \
&& git push --set-upstream study_fops39 master \
&& git push --set-upstream study_fops39_gitflic_ru master
```