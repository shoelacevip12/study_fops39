#!/bin/bash
# Скрипт подготовки отдельных rootfs для каждой k8s-ноды.
#
# Каждая нода получает свою копию rootfs (/disk/VMs/<нода>/rootfs),
# уникальные machine-id/hostname и статический IP через etcnet.

set -euo pipefail

BASE_ROOTFS="${BASE_ROOTFS:-/disk/VMs/k8s_rootfs}"
LXC_ROOT="${LXC_ROOT:-/disk/VMs}"

SUDO=""
[ "$(id -u)" -eq 0 ] || SUDO="sudo"

clone_node() {
    local node="$1" octet="$2"
    local dest="$LXC_ROOT/$node/rootfs"

    if [ -d "$dest" ]; then
        echo "  пропускаю (уже существует): $dest"
        return
    fi

    echo "Клонирование $BASE_ROOTFS -> $dest"
    $SUDO mkdir -p "$dest"
    $SUDO cp -a "$BASE_ROOTFS/." "$dest/"
    $SUDO chown -R 0:0 "$dest"

    $SUDO sh -c ": > \"$dest/etc/machine-id\""
    $SUDO rm -f "$dest/var/lib/dbus/machine-id"
    $SUDO ln -sf /etc/machine-id "$dest/var/lib/dbus/machine-id" 2>/dev/null || true

    echo "$node" | $SUDO tee "$dest/etc/hostname" >/dev/null

    # Статический IP через etcnet
    $SUDO mkdir -p "$dest/etc/net/ifaces/eth0"
    echo "192.168.89.$octet/24" \
    | $SUDO tee "$dest/etc/net/ifaces/eth0/ipv4address" >/dev/null
    echo "  $node -> IP 192.168.89.$octet/24"
}

clone_node k8s-cp 11
clone_node k8s-w1 12
clone_node k8s-w2 13
clone_node k8s-w3 14
clone_node k8s-w4 15

echo
echo "Готово."
echo "Пути rootfs: $LXC_ROOT/{k8s-cp,k8s-w1,k8s-w2,k8s-w3,k8s-w4}/rootfs"