#!/bin/bash
# Обход device-cgroup, блокирующего открытие реального /dev/kmsg.
# Внутри LXC kubelet падает: open /dev/kmsg: operation not permitted.
# Подменяет /dev/kmsg симлинком на /dev/null (открытие /dev/null permitted).
# Запускать ВНУТРИ КАЖДОЙ ноды: ./fix_kmsg_node.sh

# снять остаточный bind-mount /dev/kmsg (если был проброшен из старого XML)
mountpoint -q /dev/kmsg && umount /dev/kmsg || true

rm -f /dev/kmsg
ln -sf /dev/null /dev/kmsg

# постоянство при пересоздании /dev (tmpfiles.d)
mkdir -p /etc/tmpfiles.d
printf 'L /dev/kmsg - - - - /dev/null\n' > /etc/tmpfiles.d/kmsg.conf

systemctl restart systemd-tmpfiles-setup 2>/dev/null || systemd-tmpfiles --create 2>/dev/null || true

systemctl restart kubelet

echo "Готово: /dev/kmsg -> /dev/null, kubelet=$(systemctl is-active kubelet)"