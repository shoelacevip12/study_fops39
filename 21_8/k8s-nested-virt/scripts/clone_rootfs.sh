#!/bin/bash
# Скрипт подготовки отдельных rootfs для каждой k8s-ноды.
# Каждая нода получает свою копию rootfs (/disk/VMs/<нода>/rootfs),
# уникальные machine-id/hostname и статический IP через etcnet.
# Запускать на ХОСТЕ.

BASE_ROOTFS=/disk/VMs/k8s_rootfs
LXC_ROOT=/disk/VMs

for f in {1..5}; do
  case $f in
    1) node=k8s-cp;; 2) node=k8s-w1;; 3) node=k8s-w2;; 4) node=k8s-w3;; 5) node=k8s-w4;;
  esac
  octet=$((10+f))
  dest="$LXC_ROOT/$node/rootfs"

  if [ -d "$dest" ]; then
    echo "  пропускаю (уже существует): $dest"
    continue
  fi

  echo "Клонирование $BASE_ROOTFS -> $dest"
  sudo mkdir -p "$dest"
  sudo cp -a "$BASE_ROOTFS/." "$dest/"
  sudo chown -R 0:0 "$dest"

  # уникальный machine-id + hostname
  sudo sh -c ": > \"$dest/etc/machine-id\""
  sudo rm -f "$dest/var/lib/dbus/machine-id"
  sudo ln -sf /etc/machine-id "$dest/var/lib/dbus/machine-id" 2>/dev/null || true
  echo "$node" | sudo tee "$dest/etc/hostname" >/dev/null

  # статический IP через etcnet
  sudo mkdir -p "$dest/etc/net/ifaces/eth0"
  echo "192.168.89.$octet/24" \
  | sudo tee "$dest/etc/net/ifaces/eth0/ipv4address" >/dev/null
  echo "  $node -> IP 192.168.89.$octet/24"
done

echo
echo "Готово."
echo "Пути rootfs: $LXC_ROOT/{k8s-cp,k8s-w1,k8s-w2,k8s-w3,k8s-w4}/rootfs"