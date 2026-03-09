#!/bin/bash -x
> ~/.ssh/known_hosts
# Копирование скрипта запуска лабораторной работы
rsync -vP -e "ssh \
-o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_lab16_1_fops39_ed25519" \
lab16_1.sh \
skv@62.84.125.162:~/

# Запуск скрипта выполнения работы
ssh -t -p 22 \
-o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_lab16_1_fops39_ed25519 \
skv@62.84.125.162 \
"chmod +x lab16_1.sh \
&& bash -c "./lab16_1.sh""
