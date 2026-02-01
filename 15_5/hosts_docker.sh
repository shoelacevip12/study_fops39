#!/bin/bash
> ~/.ssh/known_hosts
# Копирование скрипта запуска лабораторной работы
rsync -vP -e "ssh \
-o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_lab15_5_fops39_ed25519" \
lab15_5.sh \
skv@158.160.146.83:~/

# Запуск скрипта выполнения работы
ssh -t -p 22 \
-o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_lab15_5_fops39_ed25519 \
skv@158.160.146.83 \
"chmod +x lab15_5.sh \
&& bash -c "./lab15_5.sh""

# Запуск скрипта выполнения работ удаленного контекста
./rem_context_checker.sh
