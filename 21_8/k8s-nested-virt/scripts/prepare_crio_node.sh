#!/bin/bash
# Подготовка CRI-O внутри LXC-ноды.
# CRI-O падает при старте: can't create HostPortManager ...
#   no support for iptables ... or nftables ... not found
# Установить iptables/nftables, чтобы был бинарник для HostPortManager.
# Запускать ВНУТРИ КАЖДОЙ ноды от root: ./prepare_crio_node.sh

apt-get update
apt-get install -y iptables nftables

command -v iptables
command -v nft || true

systemctl restart crio
systemctl is-active crio

journalctl -u crio.service -n 20 --no-pager