# Для домашнего задания 11.2
### commit_16, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sdb-homeworks.git

find sdb-homeworks/ -mindepth 1 -not -name '11-02.md' -delete

mv sdb-homeworks 11_2

cd 11_2

mkdir img

mv {11-02,README}.md

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_16, master' \
&& git push --set-upstream study_fops39 master
```
### commit_1, 11_2-cached
```bash
git log --oneline

git checkout -b 11_2-cached

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 11_2-cached' \
&& git push --set-upstream study_fops39 11_2-cached
```
### commit_2, 11_2-cached
```bash
sudo pacman -Syu inetutils

sudo systemctl enable --now  docker.service

cat>docker-compose.yml<<'EOF'
version: '3.8'

services:
  redis:
    image: redis:alpine3.22
    container_name: redis_SKV_DV
    ports:
      - "6379:6379"
    networks:
      - cache_net

  memcached:
    image: memcached:alpine3.22
    container_name: memcached_SKV_DV
    ports:
      - "11211:11211"
    networks:
      - cache_net

networks:
  cache_net:
    driver: bridge
EOF

docker-compose up -d

docker ps -a

docker exec -it memcached_SKV_DV ps aux | grep memcached

docker exec -it memcached_SKV_DV ps top

add key 0 20 5

value

get key

get key

quit

sudo pacman -S redis

docker ps -a

docker exec -it redis_SKV_DV top

docker exec -it redis_SKV_DV ps aux | grep redis

docker exec -it redis_SKV_DV redis-cli ping

redis-cli -h localhost

SET server:host "localhost"

SET smthng:smthng "Что-то на Рус."

SET smthng:a-g-e "1232353"

SET smthng:em "SKV@DV"

LPUSH smthng:auth "BxOd:21-09-2025" "BblXoD:22-09-2025" "3a6JIoKuPoBaH:23-09-2025"

KEYS *

GET smthng:smthng

LRANGE smthng:auth 0 -1

SET ne-5 5

GET ne-5

INCRBY ne-5 1

INCRBY ne-5 2

INCRBY ne-5 1

INCRBY ne-5 3

DECRBY ne-5 2

GET ne-5

quit

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_2, 11_2-cached' \
&& git push --set-upstream study_fops39 11_2-cached
```

### commit_17, master
```bash
docker-compose down

sudo systemctl disable --now docker.service

git branch -v

git log --oneline

git status

git diff && git diff --staged

git add . .. \
&& git commit --amend --no-edit \
&& git push --set-upstream study_fops39 11_2-cached --force

git checkout master

git branch -v

git merge 11_2-cached

git add . .. \
&& git status

git commit -am 'commit_17, master & 1_2-cached' && git push study_fops39 master
```