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
nameserver 77.88.8.8
search den.skv
EOF

cat > /disk/VMs/k8s_rootfs/etc/resolv.conf <<EOF
nameserver 192.168.89.1
nameserver 77.88.8.8
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

<details>
<summary>
Скрипт копирования с эталонного образа `/disk/VMs/k8s_rootfs`
</summary>

```bash
mkdir -pv scripts

cat > scripts/clone_rootfs.sh<<'EOF'
#!/bin/bash
# Скрипт подготовки отдельных rootfs для каждой k8s-ноды.
# Каждая нода получает свою копию rootfs (/disk/VMs/<нода>/rootfs),
# уникальные machine-id/hostname и статический IP через etcnet.
# Запускать на ХОСТЕ.

BASE_ROOTFS=/disk/VMs/k8s_rootfs
LXC_ROOT=/disk/VMs

for f in {1..5}; do
  case $f in
    1) node=k8s-cp;; 2) node=k8s-w1;; 3) node=k8s-w2;; 4) node=k8s-w3;; 5) node=k8s-w4;;
  esac
  octet=$((10+f))
  dest="$LXC_ROOT/$node/rootfs"

  if [ -d "$dest" ]; then
    echo "  пропускаю (уже существует): $dest"
    continue
  fi

  echo "Клонирование $BASE_ROOTFS -> $dest"
  sudo mkdir -p "$dest"
  sudo cp -a "$BASE_ROOTFS/." "$dest/"
  sudo chown -R 0:0 "$dest"

  # уникальный machine-id + hostname
  sudo sh -c ": > \"$dest/etc/machine-id\""
  sudo rm -f "$dest/var/lib/dbus/machine-id"
  sudo ln -sf /etc/machine-id "$dest/var/lib/dbus/machine-id" 2>/dev/null || true
  echo "$node" | sudo tee "$dest/etc/hostname" >/dev/null

  # статический IP через etcnet
  sudo mkdir -p "$dest/etc/net/ifaces/eth0"
  echo "192.168.89.$octet/24" \
  | sudo tee "$dest/etc/net/ifaces/eth0/ipv4address" >/dev/null
  echo "  $node -> IP 192.168.89.$octet/24"
done

echo
echo "Готово."
echo "Пути rootfs: $LXC_ROOT/{k8s-cp,k8s-w1,k8s-w2,k8s-w3,k8s-w4}/rootfs"
EOF
```

</details>

```bash
# Делаем скрипт исполняемым
chmod -v +x scripts/clone_rootfs.sh

# Запуск Клонирования
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
  <memory unit='KiB'>{{ memory_kib | default(14680064) }}</memory>
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
      <chown/>
      <dac_override/>
      <fowner/>
      <fsetid/>
      <kill/>
      <setgid/>
      <setuid/>
      <setpcap/>
      <net_bind_service/>
      <net_raw/>
      <sys_chroot/>
      <sys_resource/>
      <audit_write/>
    </capabilities>
  </features>

  <clock offset="timezone" timezone="Europe/Moscow"/>

  <devices>
    <filesystem type='mount'>
      <source dir='/disk/VMs/{{ node_name }}/rootfs'/>
      <target dir='/'/>
    </filesystem>

    <filesystem type='mount'>
      <source dir='/dev/kvm'/>
      <target dir='/dev/kvm'/>
    </filesystem>

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
  <memory unit='KiB'>14680064</memory>
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
      <chown/>
      <dac_override/>
      <fowner/>
      <fsetid/>
      <kill/>
      <setgid/>
      <setuid/>
      <setpcap/>
      <net_bind_service/>
      <net_raw/>
      <sys_chroot/>
      <sys_resource/>
      <audit_write/>
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
  <memory unit='KiB'>14680064</memory>
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
      <chown/>
      <dac_override/>
      <fowner/>
      <fsetid/>
      <kill/>
      <setgid/>
      <setuid/>
      <setpcap/>
      <net_bind_service/>
      <net_raw/>
      <sys_chroot/>
      <sys_resource/>
      <audit_write/>
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
  <memory unit='KiB'>14680064</memory>
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
      <chown/>
      <dac_override/>
      <fowner/>
      <fsetid/>
      <kill/>
      <setgid/>
      <setuid/>
      <setpcap/>
      <net_bind_service/>
      <net_raw/>
      <sys_chroot/>
      <sys_resource/>
      <audit_write/>
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
  <memory unit='KiB'>14680064</memory>
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
      <chown/>
      <dac_override/>
      <fowner/>
      <fsetid/>
      <kill/>
      <setgid/>
      <setuid/>
      <setpcap/>
      <net_bind_service/>
      <net_raw/>
      <sys_chroot/>
      <sys_resource/>
      <audit_write/>
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
  <memory unit='KiB'>14680064</memory>
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
      <chown/>
      <dac_override/>
      <fowner/>
      <fsetid/>
      <kill/>
      <setgid/>
      <setuid/>
      <setpcap/>
      <net_bind_service/>
      <net_raw/>
      <sys_chroot/>
      <sys_resource/>
      <audit_write/>
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
# Регистрирование LXC через конфиги xml
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
Вывод обрыва связи при перезапуске сетевой службы для применения сетевых настроек
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
cri-tools1.36 \
iptables \
iptables-nft \
nftables \
skopeo \
&& systemctl enable --now crio \
&& systemctl enable kubelet"
done
```

