# Для домашнего задания 13.2
### commit_28, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sdb-homeworks.git

find sdb-homeworks/ \
-mindepth 1 \
-not -name '13-02.md' -delete

mv sdb-homeworks 13_2

cd !$

mkdir img

mv {13-02,README}.md

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_28, master' \
&& git push --set-upstream study_fops39 master
```
### commit_1, `13_2-hosts_sec`
```bash
git log --oneline

git checkout -b 13_2-hosts_sec

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 13_2-hosts_sec' \
&& git push --set-upstream study_fops39 13_2-hosts_sec
```
### commit_2, `13_2-hosts_sec`
```bash
########################
# Подготовка к запуску #
########################

# Скачать образ Altlinux p11
wget -P \
~/iso/ \
https://download.basealt.ru/pub/distributions/ALTLinux/p11/images/workstation/x86_64/alt-workstation-11.1-x86_64.iso

# Создание Vagrant файла
cat>vagrantfile<<'OEF'
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Путь к ISO образу ALT Linux p11
  altlinux_iso_path_w = "/home/shoel/iso/alt-workstation-11.1-x86_64.iso"

  # Общие настройки для провайдера libvirt
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
    libvirt.boot 'hd' # Загрузка с жесткого диска
    libvirt.boot 'cdrom' # Загрузка с CDROM (вторая опция)
    libvirt.management_network_name = "vagrant-libvirt"
    libvirt.management_network_mode = "route"
    libvirt.management_network_guest_ipv6 = "no"
  end
 # --- Создание ВМ на altlinux ---
  config.vm.define "altlinux_w2" do |work2|
    work2.vm.hostname = "altlinux-w2"
    work2.vm.communicator = "none"
    work2.vm.provider :libvirt do |libvirt|
      libvirt.storage :file, :device => :cdrom, :path => altlinux_iso_path_w
      
    end
    work2.vm.provision "shell", inline: "echo 'altlinux_w2 VM created.'", run: "never"
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

git commit -am 'commit_2, 13_2-hosts_sec' \
&& git push --set-upstream study_fops39 13_2-hosts_sec
```
### commit_3, `13_2-hosts_sec`
```bash
# Запуск vagrant без удаления в случае ошибки запуска
vagrant up --no-destroy-on-error

# Остановка всех ВМ 
sudo bash -c \
"for i in \$(virsh list --all \
| awk '{print \$2}'); do \
virsh destroy \$i; done"

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

# определяем списка виртуальных машин 
sudo bash -c \
"virsh list --all \
| awk '/alt|ub/ {print \$2}'"

git branch -v

git remote -v

git status

git log --oneline

git add . .. \
&& git status

git commit -am 'commit_3, 13_2-hosts_sec' \
&& git push --set-upstream study_fops39 13_2-hosts_sec
```
### commit_4, `13_2-hosts_sec`
```bash
# Выводим список ВМ стенда для напоминания
sudo virsh list --all

# Создание нового раздела
sudo qemu-img create \
-f qcow2 \
/var/lib/libvirt/images/adm4_altlinux_w2-vda_2.qcow2 \
10G

# XML-конфиг для подключения диска к ВМ
cat > ./disk-device.xml <<EOF
<disk type='file' device='disk'>
  <driver name='qemu' type='qcow2'/>
  <source file='/var/lib/libvirt/images/adm4_altlinux_w2-vda_2.qcow2'/>
  <target dev='vdb' bus='virtio'/>
  <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>
</disk>
EOF

# Подключение диска к ВМ
sudo virsh attach-device \
adm4_altlinux_w2 --config --live \
./disk-device.xml

# проверка диска
sudo virsh dumpxml \
adm4_altlinux_w2 \
| grep -A5 '<disk'

# Экспорт настроек созданных ВМ
sudo bash -c \
"for i in \$(virsh list --all \
| awk '/w2/ {print \$2}') ; do \
virsh dumpxml \$i \
> \$i.xml; done"

sudo chmod 777 *.xml

# Поочередный запуск всех сетей libvirt со 2ого по списку
sudo virsh net-list --all \
| awk 'NR > 3 {print $1}' \
| xargs -I {} sudo virsh net-start {}

# Запуск Рабочей станции Alt p11
sudo virsh start \
--domain adm4_altlinux_w2

# создаем ключ для подключения к хосту
ssh-keygen -t ed25519 \
-f ~/.ssh/id_kvm_host_to_vms \
-C "kvm-host_access_to_vms"

# проброс ключа до Хоста
ssh-copy-id \
-i ~/.ssh/id_kvm_host_to_vms.pub \
sadmin@192.168.121.2

# включаем агента-ssh
eval $(ssh-agent) \
&& ssh-add  ~/.ssh/id_kvm_host_to_vms

