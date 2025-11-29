# Для домашнего задания 12.6
## commit_23, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sdb-homeworks.git

find sdb-homeworks/ \
-mindepth 1 \
-not -name '12-06.md' -delete

mv sdb-homeworks 12_6

cd !$

mkdir img

mv {12-06,README}.md

git remote -v

git config --global --add safe.directory /home/shoel/nfs_git/gited

git status

git diff \
&& git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_23, master' \
&& git push --set-upstream study_fops39 master
```
## commit_1, `12_6-Repl\exp`
```bash
git log --oneline

git checkout -b 12_6-Repl\exp

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 12_6-Repl\exp' \
&& git push --set-upstream study_fops39 12_6-Repl\exp
```
## commit_2, `12_6-Repl\exp`
```bash
sudo systemctl enable --now \
docker.service

mkdir -p ./{master,slave}/db

cat > ./master/master.env <<'EOF'
MYSQL_ROOT_PASSWORD=skvdv
MYSQL_PORT=3306
MYSQL_USER=skvdv-master
MYSQL_PASSWORD=passskvdvm
MYSQL_DATABASE=mydb
MYSQL_LOWER_CASE_TABLE_NAMES=0
EOF

cat > ./slave/slave.env <<'EOF'
MYSQL_ROOT_PASSWORD=skvdv
MYSQL_PORT=3306
MYSQL_USER=skvdv-slave
MYSQL_PASSWORD=passskvdvs
MYSQL_DATABASE=mydb
MYSQL_LOWER_CASE_TABLE_NAMES=0
EOF

cat > ./master/m_mys.cnf <<'EOF'
[mysqld]
skip-name-resolve

server-id = 1
log_bin = mysql-bin
binlog_format = ROW
binlog_do_db = mydb
EOF

cat > ./slave/s_mys.cnf <<'EOF'
[mysqld]
skip-name-resolve

server-id = 2
read_only = ON
replicate_do_db = mydb
relay_log = mysql-relay-bin
EOF

cat > ./master/master.sql <<'EOF'
CREATE USER 'repl_skv'@'%' IDENTIFIED WITH caching_sha2_password BY 'passskvdvs' REQUIRE NONE PASSWORD EXPIRE NEVER;
GRANT REPLICATION SLAVE ON *.* TO 'repl_skv'@'%';
EOF

chmod 644 ./{master,slave}/*.cnf

cat>docker-compose.yml<<'EOF'
services:
  db_mysql_master_12_6:
    image: mysql:lts
    container_name: mysql-master
    restart: unless-stopped
    user: "1000:1000"
    env_file:
      - ./master/master.env
    volumes:
      - ./master/m_mys.cnf:/etc/mysql/conf.d/m_mys.cnf
      - ./master/db:/var/lib/mysql
      - ./master/master.sql:/docker-entrypoint-initdb.d/start.sql
    ports:
      - "3306:3306"
    networks:
      - mysql

  db_mysql_slave_12_6:
    image: mysql:lts
    container_name: mysql-slave
    user: "1000:1000"
    env_file:
      - ./slave/slave.env
    volumes:
      - ./slave/s_mys.cnf:/etc/mysql/conf.d/s_mys.cnf
      - ./slave/db:/var/lib/mysql
    ports:
      - 3307:3306
    networks:
      - mysql
    depends_on:
      - db_mysql_master_12_6

networks:
  mysql:
    driver: bridge
EOF

docker-compose down \
&& sleep 2 \
&& rm -rf  ./{master,slave}/db/* \
&& sleep 2 \
&& docker-compose up -d

docker exec \
mysql-master \
mysql -uroot -pskvdv \
-e "SHOW BINARY LOG STATUS;" \
| awk ' NR >1 {print "\n" $1 "\n" $2}'

docker exec \
-i mysql-slave \
mysql -uroot -pskvdv <<'EOF_SQL'
STOP REPLICA IO_THREAD FOR CHANNEL '';
CHANGE REPLICATION SOURCE TO
  SOURCE_HOST = 'mysql-master',
  SOURCE_USER = 'repl_skv',
  SOURCE_PASSWORD = 'passskvdvs',
  SOURCE_LOG_FILE = 'mysql-bin.000003',
  SOURCE_LOG_POS = 158,
  GET_SOURCE_PUBLIC_KEY=1;
START REPLICA user='repl_skv' password='passskvdvs';
EOF_SQL

docker exec \
-i mysql-slave \
mysql -uroot -pskvdv <<'EOF_SQL'
USE mydb;
SHOW TABLES;
EOF_SQL

docker exec \
-i mysql-master \
mysql -uroot -pskvdv <<'EOF_SQL'
USE mydb;
CREATE TABLE code (code INT);
INSERT INTO code VALUES (100), (200);
EOF_SQL

docker exec \
-i mysql-slave \
mysql -uroot -pskvdv <<'EOF_SQL'
USE mydb;
SHOW TABLES;
EOF_SQL

docker exec \
-i mysql-master \
mysql -uroot -pskvdv <<'EOF_SQL'
USE mydb;
DROP TABLE code;
EOF_SQL

docker exec \
-i mysql-slave \
mysql -uroot -pskvdv <<'EOF_SQL'
USE mydb;
SHOW TABLES;
EOF_SQL

docker exec \
-i mysql-master \
mysql -uroot -pskvdv <<'EOF_SQL'
SELECT @@server_id AS 'Server ID',
@@log_bin AS 'Binary Logging',
@@binlog_format AS 'Binlog Format'\G;
SHOW PROCESSLIST\G;
EOF_SQL

docker exec \
-i mysql-slave \
mysql -uroot -pskvdv <<'EOF_SQL'
SELECT @@server_id AS 'Server ID',
@@read_only AS 'Read Only'\G;
SHOW REPLICA STATUS\G;
EOF_SQL

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_2, 12_6-Repl\exp' \
&& git push --set-upstream study_fops39 12_6-Repl\exp
```
## commit_24, master
```bash
docker-compose down \
&& sleep 2 \
&& rm -rf  ./{master,slave}/db/*

sudo systemctl disable --now docker.service

git add . .. \
&& git commit --amend --no-edit \
&& git push --set-upstream study_fops39 12_6-Repl\exp --force

git checkout master

git branch -v

git merge 12_6-Repl\exp

git add . .. \
&& git status

git commit -am 'commit_24, master & 12_6-Repl/exp1' \
&& git push study_fops39 master
```