<details>
<summary>
Вывод установки и запуска служб
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
...
Created symlink '/etc/systemd/system/cri-o.service' → '/usr/lib/systemd/system/crio.service'.
Created symlink '/etc/systemd/system/multi-user.target.wants/crio.service' → '/usr/lib/systemd/system/crio.service'.
Created symlink '/etc/systemd/system/multi-user.target.wants/kubelet.service' → '/usr/lib/systemd/system/kubelet.service'.
...
Connection to 192.168.89.11 closed.
...
```

</details>

```bash
# проверка статуса CRI и версии kubectl на нодах на нодах 
for f in {1..5}; do
echo -e "\n---===проверка статуса CRI на ноде .1$f===---"
ssh -t -o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_kvm_host root@192.168.89.1$f \
"systemctl status crio | head -n8 && echo \
&& kubectl version 2> /dev/null"
done
```

<details>
<summary>
Вывод статуса службы CRI и версии kubectl на нодах
</summary>

```log
---===проверка статуса CRI на ноде .11===---
● crio.service - Container Runtime Interface for OCI (CRI-O)
     Loaded: loaded (/usr/lib/systemd/system/crio.service; enabled; preset: disabled)
     Active: active (running) since Wed 2026-08-26 14:01:22 UTC; 43min ago
 Invocation: 0696980072f645cabab38dbc7d450f72
       Docs: https://github.com/cri-o/cri-o
   Main PID: 3690 (crio)
        CPU: 995ms
     CGroup: /machine.slice/machine-lxc\x2d50642\x2dk8s\x2dcp.scope/libvirt/system.slice/crio.service

Client Version: v1.36.1
Kustomize Version: v5.8.1
Connection to 192.168.89.11 closed.

---===проверка статуса CRI на ноде .12===---
● crio.service - Container Runtime Interface for OCI (CRI-O)
     Loaded: loaded (/usr/lib/systemd/system/crio.service; enabled; preset: disabled)
     Active: active (running) since Wed 2026-08-26 14:01:22 UTC; 43min ago
 Invocation: 8a637d213a0148aab76acb186889b289
       Docs: https://github.com/cri-o/cri-o
   Main PID: 3507 (crio)
        CPU: 1.020s
     CGroup: /machine.slice/machine-lxc\x2d50702\x2dk8s\x2dw1.scope/libvirt/system.slice/crio.service

Client Version: v1.36.1
Kustomize Version: v5.8.1
Connection to 192.168.89.12 closed.

---===проверка статуса CRI на ноде .13===---
● crio.service - Container Runtime Interface for OCI (CRI-O)
     Loaded: loaded (/usr/lib/systemd/system/crio.service; enabled; preset: disabled)
     Active: active (running) since Wed 2026-08-26 14:01:23 UTC; 43min ago
 Invocation: 16a12d000f4f4ff2ad1b5b0dd1f09703
       Docs: https://github.com/cri-o/cri-o
   Main PID: 3448 (crio)
        CPU: 1.031s
     CGroup: /machine.slice/machine-lxc\x2d50763\x2dk8s\x2dw2.scope/libvirt/system.slice/crio.service

Client Version: v1.36.1
Kustomize Version: v5.8.1
Connection to 192.168.89.13 closed.

