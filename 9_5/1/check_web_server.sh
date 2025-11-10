#!/bin/bash
# Параметры по умолчанию
HOST="127.0.0.1"
PORT="80"
FILE="/var/www/html/index.nginx-debian.html"
# Проверка доступности порта
if nc -z "$HOST" "$PORT" &>/dev/null; then
    echo "Порт $PORT на $HOST доступен"
else
    exit 1
fi
# Проверка существования файла
if [ -f "$FILE" ]; then
    echo "Файл $FILE существует"
else
    exit 2
fi
exit 0