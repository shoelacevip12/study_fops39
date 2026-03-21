#!/bin/bash
# Проверка поддержки libvirt-lxc

echo " Проверка libvirt LXC драйвера..."

# Проверка пакета
if ! pacman -Qi libvirt | grep lxc; then
    echo " libvirt не установлен"
    echo " Установите: pacman -Suy libvirt"
    exit 1
fi

# Проверка URI
if ! virsh -c lxc:/// uri 2>/dev/null | grep lxc; then
    echo "libvirt LXC URI недоступен"
    echo "Проверьте: sudo systemctl restart libvirtd"
    exit 1
fi

# Проверка прав
if ! virsh -c lxc:/// list --all &>/dev/null; then
    echo " Нет прав на управление LXC контейнерами"
    echo "Добавьте пользователя в группу libvirt: sudo usermod -aG libvirt $USER"
    exit 1
fi

echo "✅ Все проверки пройдены"
exit 0
