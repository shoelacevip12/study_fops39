#!/bin/bash
# Остановка и удаление всех LXC-контейнеров k8s + очистка их rootfs.

virsh -c lxc:/// list --all --name \
| xargs -I {} virsh -c lxc:/// shutdown {}

virsh -c lxc:/// list --all --name \
| xargs -I {} virsh -c lxc:/// undefine --remove-all-storage {}

sudo bash -c \
"umount /disk/VMs/overlays/*/merged 2>/dev/null || true \
&& rm -vrf /disk/VMs/k8s-*"

echo
echo "ВНИМАНИЕ: далее будет удалена базовая эталонная rootfs:"
echo "  /disk/VMs/k8s_rootfs"
read -r -p "Удалить базовую rootfs /disk/VMs/k8s_rootfs? [y/N]: " answer
case "$answer" in
    y|Y|yes|Yes|YES)
        sudo rm -vrf \
        /disk/VMs/k8s_rootfs
        echo "Базовая rootfs удалена."
        ;;
    *)
        echo "Отменено. Базовая rootfs НЕ удалена."
        ;;
esac
