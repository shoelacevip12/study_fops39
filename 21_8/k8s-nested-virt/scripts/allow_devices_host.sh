#!/bin/bash
# Разрешение доступа к /dev/kmsg (c 1:11) и /dev/kvm (c 10:232) через device cgroup.
# Запускать НА ХОСТЕ (после virsh start контейнеров):
#   sudo ./allow_devices_host.sh            # все ноды k8s-*
#   sudo ./allow_devices_host.sh k8s-cp     # только указанная нода
# на cgroup v2 devices.allow не используется - вместо этого
# применяется fix_kmsg_node.sh (/dev/kmsg -> /dev/null).

NODES=(k8s-cp k8s-w1 k8s-w2 k8s-w3 k8s-w4)
[ "$#" -gt 0 ] && NODES=("$@")

for node in "${NODES[@]}"; do
  # пути libvirt LXC + systemd
  scope=$(find /sys/fs/cgroup -type d \
       \( -name "machine-lxc*${node}*" -o -name "*${node}*.scope" -o -name "*lxc*${node}*" \) \
       2>/dev/null | grep -i "$node" | head -n1)

  if [ -z "$scope" ]; then
    echo "! не найден cgroup для $node"
    continue
  fi

  echo "=== $node -> $scope ==="
  if [ -w "$scope/devices.allow" ]; then
    echo "c 1:11 rwm" > "$scope/devices.allow" && echo "  allow: c 1:11 rwm (kmsg)"
    echo "c 10:232 rwm" > "$scope/devices.allow" && echo "  allow: c 10:232 rwm (kvm)"
  else
    echo "  нет прав записи в $scope/devices.allow (нужен sudo; на cgroup v2 недоступно)"
  fi
done

echo
echo "Готово. Проверка внутри ноды:"
echo "  cat /dev/kmsg > /dev/null   # не должно быть 'operation not permitted'"