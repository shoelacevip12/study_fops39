#!/bin/bash
# Подготовка rootfs для LXC-контейнера CI-runner'а.
# Запускать НА ХОСТЕ.
# Хост: br0=192.168.89.193 (шлюз к LAN), wg0=10.8.0.1 (forgejo).

set -euo pipefail

BASE_ROOTFS=/disk/VMs/k8s_rootfs   # эталонный образ ALT Linux p11 (из 21_8)
DEST_ROOTFS=/disk/VMs/ci-runner/rootfs
NODE=ci-runner
IP=192.168.89.20/24
HOST_BR0_IP=192.168.89.193         # IP br0 на физическом хосте (маршрут к 10.8.0.1)
SSH_PUB_KEY=${SSH_PUB_KEY:-$HOME/.ssh/id_kvm_host.pub}

if [ -d "$DEST_ROOTFS" ]; then
  echo "Уже существует: $DEST_ROOTFS — пропускаю клонирование."
else
  echo "Клонирование $BASE_ROOTFS -> $DEST_ROOTFS"
  sudo mkdir -p "$DEST_ROOTFS"
  sudo cp -a "$BASE_ROOTFS/." "$DEST_ROOTFS/"
  sudo chown -R 0:0 "$DEST_ROOTFS"
fi

echo "Hostname и machine-id"
sudo sh -c ": > $DEST_ROOTFS/etc/machine-id"
sudo rm -f "$DEST_ROOTFS/var/lib/dbus/machine-id"
echo "$NODE" | sudo tee "$DEST_ROOTFS/etc/hostname" >/dev/null

echo "Статическая сеть (etcnet)"
sudo mkdir -p "$DEST_ROOTFS/etc/net/ifaces/eth0"
echo "$IP" | sudo tee "$DEST_ROOTFS/etc/net/ifaces/eth0/ipv4address" >/dev/null

cat > /tmp/runner-eth0-options <<'EOF'
BOOTPROTO=static
TYPE=eth
SYSTEMD_CONTROLLED=no
DISABLED=no
CONFIG_WIRELESS=no
SYSTEMD_BOOTPROTO=static
CONFIG_IPV4=yes
CONFIG_IPV6=no
NM_CONTROLLED=no
ONBOOT=yes
EOF
sudo cp /tmp/runner-eth0-options "$DEST_ROOTFS/etc/net/ifaces/eth0/options"

# default-маршрут + маршрут до VPN-сети forgejo (10.8.0.0/24) через br0 хоста
cat > /tmp/runner-eth0-route <<EOF
default via 192.168.89.1
10.8.0.0/24 via ${HOST_BR0_IP}
EOF
sudo cp /tmp/runner-eth0-route "$DEST_ROOTFS/etc/net/ifaces/eth0/ipv4route"

cat > /tmp/runner-resolv <<'EOF'
nameserver 192.168.89.1
nameserver 77.88.8.8
search den.skv
EOF
sudo cp /tmp/runner-resolv "$DEST_ROOTFS/etc/resolv.conf"
sudo cp /tmp/runner-resolv "$DEST_ROOTFS/etc/net/ifaces/eth0/resolv.conf"

echo "git.den-skv.ru -> 10.8.0.1 в /etc/hosts (страховка от DNS)"
echo "10.8.0.1 git.den-skv.ru" | sudo tee -a "$DEST_ROOTFS/etc/hosts" >/dev/null

echo "SSH-ключ для root"
if [ -f "$SSH_PUB_KEY" ]; then
  sudo mkdir -p "$DEST_ROOTFS/root/.ssh"
  cat "$SSH_PUB_KEY" | sudo tee -a "$DEST_ROOTFS/root/.ssh/authorized_keys" >/dev/null
  sudo chmod 700 "$DEST_ROOTFS/root/.ssh"
  sudo chmod 600 "$DEST_ROOTFS/root/.ssh/authorized_keys"
else
  echo "Нет ключа $SSH_PUB_KEY — пропускаю (зайдёте через virsh console)"
fi

echo "Определяем домен:"
sudo virsh define "$(dirname "$0")/lxc-ci-runner.xml"
echo "Стартуем:"
sudo virsh start ci-runner || true
sudo virsh list --all
echo
echo "Вход: sudo virsh console ci-runner   (или ssh root@192.168.89.20)"
echo "Далее внутри контейнера выполнить: bash <(curl -s http://10.8.0.1:3000/... ) — либо скопировать setup_runner_inside.sh"