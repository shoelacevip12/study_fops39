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