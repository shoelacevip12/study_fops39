# Для домашнего задания 8.3
### commit_5, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sys-pattern-homework.git

mv  sys-pattern-homework 8_3

git clone https://github.com/netology-code/sdvps-materials.git

rm -rf sdvps-materials/CICD

sudo pacman -Syu rsync

rsync -a --progress --remove-source-files \
--exclude="README.md" \
--exclude=".git/" \
sdvps-materials/ 8_3/

rm -rf sdvps-materials

sudo pacman -Syu qemu \ 
libvirt \
virt-manager \
ebtables \
nfs-utils \
dnsmasq

sudo usermod -a -G libvirt $(whoami)

sudo systemctl enable --now libvirtd

yay -Syu vagrant

vagrant --version

source ~/proxy_socks.sh

export ALL_PROXY="socks5://localhost:1080

vagrant plugin install \
--plugin-clean-sources \
--plugin-source https://rubygems.org \
vagrant-libvirt \
vagrant-mutate

cat > 8_3/vagrant-network.xml << EOF
<network>
  <name>vagrant-network</name>
  <forward mode='nat'/>
  <bridge name='virbr1' stp='on' delay='0'/>
  <ip address='192.168.56.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.56.100' end='192.168.56.200'/>
    </dhcp>
  </ip>
</network>
EOF

sudo cp 8_3/vagrant-network.xml /etc/libvirt/qemu/networks/

sudo virsh net-define /etc/libvirt/qemu/networks/vagrant-network.xml

sudo virsh net-autostart vagrant-network

sudo virsh net-start vagrant-network

sudo virsh net-list --all

cd 8_3/gitlab

vagrant up --provider=libvirt

git status

git diff && git diff --staged

cd ../..

git add .

git status

git log --oneline

git commit -am 'commit_5, master' && git push study_fops39 master
```