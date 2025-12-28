# Для домашнего задания 13.1
### commit_26, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sdb-homeworks.git

find sdb-homeworks/ \
-mindepth 1 \
-not -name '13-01.md' -delete

mv sdb-homeworks 13_1

cd !$

mkdir img

mv {13-01,README}.md

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_26, master' \
&& git push --set-upstream study_fops39 master
```

### commit_1, `13_1-explo_and_atta`
```bash
git log --oneline

git checkout -b 13_1-explo_and_atta

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 13_1-explo_and_atta' \
&& git push --set-upstream study_fops39 13_1-explo_and_atta
```

### commit_2, `13_1-explo_and_atta`
```bash
########################
# Подготовка к запуску #
########################

# Скачать образ Altlinux p11 для bastion хоста
wget -P \
~/iso/ \
https://download.basealt.ru/pub/distributions/ALTLinux/p11/images/workstation/x86_64/alt-workstation-11.1-x86_64.iso

# Создание Vagrant файла развертывания для пинтеста
cat>vagrantfile<<'OEF'
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Путь к ISO образу ALT Linux p11
  altlinux_iso_path_w = "/home/shoel/iso/alt-workstation-11.1-x86_64.iso"
  config.vm.box = "deargle/metasploitable2"
  config.vm.box_version = "0.0.4"
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = "kvm"
    libvirt.uri = 'qemu:///system'
    libvirt.memory = 3072
    libvirt.cpus = 2
    libvirt.nested = true
    libvirt.disk_driver :cache => 'none'
    libvirt.disk_bus = "virtio"
    libvirt.nic_model_type = "virtio"
    libvirt.storage :file, :size => '40G', :type => 'qcow2'
    libvirt.management_network_name = "vagrant-libvirt"
    libvirt.management_network_mode = "route"
    libvirt.management_network_guest_ipv6 = "no"
  end
  
  config.vm.define "ub1404" do |ub1404|
    ub1404.vm.hostname = "metasploitable2-ub1404"
    config.ssh.username = 'msfadmin'
    config.ssh.password = 'msfadmin'
    ub1404.vm.network "private_network",
                      libvirt__network_name: "s_private_network", # Имя создаваемой сети
                      libvirt__forward_mode: "none", # Режим маршрутизации
                      libvirt__dhcp_enabled: false  # Отключаем DHCP в этой сети
  end
 # --- Создание ВМ на altlinux ---
  config.vm.define "altlinux_w2" do |node_3|
    # Исправлено: имя хоста должно зависеть от переменной цикла i
    node_3.vm.hostname = "altlinux-w2"
    node_3.vm.communicator = "none"
    # Настройки сети: только private_network
    node_3.vm.network "private_network",
                          libvirt__network_name: "s_private_network",
                          libvirt__forward_mode: "none",
                          libvirt__dhcp_enabled: false

    node_3.vm.provider :libvirt do |libvirt|
      libvirt.boot 'hd' # Загрузка с жесткого диска
      libvirt.boot 'cdrom' # Загрузка с CDROM (вторая опция)
      libvirt.storage :file, :device => :cdrom, :path => altlinux_iso_path_w
      
    end
    node_3.vm.provision "shell", inline: "echo 'altlinux_w2 VM created.'", run: "never"
  end
end
OEF

# Проверка правильности конфига
vagrant validate

git branch -v

git remote -v

git status

git log --oneline

git add . .. \
&& git status

git commit -am 'commit_2, 13_1-explo_and_atta' \
&& git push --set-upstream study_fops39 13_1-explo_and_atta
```
## commit_3, `13_1-explo_and_atta`
```bash
###############################################
# VPN для скачивания с hashicorp.com образов  #
###############################################
# Создание службы для подключения к существующему SSH серверу как к proxy-SOCKS серверу 
cat > ~/.config/systemd/user/ssh-tunnel.service << 'EOF'
[Unit]
Description=SSH SOCKS Tunnel
After=network.target

[Service]
Type=simple
Environment="TERM=xterm"
Environment="HOME=%h"
Environment="IP=xxx.xxx.xxx.xxx"
ExecStart=/usr/bin/ssh -v -D 1080 -N \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  -o TCPKeepAlive=yes \
  -i /home/%u/.ssh/ssh_id_ed25519 \
  root@$IP
Restart=always
RestartSec=10
MemoryLimit=100M

[Install]
WantedBy=default.target
EOF

# Запуск службы для текущего пользователя 
systemctl --user enable --now ssh-tunnel.service

# Используем переменную окружения ALL_PROXY для обозначения прокси по протоколу, серверу и порту
export ALL_PROXY="socks5://localhost:1080"

# Проверка получаемого ip WAN
curl 2ip.ru
###############################################
```
```bash
# Запуск vagrant без удаления в случае ошибки запуска
vagrant up --no-destroy-on-error

# Остановка всех ВМ 
sudo bash -c \
"for i in \$(virsh list --all \
| awk '{print \$2}'); do \
virsh destroy \$i; done"

# Отключение VPN
systemctl --user disable --now ssh-tunnel.service
unset ALL_PROXY
curl 2ip.ru

