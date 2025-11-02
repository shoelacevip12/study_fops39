# Для домашнего задания 12.2
### commit_22, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sdb-homeworks.git

find sdb-homeworks/ \
-mindepth 1 \
-not -name '12-02.md' -delete

mv sdb-homeworks 12_2

cd !$

mkdir img mysql_D

mv {12-02,README}.md

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_22, master' \
&& git push --set-upstream study_fops39 master
```

### commit_1, `12_2-DDL/DML`
```bash
git log --oneline

git checkout -b 12_2-DDL/DML

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 12_2-DDL/DML' \
&& git push --set-upstream study_fops39 12_2-DDL/DML
```

### commit_2, `12_2-DDL/DML`
```bash
sudo systemctl enable --now docker.service

cat>docker-compose.yml<<'EOF'
services:
  db_mysql_fops-39_12_2:
    image: mysql:lts
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: skvDV
    volumes:
      - ./mysql_D:/var/lib/mysql
    ports:
      - "3306:3306"
EOF

sudo pacman -Syu unzip mariadb-clients

sudo rm -rf mysql_D/* \
&& chmod 770 -R mysql_D

docker-compose down \
&& docker-compose up -d

mysql -h 127.0.0.1 -P 3306 -u root -p
```
```sql
CREATE USER 'sys_temp'@'%' IDENTIFIED BY 'sysskvtmp';

SELECT User, Host FROM mysql.user;

GRANT ALL PRIVILEGES ON *.* TO 'sys_temp'@'%';

SHOW GRANTS FOR 'sys_temp'@'%';

\q
```
```bash
curl https://downloads.mysql.com/docs/sakila-db.zip \
-o sakila-db.zip \
&& unzip sakila-db.zip \
&& rm -rf sakila-db.zip

chmod 777 -R ./sakila-db

docker cp sakila-db/sakila-schema.sql \
$(docker ps -a \
--filter name=12_2-db_mysql_fops-39 \
--format "{{.ID}}"):/tmp/sakila-schema.sql

docker cp sakila-db/sakila-data.sql \
$(docker ps -a --filter name=12_2-db_mysql_fops-39 \
--format "{{.ID}}"):/tmp/sakila-data.sql

mysql -h 127.0.0.1 -P 3306 -u sys_temp -p
```
```sql
ALTER USER 'sys_temp'@'%' IDENTIFIED WITH caching_sha2_password BY 'sysskvtmp';

FLUSH PRIVILEGES;

CREATE DATABASE sakila;

\q
```
```bash
docker exec $(docker ps -a \
--filter name=12_2-db_mysql_fops-39 \
--format "{{.ID}}") \
sh -c 'exec mysql -u"sys_temp" \
-p"sysskvtmp" sakila \
< /tmp/sakila-schema.sql'

docker exec $(docker ps -a \
--filter name=12_2-db_mysql_fops-39 \
--format "{{.ID}}") \
sh -c 'exec mysql -u"sys_temp" \
-p"sysskvtmp" sakila \
< /tmp/sakila-data.sql'

docker exec  $(docker ps -a \
--filter name=12_2-db_mysql_fops-39 \
--format "{{.ID}}") \
rm /tmp/sakila-schema.sql /tmp/sakila-data.sql

rm -rf ./sakila-db

mysql -h 127.0.0.1 -P 3306 -u sys_temp -p
```
```sql
USE sakila;

SHOW TABLES;

\q
```
```bash
git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_2, 12_2-DDL/DML' \
&& git push --set-upstream study_fops39 12_2-DDL/DML

git add . .. \
&& git commit --amend --no-edit \
&& git push --set-upstream study_fops39 12_2-DDL/DML --force
```

### commit_3, `12_2-DDL/DML`
```bash
mysql -h 127.0.0.1 -P 3306 -u root -p
```
```sql
GRANT ALL PRIVILEGES ON sakila.* TO 'sys_temp'@'%';

REVOKE INSERT, UPDATE, DELETE ON sakila.* FROM 'sys_temp'@'%';

SHOW GRANTS FOR 'sys_temp'@'%';
```
```sql
USE sakila;

SELECT 
TABLE_NAME AS 'Название таблицы', 
COLUMN_NAME AS 'Название первичного ключа'
FROM 
information_schema.KEY_COLUMN_USAGE
WHERE 
TABLE_SCHEMA = 'sakila' 
AND 
CONSTRAINT_NAME = 'PRIMARY'
ORDER BY 
TABLE_NAME;

\q
```
```bash
git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_3, 12_2-DDL/DML' \
&& git push --set-upstream study_fops39 12_2-DDL/DML

git add . .. \
&& git commit --amend --no-edit \
&& git push --set-upstream study_fops39 12_2-DDL/DML --force
```
### commit_23, master
```bash
docker-compose down

sudo systemctl disable --now docker.service

git branch -v

git log --oneline

git status

git diff && git diff --staged

git add . .. \
&& git commit --amend --no-edit \
&& git push --set-upstream study_fops39 12_2-DDL/DML --force

git checkout master

git branch -v

git merge 12_2-DDL/DML

git add . .. \
&& git status

git commit -am 'commit_23, master & 12_2-DDL/DML' \
&& git push study_fops39 master
```