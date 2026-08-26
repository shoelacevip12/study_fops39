#!/bin/bash
# Подготовка ноды под Kubernetes (CRI: CRI-O) по руководству Alt Linux.
# Запускать ВНУТРИ КАЖДОЙ ноды от root: ./setup_k8s_node.sh

# 1/4 Взаимное разрешение имён нод (/etc/hosts)
grep -q "k8s-cp" /etc/hosts || cat >> /etc/hosts <<'EOF'
192.168.89.11 k8s-cp
192.168.89.12 k8s-w1
192.168.89.13 k8s-w2
192.168.89.14 k8s-w3
192.168.89.15 k8s-w4
EOF

# 2/4 Отключение swap
swapoff -a || true

# 3/4 Установка пакетов kubeadm/kubelet/CRI-O
apt-get update
apt-get install -y \
    kubernetes1.36-kubeadm \
    kubernetes1.36-kubelet \
    kubernetes1.36-crio \
    cri-tools1.36 \
    iptables nftables

# 4/4 Запуск служб
systemctl enable --now crio
systemctl enable kubelet

echo "Готово. Статус CRI-O: $(systemctl is-active crio)"
echo "ВАЖНО: из-за host-ового zram-swap выполните: ./disable_swap_node.sh"