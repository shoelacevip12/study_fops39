#!/bin/bash
# Инициализация HA control-plane (Задание 2*: 3 мастера + keepalived VIP 192.168.89.100).
# Запускать на k8s-cp от root ПОСЛЕ настройки keepalived (VIP 192.168.89.100 активен).
# Мастера: k8s-cp, k8s-w1, k8s-w2. Workers: k8s-w3, k8s-w4.
# Сеть подов: Calico (10.10.0.0/16).
# Предварительно на 3 мастерах:
#   apt-get install keepalived
#   скопировать keepalived/keepalived.conf.{cp,w1,w2} в /etc/keepalived/keepalived.conf
#   systemctl enable --now keepalived
#   ip addr show eth0   # убедиться, что VIP 192.168.89.100 на MASTER

kubeadm init \
--control-plane-endpoint=192.168.89.100:6443 \
--upload-certs \
--pod-network-cidr=10.10.0.0/16 \
--kubernetes-version=1.36.1 \
--image-repository=registry.altlinux.org/p11 \
--cri-socket=unix:///var/run/crio/crio.sock \
--ignore-preflight-errors=Swap

echo
echo ">>> kubectl для root"
mkdir -p ~/.kube
cp -f /etc/kubernetes/admin.conf ~/.kube/config

echo
echo ">>> Сохраните ОБЕ команды join из вывода выше:"
echo "    1) control-plane (для k8s-w1, k8s-w2) — с --control-plane --certificate-key"
echo "    2) worker (для k8s-w3, k8s-w4) — без --control-plane"