---===проверка статуса CRI на ноде .14===---
● crio.service - Container Runtime Interface for OCI (CRI-O)
     Loaded: loaded (/usr/lib/systemd/system/crio.service; enabled; preset: disabled)
     Active: active (running) since Wed 2026-08-26 14:01:23 UTC; 43min ago
 Invocation: 628c95962f2e435a8004289749d0c81a
       Docs: https://github.com/cri-o/cri-o
   Main PID: 3417 (crio)
        CPU: 1.081s
     CGroup: /machine.slice/machine-lxc\x2d50891\x2dk8s\x2dw3.scope/libvirt/system.slice/crio.service

Client Version: v1.36.1
Kustomize Version: v5.8.1
Connection to 192.168.89.14 closed.

---===проверка статуса CRI на ноде .15===---
● crio.service - Container Runtime Interface for OCI (CRI-O)
     Loaded: loaded (/usr/lib/systemd/system/crio.service; enabled; preset: disabled)
     Active: active (running) since Wed 2026-08-26 14:01:24 UTC; 43min ago
 Invocation: 1cbdb80760f54602809d4160748a0fef
       Docs: https://github.com/cri-o/cri-o
   Main PID: 3377 (crio)
        CPU: 1.098s
     CGroup: /machine.slice/machine-lxc\x2d51116\x2dk8s\x2dw4.scope/libvirt/system.slice/crio.service

Client Version: v1.36.1
Kustomize Version: v5.8.1
Connection to 192.168.89.15 closed.
```

</details>

### фиксы под работу с версией kubernetes 1.36.1 на altlinux

```bash
# Указываем конкретный pause-контейнер для работы CRI
for f in {1..5}; do
echo "---=== Настройка pause-контейнер на ноде 192.168.89.1${f} ===---"
ssh -o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_kvm_host \
root@192.168.89.1"${f}" \
'crictl pull registry.altlinux.org/p11/pause:3.10.1 && \
sed -i '\''s|^#* *pause_image *=.*|pause_image = "registry.altlinux.org/p11/pause:3.10.1"|'\'' \
/etc/crio/crio.conf \
&& systemctl restart crio \
&& crictl info | grep -i pause \
&& skopeo copy docker://registry.altlinux.org/p11/pause:3.10.1 \
containers-storage:registry.altlinux.org/p11/pause:3.10.2'
done
```

<details>
<summary>
вывод перетэгирования pause-контейнера в CRI
</summary>

```log
---=== Настройка pause-контейнер на ноде 192.168.89.11 ===---
Image is up to date for 4d9a3ab7ef4069d1ed71610609c3fd9684d6ad28e9db21b5c24f5001364dadfa
    "sandboxImage": "registry.altlinux.org/p11/pause:3.10.1"
time="2026-08-26T16:58:18Z" level=info msg="Not using native diff for overlay, this may cause degraded performance for building images: kernel has CONFIG_OVERLAY_FS_REDIRECT_DIR enabled"
Getting image source signatures
Copying blob sha256:e8fd17787cb801cf887ec29c4c8716b2038cd819e55fffaabee59ae87005be7c
Copying config sha256:4d9a3ab7ef4069d1ed71610609c3fd9684d6ad28e9db21b5c24f5001364dadfa
Writing manifest to image destination
---=== Настройка pause-контейнер на ноде 192.168.89.12 ===---
Image is up to date for 4d9a3ab7ef4069d1ed71610609c3fd9684d6ad28e9db21b5c24f5001364dadfa
    "sandboxImage": "registry.altlinux.org/p11/pause:3.10.1"
time="2026-08-26T16:58:20Z" level=info msg="Not using native diff for overlay, this may cause degraded performance for building images: kernel has CONFIG_OVERLAY_FS_REDIRECT_DIR enabled"
Getting image source signatures
Copying blob sha256:e8fd17787cb801cf887ec29c4c8716b2038cd819e55fffaabee59ae87005be7c
Copying config sha256:4d9a3ab7ef4069d1ed71610609c3fd9684d6ad28e9db21b5c24f5001364dadfa
Writing manifest to image destination
---=== Настройка pause-контейнер на ноде 192.168.89.13 ===---
Image is up to date for 4d9a3ab7ef4069d1ed71610609c3fd9684d6ad28e9db21b5c24f5001364dadfa
    "sandboxImage": "registry.altlinux.org/p11/pause:3.10.1"
