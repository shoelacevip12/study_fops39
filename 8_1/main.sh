#!/bin/bash

#Обновление Arch и очистка кеша pacman

if [ "$(id -u)" -ne 0 ]; then
    echo "Запустить от суперпользователя"
    exit 1
fi

echo "Обновление базы данных пакетов..."
pacman -Sy

echo "Запуск полного обновления системы..."
pacman -Su --noconfirm

echo "Очистка кеша pacman..."
pacman -Sc --noconfirm

echo  "Дополнительная очистка (удаляет ВСЕ пакеты из кеша)"
pacman -Scc --noconfirm

echo "Удаление неиспользуемых зависимостей..."
pacman -Rns $(pacman -Qdtq) --noconfirm 2>/dev/null

echo "Обновление и очистка завершены!"
