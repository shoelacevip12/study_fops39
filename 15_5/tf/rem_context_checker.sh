#!/bin/bash
# Запуск скрипта выполнения работ удаленного контекста
ssh -t -p 22 \
-o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_lab15_5_fops39_ed25519 \
skv@158.160.146.83 \
"cd /opt/shvirtd-example-python && docker ps -a \
&& docker exec \
-i mysql-db \
mysql -uroot \
-p"$(grep ROOT_PASSWORD .env \
    | cut -d '"' -f 2)" <<'EOF_SQL'
    show databases;
    use virtd;
    show tables;
    SELECT * from requests LIMIT 60;"