time="2026-08-26T16:58:21Z" level=info msg="Not using native diff for overlay, this may cause degraded performance for building images: kernel has CONFIG_OVERLAY_FS_REDIRECT_DIR enabled"
Getting image source signatures
Copying blob sha256:e8fd17787cb801cf887ec29c4c8716b2038cd819e55fffaabee59ae87005be7c
Copying config sha256:4d9a3ab7ef4069d1ed71610609c3fd9684d6ad28e9db21b5c24f5001364dadfa
Writing manifest to image destination
---=== Настройка pause-контейнер на ноде 192.168.89.14 ===---
Image is up to date for 4d9a3ab7ef4069d1ed71610609c3fd9684d6ad28e9db21b5c24f5001364dadfa
    "sandboxImage": "registry.altlinux.org/p11/pause:3.10.1"
time="2026-08-26T16:58:22Z" level=info msg="Not using native diff for overlay, this may cause degraded performance for building images: kernel has CONFIG_OVERLAY_FS_REDIRECT_DIR enabled"
Getting image source signatures
Copying blob sha256:e8fd17787cb801cf887ec29c4c8716b2038cd819e55fffaabee59ae87005be7c
Copying config sha256:4d9a3ab7ef4069d1ed71610609c3fd9684d6ad28e9db21b5c24f5001364dadfa
Writing manifest to image destination
---=== Настройка pause-контейнер на ноде 192.168.89.15 ===---
Image is up to date for 4d9a3ab7ef4069d1ed71610609c3fd9684d6ad28e9db21b5c24f5001364dadfa
    "sandboxImage": "registry.altlinux.org/p11/pause:3.10.1"
time="2026-08-26T16:58:23Z" level=info msg="Not using native diff for overlay, this may cause degraded performance for building images: kernel has CONFIG_OVERLAY_FS_REDIRECT_DIR enabled"
Getting image source signatures
Copying blob sha256:e8fd17787cb801cf887ec29c4c8716b2038cd819e55fffaabee59ae87005be7c
Copying config sha256:4d9a3ab7ef4069d1ed71610609c3fd9684d6ad28e9db21b5c24f5001364dadfa
Writing manifest to image destination
```

</details>

### Инициализация control-plane и развёртывание кластера (Задание 1)

#### Этап 0. Обязательные фиксы вложенной виртуализации (до `kubeadm init`)

Внутри LXC (libvirt, cgroup v2) `kubeadm init`/`kubelet` падают без ряда обходов.
Три скрипта применяются **в строгом порядке до** инициализации:

| Скрипт | Где запускать | Что делает |
|--------|---------------|------------|
| `scripts/fix_sysctl_host.sh` | **ХОСТ** (там, где `virsh -c lxc:///`) | выставляет глобальные sysctl (`vm.overcommit_memory`, `kernel.panic*`), чтобы kubelet в нодах не пытался писать в read-only `/proc/sys` |
| `scripts/fix_kmsg_node.sh` | **КАЖДАЯ нода** | симлинк `/dev/kmsg -> /dev/null` (device-cgroup блокирует открытие реального `/dev/kmsg`) |
| `scripts/fix_runtime_nested.sh` | **КАЖДАЯ нода** | crun-wrapper без device-BPF, cgroup-драйвер `cgroupfs`, перемонтирование `/proc/sys` в rw |

##### 1. fix_sysctl_host.sh - на ХОСТЕ

```bash
# на ХОСТЕ, где libvirt (virsh -c lxc:///) - глобальные sysctl для kubelet
sudo ./scripts/fix_sysctl_host.sh
```

<details>
<summary>
контроль применённых sysctl на хосте (повторный замер)
</summary>

```log
$ ls -l /etc/sysctl.d/99-kubelet-lxc.conf
-rw-r--r-- 1 root root 389 Aug 26 21:10 /etc/sysctl.d/99-kubelet-lxc.conf

$ sysctl vm.overcommit_memory kernel.panic kernel.panic_on_oops
vm.overcommit_memory = 1
kernel.panic = 10
kernel.panic_on_oops = 1
```

</details>

##### 2. fix_kmsg_node.sh - на КАЖДОЙ ноде

```bash
# на каждой ноде (192.168.89.11..15): /dev/kmsg -> /dev/null
for f in {1..5}; do
  ssh -o StrictHostKeyChecking=accept-new -i ~/.ssh/id_kvm_host \
    root@192.168.89.1"$f" './scripts/fix_kmsg_node.sh'
done
```

