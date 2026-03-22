#!/bin/bash
# вывод ip контейнеров
for i in $(ls /disk/VMs/overlays/); do \
sudo awk '/global/ {print $7}' \
"/disk/VMs/overlays/$i/merged/var/log/cloud-init-output.log" \
| tail -n1; done \
| while read ip_value; do \
echo "$(ssh -n -t -o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_kvm_host_to_vms "root@$ip_value" \
"hostname")" \
- "$ip_value"; done \
2> /dev/null
