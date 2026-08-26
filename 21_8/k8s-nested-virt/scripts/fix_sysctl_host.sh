#!/bin/bash
# Глобальные sysctl, ожидаемые kubelet (SetupKernelTunables), на ХОСТЕ.
# Внутри LXC /proc/sys смонтирован read-only, а kubelet пишет значение,
# только если оно НЕ совпадает с желаемым. Поэтому достаточно выставить их
# глобально на хосте — kubelet в нодах прочитает совпадающее значение.
# Запускать на ХОСТЕ (там, где libvirt / virsh -c lxc:///) от root:
#   sudo ./fix_sysctl_host.sh

sysctl -w vm.overcommit_memory=1
sysctl -w kernel.panic=10
sysctl -w kernel.panic_on_oops=1
# параметры пула ключей kubelet тоже проверяет; || true чтобы не ломать скрипт
sysctl -w kernel.keys.root_maxkeys=1000000 || true
sysctl -w kernel.keys.root_maxbytes=25000000 || true

# постоянство на хосте
mkdir -p /etc/sysctl.d
cat > /etc/sysctl.d/99-kubelet-lxc.conf <<'EOF'
vm.overcommit_memory = 1
kernel.panic = 10
kernel.panic_on_oops = 1
kernel.keys.root_maxkeys = 1000000
kernel.keys.root_maxbytes = 25000000
EOF

echo "Готово на хосте. Теперь перезапустить kubelet на ВСЕХ нодах:"
echo "  for f in {1..5}; do"
echo "    ssh -i ~/.ssh/id_kvm_host root@192.168.89.1\$f 'systemctl restart kubelet && systemctl is-active kubelet'"
echo "  done"