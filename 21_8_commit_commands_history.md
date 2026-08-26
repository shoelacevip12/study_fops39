# Для домашнего задания 21.8 `Установка Kubernetes`

## commit_83, master Предварительная подготовка

```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master
```

<details>
<summary>
переход на master
</summary>

```log
Уже на «master»
```

</details>

```bash
# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/kuber-homeworks.git

cd kuber-homeworks

# Удаление всех файлов и каталогов кроме нужных
find kuber-homeworks/ \
-mindepth 1 \
-not -path "*3.2*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем
mv -v kuber-homeworks \
21_8

# Переход в каталог по последней переменной вывода последней команды
cd !$

mv -v 3.2/* ./

# Удаление всех файлов и каталогов кроме нужных
find . \
-mindepth 1 \
-not -path "*3.2.md*" \
-delete

# Переименование 
mv -v {3.2,README}.md
```

```bash
# Просмотр текущих удаленных репозиториев
git remote -v

# Проверка текущего локального состояния репозитория
git status

git rm -r --cached \
../

git remote -v

# Добавляем ключи агенту ssh от репозитория gitflic и github
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_gitflic_2026_ed25519 \
&& ssh-add ~/.ssh/id_github_2026_ed25519 \
&& ssh-agent -c

# Просмотр различий в рабочей директории и индексов
git diff \
&& git diff --staged

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

git diff \
&& git diff --staged

# Просмотр истории коммитов в кратком формате
git log --oneline

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий
git commit -am 'commit_83, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master \
&& git push \
--set-upstream \
study-fops39_sc \
master
```

## commit_1, `21_8-kubeadm-inst`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 21_8-kubeadm-inst

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавляем ключи агенту ssh от репозитория gitflic и github
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_gitflic_2026_ed25519 \
&& ssh-add ~/.ssh/id_github_2026_ed25519 \
&& ssh-agent -c

# Просмотр различий в рабочей директории и индексов
git diff \
&& git diff --staged

git rm -r --cached \
./ ../

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit1, 21_8-kubeadm-inst' \
&& git push \
--set-upstream \
study_fops39 \
21_8-kubeadm-inst \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_8-kubeadm-inst \
&& git push \
--set-upstream \
study-fops39_sc \
21_8-kubeadm-inst
```

## commit_2,`21_8-kubeadm-inst`

### Удаление кластера kind из предыдущего задания

```bash
# Удаление кластера kind из предыдущего задания
kind delete cluster \
--name="$(kind get clusters |head -n1)"
```

<details>
<summary>
Удаление кластера kind из предыдущего задания
</summary>

```log
Deleting cluster "skv-21-2-k8s-depl" ...
Deleted nodes: ["skv-21-2-k8s-depl-worker2" "skv-21-2-k8s-depl-worker" "skv-21-2-k8s-depl-control-plane"]
```

</details>

### Запуск lcx контейнеров

### Archlinux host libvirt lxc

#### Включение nested виртуализации

```bash
# Включаем агента в текущей оснастке для подключения к хост на archlinux
> ~/.ssh/known_hosts
eval $(ssh-agent) \
&& ssh-add  ~/.ssh/id_kvm_host

# вход на хост по ключу по ssh и вход под суперпользователя
ssh -t \
-i ~/.ssh/id_kvm_host \
-o StrictHostKeyChecking=accept-new \
shoel@192.168.89.193

# Проверка вложенной виртуализации компьютером на процессоре AMD 
# (если intel заменить amd в команде ниже)
sudo cat /sys/module/kvm_amd/parameters/nested

```

<details>
<summary>
Включение nested виртуализации
</summary>

```log
1
```

</details>

```bash
# Предварительно выключить все виртуальные машины на хосте
# и выгрузить модуль ядра kvm для процессора amd
sudo modprobe \
-r \
kvm_amd

# Включение модуля kvm nested виртуализации, работающей до перезапуска хоста
sudo modprobe kvm_amd nested=1

# Выставление опции загрузки nested виртуализации в автозапуск
echo "options kvm_amd nested=1" \
| sudo tee /etc/modprobe.d/kvm_amd.conf

ls -l /dev/kvm
```

```log
crw-rw-rw- 1 root kvm 10, 232 авг 25 18:40 /dev/kvm
```

#### Создание сети моста средствами systemd

```bash
# отключаем и останавливаем NetworkManager и связанные службы
systemctl \
disable --now \
NetworkManager \
NetworkManager-wait-online

# Включение и запуск служб управления сетью systemd
systemctl \
enable --now \
systemd-networkd \
systemd-resolved


# Создание Интерфейс моста как устройства
cat >/etc/systemd/network/15-br0.netdev<<'EOF'
[NetDev]
Name=br0
Kind=bridge
EOF

# Привязка в существующем конфиге физического Ethernet к мосту
cat >/etc/systemd/network/10-eno1.network<<'EOF'
[Match]
Name=eno1

[Network]
Bridge=br0
EOF

# Сеть моста, создаем настройки IP
cat > /etc/systemd/network/15-br0.network <<'EOF'
[Match]
Name=br0

[Network]
DHCP=ipv4
EOF

# Перезапуск сетевой службы
systemctl restart \
systemd-networkd
```

```bash
# Поиск пакета libvirt с lxc
sudo pacman -Qi libvirt \
| grep -B10 lxc
```

<details>
<summary>
Поиск пакета libvirt с lxc
</summary>

```log
Название             : libvirt
Версия               : 1:12.6.0-1
Описание             : API for controlling virtualization engines (openvz,kvm,qemu,virtualbox,xen,etc)
Архитектура          : x86_64
URL                  : https://libvirt.org/
Лицензии             : LGPL-2.1-or-later  GPL-3.0-or-later
Группы               : Нет
Предоставляет        : libvirt=12.6.0  libvirt.so=0-64  libvirt-admin.so=0-64  libvirt-lxc.so=0-64  libvirt-qemu.so=0-64
```

</details>

```bash
# Установка пакета libvirt
sudo pacman -Syu libvirt
```

<details>
<summary>
Установка пакета libvirt
</summary>

```log
...
проверка конфликтов...

Пакеты (1) libvirt-1:12.6.0-1

Будет установлено:  55,22 MiB
Изменение размера:   0,00 MiB