# Остановка всех сетей Libvirt начиная со 2ого по списку
sudo virsh net-list --all \
| awk 'NR > 3 {print $1}' \
| xargs -I {} sudo virsh net-destroy {}

# Запуск редактора сети vagrant-libvirt для выхода в интернет
sudo virsh net-edit \
--network \
vagrant-libvirt

# экспорт настроек созданных сетей Libvirt
sudo virsh net-dumpxml \
vagrant-libvirt \
> ./mngt_net.xml

sudo chmod 777 !$

sudo virsh net-dumpxml \
s_private_network \
> ./s_private_network.xml

sudo chmod 777 !$

# определяем списка виртуальных машин 
sudo bash -c \
"virsh list --all \
| awk '/alt|ub/ {print \$2}'"

# определяем мак адреса интерфейсов для отключения
sudo bash -c \
"virsh list --all \
| awk '/alt|ub/ && !/x_w2/ {print \$2}' \
| xargs -I {} virsh dumpxml {} \
| grep -B1 vagrant-libvir" \
| sed -n "s/.*<mac address='\([^']*\)'.*/\1/p"

# Удаление интерфейса management_network для прямого общения с хост машиной с выходом в интернет 
sudo virsh detach-interface \
13_1_ub1404 \
--type network \
--mac 52:54:00:88:a9:59 \
--config

# Экспорт настроек созданных ВМ
sudo bash -c \
"for i in \$(virsh list --all \
| awk '/w2|ub/ {print \$2}') ; do \
virsh dumpxml \$i \
> \$i.xml; done"

sudo chmod 777 *.xml

git branch -v

git remote -v

git status

git log --oneline

git add . .. \
&& git status

git commit -am 'commit_3, 13_1-explo_and_atta' \
&& git push --set-upstream study_fops39 13_1-explo_and_atta
```
## commit_4, `13_1-explo_and_atta`
```bash
# Выводим список ВМ стенда для напоминания
sudo virsh list --all

# Поочередный запуск всех сетей libvirt со 2ого по списку
sudo virsh net-list --all \
| awk 'NR > 3 {print $1}' \
| xargs -I {} sudo virsh net-start {}

# Запуск Рабочей станции Alt p11 выступающим в роли bastion
sudo virsh start \
--domain adm4_altlinux_w2

# Запуск "песочницы" для пентеста
sudo virsh start \
--domain 13_1_ub1404

# создаем ключ для подключения к bastion хосту
ssh-keygen -t ed25519 \
-f ~/.ssh/id_kvm_host_to_vms \
-C "kvm-host_access_to_vms"

# создаем ключ для подключения к другим виртуальным машинам
ssh-keygen -t ed25519 \
-f ~/.ssh/id_vm \
-C "vm-access-key"

# проброс ключа до шлюза
ssh-copy-id \
-i ~/.ssh/id_kvm_host_to_vms.pub \
sadmin@192.168.121.2

# включаем агента-ssh
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_vm \
&& ssh-add  ~/.ssh/id_kvm_host_to_vms
```
![](13_1/img/1.png)
```bash
#####################
# Настройка bastion #
#####################
# вход на bastion server
ssh \
-i ~/.ssh/id_kvm_host_to_vms \
sadmin@alt-w-p11-route

su -

# Отключение из автозагрузки служб для графического взаимодействия
systemctl isolate multi-user.target
systemctl set-default multi-user.target

runlevel

# включение внутренней маршрутизации пакетов между интерфейсами
sed -i 's/rd\ =\ 0/rd\ =\ 1/' \
/etc/net/sysctl.conf

# обновление системы и установка пакетов для nat-маршрутизации
apt-get update \
&& update-kernel -y \
&& apt-get dist-upgrade -y \
&& apt-get install -y \
nftables

# Включаем и добавляем в автозагрузку службу nftables:
systemctl enable --now nftables


# Создаём необходимую структуру для nftables (семейство, таблица, цепочка) для настройки NAT:
nft add table ip nat
nft add chain ip nat postrouting '{ type nat hook postrouting priority 0; }'
nft add rule ip nat postrouting ip saddr 10.10.10.240/28 oifname "ens5" counter masquerade

# Сохраняем правила nftables
nft list ruleset \
| tail -n6 \
| tee -a /etc/nftables/nftables.nft

systemctl reboot

su -

nft list ruleset

# установка nmap
apt-get update \
&& apt-get install -y \
nmap

exit

exit
#####################
```
```bash
################################
# Настройка хоста для пентеста #
################################
# вход через bastion (192.168.121.2), как прокси, на машину локальной сети 10.10.10.245
ssh -i ~/.ssh/id_kvm_host_to_vms \
-o HostkeyAlgorithms=+ssh-rsa \
-o "ProxyJump sadmin@192.168.121.2" \
msfadmin@10.10.10.245

sudo tcpdump -nn \
-i eth0 \
-l port 53 \
or port 69 \
or port 111 \
or 'tcp[13] & 2 != 0 or tcp[13] & 1 != 0 or tcp[13] & 32 != 0' \
2>&1 \
| tee metasploitable_incoming.log

