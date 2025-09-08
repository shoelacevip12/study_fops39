# Для домашнего задания 9.7
### commit_15, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sflt-homeworks.git

rm -rf sflt-homeworks/{.git,1,1.md,2,2.md,4.md,README.md}

mv sflt-homeworks 9_7

cd 9_7

mv {3,README}.md

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_15, master' \
&& git push --set-upstream study_fops39 master

```

### commit_1, 9_7-Rsync
```bash
git log --oneline

git checkout -b 9_7-Rsync

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 9_7-Rsync' \
&& git push --set-upstream study_fops39 9_7-Rsync
```

### commit_2, 9_7-Rsync
```bash

rsync --archive \
--verbose \
--delete \
--checksum \
--exclude='/.*' \
--exclude='*.qcow2' \
--exclude='*.iso' \
-P \
~/ /tmp/backup/

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_2, 9_7-Rsync' \
&& git push --set-upstream study_fops39 9_7-Rsync

```

### commit_3, 9_7-Rsync
```bash

cat > backup_home.sh <<'EOF'
#!/bin/bash

Sou_dir="$HOME/"
D_dir="/tmp/backup/"

# Cоздание директории назначения
mkdir -p "$D_dir"

# Выполнение резервного копирования
logger -t "home_backup" "Запуск резервного копирования из $Sou_dir в $D_dir"

rsync --archive \
      --verbose \
      --delete \
      --checksum \
      --exclude='/.*' \
      --exclude='*.qcow2' \
      --exclude='*.iso' \
      -P \
      "$Sou_dir" "$D_dir" > /tmp/backup_output.tmp 2>&1

# Сохраняем код завершения rsync
RS_EX_code=$?

# Логирование результата
if [ $RS_EX_code -eq 0 ]; then
    # Если rsync завершился успешно
    logger -t "home_backup" "Резервное копирование успешно завершено."
else
    # Если rsync завершился с ошибкой
    logger -t "home_backup" "Ошибка резервного копирования. Код ошибки: $RS_EX_code. Подробности в /tmp/backup_output.tmp"
fi

exit $RS_EX_code
EOF

chmod +x ~/gited/9_7/backup_home.sh

sudo pacman -Syu cronie

EDITOR=nano crontab -e

0 1 * * * ~/gited/9_7/backup_home.sh

crontab -l

./backup_home.sh 

journalctl -fe | grep копир

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_3, 9_7-Rsync' \
&& git push --set-upstream study_fops39 9_7-Rsync

```