:: Приступить к установке? [Y/n] Y
...
```

</details>

```bash
sudo sh -c "systemctl start libvirtd \
&& systemctl is-active libvirtd" 
```

```log
active
```

```bash
# Получение URI libvirt
virsh -c lxc:/// uri \
| grep lxc
```

<details>
<summary>
Получение URI libvirt
</summary>

```log
lxc:///
```

</details>

```bash
# Проверка прав для libvirt для пользователя НЕ root
virsh -c lxc:/// list --all
```

<details>
<summary>
Проверка прав для libvirt для пользователя НЕ root
</summary>

```log
 ID   Имя   Состояние
-----------------------
```

</details>

### Управление ВМ средствами virt-manager, подключение с удаленного узла

```bash
eval $(ssh-agent) && ssh-add  ~/.ssh/id_kvm_host
export LIBVIRT_DEFAULT_URI=lxc+ssh://shoel@192.168.89.193/system

virt-manager -c lxc+ssh://shoel@192.168.89.193/system
```

```bash
mkdir k8s-nested-virt

cd !$
```

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 21_8-kubeadm-inst' \
&& git push \
--set-upstream \
study_fops39 \
21_8-kubeadm-inst \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_8-kubeadm-inst \
&& git push \
--set-upstream \
study-fops39_sc \
21_8-kubeadm-inst
```

## commit_3,`21_8-kubeadm-inst`

#### ПАМЯТКА: сброс блока ввода пароля в сеансе пользователя на Archlinux

```bash
faillock --reset
```

```bash
# Скачиваем и распаковываем rootfs
### Cloud версия
curl -o ~/iso/ubuntu_24.04_cloud_rootfs.tar.xz \
https://fra1mirror01.do.images.linuxcontainers.org/images/ubuntu/noble/amd64/cloud/20260825_07%3A42/rootfs.tar.xz

curl -o ~/iso/alt-rootfs.tar.xz \
https://ftp.altlinux.org/pub/distributions/ALTLinux/images/p11/cloud/x86_64/alt-p11-rootfs-systemd-etcnet-x86_64.tar.xz
```

```bash
# Создание каталога для эталонной файловой системы контейнера
mkdir -vp \
/disk/VMs/k8s_rootfs

# Распаковка cloud версии
tar -xvJf \
~/iso/alt-rootfs.tar.xz \
-C /disk/VMs//k8s_rootfs
```


```bash
ll \
/disk/VMs/k8s_rootfs
```

## Вариант ручного проброса имеющего ключа и пароля в файловую систему lxc контейнера ОС

```bash
# проброс ключа ssh на суперпользователя в эталонную ФС контейнера
mkdir -vp \
/disk/VMs/k8s_rootfs/root/.ssh/

cat  ~/.ssh/id_kvm_host.pub \
>>/disk/VMs/k8s_rootfs/root/.ssh/authorized_keys

# на всякий случай задать пароль для root "qwerty!2" в эталонный образ
sed -i 's|t:x:|t:$6$jOJaaad3$213aac5XXw7XMVrtI8dPuwyJazAeMOoaq5QOvo.uf/7V70lA3PIsV7WAiM3d1SWPyDkPiVTvizRHta1P7ZyKs/:|' \
/disk/VMs/k8s_rootfs/etc/tcb/root/shadow
```

## Создание файла etcnet для работы сети по static

```bash
# отключение ipv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" \
| tee -a  /disk/VMs/k8s_rootfs/etc/sysctl.conf

# создание каталога для интерфейса внутри эталонного образа
mkdir -pv /disk/VMs/k8s_rootfs/etc/net/ifaces/eth0/
```

<details>
<summary>
Вывод подготовки для работы с сетью
</summary>

```log
net.ipv6.conf.all.disable_ipv6 = 1

mkdir: создан каталог '/disk/VMs/k8s_rootfs/etc/net/ifaces/eth0/'
```

</details>

### Файл настроек для работы по static для интерфейса eth0

<details>
<summary>
Файл настроек для работы по static для интерфейса eth0 lxc контейнера
</summary>

```bash
cat > /disk/VMs/k8s_rootfs/etc/net/ifaces/eth0/options <<'EOF'
BOOTPROTO=static
TYPE=eth
SYSTEMD_CONTROLLED=no
DISABLED=no
CONFIG_WIRELESS=no
SYSTEMD_BOOTPROTO=static
CONFIG_IPV4=yes
CONFIG_IPV6=no
NM_CONTROLLED=no
ONBOOT=yes
EOF

echo "default via 192.168.89.1" > /disk/VMs/k8s_rootfs/etc/net/ifaces/eth0/ipv4route

cat > /disk/VMs/k8s_rootfs/etc/net/ifaces/eth0/resolv.conf <<EOF
nameserver 192.168.89.1
search den.skv
EOF

cat > /disk/VMs/k8s_rootfs/etc/resolv.conf <<EOF
nameserver 192.168.89.1
search den.skv
EOF
```

</details>

## Пулы на Физической Хостовой машине

```bash
# Список пулов физического хоста
virsh pool-list \
--all \
--details
```

<details>
<summary>
Список пулов физического хоста
</summary>

```log
 Имя       Состояние   Автозапуск   Постоянный   Размер       Распределение   Доступно
------------------------------------------------------------------------------------------
 default   работает    yes          yes          467,40 GiB   144,24 GiB      323,16 GiB
 iso       работает    yes          yes          15,71 TiB    11,89 TiB       3,81 TiB
 VMs       работает    yes          yes          467,40 GiB   144,24 GiB      323,16 GiB
```

</details>

## Создание отдельного rootfs для каждой ноды

### Скрипт копирования с эталонного образа `/disk/VMs/k8s_rootfs`