git branch -v

git remote -v

git status

git log --oneline

git add . .. \
&& git status

git commit -am 'commit_4, 13_2-hosts_sec' \
&& git push --set-upstream study_fops39 13_2-hosts_sec
########################
```
### commit_5, `13_2-hosts_sec`
```bash
#####################
# Подготовка Хоста #
#####################
# вход на машину под суперпользователем 
ssh -t \
-i ~/.ssh/id_kvm_host_to_vms \
sadmin@alt-w-p11-route "su -"

# Поиск созданного примонтированного раздела в 10 G
lsblk \
| grep 10G

# Отключение из автозагрузки служб для графического взаимодействия
systemctl isolate \
multi-user.target

systemctl set-default \
multi-user.target

runlevel

# обновление системы
apt-get update \
&& update-kernel -y \
&& apt-get dist-upgrade -y

# Поиск eCryptfs в дистрибутиве altinux в репозитории p11
apt-cache search eCryptfs

# ПОИСК LUKS утилит
apt-cache search LUKS

# Установка утилит
apt-get install -y \
ecryptfs-utils \
cryptsetup \
tree
#####################
```
```bash
##############################
# Выполнение работы ecryptfs #
##############################

# Создание пользователя cryptouser
useradd -c "Скворцов Денис" \
cryptouser

# Подключение PAM модуля pam_ecryptfs.so
cat > /etc/pam.d/postlogin << 'EOF'
# ALT Linux: Для совместимости с ecryptfs
session optional pam_ecryptfs.so unwrap
EOF

# Доступ до служебной группы ecryptfs
usermod -a -G ecryptfs cryptouser

# Проверка читабельности из-под суперпользователя
tree -a \
/home/cryptouser/


# Шифрование каталога пользователя
ecryptfs-migrate-home -u cryptouser


# Проверка читабельности из-под суперпользователя
tree -a \
/home/cryptouser/ \
&& tree -a \
/home/cryptouser/.Private

git branch -v

git remote -v

git status

git log --oneline

git add . .. \
&& git status

git commit -am 'commit_5, 13_2-hosts_sec' \
&& git push --set-upstream study_fops39 13_2-hosts_sec
##############################
```
### commit_6, `13_2-hosts_sec`
```bash
##########################
# Выполнение работы LUKS #
##########################
# Для определения нового диска под шифрование
lsblk

# Создание Раздела LUKS на всем диске /dev/sda
cryptsetup luksFormat \
/dev/sda

# Проверка информации о LUKS разделе
cryptsetup luksDump \
/dev/sda

# Создаем отображение на новое блочное устройство dm-crypt
cryptsetup open \
/dev/sda \
skv-sec-disk


# Проверки отображения нового блочного устройства
lsblk

ll /dev/mapper/skv-sec-disk

cryptsetup -v status \
skv-sec-disk

# создание файловой системы на LUKS устройстве
mkfs.xfs /dev/dm-0

# Монтирование раздела LUKS для синхронизации данных
mount -m \
/dev/mapper/skv-sec-disk \
/mnt/home

# Проверка монтирования
findmnt /mnt/home

# синхронизация Каталога /home на новый раздел
rsync -aP \
/home/ \
/mnt/home

# Отмонтирование LUKS
umount /mnt/home

# Организуем запись в /etc/crypttab на основе UUID 
echo "skv-sec-disk \
UUID=$(cryptsetup luksUUID /dev/sda)" \
> /etc/crypttab

# Проверка записи в /etc/crypttab
cat /etc/crypttab

# Добавляем запись в /etc/fstab на основе UUID /dev/mapper/skv-sec-disk
echo "UUID=$(blkid \
-s UUID \
-o value /dev/mapper/skv-sec-disk) \
/home xfs defaults 0 2" \
>> /etc/fstab

# Проверка записи в /etc/fstab
cat /etc/fstab

# Перезагрузка 
systemctl reboot

# Вход на ВМ
ssh -t \
-i ~/.ssh/id_kvm_host_to_vms \
sadmin@alt-w-p11-route "su -" 

# Проверка Дисков и монтирований
lsblk

findmnt /home

git branch -v

git remote -v

git status

git log --oneline

git add . .. \
&& git status

git commit -am 'commit_6, 13_2-hosts_sec' \
&& git push --set-upstream study_fops39 13_2-hosts_sec
##########################
```
### commit_29, master
```bash
systemctl poweroff

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
&& git push --set-upstream study_fops39 13_2-hosts_sec --force

git checkout master

git branch -v

git merge 13_2-hosts_sec

git add . .. \
&& git status

git commit -am 'commit_29, master & 13_2-hosts_sec' \
&& git push study_fops39 master
```