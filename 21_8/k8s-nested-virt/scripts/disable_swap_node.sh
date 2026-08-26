#!/bin/bash
# Отключение swap и настройка kubelet для работы без swap.
#
# внутри LXC-контейнера виден HOST-овый zram0 как swap, т.к. libvirt-LXC
# пробрасывает хост-устройства, а swap в ядре Linux является ГЛОБАЛЬНЫМ ресурсом хоста.
# Поэтому "swapoff -a" внутри контейнера не убирает swap по-настоящему.
#
# сказать kubelet игнорировать swap
# (fail-swap-on=false), а на этапе init/join использовать --ignore-preflight-errors=Swap.
 
# "!!!для kubeadm (выполнить на CP/worker при init/join):!!!"
# kubeadm init --ignore-preflight-errors=Swap"
# kubeadm join ... --ignore-preflight-errors=Swap"

#!!! Запускать ВНУТРИ каждой ноды-LCX от root: !!!!
#   ./disable_swap_node.sh

set -euo pipefail

# 1) Выключить текущий swap (что можно выключить из namespace контейнера)
swapoff -a || true

# 2) Помешаем systemd в контейнере снова поднимать zram-swap
systemctl stop systemd-zram-setup@zram0.service 2>/dev/null || true
systemctl mask systemd-zram-setup@zram0.service 2>/dev/null || true

# 3) kubelet: не падать из-за наличия swap на хосте
mkdir -p /etc/systemd/system/kubelet.service.d
cat > /etc/systemd/system/kubelet.service.d/11-noswap.conf <<'EOF'
[Service]
Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"
EOF

systemctl daemon-reload
systemctl restart kubelet 2>/dev/null || true

echo "Готово."
echo "  swapoff -a выполнен"
echo "  systemd-zram-setup@zram0  ->  stop + mask"
echo "  kubelet  ->  KUBELET_EXTRA_ARGS=--fail-swap-on=false"

