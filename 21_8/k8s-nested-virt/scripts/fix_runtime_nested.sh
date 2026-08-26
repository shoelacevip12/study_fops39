#!/bin/bash
# Настройка OCI-рантайма (CRI-O + crun) для работы ВНУТРИ LXC (cgroup v2).
# 1. crun не может прикрепить cgroup_device BPF (EPERM) вложенно под libvirt
#    -> оборачиваем crun: вырезаем linux.resources.devices / linux.devices из OCI-bundle
# 2. контроллер pids недоступен в kubepods.slice при systemd-менеджере
#    -> переключаем CRI-O и kubelet на cgroup-драйвер cgroupfs.
# Запускать ВНУТРИ КАЖДОЙ ноды от root: ./fix_runtime_nested.sh

# 1. crun-wrapper без device-BPF
cat > /usr/local/bin/crun-nobpf <<'EOF'
#!/bin/bash
set -euo pipefail
CFG="$(pwd)/config.json"
[ -f "$CFG" ] && jq 'del(.linux.resources.devices, .linux.devices)' "$CFG" > "$CFG.nobpf" && mv "$CFG.nobpf" "$CFG"
exec /bin/crun "$@"
EOF
chmod +x /usr/local/bin/crun-nobpf

# 2. CRI-O: cgroup_manager=cgroupfs + runtime_path=wrapper
sed -i 's|^# *cgroup_manager = .*|cgroup_manager = "cgroupfs"|' /etc/crio/crio.conf
grep -q '^cgroup_manager = "cgroupfs"' /etc/crio/crio.conf || \
  sed -i '/^\[crio.runtime\]/a cgroup_manager = "cgroupfs"' /etc/crio/crio.conf
sed -i 's|^runtime_path = .*|runtime_path = "/usr/local/bin/crun-nobpf"|' /etc/crio/crio.conf
grep -q 'crun-nobpf' /etc/crio/crio.conf || \
  sed -i '/^\[crio.runtime.runtimes.crun\]/,+5 s|^runtime_path = ""|runtime_path = "/usr/local/bin/crun-nobpf"|' /etc/crio/crio.conf

# 3. kubelet: cgroup-driver=cgroupfs
[ -f /var/lib/kubelet/config.yaml ] && \
  sed -i 's|^cgroupDriver:.*|cgroupDriver: cgroupfs|' /var/lib/kubelet/config.yaml
[ -f /etc/systemd/system/kubelet.service.d/10-kubeadm.conf ] && \
  sed -i 's|--cgroup-driver=[a-z0-9]*|--cgroup-driver=cgroupfs|' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# 4. /proc/sys read-write (нужно для Calico CNI и вложенных netns)
cat > /etc/systemd/system/proc-sys-rw.service <<'EOF'
[Unit]
Description=Remount /proc/sys read-write for nested container (Calico CNI)
DefaultDependencies=no
Before=crio.service kubelet.service
[Service]
Type=oneshot
ExecStart=/bin/mount -o remount,rw /proc/sys
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF
systemctl enable proc-sys-rw.service 2>&1 | tail -n 1
systemctl start proc-sys-rw.service 2>&1 || true
mount -o remount,rw /proc/sys 2>/dev/null || true

# 5. restart crio + kubelet
systemctl daemon-reload
systemctl restart crio
systemctl restart kubelet

echo "Готово: crio=$(systemctl is-active crio) kubelet=$(systemctl is-active kubelet) /proc/sys rw=$(test -w /proc/sys/net/ipv4/ip_forward && echo yes || echo no)"