#!/bin/bash
# Инициализация control-plane
# Запускать на k8s-cp.
# CRI: CRI-O. Сеть подов: Calico (10.10.0.0/16).
# !!!Из-за host-ового swap добавлен --ignore-preflight-errors=Swap.
# !!! после установки Calico согласовать IPPool с 10.10.0.0/16.

kubeadm init \
--pod-network-cidr=10.10.0.0/16 \
--kubernetes-version=1.36.1 \
--image-repository=registry.altlinux.org/p11 \
--apiserver-advertise-address=192.168.89.11 \
--cri-socket=unix:///var/run/crio/crio.sock \
--ignore-preflight-errors=Swap

echo
echo ">>> kubectl для root"
mkdir -p ~/.kube
cp -f /etc/kubernetes/admin.conf ~/.kube/config

echo
echo ">>> Сохраните команду join из вывода выше (для рабочих нод)."
echo ">>> После init установите Calico (CNI):"
echo "    kubectl apply -f <calico-manifest>"
echo "    kubectl -n kube-system get ippool -o yaml   # при необходимости задать cidr: 10.10.0.0/16"