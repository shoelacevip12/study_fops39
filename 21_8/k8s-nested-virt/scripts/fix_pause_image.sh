#!/bin/bash
# Синхронизация sandbox-образа (pause) между CRI-O и реестром Alt Linux.
# kubeadm 1.36.1 тянет registry.altlinux.org/p11/pause:3.10.2, но такого тега-> "manifest unknown". 
# Запускать на КАЖДОЙ ноде от root: ./fix_pause_image.sh
# Другой тег: PAUSE_TAG=3.10.1 ./fix_pause_image.sh

PAUSE_IMG="registry.altlinux.org/p11/pause:${PAUSE_TAG:-3.10.1}"

# подтянуть pause-образ и задать его как sandbox-образ CRI-O
crictl pull "$PAUSE_IMG"
sed -i \
    "s|^#\?pause_image *=.*|pause_image = \"${PAUSE_IMG}\"|" \
    /etc/crio/crio.conf
systemctl restart crio

crictl info 2>/dev/null | grep -i pause || true

echo "Готово. Теперь выполняйте kubeadm init."
echo "Если kubeadm всё равно просит pause:3.10.2, локально присвойте тег:"
echo "  skopeo copy docker://$PAUSE_IMG containers-storage:registry.altlinux.org/p11/pause:3.10.2"