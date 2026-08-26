#!/bin/bash
# Отключение swap и настройка kubelet для работы без swap.
# Внутри LXC виден HOST-овый zram0 как swap (глобальный ресурс хоста),
# поэтому "swapoff -a" внутри контейнера не убирает swap по-настоящему.
# Запускать ВНУТРИ каждой ноды-LXC от root: ./disable_swap_node.sh

# выключить текущий swap (что можно выключить из namespace контейнера)
swapoff -a || true

# помешать systemd снова поднимать zram-swap
systemctl stop systemd-zram-setup@zram0.service 2>/dev/null || true
systemctl mask systemd-zram-setup@zram0.service 2>/dev/null || true

# kubelet: не падать из-за наличия swap на хосте
mkdir -p /etc/systemd/system/kubelet.service.d
cat > /etc/systemd/system/kubelet.service.d/11-noswap.conf <<'EOF'
[Service]
Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"
EOF

systemctl daemon-reload
systemctl restart kubelet 2>/dev/null || true

echo "Готово."
echo "  swapoff -a выполнен; zram0 -> stop+mask; kubelet -> --fail-swap-on=false"
