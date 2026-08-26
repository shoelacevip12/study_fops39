# Подготовительная часть для тестов

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

# на всякий случай задать пароль для root "qwerty!2" в эталонный образ altlinux
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

## Создание шаблонов LXC контейнера под libvirt

```bash
mkdir -p \
templates/
```

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

## Скрипт удаления контейнеров через libvirt и ручную чистку

```bash
# Создание скрипта удаления
cat > scripts/delete_containers.sh <<'EOF'
#!/bin/bash
# Остановка и удаление всех LXC-контейнеров k8s + очистка их rootfs.

virsh -c lxc:/// list --all --name \
| xargs -I {} virsh -c lxc:/// shutdown {}

virsh -c lxc:/// list --all --name \
| xargs -I {} virsh -c lxc:/// undefine --remove-all-storage {}

sudo bash -c \
"umount /disk/VMs/overlays/*/merged 2>/dev/null || true \
&& rm -vrf /disk/VMs/k8s-*"

echo
echo "ВНИМАНИЕ: далее будет удалена базовая эталонная rootfs:"
echo "  /disk/VMs/k8s_rootfs"
read -r -p "Удалить базовую rootfs /disk/VMs/k8s_rootfs? [y/N]: " answer
case "$answer" in
    y|Y|yes|Yes|YES)
        sudo rm -vrf \
        /disk/VMs/k8s_rootfs
        echo "Базовая rootfs удалена."
        ;;
    *)
        echo "Отменено. Базовая rootfs НЕ удалена."
        ;;
esac
EOF

# ДЕлаем скрипт исполняемым
chmod +x \
scripts/delete_containers.sh
```
