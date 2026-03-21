#!/bin/bash -x
virsh -c lxc:/// list --all \
| awk 'NR > 1 {print $2}' \
| xargs -I {} virsh -c lxc:/// shutdown {}

virsh -c lxc:/// list --all \
| awk 'NR > 1 {print $2}' \
| xargs -I {} virsh -c lxc:/// undefine --remove-all-storage {}

sudo bash -c \
"umount /disk/VMs/overlays/*/merged 2>/dev/null || true \
&& rm -rf /disk/VMs/overlays"

sudo rm -rf \
/disk/VMs/ubuntu_24.04_rootfs
