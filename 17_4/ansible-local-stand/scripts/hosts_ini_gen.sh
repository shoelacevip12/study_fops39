#!/bin/bash
# Генерация hosts.ini

{
  # Динамическая часть: поиск IP и имен хостов
  for i in $(ls /disk/VMs/overlays/); do
    sudo awk '/global/ {print $7}' \
    "/disk/VMs/overlays/$i/merged/var/log/cloud-init-output.log" \
    | tail -n1; done \
  | while read ip_value; do
    host_name=$(ssh -n -t -o StrictHostKeyChecking=accept-new \
    -i ~/.ssh/id_kvm_host_to_vms "root@$ip_value" \
    "hostname" 2>/dev/null)
    
    # Вывод в формате Ansible inventory
    echo "[$host_name]"
    echo "$ip_value"
    echo ""
  done

  # Статическая часть: группы
  echo "[stack_log:children]"
  echo "clickhouse"
  echo "lighthouse"
  echo "vector"
} > hosts.ini