exit
################################
```
```bash
git branch -v

git remote -v

git status

git log --oneline

git add . .. \
&& git status

git commit -am 'commit_4, 13_1-explo_and_atta' \
&& git push --set-upstream study_fops39 13_1-explo_and_atta
```
## commit_5, `13_1-explo_and_atta`
```bash
########################
# Работа через bastion #
########################
# вход на bastion server
ssh \
-i ~/.ssh/id_kvm_host_to_vms \
sadmin@alt-w-p11-route

su -
# -p- Сканирует все 65535 TCP-портов
# -A Агрессивный набор опций сканирования (включает в себя `-sC`, `-sV`, `-O`, `--traceroute`)
# -sV Определяет версии служб, работающих на открытых портах
# -sC Запускает набор встроенных NSE-скриптов по умолчанию
# -O определение ОС
# --traceroute выполняет трассировку до хоста
nmap -p- -A \
10.10.10.245 \
| grep -i 'open\|filtered'
```
    21/tcp    open  ftp         vsftpd 2.3.4
    22/tcp    open  ssh         OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0)
    23/tcp    open  telnet      Linux telnetd
    25/tcp    open  smtp        Postfix smtpd
    53/tcp    open  domain      ISC BIND 9.4.2
    80/tcp    open  http        Apache httpd 2.2.8 ((Ubuntu) DAV/2)
    111/tcp   open  rpcbind
    139/tcp   open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
    512/tcp   open  exec        netkit-rsh rexecd
    513/tcp   open  login       OpenBSD or Solaris rlogind
    514/tcp   open  shell       Netkit rshd
    1099/tcp  open  java-rmi    GNU Classpath grmiregistry
    1524/tcp  open  bindshell   Metasploitable root shell
    2049/tcp  open  rpcbind
    2121/tcp  open  ftp         ProFTPD 1.3.1
    3306/tcp  open  mysql       MySQL 5.0.51a-3ubuntu5
    3632/tcp  open  distccd     distccd v1 ((GNU) 4.2.4 (Ubuntu 4.2.4-1ubuntu4))
    5432/tcp  open  postgresql  PostgreSQL DB 8.3.0 - 8.3.7
    5900/tcp  open  vnc         VNC (protocol 3.3)
    6000/tcp  open  X11         (access denied)
    6667/tcp  open  irc         UnrealIRCd
    6697/tcp  open  irc         UnrealIRCd
    8009/tcp  open  ajp13       Apache Jserv (Protocol v1.3)
    8180/tcp  open  http        Apache Tomcat/Coyote JSP engine 1.1
    8787/tcp  open  drb         Ruby DRb RMI (Ruby 1.8; path /usr/lib/ruby/1.8/drb)
    38253/tcp open  rpcbind
    38528/tcp open  rpcbind
    58186/tcp open  java-rmi    GNU Classpath grmiregistry
    58399/tcp open  rpcbind
```bash
# -A Агрессивный набор опций сканирования (включает в себя `-sC`, `-sV`, `-O`, `--traceroute`)
# -sU для сканирования UDP-портов
# -sV Определяет версии служб, работающих на открытых портах
# -sC Запускает набор встроенных NSE-скриптов по умолчанию
# -O определение ОС
# --traceroute выполняет трассировку до хоста
nmap -sU -A \
10.10.10.245 \
| grep -i 'open\|filtered'
```
    53/udp   open          domain      ISC BIND 9.4.2 (generic dns response: NOTIMP)
    69/udp   open|filtered tftp
    111/udp  open          rpcbind
    137/udp  open          netbios-ns  Microsoft Windows netbios-ns (workgroup: WORKGROUP)
    138/udp  open|filtered netbios-dgm
    2049/udp open          rpcbind
```bash
nmap -sS -p 1-1000 10.10.10.245 \
&& echo "SYN сканирование" \
&& nmap -sF -p 1-1000 10.10.10.245 \
&& echo "FIN сканирование" \
&& nmap -sX -p 1-1000 10.10.10.245 \
&& echo "Xmas сканирование" \
&& nmap -sU -p 53,69,111,137,138,2049 10.10.10.245 \
&& echo "UDP сканирование"
```
```bash
git branch -v

git remote -v

git status

git log --oneline

git add . .. \
&& git status

git commit -am 'commit_5_upd2, 13_1-explo_and_atta' \
&& git push --set-upstream study_fops39 13_1-explo_and_atta
```
### commit_27, master
```bash
sudo bash -c \
"for i in \$(virsh list --all \
| awk '{print \$2}'); do \
virsh destroy \$i; done"

sudo virsh net-list --all \
| awk 'NR > 3 {print $1}' \
| xargs -I {} sudo virsh net-destroy {}

git branch -v

git log --oneline

git status

git diff && git diff --staged

git add . .. \
&& git commit --amend --no-edit \
&& git push --set-upstream study_fops39 13_1-explo_and_atta --force

git checkout master

git branch -v

git merge 13_1-explo_and_atta

git add . .. \
&& git status

git commit -am 'commit_27, master & 13_1-explo_and_atta' \
&& git push study_fops39 master
```