```bash
mkdir -pv scripts

cat > scripts/clone_rootfs.sh<<'EOF'
#!/bin/bash
# Скрипт подготовки отдельных rootfs для каждой k8s-ноды.
#
# Каждая нода получает свою копию rootfs (/disk/VMs/<нода>/rootfs),
# уникальные machine-id/hostname и статический IP через etcnet.

set -euo pipefail

BASE_ROOTFS="${BASE_ROOTFS:-/disk/VMs/k8s_rootfs}"
LXC_ROOT="${LXC_ROOT:-/disk/VMs}"

SUDO=""
[ "$(id -u)" -eq 0 ] || SUDO="sudo"

clone_node() {
    local node="$1" octet="$2"
    local dest="$LXC_ROOT/$node/rootfs"

    if [ -d "$dest" ]; then
        echo "  пропускаю (уже существует): $dest"
        return
    fi

    echo "Клонирование $BASE_ROOTFS -> $dest"
    $SUDO mkdir -p "$dest"
    $SUDO cp -a "$BASE_ROOTFS/." "$dest/"
    $SUDO chown -R 0:0 "$dest"

    $SUDO sh -c ": > \"$dest/etc/machine-id\""
    $SUDO rm -f "$dest/var/lib/dbus/machine-id"
    $SUDO ln -sf /etc/machine-id "$dest/var/lib/dbus/machine-id" 2>/dev/null || true

    echo "$node" | $SUDO tee "$dest/etc/hostname" >/dev/null

    # Статический IP через etcnet
    $SUDO mkdir -p "$dest/etc/net/ifaces/eth0"
    echo "192.168.89.$octet/24" \
    | $SUDO tee "$dest/etc/net/ifaces/eth0/ipv4address" >/dev/null
    echo "  $node -> IP 192.168.89.$octet/24"
}

clone_node k8s-cp 11
clone_node k8s-w1 12
clone_node k8s-w2 13
clone_node k8s-w3 14
clone_node k8s-w4 15

echo
echo "Готово."
echo "Пути rootfs: $LXC_ROOT/{k8s-cp,k8s-w1,k8s-w2,k8s-w3,k8s-w4}/rootfs"
EOF

chmod -v +x scripts/clone_rootfs.sh

BASE_ROOTFS=/disk/VMs/k8s_rootfs \
./scripts/clone_rootfs.sh
```

<details>
<summary>
Вывод скрипта
</summary>

```log
права доступа 'scripts/clone_rootfs.sh' оставлены в виде 0777 (rwxrwxrwx)
Клонирование /disk/VMs/k8s_rootfs -> /disk/VMs/k8s-cp/rootfs
[sudo] пароль для shoel: 
  k8s-cp -> IP 192.168.89.11/24
Клонирование /disk/VMs/k8s_rootfs -> /disk/VMs/k8s-w1/rootfs
  k8s-w1 -> IP 192.168.89.12/24
Клонирование /disk/VMs/k8s_rootfs -> /disk/VMs/k8s-w2/rootfs
  k8s-w2 -> IP 192.168.89.13/24
Клонирование /disk/VMs/k8s_rootfs -> /disk/VMs/k8s-w3/rootfs
  k8s-w3 -> IP 192.168.89.14/24
Клонирование /disk/VMs/k8s_rootfs -> /disk/VMs/k8s-w4/rootfs
  k8s-w4 -> IP 192.168.89.15/24

Готово.
Пути rootfs: /disk/VMs/{k8s-cp,k8s-w1,k8s-w2,k8s-w3,k8s-w4}/rootfs
```

</details>

```bash
# все 5 нод, владелецы root
ls -ld /disk/VMs/k8s-*/rootfs

ls -l /disk/VMs/k8s-cp/rootfs/etc/machine-id

# Hostname соответствует клонированному образу /disk/VMs/k8s-cp
cat /disk/VMs/k8s-cp/rootfs/etc/hostname
```

<details>
<summary>
проверка клонирования
</summary>

```log
drwxr-xr-x 18 root root 4096 апр 13 16:19 /disk/VMs/k8s-cp/rootfs
drwxr-xr-x 18 root root 4096 апр 13 16:19 /disk/VMs/k8s-w1/rootfs
drwxr-xr-x 18 root root 4096 апр 13 16:19 /disk/VMs/k8s-w2/rootfs
drwxr-xr-x 18 root root 4096 апр 13 16:19 /disk/VMs/k8s-w3/rootfs
drwxr-xr-x 18 root root 4096 апр 13 16:19 /disk/VMs/k8s-w4/rootfs

-r--r--r-- 1 root root 0 авг 25 23:03 /disk/VMs/k8s-cp/rootfs/etc/machine-id

k8s-cp
```

</details>

### Шаблон под параметризацию Ansible

<details>
<summary>
Шаблон под параметризацию Ansible
</summary>

```xml
cat > ./templates/lxc-k8s.xml.j2 <<'EOF'
<domain type='lxc'>
  <name>{{ node_name }}</name>
  <memory unit='KiB'>2097152</memory>
  <vcpu>2</vcpu>

  <os>
    <type>exe</type>
    <init>/sbin/init</init>
  </os>

  <!-- NESTED VIRTUALIZATION: проброс CPU-флагов хоста (vmx/svm) -->
  <cpu mode='host-passthrough'/>

  <features>
    <capabilities policy='allow'>
      <net_admin/>
      <sys_admin/>
      <sys_ptrace/>
      <mknod/>
    </capabilities>
  </features>

  <clock offset="timezone" timezone="Europe/Moscow"/>

  <devices>
    <!-- Корневая ФС (отдельная для каждой ноды, чтобы контейнеры не мешали друг другу) -->
    <filesystem type='mount'>
      <source dir='/disk/VMs/{{ node_name }}/rootfs'/>
      <target dir='/'/>
    </filesystem>

    <!-- NESTED VIRTUALIZATION: проброс /dev/kvm -->
    <filesystem type='mount'>
      <source dir='/dev/kvm'/>
      <target dir='/dev/kvm'/>
    </filesystem>

    <!-- Сеть: статический IP -->
    <interface type='bridge'>
      <source bridge='br0'/>
      <ip address='{{ ip_address }}' family='ipv4' prefix='24'/>
      <route family='ipv4' address='0.0.0.0' gateway='192.168.89.1'/>
      <guest dev='eth0'/>
      <link state='up'/>
    </interface>

    <console type='pty'>
      <target type='lxc' port='0'/>
    </console>
    <tty/>
  </devices>
</domain>
EOF
```

</details>

### Шаблон развертывания ноды `Control-Plane`

<details>
<summary>
Xml шаблон lxc под control-plane
</summary>

