```bash
# Скачиваем и распаковываем rootfs
curl -o ~/iso/ubuntu_24.04_cloud_rootfs.tar.xz \
https://fra1lxdmirror01.do.letsbuildthe.cloud/images/ubuntu/noble/amd64/cloud/20260320_07:42/rootfs.tar.xz

curl -o ~/iso/ubuntu_24.04__rootfs.tar.xz \
https://fra1lxdmirror01.do.letsbuildthe.cloud/images/ubuntu/noble/amd64/default/20260320_07:42/rootfs.tar.xz

# Создание каталога для файловой системы контейнера
mkdir -p \
/disk/VMs/ubuntu_24.04_rootfs

tar -xvJf \
~/iso/ubuntu_24.04_cloud_rootfs.tar.xz \
-C /disk/VMs/ubuntu_24.04_rootfs

ll \
/disk/VMs/ubuntu_24.04_rootfs
```
```
drwxr-xr-x  20 shoel shoel   4096 мар 20 10:47 .
drwxr-xr-x+  3 shoel libvirt 4096 мар 21 13:11 ..
lrwxrwxrwx   1 shoel shoel      7 апр 22  2024 bin -> usr/bin
drwxr-xr-x   2 shoel shoel   4096 фев 26  2024 bin.usr-is-merged
drwxr-xr-x   2 shoel shoel   4096 апр 22  2024 boot
drwxr-xr-x   2 shoel shoel   4096 мар 20 10:47 dev
drwxr-xr-x  67 shoel shoel   4096 мар 20 10:46 etc
drwxr-xr-x   3 shoel shoel   4096 мар 20 10:45 home
lrwxrwxrwx   1 shoel shoel      7 апр 22  2024 lib -> usr/lib
lrwxrwxrwx   1 shoel shoel      9 апр 22  2024 lib64 -> usr/lib64
drwxr-xr-x   2 shoel shoel   4096 апр  8  2024 lib.usr-is-merged
drwxr-xr-x   2 shoel shoel   4096 мар 20 10:44 media
drwxr-xr-x   2 shoel shoel   4096 мар 20 10:44 mnt
drwxr-xr-x   2 shoel shoel   4096 мар 20 10:44 opt
drwxr-xr-x   2 shoel shoel   4096 апр 22  2024 proc
drwx------   3 shoel shoel   4096 мар 20 10:44 root
drwxr-xr-x   2 shoel shoel   4096 мар 20 10:46 run
lrwxrwxrwx   1 shoel shoel      8 апр 22  2024 sbin -> usr/sbin
drwxr-xr-x   2 shoel shoel   4096 мар 31  2024 sbin.usr-is-merged
drwxr-xr-x   2 shoel shoel   4096 мар 20 10:44 srv
drwxr-xr-x   2 shoel shoel   4096 апр 22  2024 sys
drwxr-xr-x   2 shoel shoel   4096 мар 20 10:44 tmp
drwxr-xr-x  12 shoel shoel   4096 мар 20 10:44 usr
drwxr-xr-x  12 shoel shoel   4096 мар 20 10:45 var
```
```bash
cat > cloud-init.yml <<'EOF'
#cloud-config
package_upgrade: true
packages:
  - openssh-server
EOF
# проброс ключа ssh на суперпользователя
mkdir -p \
/disk/VMs/ubuntu_24.04_rootfs/root/.ssh/

cat  ~/.ssh/id_kvm_host_to_vms.pub \
>>/disk/VMs/ubuntu_24.04_rootfs/root/.ssh/authorized_keys

# на всякий случай задать пароль для ubuntu "qwerty!2" в 
sed -i 's|u:!:|u:$6$jOJaaad3$213aac5XXw7XMVrtI8dPuwyJazAeMOoaq5QOvo.uf/7V70lA3PIsV7WAiM3d1SWPyDkPiVTvizRHta1P7ZyKs/:|' \
/disk/VMs/ubuntu_24.04_rootfs/etc/shadow
```
```bash
cat > ansible.cfg <<'EOF'
[defaults]
inventory = hosts.ini
roles_path = roles
collections_paths = collections
host_key_checking = False
retry_files_enabled = False
stdout_callback = yaml
callback_enabled = profile_tasks

[privilege_escalation]
become = true
become_method = sudo

[libvirt]
uri = lxc:///
EOF

mkdir scripts
cat > scripts/check_lxc_support.sh <<'EOF'
#!/bin/bash
# Проверка поддержки libvirt-lxc

echo " Проверка libvirt LXC драйвера..."

# Проверка пакета
if ! pacman -Qi libvirt | grep lxc; then
    echo " libvirt не установлен"
    echo " Установите: pacman -Suy libvirt"
    exit 1
fi

# Проверка URI
if ! virsh -c lxc:/// uri 2>/dev/null | grep lxc; then
    echo "libvirt LXC URI недоступен"
    echo "Проверьте: sudo systemctl restart libvirtd"
    exit 1
fi

# Проверка прав
if ! virsh -c lxc:/// list --all &>/dev/null; then
    echo " Нет прав на управление LXC контейнерами"
    echo "Добавьте пользователя в группу libvirt: sudo usermod -aG libvirt $USER"
    exit 1
fi

echo "✅ Все проверки пройдены"
exit 0
EOF

cat > hosts.ini <<'EOF'
[libvirt_host]
localhost ansible_connection=local ansible_user=shoel

# Управление Контейнерами через libvirt, не по SSH
[clickhouse]
clickhouse ansible_connection=libvirt_lxc ansible_libvirt_uri=lxc:/// ansible_user=root

[vector]
vector ansible_connection=libvirt_lxc ansible_libvirt_uri=lxc:/// ansible_user=root

[lighthouse]
lighthouse ansible_connection=libvirt_lxc ansible_libvirt_uri=lxc:/// ansible_user=root

[containers:children]
clickhouse
vector
lighthouse
EOF

mkdir group_vars

cat > group_vars/all.yml <<'EOF'
---
# === Libvirt LXC ===
libvirt_uri: "lxc:///"

# === Ресурсы контейнеров ===
memory_kb: 2097152 # 2 GB
vcpus: 2

# === OverlayFS ===
rootfs_base: /disk/VMs/ubuntu_24.04_rootfs
overlays_root: /disk/VMs/overlays

# === Сеть ===
network:
  bridge: br0
  link_state: up
  dhcp: true
  route_gateway: 192.168.89.1

# === Часовой пояс ===
timezone: Europe/Moscow

# === MAC-адреса общий префиксы ===
mac_prefix: "52:54:00"

# === MAC-адреса уникальные префиксы контейнеров ===
containers:
  clickhouse:   { mac: "a1:01" }
  vector:       { mac: "a1:02" }
  lighthouse:   { mac: "a1:03" }
...
EOF

cat >containers.yml <<'EOF'
#!/usr/bin/env ansible-playbook
# Топорный Playbook на localhost для развертывания lxc ubuntu-cloud-24-04 amd64 на libvirt
---
- name: Развёртывание VM с Cloud-Init
  hosts: localhost
  gather_facts: false
  become: true
  vars:
    # Публичный ключ, который будет добавлен root-у
    root_ssh_key: "{{ lookup('file', '~/.ssh/id_kvm_host_to_vms.pub', errors='ignore') | default('') }}"

  tasks:
    # === ПРЕДВАРИТЕЛЬНЫЕ ЗАДАЧИ: Подготовка RootFS ===
    - name: Создаём каталог для базового образа
      file:
        path: "{{ rootfs_base }}"
        state: directory
        mode: '0755'

    - name: Скачиваем Ubuntu 24.04 Cloud RootFS
      get_url:
        url: "https://fra1lxdmirror01.do.letsbuildthe.cloud/images/ubuntu/noble/amd64/cloud/20260320_07:42/rootfs.tar.xz"
        dest: "/home/shoel/iso/ubuntu_24.04_cloud_rootfs.tar.xz"
        mode: '0644'
        timeout: 300

    - name: Распаковываем rootfs в целевую директорию
      unarchive:
        src: "/home/shoel/iso/ubuntu_24.04_cloud_rootfs.tar.xz"
        dest: "{{ rootfs_base }}/"
        remote_src: true # файл уже на удаленной машине (localhost)
        extra_opts: 
          - --no-same-owner
          - --no-same-permissions
        mode: '0755'

    # === 0. Подготовка базового образа ===
    # Убираем блокировку cloud-init в базовом образе
    - name: Включаем cloud-init в базовом образе
      file:
        path: "{{ rootfs_base }}/etc/cloud/cloud-init.disabled"
        state: absent

    # # === 0.2. Настройка autologin для root (консоль) ===
    # - name: Создаём необходимые системные директории
    #   file:
    #     path: "{{ rootfs_base }}/{{ item }}"
    #     state: directory
    #     mode: '0755'
    #   loop:
    #     - root/.ssh
    #     - etc/systemd/system/serial-getty@ttyS0.service.d
    #     - etc/systemd/system/console-getty.service.d
    #     - etc/netplan
    #     - var/log
    #     - var/lib/apt/lists/partial
    #     - var/cache/apt/archives/partial

    # - name: Включаем autologin для root на serial консоли
    #   copy:
    #     content: |
    #       [Service]
    #       ExecStart=
    #       ExecStart=-/sbin/agetty --autologin root --noclear %I $TERM
    #     dest: "{{ rootfs_base }}/etc/systemd/system/serial-getty@ttyS0.service.d/autologin.conf"
    #     mode: '0644'

    # - name: Включаем autologin для root на основной консоли
    #   copy:
    #     content: |
    #       [Service]
    #       ExecStart=
    #       ExecStart=-/sbin/agetty --autologin root --noclear tty1 $TERM
    #     dest: "{{ rootfs_base }}/etc/systemd/system/console-getty.service.d/autologin.conf"
    #     mode: '0644'

    # - name: Файл конфигурации сети по DHCP
    #   copy:
    #     content: >
    #       network:
    #         version: 2
    #         ethernets:
    #           eth0:
    #             dhcp4: true
    #             dhcp-identifier: mac
    #     dest: "{{ rootfs_base }}/etc/netplan/10-lxc.yaml"
    #     mode: '0644'

    # === 1. Подготовка OverlayFS ===
    - name: Создаём структуру overlay для всех контейнеров
      file:
        path: "{{ overlays_root }}/{{ item.0 }}/{{ item.1 }}"
        state: directory
        mode: '0755'
      loop: "{{ containers | product(['upper', 'work', 'merged']) | list }}"
      loop_control:
        label: "{{ item.0 }}/{{ item.1 }}"

    - name: Монтируем OverlayFS
      mount:
        path: "{{ overlays_root }}/{{ item }}/merged"
        src: overlay
        fstype: overlay
        opts: "lowerdir={{ rootfs_base }},upperdir={{ overlays_root }}/{{ item }}/upper,workdir={{ overlays_root }}/{{ item }}/work"
        state: mounted
        boot: false
      loop: "{{ containers }}"
      loop_control:
        label: "{{ item }}"
   
    # === 2. Настройка Cloud-Init ===
    # 1. Создаём директорию seed
    - name: Создаём директорию seed для cloud-init (NoCloud)
      file:
        path: "{{ overlays_root }}/{{ item }}/merged/var/lib/cloud/seed/nocloud-net"
        state: directory
        mode: '0755'
      loop: "{{ containers }}"
      loop_control:
        label: "{{ item }}"

    # 2. Meta-data (Hostname)
    - name: Генерируем meta-data (hostname)
      copy:
        content: |
          instance-id: {{ item }}
          local-hostname: {{ item }}
        dest: "{{ overlays_root }}/{{ item }}/merged/var/lib/cloud/seed/nocloud-net/meta-data"
        mode: '0644'
      loop: "{{ containers }}"
      loop_control:
        label: "{{ item }}"

    # === 2.1. Исправление /etc/hosts ===
    - name: Обновляем /etc/hosts для соответствия hostname (merged layer)
      lineinfile:
        path: "{{ overlays_root }}/{{ item }}/merged/etc/hosts"
        regexp: '^127\.0\.1\.1\s+.*$'
        line: "127.0.1.1\t{{ item }}"
        create: true
        mode: '0644'
      loop: "{{ containers }}"
      loop_control:
        label: "{{ item }}"

    # 3. Network-config
    - name: Генерируем network-config (DHCP)
      copy:
        content: |
          version: 2
          ethernets:
            eth0:
              dhcp4: true
              dhcp-identifier: mac
        dest: "{{ overlays_root }}/{{ item }}/merged/var/lib/cloud/seed/nocloud-net/network-config"
        mode: '0644'
      loop: "{{ containers }}"
      loop_control:
        label: "{{ item }}"

    # 4. User-data (Пользователи, пакеты, SSH)
    # Секцию network отсюда убираем, она не сработает
    - name: Генерируем user-data (SSH, пакеты, root)
      copy:
        content: |
          #cloud-config
          
          # Настройка пользователей
          users:
            - name: root
              lock_passwd: false
              ssh_authorized_keys:
                - {{ root_ssh_key }}
          
          # Разрешаем вход по паролю
          ssh_pwauth: false
          
          # Принудительно разрешаем root login
          write_files:
            - path: /etc/ssh/sshd_config.d/01-permit-root-login.conf
              content: |
                PermitRootLogin yes
                PasswordAuthentication yes
              permissions: '0644'

          packages:
            - openssh-server
          
          runcmd:
            - systemctl restart ssh
        dest: "{{ overlays_root }}/{{ item }}/merged/var/lib/cloud/seed/nocloud-net/user-data"
        mode: '0600'
      loop: "{{ containers }}"
      loop_control:
        label: "{{ item }}"

    # === 3. Для клонирования: Сброс machine-id ===
    # Чтобы cloud-init сработал на каждом новом контейнере, он должен думать, что это новая машина
    - name: Сбрасываем machine-id в upper слое
      copy:
        content: ""
        dest: "{{ overlays_root }}/{{ item }}/merged/etc/machine-id"
        mode: '0644'
        force: true
      loop: "{{ containers }}"
      loop_control:
        label: "{{ item }}"
      
    - name: Ссылка на пустой machine-id (требование systemd)
      file:
        src: /etc/machine-id
        dest: "{{ overlays_root }}/{{ item }}/merged/var/lib/dbus/machine-id"
        state: link
        force: true
      loop: "{{ containers }}"
      loop_control:
        label: "{{ item }}"
      ignore_errors: true

    # === 5. Генерация XML и запуск (без изменений) ===
    - name: Формируем XML для контейнеров
      template:
        src: templates/lxc.xml.j2
        dest: "/tmp/{{ item }}.xml"
        mode: '0644'
      loop: "{{ containers }}"
      loop_control:
        label: "{{ item }}"
      vars:
        container_name: "{{ item }}"

    - name: Определяем контейнер в libvirt
      community.libvirt.virt:
        uri: "{{ libvirt_uri }}"
        command: define
        xml: "{{ lookup('file', '/tmp/' + item + '.xml') }}"
      loop: "{{ containers }}"
      loop_control:
        label: "{{ item }}"
      ignore_errors: true

    - name: Очищаем временные XML
      file:
        path: "/tmp/{{ item }}.xml"
        state: absent
      loop: "{{ containers }}"
      loop_control:
        label: "{{ item }}"

    - name: Выключаем контейнер если запущен
      command: virsh -c "{{ libvirt_uri }}" shutdown "{{ item }}"
      environment:
        LANG: C
        LC_ALL: C
      register: shutdown
      until: "'shutdown' in shutdown.stdout"
      retries: 1
      delay: 3
      loop: "{{ containers }}"
      loop_control:
        label: "{{ item }}"
      changed_when: false
      ignore_errors: true

    - name: Запускаем контейнеры
      community.libvirt.virt:
        uri: "{{ libvirt_uri }}"
        name: "{{ item }}"
        state: running
      loop: "{{ containers }}"
      loop_control:
        label: "{{ item }}"
      retries: 3
      delay: 5

    # === 6. Ожидание и сбор инфо ===
    - name: Ждём, пока контейнеры запустятся
      command: virsh -c "{{ libvirt_uri }}" domstate "{{ item }}"
      environment:
        LANG: C
        LC_ALL: C
      register: domstate
      until: "'running' in domstate.stdout"
      retries: 10
      delay: 3
      loop: "{{ containers }}"
      loop_control:
        label: "{{ item }}"
      changed_when: false
      ignore_errors: true
...
EOF

chmod +x ./containers.yml

mkdir -p \
templates/

cat > templates/lxc.xml.j2 <<'EOF'
<domain type='lxc'>
  <name>{{ container_name }}</name>
  <memory unit='KiB'>{{ memory_kb }}</memory>
  <vcpu>{{ vcpus }}</vcpu>

  <os>
    <type>exe</type>
    <init>/sbin/init</init>
  </os>

  <features>
    <capabilities policy='allow'/>
  </features>

  <clock offset="timezone" timezone="{{ timezone | default('Europe/Moscow') }}" />

  <devices>
    <!-- Корневая ФС: OverlayFS merged слой -->
    <filesystem type='mount'>
      <source dir='{{ overlays_root }}/{{ container_name }}/merged'/>
      <target dir='/'/>
    </filesystem>

    <!-- Дополнительные монтирования (опционально) -->
    {% if extra_mounts is defined %}
    {% for mount in extra_mounts %}
    <filesystem type='mount'>
      <source dir='{{ mount.source }}'/>
      <target dir='{{ mount.target }}'/>
    </filesystem>
    {% endfor %}
    {% endif %}

    <!-- Сетевой интерфейс: br0 + DHCP + маршрут -->
    <interface type='bridge'>
      <!-- MAC задаём явно для стабильности DHCP-резервирований -->
      <mac address='{{ mac_address }}'/>
      <source bridge='{{ network.bridge }}'/>
      <!-- route добавляется, даже при DHCP -->
      <route family='ipv4' address='0.0.0.0' gateway='{{ network.route_gateway }}'/>
      <guest dev='{{ network.guest_dev }}'/>
      <link state='{{ network.link_state }}'/>
    </interface>

    <!-- Консоль и tty -->
    <console type='pty'>
      <target type='lxc' port='0'/>
    </console>
    <tty/>
  </devices>
</domain>
EOF
```
```bash
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
/disk/VMs/ubuntu_24.04_rootfs
EOF

chmod +x \
scripts/delete_containers.sh

./containers.yml -b -K -v
```