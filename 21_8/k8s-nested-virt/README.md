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

## Вариант ручного проброса имеющего ключа и пароля в файловую систему lxc контейнера ОС ubuntu

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
# Проблема, которую решает: все контейнеры НЕ должны монтировать один и тот же
# каталог rootfs как '/' — это ведёт к конфликтам (/etc/hosts, machine-id, /run,
# /tmp, cgroup, pid-файлы). Каждой ноде нужна собственная копия.
#
# Использование (запускать без sudo — при необходимости сам вызовет sudo):
#   ./clone_rootfs.sh
#   BASE_ROOTFS=/path/to/base/rootfs ./clone_rootfs.sh k8s-cp k8s-w1 k8s-w2 k8s-w3 k8s-w4

set -euo pipefail

# Базовая (эталонная) rootfs, из которой клонируем
BASE_ROOTFS="${BASE_ROOTFS:-/disk/VMs/k8s_rootfs}"
# Корневой каталог, куда раскладываем per-node rootfs
LXC_ROOT="${LXC_ROOT:-/disk/VMs}"

# Ноды по умолчанию (корректно как массив из нескольких элементов)
if [ "$#" -gt 0 ]; then
    NODES=("$@")
else
    NODES=(k8s-cp k8s-w1 k8s-w2 k8s-w3 k8s-w4)
fi

# Привилегии: нужны root, т.к. файлы внутри rootfs принадлежат root (контейнер работает под root)
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
fi

if [ ! -d "$BASE_ROOTFS" ]; then
    echo "ОШИБКА: базовая rootfs не найдена: $BASE_ROOTFS" >&2
    exit 1
fi

for node in "${NODES[@]}"; do
    dest="$LXC_ROOT/$node/rootfs"
    if [ -d "$dest" ]; then
        echo "  пропускаю (уже существует): $dest"
        continue
    fi
    echo "Клонирование $BASE_ROOTFS -> $dest"
    $SUDO mkdir -p "$(dirname "$dest")"
    # cp -a сохраняет права/владельцев/симлинки
    $SUDO cp -a "$BASE_ROOTFS" "$dest"

    # Внутри контейнера процессы идут под uid=0, поэтому rootfs должен принадлежать root
    $SUDO chown -R 0:0 "$dest"

    # Каждая нода должна иметь уникальный machine-id и hostname
    $SUDO sh -c ": > \"$dest/etc/machine-id\""
    $SUDO rm -f "$dest/var/lib/dbus/machine-id"
    $SUDO ln -sf /etc/machine-id "$dest/var/lib/dbus/machine-id" 2>/dev/null || true
    echo "$node" | $SUDO tee "$dest/etc/hostname" >/dev/null
done

echo
echo "Готово. Проверить, что пути в XML-конфигах указывают на:"
for node in "${NODES[@]}"; do
    echo "  $LXC_ROOT/$node/rootfs  (нода: $node)"
done
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
Клонирование /disk/VMs/k8s_rootfs -> /disk/VMs/k8s-cp/rootfs
Клонирование /disk/VMs/k8s_rootfs -> /disk/VMs/k8s-w1/rootfs
Клонирование /disk/VMs/k8s_rootfs -> /disk/VMs/k8s-w2/rootfs
Клонирование /disk/VMs/k8s_rootfs -> /disk/VMs/k8s-w3/rootfs
Клонирование /disk/VMs/k8s_rootfs -> /disk/VMs/k8s-w4/rootfs

Готово. Проверить, что пути в XML-конфигах указывают на:
  /disk/VMs/k8s-cp/rootfs  (нода: k8s-cp)
  /disk/VMs/k8s-w1/rootfs  (нода: k8s-w1)
  /disk/VMs/k8s-w2/rootfs  (нода: k8s-w2)
  /disk/VMs/k8s-w3/rootfs  (нода: k8s-w3)
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

    <!-- Сеть: DHCP (адрес выдаёт DHCP-сервер; резерв делаем по MAC) -->
    <interface type='bridge'>
      <mac address='{{ mac_address }}'/>
      <source bridge='br0'/>
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
      <mac address='52:54:00:89:02:01'/>
      <source bridge='br0'/>
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
      <mac address='52:54:00:89:02:02'/>
      <source bridge='br0'/>
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
      <mac address='52:54:00:89:02:03'/>
      <source bridge='br0'/>
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
      <mac address='52:54:00:89:02:04'/>
      <source bridge='br0'/>
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
      <mac address='52:54:00:89:02:05'/>
      <source bridge='br0'/>
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
for f in lxc-k8s-*.xml; do
echo "Определяю $f"
virsh -c lxc:/// define "$f"
done
```

## Скрипт удаления контейнеров через libvirt и ручную чистку

```bash
# Создание скрипта удаления
cat > scripts/delete_containers.sh <<'EOF'
virsh -c lxc:/// list --all \
| awk 'NR > 1 {print $2}' \
| xargs -I {} virsh -c lxc:/// shutdown {}

virsh -c lxc:/// list --all \
| awk 'NR > 1 {print $2}' \
| xargs -I {} virsh -c lxc:/// undefine --remove-all-storage {}

sudo bash -c \
"umount /disk/VMs/overlays/*/merged 2>/dev/null || true \
&& rm -rf /disk/VMs/overlays"

sudo rm -rf \
/disk/VMs/k8s_rootfs
EOF

# ДЕлаем скрипт исполняемым
chmod +x \
scripts/delete_containers.sh
```
