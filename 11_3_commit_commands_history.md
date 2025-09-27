# Для домашнего задания 11.3
### commit_18, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sdb-homeworks.git

find sdb-homeworks/ -mindepth 1 -not -name '11-03.md' -delete

mv sdb-homeworks 11_3

cd 11_3

mkdir img

mv {11-03,README}.md

git clone  https://github.com/ortariot/neto-elk.git

rm -rf neto-elk/.git

mv neto-elk/* .

rm -rf neto-elk

cat /dev/null > ./app/log_gen.log

sudo systemctl enable --now docker.service

cat>docker-compose.yml<<'EOF'
version: "3.9"
services:
  elasticsearch:
    image: elasticsearch:9.1.4
    environment:
      - discovery.type=single-node
      - cluster.name=es_SKV-DV
      - xpack.security.enabled=false
    ports:
      - 9200:9200
EOF

docker-compose up -d

curl -X GET 'localhost:9200/_cluster/health?pretty'

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_18, master' \
&& git push --set-upstream study_fops39 master
```

### commit_1, 11_3-ELK
```bash
git log --oneline

git checkout -b 11_3-ELK

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 11_3-ELK' \
&& git push --set-upstream study_fops39 11_3-ELK
```
### commit_2, 11_3-ELK
```bash

cat>>docker-compose.yml<<'EOF'
    networks:
      - ELK-net

  kibana:
    image: kibana:9.1.4
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    networks:
      - ELK-net

networks:
  ELK-net:
    driver: bridge
EOF

docker-compose up -d

docker ps -a

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_2, 11_3-ELK' \
&& git push --set-upstream study_fops39 11_3-ELK
```