<details>
<summary>
контроль /dev/kmsg на ноде (симлинк на /dev/null)
</summary>

```log
$ ls -l /dev/kmsg
lrwxrwxrwx 1 root root 9 Aug 26 19:32 /dev/kmsg -> /dev/null
```

</details>

##### 3. fix_runtime_nested.sh - на КАЖДОЙ ноде

```bash
# на каждой ноде: crun-wrapper без device-BPF + cgroupfs + /proc/sys rw
for f in {1..5}; do
  ssh -o StrictHostKeyChecking=accept-new -i ~/.ssh/id_kvm_host \
    root@192.168.89.1"$f" './scripts/fix_runtime_nested.sh'
done
```

<details>
<summary>
контроль runtime-фиксов на ноде (crun-nobpf, cgroupfs, /proc/sys rw)
</summary>

```log
$ ls -l /usr/local/bin/crun-nobpf
-rwxr-xr-x 1 root root 632 Aug 26 19:14 /usr/local/bin/crun-nobpf

$ grep -E 'cgroup_manager|runtime_path' /etc/crio/crio.conf | grep -v '^#'
cgroup_manager = "cgroupfs"
runtime_path = "/usr/local/bin/crun-nobpf"

$ grep -i cgroup /var/lib/kubelet/config.yaml
cgroupDriver: cgroupfs

$ mount | grep -E '/proc/sys '
proc on /proc/sys type proc (rw,nosuid,nodev,noexec,relatime,gid=19)

$ test -w /proc/sys/net/ipv4/ip_forward && echo "/proc/sys writable: yes"
/proc/sys writable: yes
```

</details>

После «Этапа 0» обе службы на всех нодах активны и можно переходить к инициализации:

```bash
ssh -t -o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_kvm_host root@192.168.89.11 \
"kubeadm init \
--pod-network-cidr=10.10.0.0/16 \
--kubernetes-version=1.36.1 \
--image-repository=registry.altlinux.org/p11 \
--cri-socket=unix:///var/run/crio/crio.sock \
--ignore-preflight-errors=Swap"
```

<details>
<summary>
Лог успешного kubeadm init на control-plane готов
</summary>

```log
[control-plane-check] kube-apiserver is healthy after 2.001232118s
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config"
[mark-control-plane] Marking the node k8s-cp as control-plane
[bootstrap-token] Using token: qhepku.g4i5627odrxm02by
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!
Then you can join any number of worker nodes by running the following on each as root:
kubeadm join 192.168.89.11:6443 --token qhepku.g4i5627odrxm02by \
	--discovery-token-ca-cert-hash sha256:4779932cd0ec3e1708f4dfb9b98f3fbef1923877226b349797ad407e259b39e6
```

</details>

#### kubectl: контекст кластера на ХОСТЕ для пользователя

```bash
cp -v ~/.kube/config ~/.kube/config.bak
scp -O -i ~/.ssh/id_kvm_host root@192.168.89.11:/etc/kubernetes/admin.conf ~/.kube/config
chmod 600 ~/.kube/config
```

Теперь контекст доступен для текущего пользователя на хосте:

```bash
kubectl config get-contexts
kubectl config current-context
kubectl config get-clusters
kubectl get nodes
```