```xml
cat > ./lxc-k8s-cp.xml <<'EOF'
<domain type='lxc'>
  <name>k8s-cp</name>
  <memory unit='KiB'>2097152</memory>
  <vcpu>2</vcpu>

  <os>
    <type>exe</type>
    <init>/sbin/init</init>
  </os>

  <cpu mode='host-passthrough'/>

  <features>
    <capabilities policy='allow'>
      <net_admin/>
      <sys_admin/>
      <sys_ptrace/>
      <mknod/>
    </capabilities>
  </features>

  <clock offset="timezone" timezone="Europe/Moscow"/>

  <devices>

    <filesystem type='mount'>
      <source dir='/disk/VMs/k8s-cp/rootfs'/>
      <target dir='/'/>
    </filesystem>

    <filesystem type='mount'>
      <source dir='/dev/kvm'/>
      <target dir='/dev/kvm'/>
    </filesystem>

    <interface type='bridge'>
      <source bridge='br0'/>
      <ip address='192.168.89.11' family='ipv4' prefix='24'/>
      <route family='ipv4' address='0.0.0.0' gateway='192.168.89.1'/>
      <guest dev='eth0'/>
      <link state='up'/>
    </interface>

    <console type='pty'>
      <target type='lxc' port='0'/>
    </console>
    <tty/>
  </devices>
</domain>
EOF
```

</details>

### Шаблон развертывания ноды `Worker ноду 1`

<details>
<summary>
Xml шаблон lxc под под рабочую ноду 1
</summary>

```xml
cat > ./lxc-k8s-w1.xml <<'EOF'
<domain type='lxc'>
  <name>k8s-w1</name>
  <memory unit='KiB'>2097152</memory>
  <vcpu>2</vcpu>

  <os>
    <type>exe</type>
    <init>/sbin/init</init>
  </os>

  <cpu mode='host-passthrough'/>

  <features>
    <capabilities policy='allow'>
      <net_admin/>
      <sys_admin/>
      <sys_ptrace/>
      <mknod/>
    </capabilities>
  </features>

  <clock offset="timezone" timezone="Europe/Moscow"/>

  <devices>

    <filesystem type='mount'>
      <source dir='/disk/VMs/k8s-w1/rootfs'/>
      <target dir='/'/>
    </filesystem>

    <filesystem type='mount'>
      <source dir='/dev/kvm'/>
      <target dir='/dev/kvm'/>
    </filesystem>

    <interface type='bridge'>
      <source bridge='br0'/>
      <ip address='192.168.89.12' family='ipv4' prefix='24'/>
      <route family='ipv4' address='0.0.0.0' gateway='192.168.89.1'/>
      <guest dev='eth0'/>
      <link state='up'/>
    </interface>

    <console type='pty'>
      <target type='lxc' port='0'/>
    </console>
    <tty/>
  </devices>
</domain>
EOF
```

</details>

### Шаблон развертывания ноды `Worker ноду 2`

<details>
<summary>
Xml шаблон lxc под под рабочую ноду 2
</summary>

```xml
cat > ./lxc-k8s-w2.xml <<'EOF'
<domain type='lxc'>
  <name>k8s-w2</name>
  <memory unit='KiB'>2097152</memory>
  <vcpu>2</vcpu>

  <os>
    <type>exe</type>
    <init>/sbin/init</init>
  </os>

  <cpu mode='host-passthrough'/>

  <features>
    <capabilities policy='allow'>
      <net_admin/>
      <sys_admin/>
      <sys_ptrace/>
      <mknod/>
    </capabilities>
  </features>

  <clock offset="timezone" timezone="Europe/Moscow"/>

  <devices>

    <filesystem type='mount'>
      <source dir='/disk/VMs/k8s-w2/rootfs'/>
      <target dir='/'/>
    </filesystem>

    <filesystem type='mount'>
      <source dir='/dev/kvm'/>
      <target dir='/dev/kvm'/>
    </filesystem>

    <interface type='bridge'>
      <source bridge='br0'/>
      <ip address='192.168.89.13' family='ipv4' prefix='24'/>
      <route family='ipv4' address='0.0.0.0' gateway='192.168.89.1'/>
      <guest dev='eth0'/>
      <link state='up'/>
    </interface>

    <console type='pty'>
      <target type='lxc' port='0'/>
    </console>
    <tty/>
  </devices>
</domain>
EOF
```

</details>

### Шаблон развертывания ноды `Worker ноду 3`

<details>
<summary>
Xml шаблон lxc под под рабочую ноду 3
</summary>

```xml
cat > ./lxc-k8s-w3.xml <<'EOF'
<domain type='lxc'>
  <name>k8s-w3</name>
  <memory unit='KiB'>2097152</memory>
  <vcpu>2</vcpu>

  <os>
    <type>exe</type>
    <init>/sbin/init</init>
  </os>

  <cpu mode='host-passthrough'/>

  <features>
    <capabilities policy='allow'>
      <net_admin/>
      <sys_admin/>
      <sys_ptrace/>
      <mknod/>
    </capabilities>
  </features>

  <clock offset="timezone" timezone="Europe/Moscow"/>

  <devices>

    <filesystem type='mount'>
      <source dir='/disk/VMs/k8s-w3/rootfs'/>
      <target dir='/'/>
    </filesystem>

    <filesystem type='mount'>
      <source dir='/dev/kvm'/>
      <target dir='/dev/kvm'/>
    </filesystem>

    <interface type='bridge'>
      <source bridge='br0'/>
      <ip address='192.168.89.14' family='ipv4' prefix='24'/>
      <route family='ipv4' address='0.0.0.0' gateway='192.168.89.1'/>
      <guest dev='eth0'/>
      <link state='up'/>
    </interface>

    <console type='pty'>
      <target type='lxc' port='0'/>
    </console>
    <tty/>
  </devices>
</domain>
EOF
```

</details>

### Шаблон развертывания ноды `Worker ноду 4`

<details>
<summary>
Xml шаблон lxc под под рабочую ноду 4
</summary>

```xml
cat > ./lxc-k8s-w4.xml <<'EOF'
<domain type='lxc'>
  <name>k8s-w4</name>
  <memory unit='KiB'>2097152</memory>
  <vcpu>2</vcpu>

  <os>
    <type>exe</type>
    <init>/sbin/init</init>
  </os>

  <cpu mode='host-passthrough'/>

  <features>
    <capabilities policy='allow'>
      <net_admin/>
      <sys_admin/>
      <sys_ptrace/>
      <mknod/>
    </capabilities>
  </features>

  <clock offset="timezone" timezone="Europe/Moscow"/>

  <devices>

    <filesystem type='mount'>
      <source dir='/disk/VMs/k8s-w4/rootfs'/>
      <target dir='/'/>
    </filesystem>

    <filesystem type='mount'>
      <source dir='/dev/kvm'/>
      <target dir='/dev/kvm'/>
    </filesystem>

    <interface type='bridge'>
      <source bridge='br0'/>
      <ip address='192.168.89.15' family='ipv4' prefix='24'/>
      <route family='ipv4' address='0.0.0.0' gateway='192.168.89.1'/>
      <guest dev='eth0'/>
      <link state='up'/>
    </interface>

    <console type='pty'>
      <target type='lxc' port='0'/>
    </console>
    <tty/>
  </devices>
</domain>
EOF
```

