#!/bin/bash
# Скрипт подготовки отдельных rootfs для каждой k8s-ноды.
#
# Проблема, которую решает: все контейнеры НЕ должны монтировать один и тот же
# каталог rootfs как '/' — это ведёт к конфликтам (/etc/hosts, machine-id, /run,
# /tmp, cgroup, pid-файлы). Каждой ноде нужна собственная копия.
#
# Использование (запускать без sudo — при необходимости сам вызовет sudo):
#   ./clone_rootfs.sh
#   BASE_ROOTFS=/path/to/base/rootfs ./clone_rootfs.sh k8s-cp k8s-w1 k8s-w2 k8s-w3 k8s-w4

set -euo pipefail

# Базовая (эталонная) rootfs, из которой клонируем
BASE_ROOTFS="${BASE_ROOTFS:-/disk/VMs/k8s_rootfs}"
# Корневой каталог, куда раскладываем per-node rootfs
LXC_ROOT="${LXC_ROOT:-/disk/VMs}"

# Ноды по умолчанию (корректно как массив из нескольких элементов)
if [ "$#" -gt 0 ]; then
    NODES=("$@")
else
    NODES=(k8s-cp k8s-w1 k8s-w2 k8s-w3 k8s-w4)
fi

# Привилегии: нужны root, т.к. файлы внутри rootfs принадлежат root (контейнер работает под root)
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
fi

if [ ! -d "$BASE_ROOTFS" ]; then
    echo "ОШИБКА: базовая rootfs не найдена: $BASE_ROOTFS" >&2
    exit 1
fi

for node in "${NODES[@]}"; do
    dest="$LXC_ROOT/$node/rootfs"
    if [ -d "$dest" ]; then
        echo "  пропускаю (уже существует): $dest"
        continue
    fi
    echo "Клонирование $BASE_ROOTFS -> $dest"
    $SUDO mkdir -p "$(dirname "$dest")"
    # cp -a сохраняет права/владельцев/симлинки
    $SUDO cp -a "$BASE_ROOTFS" "$dest"

    # Внутри контейнера процессы идут под uid=0, поэтому rootfs должен принадлежать root
    $SUDO chown -R 0:0 "$dest"

    # Каждая нода должна иметь уникальный machine-id и hostname
    $SUDO sh -c ": > \"$dest/etc/machine-id\""
    $SUDO rm -f "$dest/var/lib/dbus/machine-id"
    $SUDO ln -sf /etc/machine-id "$dest/var/lib/dbus/machine-id" 2>/dev/null || true
    echo "$node" | $SUDO tee "$dest/etc/hostname" >/dev/null
done

echo
echo "Готово. Проверить, что пути в XML-конфигах указывают на:"
for node in "${NODES[@]}"; do
    echo "  $LXC_ROOT/$node/rootfs  (нода: $node)"
done