<details>
<summary>
контекст kubernetes-admin@kubernetes (server https://192.168.89.11:6443), кластер рабочий
</summary>

```log
$ kubectl config get-contexts
CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
*         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin

$ kubectl config current-context
kubernetes-admin@kubernetes

$ kubectl config get-clusters
NAME
kubernetes

$ kubectl get nodes
NAME     STATUS   ROLES           AGE    VERSION
k8s-cp   Ready    control-plane   137m   v1.36.1
k8s-w1   Ready    <none>          100m   v1.36.1
k8s-w2   Ready    <none>          100m   v1.36.1
k8s-w3   Ready    <none>          100m   v1.36.1
k8s-w4   Ready    <none>          100m   v1.36.1
```

</details>

#### kube-proxy: отключение conntrack-систклтов

```bash
# Правка ConfigMap kube-proxy: conntrack.maxPerCore/min=0, таймауты=0s
kubectl -n kube-system patch cm kube-proxy --type=json \
-p "$(jq -n --arg v "$(sed 's/^  maxPerCore: null/  maxPerCore: 0/;s/^  min: null/  min: 0/;\
s/^  tcpCloseWaitTimeout: null/  tcpCloseWaitTimeout: 0s/;\
s/^  tcpEstablishedTimeout: null/  tcpEstablishedTimeout: 0s/' <(kubectl -n kube-system get cm kube-proxy -o jsonpath='{.data.config\.conf}'))" \
'[{"op":"replace","path":"/data/config.conf","value":$v}]')"
kubectl -n kube-system rollout restart ds/kube-proxy
```

#### Установка CNI Calico

```bash
curl -fsSL https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/calico.yaml -o /tmp/calico.yaml
kubectl apply -f /tmp/calico.yaml
kubectl get ippool default-ipv4-ippool -o jsonpath='{.spec.cidr}'
```

#### Присоединение рабочих нод (w1..w4)

```bash
for f in {2..5}; do
ssh -o StrictHostKeyChecking=accept-new -i ~/.ssh/id_kvm_host root@192.168.89.1$f \
"kubeadm join 192.168.89.11:6443 --token qhepku.g4i5627odrxm02by \
--discovery-token-ca-cert-hash sha256:4779932cd0ec3e1708f4dfb9b98f3fbef1923877226b349797ad407e259b39e6 \
--cri-socket=unix:///var/run/crio/crio.sock"
done
```

#### Тестовый запуск nginx и проверка

```bash
kubectl create deployment nginx-test --image=docker.io/library/nginx:alpine --replicas=3
kubectl expose deployment nginx-test --port=80 --type=NodePort
kubectl get nodes -o wide
kubectl get pods -A -o wide
curl -s http://192.168.89.11:$(kubectl get svc nginx-test -o jsonpath='{.spec.ports[0].nodePort}')/ -o /dev/null -w 'HTTP %{http_code}\n'
```

<details>
<summary>
состояния кластера
</summary>

```log
$ kubectl get nodes -o wide
NAME     STATUS   ROLES           AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE        KERNEL-VERSION             CONTAINER-RUNTIME
k8s-cp   Ready    control-plane   101m   v1.36.1   10.10.62.128   <none>        ALT Container   7.1.9-zen1-2-zen (amd64)   cri-o://1.36.0
k8s-w1   Ready    <none>          65m    v1.36.1   10.10.228.64   <none>        ALT Container   7.1.9-zen1-2-zen (amd64)   cri-o://1.36.0
k8s-w2   Ready    <none>          65m    v1.36.1   10.10.46.0     <none>        ALT Container   7.1.9-zen1-2-zen (amd64)   cri-o://1.36.0
k8s-w3   Ready    <none>          65m    v1.36.1   10.10.197.0    <none>        ALT Container   7.1.9-zen1-2-zen (amd64)   cri-o://1.36.0
k8s-w4   Ready    <none>          65m    v1.36.1   10.10.23.64    <none>        ALT Container   7.1.9-zen1-2-zen (amd64)   cri-o://1.36.0

$ kubectl get pods -A -o wide
NAMESPACE     NAME                                       READY   STATUS    RESTARTS      AGE    IP              NODE
default       nginx-test-676977dfff-4n4n9                1/1     Running   0             43m    10.10.228.67    k8s-w1
default       nginx-test-676977dfff-bpbnb                1/1     Running   0             43m    10.10.197.2     k8s-w3
default       nginx-test-676977dfff-dmdcd                1/1     Running   0             43m    10.10.23.67     k8s-w4
kube-system   calico-kube-controllers-7bc9dccf69-qs8rw   1/1     Running   2 (66m ago)   68m    10.10.62.180    k8s-cp
kube-system   calico-node-4gpz6                          1/1     Running   4 (66m ago)   88m    192.168.89.11   k8s-cp
kube-system   calico-node-986kh                          1/1     Running   1             65m    192.168.89.15   k8s-w4
kube-system   calico-node-fcldt                          1/1     Running   1             65m    192.168.89.13   k8s-w2
kube-system   calico-node-pxtmg                          1/1     Running   1             65m    192.168.89.12   k8s-w1
kube-system   calico-node-v6p7l                          1/1     Running   1             65m    192.168.89.14   k8s-w3
kube-system   coredns-5fc84b665c-lqmzg                   1/1     Running   2 (66m ago)   68m    10.10.62.179    k8s-cp
kube-system   coredns-5fc84b665c-vk9vl                   1/1     Running   2 (66m ago)   68m    10.10.62.178    k8s-cp
kube-system   etcd-k8s-cp                                1/1     Running   6             101m   192.168.89.11   k8s-cp
kube-system   kube-apiserver-k8s-cp                      1/1     Running   6             101m   192.168.89.11   k8s-cp
kube-system   kube-controller-manager-k8s-cp             1/1     Running   6             101m   192.168.89.11   k8s-cp
kube-system   kube-proxy-c4pxk                           1/1     Running   1             65m    192.168.89.12   k8s-w1
kube-system   kube-proxy-hnkmk                           1/1     Running   4 (66m ago)   92m    192.168.89.11   k8s-cp
kube-system   kube-proxy-ll9nr                           1/1     Running   1             65m    192.168.89.14   k8s-w3
kube-system   kube-proxy-m6ds5                           1/1     Running   1             65m    192.168.89.15   k8s-w4
kube-system   kube-proxy-n7vdn                           1/1     Running   1             65m    192.168.89.13   k8s-w2
kube-system   kube-scheduler-k8s-cp                      1/1     Running   6             101m   192.168.89.11   k8s-cp

$ kubectl get svc nginx-test
NAME         TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
nginx-test   NodePort   10.97.57.77   <none>        80:32493/TCP   44m

# доступ извне по NodePort (с хоста) и внутри кластера по ClusterIP
$ curl -s http://192.168.89.11:32493/ -o /dev/null -w 'HTTP %{http_code}\n'
HTTP 200
$ curl -s http://10.97.57.77/ -o /dev/null -w 'HTTP %{http_code}\n'
HTTP 200

# условия всех нод - давления сняты (ложный MemoryPressure устранён поднятием памяти до 14 GiB)
$ kubectl get nodes -o json | jq -r '.items[] | .metadata.name as $n | .status.conditions[] |
  select(.type=="Ready" or .type=="MemoryPressure" or .type=="DiskPressure" or .type=="PIDPressure" or .type=="NetworkUnavailable") |
  "\($n): \(.type)=\(.status)"'
k8s-cp: NetworkUnavailable=False
k8s-cp: MemoryPressure=False
k8s-cp: DiskPressure=False
k8s-cp: PIDPressure=False
k8s-cp: Ready=True
k8s-w1: NetworkUnavailable=False
k8s-w1: MemoryPressure=False
k8s-w1: DiskPressure=False
k8s-w1: PIDPressure=False
k8s-w1: Ready=True
k8s-w2: NetworkUnavailable=False
k8s-w2: MemoryPressure=False
k8s-w2: DiskPressure=False
k8s-w2: PIDPressure=False
k8s-w2: Ready=True
k8s-w3: NetworkUnavailable=False
k8s-w3: MemoryPressure=False
k8s-w3: DiskPressure=False
k8s-w3: PIDPressure=False
k8s-w3: Ready=True
k8s-w4: NetworkUnavailable=False
k8s-w4: MemoryPressure=False
k8s-w4: DiskPressure=False
k8s-w4: PIDPressure=False
k8s-w4: Ready=True
```

</details>

## Скрипт удаления контейнеров через libvirt и ручную чистку

<details>
<summary>
Скрипта удаления контейнеров
</summary>

```bash
# Создание скрипта удаления
cat > scripts/delete_containers.sh <<'EOF'
#!/bin/bash
# Остановка и удаление всех LXC-контейнеров k8s + очистка их rootfs.
# Запускать на ХОСТЕ.

virsh -c lxc:/// list --all --name | xargs -I {} virsh -c lxc:/// shutdown {}
virsh -c lxc:/// list --all --name | xargs -I {} virsh -c lxc:/// undefine --remove-all-storage {}

sudo bash -c "umount /disk/VMs/overlays/*/merged 2>/dev/null || true; rm -vrf /disk/VMs/k8s-*"

echo
echo "ВНИМАНИЕ: далее будет удалена базовая эталонная rootfs:"
echo "  /disk/VMs/k8s_rootfs"
read -r -p "Удалить базовую rootfs /disk/VMs/k8s_rootfs? [y/N]: " answer
case "$answer" in
  y|Y|yes|Yes|YES)
    sudo rm -vrf /disk/VMs/k8s_rootfs
    echo "Базовая rootfs удалена."
    ;;
  *)
    echo "Отменено. Базовая rootfs НЕ удалена."
    ;;
esac
EOF
```

</details>

```bash
# Делаем скрипт исполняемым
chmod +x \
scripts/delete_containers.sh
```