</details>

### Запуск контейнеров

```bash
# Регистрирование конфигов
for f in lxc-k8s-*.xml; do
echo "Определено $f"
virsh -c lxc:/// define "$f"
done
```

<details>
<summary>
Вывод регистрации lxc контейнеров под k8s
</summary>

```log
Определено lxc-k8s-cp.xml
Domain 'k8s-cp' defined from lxc-k8s-cp.xml

Определено lxc-k8s-w1.xml
Domain 'k8s-w1' defined from lxc-k8s-w1.xml

Определено lxc-k8s-w2.xml
Domain 'k8s-w2' defined from lxc-k8s-w2.xml

Определено lxc-k8s-w3.xml
Domain 'k8s-w3' defined from lxc-k8s-w3.xml

Определено lxc-k8s-w4.xml
Domain 'k8s-w4' defined from lxc-k8s-w4.xml
```

</details>

```bash
# Запуск контейнеров
for f in $(virsh -c lxc:/// list --all --name); do
echo "Запуск $f"
virsh -c lxc:/// start "$f"
done
```

<details>
<summary>
Вывод запуска контейнеров
</summary>

```log
Запуск k8s-cp
Domain 'k8s-cp' started

Запуск k8s-w1
Domain 'k8s-w1' started

Запуск k8s-w2
Domain 'k8s-w2' started

Запуск k8s-w3
Domain 'k8s-w3' started

Запуск k8s-w4
Domain 'k8s-w4' started
```

</details>

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit3, 21_8-kubeadm-inst' \
&& git push \
--set-upstream \
study_fops39 \
21_8-kubeadm-inst \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_8-kubeadm-inst \
&& git push \
--set-upstream \
study-fops39_sc \
21_8-kubeadm-inst
```

## commit_4,`21_8-kubeadm-inst`

### Проверка работы в контейнерах

```bash
# Проверка входа в контейнеры
for f in {1..5}; do
echo "Проверка входа на .1$f"
ssh -t -o StrictHostKeyChecking=accept-new -i ~/.ssh/id_kvm_host root@192.168.89.1$f "exit"
done
```

<details>
<summary>
Вывод проверки входа в контейнеры LXC по ssh
</summary>

```log
Проверка входа на .11
Warning: Permanently added '192.168.89.11' (ED25519) to the list of known hosts.
Connection to 192.168.89.11 closed.
Проверка входа на .12
Warning: Permanently added '192.168.89.12' (ED25519) to the list of known hosts.
Connection to 192.168.89.12 closed.
Проверка входа на .13
Warning: Permanently added '192.168.89.13' (ED25519) to the list of known hosts.
Connection to 192.168.89.13 closed.
Проверка входа на .14
Warning: Permanently added '192.168.89.14' (ED25519) to the list of known hosts.
Connection to 192.168.89.14 closed.
Проверка входа на .15
Warning: Permanently added '192.168.89.15' (ED25519) to the list of known hosts.
Connection to 192.168.89.15 closed.
```

</details>

```bash
# принудительный перезапуск сетевой службы для применения сетевых настроек
for f in {1..5}; do
echo "перезапуск сетевой службы на .1$f"
ssh -o StrictHostKeyChecking=accept-new \
-o ConnectTimeout=1 \
-o ServerAliveInterval=1 \
-o ServerAliveCountMax=2 \
-i ~/.ssh/id_kvm_host root@192.168.89.1$f \
"systemctl restart network; poweroff"
done
```

<details>
<summary>
Вывод ожидаемого обрыва связи при перезапуске сетевой службы для применения сетевых настроек
</summary>

```log
перезапуск сетевой службы на .11
Timeout, server 192.168.89.11 not responding.
перезапуск сетевой службы на .12
Timeout, server 192.168.89.12 not responding.
перезапуск сетевой службы на .13
Timeout, server 192.168.89.13 not responding.
перезапуск сетевой службы на .14
Timeout, server 192.168.89.14 not responding.
перезапуск сетевой службы на .15
Timeout, server 192.168.89.15 not responding.
```

</details>

```bash
# Повторный Запуск контейнеров
for f in $(virsh -c lxc:/// list --all --name); do
echo "Повторный Запуск на $f"
virsh -c lxc:/// start "$f"
done
```

<details>
<summary>
Вывод повторного запуска контейнеров
</summary>

```log
Повторный Запуск на k8s-cp
Domain 'k8s-cp' started

Повторный Запуск на k8s-w1
Domain 'k8s-w1' started

Повторный Запуск на k8s-w2
Domain 'k8s-w2' started

Повторный Запуск на k8s-w3
Domain 'k8s-w3' started

Повторный Запуск на k8s-w4
Domain 'k8s-w4' started
```

</details>

```bash
# Проверка resolver dns
for f in {1..5}; do
echo "Проверка DNS resolver на .1$f"
ssh -t -o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_kvm_host root@192.168.89.1$f \
"ping -c3 ya.ru"
done
```

<details>
<summary>
Проверка DNS resolver
</summary>

```log
Проверка DNS resolver на .11
PING ya.ru (77.88.44.242) 56(84) bytes of data.
64 bytes from ya.ru (77.88.44.242): icmp_seq=1 ttl=250 time=5.06 ms
64 bytes from ya.ru (77.88.44.242): icmp_seq=2 ttl=250 time=4.95 ms
64 bytes from ya.ru (77.88.44.242): icmp_seq=3 ttl=250 time=5.07 ms

--- ya.ru ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 4.952/5.026/5.071/0.052 ms
Connection to 192.168.89.11 closed.
Проверка DNS resolver на .12
PING ya.ru (77.88.44.242) 56(84) bytes of data.
64 bytes from ya.ru (77.88.44.242): icmp_seq=1 ttl=250 time=5.09 ms
64 bytes from ya.ru (77.88.44.242): icmp_seq=2 ttl=250 time=5.15 ms
64 bytes from ya.ru (77.88.44.242): icmp_seq=3 ttl=250 time=5.12 ms

--- ya.ru ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 5.092/5.120/5.149/0.023 ms
Connection to 192.168.89.12 closed.
Проверка DNS resolver на .13
PING ya.ru (77.88.44.242) 56(84) bytes of data.
64 bytes from ya.ru (77.88.44.242): icmp_seq=1 ttl=250 time=4.89 ms
64 bytes from ya.ru (77.88.44.242): icmp_seq=2 ttl=250 time=5.03 ms
64 bytes from ya.ru (77.88.44.242): icmp_seq=3 ttl=250 time=5.27 ms

--- ya.ru ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 4.885/5.062/5.274/0.160 ms
Connection to 192.168.89.13 closed.
Проверка DNS resolver на .14
PING ya.ru (5.255.255.242) 56(84) bytes of data.
64 bytes from ya.ru (5.255.255.242): icmp_seq=1 ttl=250 time=5.51 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=2 ttl=250 time=5.64 ms
64 bytes from ya.ru (5.255.255.242): icmp_seq=3 ttl=250 time=5.67 ms

--- ya.ru ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 5.509/5.605/5.665/0.068 ms
Connection to 192.168.89.14 closed.
Проверка DNS resolver на .15
PING ya.ru (77.88.55.242) 56(84) bytes of data.
64 bytes from ya.ru (77.88.55.242): icmp_seq=1 ttl=250 time=10.1 ms
64 bytes from ya.ru (77.88.55.242): icmp_seq=2 ttl=250 time=10.4 ms
64 bytes from ya.ru (77.88.55.242): icmp_seq=3 ttl=250 time=10.3 ms

--- ya.ru ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 10.126/10.281/10.413/0.118 ms
Connection to 192.168.89.15 closed.
```

</details>

```bash
# Проверка связности нод между собой по dns именам через местный DNS
for f in {1..5}; do
echo "---===Проверка связности нод по dns на ноде .1$f===---"
ssh -t -o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_kvm_host root@192.168.89.1$f \
"for D in cp w{1..4}; do \
ping -c 2 k8s-\$D \
| grep -B1 'packets transmitted' && echo ; done"
done
```

<details>
<summary>
Проверка DNS связности нод
</summary>

```log
---===Проверка связности нод по dns на ноде .11===---
--- k8s-cp ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

--- k8s-w1.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms

--- k8s-w2.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

--- k8s-w3.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms

--- k8s-w4.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

Connection to 192.168.89.11 closed.
---===Проверка связности нод по dns на ноде .12===---
--- k8s-cp.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

--- k8s-w1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms

--- k8s-w2.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms

--- k8s-w3.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

--- k8s-w4.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1044ms

Connection to 192.168.89.12 closed.
---===Проверка связности нод по dns на ноде .13===---
--- k8s-cp.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1021ms

--- k8s-w1.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

--- k8s-w2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

--- k8s-w3.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

--- k8s-w4.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

Connection to 192.168.89.13 closed.
---===Проверка связности нод по dns на ноде .14===---
--- k8s-cp.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms

--- k8s-w1.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

--- k8s-w2.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1062ms

--- k8s-w3 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms

--- k8s-w4.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

Connection to 192.168.89.14 closed.
---===Проверка связности нод по dns на ноде .15===---
--- k8s-cp.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

--- k8s-w1.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

--- k8s-w2.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

--- k8s-w3.den.skv ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

--- k8s-w4 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms

Connection to 192.168.89.15 closed.
```

</details>

### Отключение swap в LXC контейнерах

```bash
# Отключение файла подкачки на хостовой системе с LXC
sudo swapoff -va

# Проверка Отключенного swap в LXC контейнерах
for f in {1..5}; do
echo "Проверка Отключенного swap на .1$f"
ssh -t -o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_kvm_host root@192.168.89.1$f \
"free -h | grep Swap"
done
```

<details>
<summary>
Вывод Скрипта проверки swap в LXC контейнерах
</summary>

```log
swapoff /dev/zram0

Проверка Отключенного swap на .11
Swap:             0B          0B          0B
Connection to 192.168.89.11 closed.
Проверка Отключенного swap на .12
Swap:             0B          0B          0B
Connection to 192.168.89.12 closed.
Проверка Отключенного swap на .13
Swap:             0B          0B          0B
Connection to 192.168.89.13 closed.
Проверка Отключенного swap на .14
Swap:             0B          0B          0B
Connection to 192.168.89.14 closed.
Проверка Отключенного swap на .15
Swap:             0B          0B          0B
Connection to 192.168.89.15 closed.
```

</details>

### Обновление Приложений в LXC контейнерах и установка kubeadm, kubelet, crio и cri-tools

```bash
# Поиск доступных версий kubernetes1.3 (на момент Августа 2026 года)
ssh -t -o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_kvm_host root@192.168.89.11 \
"apt-get update && \
apt-cache search kubernetes1.3"
```

<details>
<summary>
Вывод Скрипта поиска доступных версий kubernetes1.3
</summary>

```log
Get:1 http://ftp.altlinux.org p11/branch/x86_64 release [4210B]
Get:2 http://ftp.altlinux.org p11/branch/x86_64-i586 release [1665B]
Get:3 http://ftp.altlinux.org p11/branch/noarch release [2831B]
Fetched 8706B in 0s (267kB/s)
Hit http://ftp.altlinux.org p11/branch/x86_64/classic pkglist
Hit http://ftp.altlinux.org p11/branch/x86_64/classic release
Hit http://ftp.altlinux.org p11/branch/x86_64-i586/classic pkglist
Hit http://ftp.altlinux.org p11/branch/x86_64-i586/classic release
Hit http://ftp.altlinux.org p11/branch/noarch/classic pkglist
Hit http://ftp.altlinux.org p11/branch/noarch/classic release
Reading Package Lists... Done
Building Dependency Tree... Done
coredns-for-kubernetes1.33 - CoreDNS is a DNS server that chains plugins
coredns-for-kubernetes1.34 - CoreDNS is a DNS server that chains plugins
coredns-for-kubernetes1.35 - CoreDNS is a DNS server that chains plugins
coredns-for-kubernetes1.36 - CoreDNS is a DNS server that chains plugins
etcd-for-kubernetes1.31 - A highly-available key value store for shared configuration
etcd-for-kubernetes1.32 - A highly-available key value store for shared configuration
etcd-for-kubernetes1.33 - A highly-available key value store for shared configuration
etcd-for-kubernetes1.34 - A highly-available key value store for shared configuration
etcd-for-kubernetes1.35 - A highly-available key value store for shared configuration
etcd-for-kubernetes1.36 - A highly-available key value store for shared configuration
kubernetes1.30-client - Kubernetes client tools
kubernetes1.30-kubeadm - Kubernetes tool for standing up clusters
kubernetes1.30-kubelet - Kubernetes kubelet daemon
kubernetes1.30-master - Kubernetes services for master host
kubernetes1.30-node - Kubernetes services for node host
kubernetes1.31-client - Kubernetes client tools
kubernetes1.31-kubeadm - Kubernetes tool for standing up clusters
kubernetes1.31-kubelet - Kubernetes kubelet daemon
kubernetes1.31-master - Kubernetes services for master host
kubernetes1.31-node - Kubernetes services for node host
kubernetes1.32-client - Kubernetes client tools
kubernetes1.32-kubeadm - Kubernetes tool for standing up clusters
kubernetes1.32-kubelet - Kubernetes kubelet daemon
kubernetes1.32-master - Kubernetes services for master host
kubernetes1.32-node - Kubernetes services for node host
kubernetes1.33-client - Kubernetes client tools
kubernetes1.33-kubeadm - Kubernetes tool for standing up clusters
kubernetes1.33-kubelet - Kubernetes kubelet daemon
kubernetes1.33-master - Kubernetes services for master host
kubernetes1.33-node - Kubernetes services for node host
kubernetes1.34-client - Kubernetes client tools
kubernetes1.34-kubeadm - Kubernetes tool for standing up clusters
kubernetes1.34-kubelet - Kubernetes kubelet daemon
kubernetes1.34-master - Kubernetes services for master host
kubernetes1.34-node - Kubernetes services for node host
kubernetes1.35-client - Kubernetes client tools
kubernetes1.35-kubeadm - Kubernetes tool for standing up clusters
kubernetes1.35-kubelet - Kubernetes kubelet daemon
kubernetes1.35-master - Kubernetes services for master host
kubernetes1.35-node - Kubernetes services for node host
kubernetes1.36-client - Kubernetes client tools
kubernetes1.36-kubeadm - Kubernetes tool for standing up clusters
kubernetes1.36-kubelet - Kubernetes kubelet daemon
kubernetes1.36-master - Kubernetes services for master host
kubernetes1.36-node - Kubernetes services for node host
kubernetes1.30-common - Kubernetes common files
kubernetes1.30-crio - Kubernetes crio files
kubernetes1.31-common - Kubernetes common files
kubernetes1.31-crio - Kubernetes crio files
kubernetes1.32-common - Kubernetes common files
kubernetes1.32-crio - Kubernetes crio files
kubernetes1.33-common - Kubernetes common files
kubernetes1.33-crio - Kubernetes crio files
kubernetes1.34-common - Kubernetes common files
kubernetes1.34-crio - Kubernetes crio files
kubernetes1.35-common - Kubernetes common files
kubernetes1.35-crio - Kubernetes crio files
kubernetes1.36-common - Kubernetes common files
kubernetes1.36-crio - Kubernetes crio files
Connection to 192.168.89.11 closed.
```

</details>

```bash
# Обновление пакетов контейнера и установка пакетов для функционирования nod
for f in {1..5}; do
echo "Обновление пакетов контейнера и установка пакетов для функционирования node на .1$f"
ssh -t -o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_kvm_host root@192.168.89.1$f \
"apt-get update \
&& apt-get dist-upgrade -y \
&& apt-get install -y \
kubernetes1.36-kubeadm \
kubernetes1.36-kubelet \
kubernetes1.36-crio \
cri-tools1.36"
done
```

<details>
<summary>

</summary>

```log
Обновление пакетов контейнера и установка пакетов для функционирования node на .11
...
Calculating Upgrade... Done
The following packages will be upgraded
  altlinux-repos   glibc-core           glibc-pthread    libaudit1    libiptables   libsasl2-3  libtinfo6        openssh-server-control  publicsuffix-list-dafsa
  apt-conf-branch  glibc-gconv-modules  glibc-utils      libcrypto3   libncursesw6  libssh2     openssh          p11-kit-trust           rpm
  bash-completion  glibc-locales        gnupg            libcurl      libnghttp2    libssl3     openssh-clients  pam-config              terminfo
  ca-certificates  glibc-nss            iptables         libgcrypt20  libp11-kit    libtasn1    openssh-common   pam-config-control      termutils
  curl             glibc-preinstall     libaudit-common  libgnutls30  librpm7       libtic6     openssh-server   perl-base               vim-minimal
45 upgraded, 0 newly installed, 0 removed and 0 not upgraded.
Need to get 31.7MB of archives.
After unpacking 1491kB of additional disk space will be used.
...
The following extra packages will be installed:
  cni-plugins  conntrack-tools    cri-o1.36  ebtables  glib2          kubernetes1.36-client  kubernetes1.36-node  libnetfilter_cthelper   libnetfilter_queue
  conmon       containers-common  crun       ethtool   glib2-locales  kubernetes1.36-common  libcrun              libnetfilter_cttimeout  socat
The following NEW packages will be installed:
  cni-plugins      containers-common  crun      glib2                  kubernetes1.36-common   kubernetes1.36-kubelet  libnetfilter_cthelper   socat
  conmon           cri-o1.36          ebtables  glib2-locales          kubernetes1.36-crio     kubernetes1.36-node     libnetfilter_cttimeout
  conntrack-tools  cri-tools1.36      ethtool   kubernetes1.36-client  kubernetes1.36-kubeadm  libcrun                 libnetfilter_queue
0 upgraded, 22 newly installed, 0 removed and 0 not upgraded.
Need to get 95.7MB of archives.
After unpacking 455MB of additional disk space will be used.
Get:1 http://ftp.altlinux.org p11/branch/noarch/classic glib2-locales 2.84.4-alt1:p11+396318.100.2.1@1760211330 [1267kB]
Get:2 http://ftp.altlinux.org p11/branch/x86_64/classic glib2 2.84.4-alt1:p11+396318.100.2.1@1760211330 [986kB]
Get:3 http://ftp.altlinux.org p11/branch/x86_64/classic conmon 1:2.2.1-alt1:p11+420109.2100.4.1@1782726038 [45.4kB]
Get:4 http://ftp.altlinux.org p11/branch/noarch/classic containers-common 2:0.64.0-alt1:p11+392191.500.2.1@1755673252 [84.7kB]
Get:5 http://ftp.altlinux.org p11/branch/x86_64/classic cri-tools1.36 1.36.0-alt1:p11+420109.600.4.1@1782724276 [15.4MB]
Get:6 http://ftp.altlinux.org p11/branch/x86_64/classic libcrun 1.27-alt1:p11+413705.100.1.1@1774957656 [252kB]                                                                                        
Get:7 http://ftp.altlinux.org p11/branch/x86_64/classic crun 1.27-alt1:p11+413705.100.1.1@1774957656 [41.3kB]                                                                                          
Get:8 http://ftp.altlinux.org p11/branch/x86_64/classic ebtables 2.0.11-alt3:sisyphus+344189.100.1.1@1712048586 [79.7kB]                                                                               
Get:9 http://ftp.altlinux.org p11/branch/x86_64/classic ethtool 1:7.0-alt1:p11+418561.100.2.1@1780407918 [301kB]                                                                                       
Get:10 http://ftp.altlinux.org p11/branch/noarch/classic kubernetes1.36-common 1.36.1-alt1:p11+420109.1300.4.1@1782725573 [11.4kB]                                                                     
Get:11 http://ftp.altlinux.org p11/branch/x86_64/classic kubernetes1.36-client 1.36.1-alt1:p11+420109.1300.4.1@1782725573 [12.0MB]                                                                     
Get:12 http://ftp.altlinux.org p11/branch/x86_64/classic libnetfilter_cthelper 1.0.1-alt1:sisyphus+300219.100.1.1@1652970568 [15.1kB]                                                                  
Get:13 http://ftp.altlinux.org p11/branch/x86_64/classic libnetfilter_cttimeout 1.0.1-alt1:sisyphus+300219.200.2.1@1652971062 [15.3kB]                                                                 
Get:14 http://ftp.altlinux.org p11/branch/x86_64/classic libnetfilter_queue 1.0.5-alt1:sisyphus+278100.3000.1.1@1626058809 [20.1kB]                                                                    
Get:15 http://ftp.altlinux.org p11/branch/x86_64/classic conntrack-tools 1.4.8-alt1:sisyphus+332528.100.1.1@1698072947 [183kB]                                                                         
Get:16 http://ftp.altlinux.org p11/branch/x86_64/classic socat 1.7.4.4-alt1:sisyphus+330215.600.3.1@1695490295 [266kB]                                                                                 
Get:17 http://ftp.altlinux.org p11/branch/x86_64/classic kubernetes1.36-kubelet 1.36.1-alt1:p11+420109.1300.4.1@1782725573 [13.4MB]                                                                    
Get:18 http://ftp.altlinux.org p11/branch/x86_64/classic kubernetes1.36-node 1.36.1-alt1:p11+420109.1300.4.1@1782725573 [9602kB]                                                                       
Get:19 http://ftp.altlinux.org p11/branch/x86_64/classic cni-plugins 1.9.1-alt1:p11+414174.100.1.1@1775317003 [10.4MB]                                                                                 
Get:20 http://ftp.altlinux.org p11/branch/x86_64/classic kubernetes1.36-kubeadm 1.36.1-alt1:p11+420109.1300.4.1@1782725573 [12.7MB]                                                                    
Get:21 http://ftp.altlinux.org p11/branch/x86_64/classic cri-o1.36 1.36.0-alt1:p11+420109.500.4.1@1782724158 [18.7MB]                                                                                  
Get:22 http://ftp.altlinux.org p11/branch/noarch/classic kubernetes1.36-crio 1.36.1-alt1:p11+420109.1300.4.1@1782725573 [10.8kB]                                                                       
Fetched 95.7MB in 44s (2156kB/s)   
Committing changes...
Preparing...                                                                                 #################################################################################################### [100%]
Updating / installing...
 1: socat-1.7.4.4-alt1                                                                       #################################################################################################### [  5%]
 2: cni-plugins-1.9.1-alt1                                                                   #################################################################################################### [  9%]
 3: kubernetes1.36-common-1.36.1-alt1                                                        #################################################################################################### [ 14%]
 4: ethtool-1:7.0-alt1                                                                       #################################################################################################### [ 18%]
 5: kubernetes1.36-client-1.36.1-alt1                                                        #################################################################################################### [ 23%]
 6: kubernetes1.36-kubelet-1.36.1-alt1                                                       #################################################################################################### [ 27%]
 7: libnetfilter_queue-1.0.5-alt1                                                            #################################################################################################### [ 32%]
 8: libnetfilter_cttimeout-1.0.1-alt1                                                        #################################################################################################### [ 36%]
 9: libnetfilter_cthelper-1.0.1-alt1                                                         #################################################################################################### [ 41%]
10: conntrack-tools-1.4.8-alt1                                                               #################################################################################################### [ 45%]
11: kubernetes1.36-node-1.36.1-alt1                                                          #################################################################################################### [ 50%]
12: ebtables-2.0.11-alt3                                                                     #################################################################################################### [ 55%]
13: libcrun-1.27-alt1                                                                        #################################################################################################### [ 59%]
14: crun-1.27-alt1                                                                           #################################################################################################### [ 64%]
15: containers-common-2:0.64.0-alt1                                                          #################################################################################################### [ 68%]
16: glib2-locales-2.84.4-alt1                                                                #################################################################################################### [ 73%]
17: glib2-2.84.4-alt1                                                                        #################################################################################################### [ 77%]
18: conmon-1:2.2.1-alt1                                                                      #################################################################################################### [ 82%]
19: cri-o1.36-1.36.0-alt1                                                                    #################################################################################################### [ 86%]
20: kubernetes1.36-crio-1.36.1-alt1                                                          #################################################################################################### [ 91%]
21: kubernetes1.36-kubeadm-1.36.1-alt1                                                       #################################################################################################### [ 95%]
22: cri-tools1.36-1.36.0-alt1                                                                #################################################################################################### [100%]
Done.
Connection to 192.168.89.11 closed.
...
```

</details>

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit4, 21_8-kubeadm-inst' \
&& git push \
--set-upstream \
study_fops39 \
21_8-kubeadm-inst \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_8-kubeadm-inst \
&& git push \
--set-upstream \
study-fops39_sc \
21_8-kubeadm-inst
```

## commit_5,`21_8-kubeadm-inst`


```bash


```

<details>
<summary>

</summary>

```log

```

</details>

```bash

```

<details>
<summary>

</summary>

```log

```

</details>