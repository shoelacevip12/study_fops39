# playbook развертывания LXC контейнера на локальной системе
#### Подготовительная часть для тестов
```bash
# Скачиваем и распаковываем rootfs
### Cloud версия
curl -o ~/iso/ubuntu_24.04_cloud_rootfs.tar.xz \
https://fra1lxdmirror01.do.letsbuildthe.cloud/images/ubuntu/noble/amd64/cloud/20260320_07:42/rootfs.tar.xz

### Default версия
curl -o ~/iso/ubuntu_24.04__rootfs.tar.xz \
https://fra1lxdmirror01.do.letsbuildthe.cloud/images/ubuntu/noble/amd64/default/20260320_07:42/rootfs.tar.xz

# Создание каталога для файловой системы контейнера
mkdir -p \
/disk/VMs/ubuntu_24.04_rootfs

# Распаковка cloud версии
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
#### Вариант ручного проброса имеющего ключа и пароля в файловую систему lxc контейнера ОС ubuntu
```bash
# проброс ключа ssh на суперпользователя
mkdir -p \
/disk/VMs/ubuntu_24.04_rootfs/root/.ssh/

cat  ~/.ssh/id_kvm_host_to_vms.pub \
>>/disk/VMs/ubuntu_24.04_rootfs/root/.ssh/authorized_keys

# на всякий случай задать пароль для ubuntu "qwerty!2" в 
sed -i 's|u:!:|u:$6$jOJaaad3$213aac5XXw7XMVrtI8dPuwyJazAeMOoaq5QOvo.uf/7V70lA3PIsV7WAiM3d1SWPyDkPiVTvizRHta1P7ZyKs/:|' \
/disk/VMs/ubuntu_24.04_rootfs/etc/shadow
```
# Создание playbook развертывания lxc ОС ubuntu 24_04_cloud
```bash
# Указываем приоритетные настройки работы ansible Для запуска playbook в текущем каталоге
cat > ansible.cfg <<'EOF'
[defaults]
inventory = hosts.ini
roles_path = roles
collections_paths = collections
host_key_checking = False
retry_files_enabled = False
# stdout_callback = yaml
callback_enabled = profile_tasks

[privilege_escalation]
become = true
become_method = sudo
EOF
```
## Bash скрипт проверки локальной системы на Archlinux для развертывания lxc под управление libvirt
```bash
mkdir scripts

# Скрипт проверок
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
```
## Указание параметров
```bash
mkdir group_vars

# Файл с Переменными для всех хостов (в данном случае только для localhost)
cat > group_vars/all.yml <<'EOF'
---
# === пользователь локальной системы ===
ansible_user: shoel

# === расположение ssh ключа и условия взаимодействия при его отсутствия ===
root_ssh_key: "{{ lookup('file', '~/.ssh/id_kvm_host_to_vms.pub', errors='ignore') | default('') }}"

# === Libvirt LXC коннектор ===
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

# === Часовой пояс ===
timezone: Europe/Moscow

# === Перечисление контейнеров ===
containers:
  - clickhouse
  - vector
  - lighthouse
...
EOF
```
## Создание Одного Playbook с задачами развертывания
```bash
cat >containers.yml <<'EOF'
#!/usr/bin/env ansible-playbook
# Топорный Playbook на localhost для развертывания lxc ubuntu-cloud-24-04 amd64 на libvirt
# c прописанным shell-bang возможен запуск Playbook как bash скрипт "./containers.yml"
---
- name: Развёртывание VM с Cloud-Init
  hosts: localhost
  connection: local
  gather_facts: false
  become: true
  tasks:
    # === Подготовка RootFS ===
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
        content: |+
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
```
## Создание шаблона LXC контейнера под libvirt
```bash
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
/disk/VMs/ubuntu_24.04_rootfs
EOF

# ДЕлаем скрипт исполняемым
chmod +x \
scripts/delete_containers.sh
```
## Запуск Ansible playbook с экспортом переменной для читабельности выводов результата в yaml
```bash
chmod +x ./containers.yml

export ANSIBLE_CALLBACK_RESULT_FORMAT=yaml

./containers.yml -b -K -v
```
```
Using /home/shoel/nfs_git/gited/17_4/ansible-local-stand/ansible.cfg as config file
BECOME password: 
[WARNING]: Unable to parse /home/shoel/nfs_git/gited/17_4/ansible-local-stand/hosts.ini as an inventory source
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Развёртывание VM с Cloud-Init] ************************************

TASK [Создаём каталог для базового образа] ******************************************
changed: [localhost] => 
    changed: true
    gid: 0
    group: root
    mode: '0755'
    owner: root
    path: /disk/VMs/ubuntu_24.04_rootfs
    size: 4096
    state: directory
    uid: 0

TASK [Скачиваем Ubuntu 24.04 Cloud RootFS] ******************************************
ok: [localhost] => 
    changed: false
    checksum_dest: 0f3866eed6f27f3a0ebe5d099de0bd811f46e358
    checksum_src: 0f3866eed6f27f3a0ebe5d099de0bd811f46e358
    dest: /home/shoel/iso/ubuntu_24.04_cloud_rootfs.tar.xz
    elapsed: 14
    gid: 100
    group: '100'
    md5sum: 7bd0c98d8b89e34f4bea1d31119f8c7e
    mode: '0644'
    msg: OK (159602344 bytes)
    owner: '1024'
    size: 159602344
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174704.5827491-37557-98907216298687/tmp9lvg_j8d
    state: file
    status_code: 200
    uid: 1024
    url: https://fra1lxdmirror01.do.letsbuildthe.cloud/images/ubuntu/noble/amd64/cloud/20260320_07:42/rootfs.tar.xz

TASK [Распаковываем rootfs в целевую директорию] ************************************************
changed: [localhost] => 
    changed: true
    dest: /disk/VMs/ubuntu_24.04_rootfs/
    extract_results:
        cmd:
        - /usr/bin/tar
        - --extract
        - -C
        - /disk/VMs/ubuntu_24.04_rootfs
        - --show-transformed-names
        - --no-same-owner
        - --no-same-permissions
        - -f
        - /home/shoel/iso/ubuntu_24.04_cloud_rootfs.tar.xz
        err: ''
        out: ''
        rc: 0
    gid: 0
    group: root
    handler: TarArchive
    mode: '0755'
    owner: root
    size: 4096
    src: /home/shoel/iso/ubuntu_24.04_cloud_rootfs.tar.xz
    state: directory
    uid: 0

TASK [Включаем cloud-init в базовом образе] *******************************************
changed: [localhost] => 
    changed: true
    path: /disk/VMs/ubuntu_24.04_rootfs/etc/cloud/cloud-init.disabled
    state: absent

TASK [Создаём структуру overlay для всех контейнеров] *****************************************************
changed: [localhost] => (item=clickhouse/upper) => 
    ansible_loop_var: item
    changed: true
    gid: 0
    group: root
    item:
    - clickhouse
    - upper
    mode: '0755'
    owner: root
    path: /disk/VMs/overlays/clickhouse/upper
    size: 4096
    state: directory
    uid: 0
changed: [localhost] => (item=clickhouse/work) => 
    ansible_loop_var: item
    changed: true
    gid: 0
    group: root
    item:
    - clickhouse
    - work
    mode: '0755'
    owner: root
    path: /disk/VMs/overlays/clickhouse/work
    size: 4096
    state: directory
    uid: 0
changed: [localhost] => (item=clickhouse/merged) => 
    ansible_loop_var: item
    changed: true
    gid: 0
    group: root
    item:
    - clickhouse
    - merged
    mode: '0755'
    owner: root
    path: /disk/VMs/overlays/clickhouse/merged
    size: 4096
    state: directory
    uid: 0
changed: [localhost] => (item=vector/upper) => 
    ansible_loop_var: item
    changed: true
    gid: 0
    group: root
    item:
    - vector
    - upper
    mode: '0755'
    owner: root
    path: /disk/VMs/overlays/vector/upper
    size: 4096
    state: directory
    uid: 0
changed: [localhost] => (item=vector/work) => 
    ansible_loop_var: item
    changed: true
    gid: 0
    group: root
    item:
    - vector
    - work
    mode: '0755'
    owner: root
    path: /disk/VMs/overlays/vector/work
    size: 4096
    state: directory
    uid: 0
changed: [localhost] => (item=vector/merged) => 
    ansible_loop_var: item
    changed: true
    gid: 0
    group: root
    item:
    - vector
    - merged
    mode: '0755'
    owner: root
    path: /disk/VMs/overlays/vector/merged
    size: 4096
    state: directory
    uid: 0
changed: [localhost] => (item=lighthouse/upper) => 
    ansible_loop_var: item
    changed: true
    gid: 0
    group: root
    item:
    - lighthouse
    - upper
    mode: '0755'
    owner: root
    path: /disk/VMs/overlays/lighthouse/upper
    size: 4096
    state: directory
    uid: 0
changed: [localhost] => (item=lighthouse/work) => 
    ansible_loop_var: item
    changed: true
    gid: 0
    group: root
    item:
    - lighthouse
    - work
    mode: '0755'
    owner: root
    path: /disk/VMs/overlays/lighthouse/work
    size: 4096
    state: directory
    uid: 0
changed: [localhost] => (item=lighthouse/merged) => 
    ansible_loop_var: item
    changed: true
    gid: 0
    group: root
    item:
    - lighthouse
    - merged
    mode: '0755'
    owner: root
    path: /disk/VMs/overlays/lighthouse/merged
    size: 4096
    state: directory
    uid: 0

TASK [Монтируем OverlayFS] **************************
[WARNING]: Deprecation warnings can be disabled by setting `deprecation_warnings=False` in ansible.cfg.
[DEPRECATION WARNING]: Importing 'to_bytes' from 'ansible.module_utils._text' is deprecated. This feature will be removed from ansible-core version 2.24. Use ansible.module_utils.common.text.converters instead.
[DEPRECATION WARNING]: Importing 'to_native' from 'ansible.module_utils._text' is deprecated. This feature will be removed from ansible-core version 2.24. Use ansible.module_utils.common.text.converters instead.
[DEPRECATION WARNING]: Passing `warnings` to `exit_json` or `fail_json` is deprecated. This feature will be removed from ansible-core version 2.23. Use `AnsibleModule.warn` instead.
changed: [localhost] => (item=clickhouse) => 
    ansible_loop_var: item
    backup_file: ''
    boot: 'no'
    changed: true
    dump: '0'
    fstab: /etc/fstab
    fstype: overlay
    item: clickhouse
    name: /disk/VMs/overlays/clickhouse/merged
    opts: lowerdir=/disk/VMs/ubuntu_24.04_rootfs,upperdir=/disk/VMs/overlays/clickhouse/upper,workdir=/disk/VMs/overlays/clickhouse/work,noauto
    passno: '0'
    src: overlay
changed: [localhost] => (item=vector) => 
    ansible_loop_var: item
    backup_file: ''
    boot: 'no'
    changed: true
    dump: '0'
    fstab: /etc/fstab
    fstype: overlay
    item: vector
    name: /disk/VMs/overlays/vector/merged
    opts: lowerdir=/disk/VMs/ubuntu_24.04_rootfs,upperdir=/disk/VMs/overlays/vector/upper,workdir=/disk/VMs/overlays/vector/work,noauto
    passno: '0'
    src: overlay
changed: [localhost] => (item=lighthouse) => 
    ansible_loop_var: item
    backup_file: ''
    boot: 'no'
    changed: true
    dump: '0'
    fstab: /etc/fstab
    fstype: overlay
    item: lighthouse
    name: /disk/VMs/overlays/lighthouse/merged
    opts: lowerdir=/disk/VMs/ubuntu_24.04_rootfs,upperdir=/disk/VMs/overlays/lighthouse/upper,workdir=/disk/VMs/overlays/lighthouse/work,noauto
    passno: '0'
    src: overlay

TASK [Создаём директорию seed для cloud-init (NoCloud)] *******************************************************
changed: [localhost] => (item=clickhouse) => 
    ansible_loop_var: item
    changed: true
    gid: 0
    group: root
    item: clickhouse
    mode: '0755'
    owner: root
    path: /disk/VMs/overlays/clickhouse/merged/var/lib/cloud/seed/nocloud-net
    size: 4096
    state: directory
    uid: 0
changed: [localhost] => (item=vector) => 
    ansible_loop_var: item
    changed: true
    gid: 0
    group: root
    item: vector
    mode: '0755'
    owner: root
    path: /disk/VMs/overlays/vector/merged/var/lib/cloud/seed/nocloud-net
    size: 4096
    state: directory
    uid: 0
changed: [localhost] => (item=lighthouse) => 
    ansible_loop_var: item
    changed: true
    gid: 0
    group: root
    item: lighthouse
    mode: '0755'
    owner: root
    path: /disk/VMs/overlays/lighthouse/merged/var/lib/cloud/seed/nocloud-net
    size: 4096
    state: directory
    uid: 0

TASK [Генерируем meta-data (hostname)] **************************************
changed: [localhost] => (item=clickhouse) => 
    ansible_loop_var: item
    changed: true
    checksum: 30bca8f09854322cc807d2822aa692639537b4c9
    dest: /disk/VMs/overlays/clickhouse/merged/var/lib/cloud/seed/nocloud-net/meta-data
    gid: 0
    group: root
    item: clickhouse
    md5sum: ca99484c6401dd10b9ff82163de972b9
    mode: '0644'
    owner: root
    size: 51
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174729.4894276-38133-207186029422304/.source
    state: file
    uid: 0
changed: [localhost] => (item=vector) => 
    ansible_loop_var: item
    changed: true
    checksum: 024ac78914ac313caea6dc42eb0e9f5b69b11b41
    dest: /disk/VMs/overlays/vector/merged/var/lib/cloud/seed/nocloud-net/meta-data
    gid: 0
    group: root
    item: vector
    md5sum: a6f84ddf9d3e60baca2b8e3c52ebaebc
    mode: '0644'
    owner: root
    size: 43
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174730.2130563-38133-127289772883480/.source
    state: file
    uid: 0
changed: [localhost] => (item=lighthouse) => 
    ansible_loop_var: item
    changed: true
    checksum: f69915e4b6c58a420e75a93264aac4afbde9f7f2
    dest: /disk/VMs/overlays/lighthouse/merged/var/lib/cloud/seed/nocloud-net/meta-data
    gid: 0
    group: root
    item: lighthouse
    md5sum: e4540d2e51fbbe37047ded6a75f7d053
    mode: '0644'
    owner: root
    size: 51
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174730.8426669-38133-148810019392766/.source
    state: file
    uid: 0

TASK [Обновляем /etc/hosts для соответствия hostname (merged layer)] ********************************************************************
changed: [localhost] => (item=clickhouse) => 
    ansible_loop_var: item
    backup: ''
    changed: true
    item: clickhouse
    msg: line replaced and ownership, perms or SE linux context changed
changed: [localhost] => (item=vector) => 
    ansible_loop_var: item
    backup: ''
    changed: true
    item: vector
    msg: line replaced and ownership, perms or SE linux context changed
changed: [localhost] => (item=lighthouse) => 
    ansible_loop_var: item
    backup: ''
    changed: true
    item: lighthouse
    msg: line replaced and ownership, perms or SE linux context changed

TASK [Генерируем network-config (DHCP)] ***************************************
changed: [localhost] => (item=clickhouse) => 
    ansible_loop_var: item
    changed: true
    checksum: 72bec98b69706d57e539353fc2c1790eaabf1e34
    dest: /disk/VMs/overlays/clickhouse/merged/var/lib/cloud/seed/nocloud-net/network-config
    gid: 0
    group: root
    item: clickhouse
    md5sum: 8cad1bcb0226f12d5a3b7121537c1d94
    mode: '0644'
    owner: root
    size: 71
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174732.6248908-38302-218318832612869/.source
    state: file
    uid: 0
changed: [localhost] => (item=vector) => 
    ansible_loop_var: item
    changed: true
    checksum: 72bec98b69706d57e539353fc2c1790eaabf1e34
    dest: /disk/VMs/overlays/vector/merged/var/lib/cloud/seed/nocloud-net/network-config
    gid: 0
    group: root
    item: vector
    md5sum: 8cad1bcb0226f12d5a3b7121537c1d94
    mode: '0644'
    owner: root
    size: 71
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174733.2439563-38302-225067002414450/.source
    state: file
    uid: 0
changed: [localhost] => (item=lighthouse) => 
    ansible_loop_var: item
    changed: true
    checksum: 72bec98b69706d57e539353fc2c1790eaabf1e34
    dest: /disk/VMs/overlays/lighthouse/merged/var/lib/cloud/seed/nocloud-net/network-config
    gid: 0
    group: root
    item: lighthouse
    md5sum: 8cad1bcb0226f12d5a3b7121537c1d94
    mode: '0644'
    owner: root
    size: 71
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174733.87623-38302-272794790411473/.source
    state: file
    uid: 0

TASK [Генерируем user-data (SSH, пакеты, root)] ***********************************************
changed: [localhost] => (item=clickhouse) => 
    ansible_loop_var: item
    changed: true
    checksum: 1185d0c3f17b14cdd2cdfbf0b36a6d684c11435b
    dest: /disk/VMs/overlays/clickhouse/merged/var/lib/cloud/seed/nocloud-net/user-data
    gid: 0
    group: root
    item: clickhouse
    md5sum: 0f356ac473026642c1ec776c2bdc223e
    mode: '0600'
    owner: root
    size: 607
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174734.5327125-38393-42508272765323/.source
    state: file
    uid: 0
changed: [localhost] => (item=vector) => 
    ansible_loop_var: item
    changed: true
    checksum: 1185d0c3f17b14cdd2cdfbf0b36a6d684c11435b
    dest: /disk/VMs/overlays/vector/merged/var/lib/cloud/seed/nocloud-net/user-data
    gid: 0
    group: root
    item: vector
    md5sum: 0f356ac473026642c1ec776c2bdc223e
    mode: '0600'
    owner: root
    size: 607
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174735.139365-38393-196013165553866/.source
    state: file
    uid: 0
changed: [localhost] => (item=lighthouse) => 
    ansible_loop_var: item
    changed: true
    checksum: 1185d0c3f17b14cdd2cdfbf0b36a6d684c11435b
    dest: /disk/VMs/overlays/lighthouse/merged/var/lib/cloud/seed/nocloud-net/user-data
    gid: 0
    group: root
    item: lighthouse
    md5sum: 0f356ac473026642c1ec776c2bdc223e
    mode: '0600'
    owner: root
    size: 607
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174735.7831771-38393-142328053092329/.source
    state: file
    uid: 0

TASK [Сбрасываем machine-id в upper слое] *****************************************
changed: [localhost] => (item=clickhouse) => 
    ansible_loop_var: item
    changed: true
    checksum: da39a3ee5e6b4b0d3255bfef95601890afd80709
    dest: /disk/VMs/overlays/clickhouse/merged/etc/machine-id
    gid: 0
    group: root
    item: clickhouse
    md5sum: d41d8cd98f00b204e9800998ecf8427e
    mode: '0644'
    owner: root
    size: 0
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174736.3966362-38492-89400749504191/.source
    state: file
    uid: 0
changed: [localhost] => (item=vector) => 
    ansible_loop_var: item
    changed: true
    checksum: da39a3ee5e6b4b0d3255bfef95601890afd80709
    dest: /disk/VMs/overlays/vector/merged/etc/machine-id
    gid: 0
    group: root
    item: vector
    md5sum: d41d8cd98f00b204e9800998ecf8427e
    mode: '0644'
    owner: root
    size: 0
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174737.040598-38492-254014013864216/.source
    state: file
    uid: 0
changed: [localhost] => (item=lighthouse) => 
    ansible_loop_var: item
    changed: true
    checksum: da39a3ee5e6b4b0d3255bfef95601890afd80709
    dest: /disk/VMs/overlays/lighthouse/merged/etc/machine-id
    gid: 0
    group: root
    item: lighthouse
    md5sum: d41d8cd98f00b204e9800998ecf8427e
    mode: '0644'
    owner: root
    size: 0
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174737.7135205-38492-169097057852034/.source
    state: file
    uid: 0

TASK [Ссылка на пустой machine-id (требование systemd)] *******************************************************
changed: [localhost] => (item=clickhouse) => 
    ansible_loop_var: item
    changed: true
    dest: /disk/VMs/overlays/clickhouse/merged/var/lib/dbus/machine-id
    gid: 0
    group: root
    item: clickhouse
    mode: '0777'
    owner: root
    size: 15
    src: /etc/machine-id
    state: link
    uid: 0
changed: [localhost] => (item=vector) => 
    ansible_loop_var: item
    changed: true
    dest: /disk/VMs/overlays/vector/merged/var/lib/dbus/machine-id
    gid: 0
    group: root
    item: vector
    mode: '0777'
    owner: root
    size: 15
    src: /etc/machine-id
    state: link
    uid: 0
changed: [localhost] => (item=lighthouse) => 
    ansible_loop_var: item
    changed: true
    dest: /disk/VMs/overlays/lighthouse/merged/var/lib/dbus/machine-id
    gid: 0
    group: root
    item: lighthouse
    mode: '0777'
    owner: root
    size: 15
    src: /etc/machine-id
    state: link
    uid: 0

TASK [Формируем XML для контейнеров] ************************************
changed: [localhost] => (item=clickhouse) => 
    ansible_loop_var: item
    changed: true
    checksum: 0eef3f60dee779ebf7194832f60d50f089b1ba47
    dest: /tmp/clickhouse.xml
    gid: 0
    group: root
    item: clickhouse
    md5sum: d60ce473eae67987eca7cd58ca55ee2d
    mode: '0644'
    owner: root
    size: 785
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174739.3966558-38651-94264661903737/.source.xml
    state: file
    uid: 0
changed: [localhost] => (item=vector) => 
    ansible_loop_var: item
    changed: true
    checksum: 0b3f984b616be9d24b4688f344a55c1386a3cbd2
    dest: /tmp/vector.xml
    gid: 0
    group: root
    item: vector
    md5sum: e76b4096b4e74daa370a13136a7428ac
    mode: '0644'
    owner: root
    size: 777
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174740.0221686-38651-140455823537156/.source.xml
    state: file
    uid: 0
changed: [localhost] => (item=lighthouse) => 
    ansible_loop_var: item
    changed: true
    checksum: b6ab65cc1d9528227036863ede967692305e23db
    dest: /tmp/lighthouse.xml
    gid: 0
    group: root
    item: lighthouse
    md5sum: f637c5c6df1c149f9d7e621caf563422
    mode: '0644'
    owner: root
    size: 785
    src: /home/shoel/.ansible/tmp/ansible-tmp-1774174740.6836646-38651-137083726627502/.source.xml
    state: file
    uid: 0

TASK [Определяем контейнер в libvirt] *************************************
changed: [localhost] => (item=clickhouse) => 
    ansible_loop_var: item
    changed: true
    created: clickhouse
    item: clickhouse
changed: [localhost] => (item=vector) => 
    ansible_loop_var: item
    changed: true
    created: vector
    item: vector
changed: [localhost] => (item=lighthouse) => 
    ansible_loop_var: item
    changed: true
    created: lighthouse
    item: lighthouse

TASK [Очищаем временные XML] ****************************
changed: [localhost] => (item=clickhouse) => 
    ansible_loop_var: item
    changed: true
    item: clickhouse
    path: /tmp/clickhouse.xml
    state: absent
changed: [localhost] => (item=vector) => 
    ansible_loop_var: item
    changed: true
    item: vector
    path: /tmp/vector.xml
    state: absent
changed: [localhost] => (item=lighthouse) => 
    ansible_loop_var: item
    changed: true
    item: lighthouse
    path: /tmp/lighthouse.xml
    state: absent

TASK [Выключаем контейнер если запущен] ***************************************
FAILED - RETRYING: [localhost]: Выключаем контейнер если запущен (1 retries left).
[ERROR]: Task failed: Module failed: non-zero return code
Origin: /home/shoel/nfs_git/gited/17_4/ansible-local-stand/containers.yml:248:7

246         label: "{{ item }}"
247
248     - name: Выключаем контейнер если запущен
          ^ column 7

failed: [localhost] (item=clickhouse) => 
    ansible_loop_var: item
    attempts: 1
    changed: false
    cmd:
    - virsh
    - -c
    - lxc:///
    - shutdown
    - clickhouse
    delta: '0:00:00.027850'
    end: '2026-03-22 13:19:07.390806'
    item: clickhouse
    msg: non-zero return code
    rc: 1
    start: '2026-03-22 13:19:07.362956'
    stderr: |-
        error: Failed to shutdown domain 'clickhouse'
        error: Недопустимая операция: домен не работает
    stderr_lines: <omitted>
    stdout: ''
    stdout_lines: <omitted>
FAILED - RETRYING: [localhost]: Выключаем контейнер если запущен (1 retries left).
failed: [localhost] (item=vector) => 
    ansible_loop_var: item
    attempts: 1
    changed: false
    cmd:
    - virsh
    - -c
    - lxc:///
    - shutdown
    - vector
    delta: '0:00:00.028030'
    end: '2026-03-22 13:19:11.112832'
    item: vector
    msg: non-zero return code
    rc: 1
    start: '2026-03-22 13:19:11.084802'
    stderr: |-
        error: Failed to shutdown domain 'vector'
        error: Недопустимая операция: домен не работает
    stderr_lines: <omitted>
    stdout: ''
    stdout_lines: <omitted>
FAILED - RETRYING: [localhost]: Выключаем контейнер если запущен (1 retries left).
failed: [localhost] (item=lighthouse) => 
    ansible_loop_var: item
    attempts: 1
    changed: false
    cmd:
    - virsh
    - -c
    - lxc:///
    - shutdown
    - lighthouse
    delta: '0:00:00.028754'
    end: '2026-03-22 13:19:14.810589'
    item: lighthouse
    msg: non-zero return code
    rc: 1
    start: '2026-03-22 13:19:14.781835'
    stderr: |-
        error: Failed to shutdown domain 'lighthouse'
        error: Недопустимая операция: домен не работает
    stderr_lines: <omitted>
    stdout: ''
    stdout_lines: <omitted>
...ignoring

TASK [Запускаем контейнеры] ***************************
changed: [localhost] => (item=clickhouse) => 
    ansible_loop_var: item
    attempts: 1
    changed: true
    item: clickhouse
    msg: 0
changed: [localhost] => (item=vector) => 
    ansible_loop_var: item
    attempts: 1
    changed: true
    item: vector
    msg: 0
changed: [localhost] => (item=lighthouse) => 
    ansible_loop_var: item
    attempts: 1
    changed: true
    item: lighthouse
    msg: 0

TASK [Ждём, пока контейнеры запустятся] ***************************************
ok: [localhost] => (item=clickhouse) => 
    ansible_loop_var: item
    attempts: 1
    changed: false
    cmd:
    - virsh
    - -c
    - lxc:///
    - domstate
    - clickhouse
    delta: '0:00:00.017719'
    end: '2026-03-22 13:19:16.596038'
    item: clickhouse
    msg: ''
    rc: 0
    start: '2026-03-22 13:19:16.578319'
    stderr: ''
    stderr_lines: <omitted>
    stdout: running
    stdout_lines: <omitted>
ok: [localhost] => (item=vector) => 
    ansible_loop_var: item
    attempts: 1
    changed: false
    cmd:
    - virsh
    - -c
    - lxc:///
    - domstate
    - vector
    delta: '0:00:00.017226'
    end: '2026-03-22 13:19:16.926133'
    item: vector
    msg: ''
    rc: 0
    start: '2026-03-22 13:19:16.908907'
    stderr: ''
    stderr_lines: <omitted>
    stdout: running
    stdout_lines: <omitted>
ok: [localhost] => (item=lighthouse) => 
    ansible_loop_var: item
    attempts: 1
    changed: false
    cmd:
    - virsh
    - -c
    - lxc:///
    - domstate
    - lighthouse
    delta: '0:00:00.025281'
    end: '2026-03-22 13:19:17.242926'
    item: lighthouse
    msg: ''
    rc: 0
    start: '2026-03-22 13:19:17.217645'
    stderr: ''
    stderr_lines: <omitted>
    stdout: running
    stdout_lines: <omitted>

PLAY RECAP *********************************************
localhost                  : ok=19   changed=16   unreachable=0    failed=0    skipped=0    rescued=0    ignored=1 
```
#### ПАМЯТКА: сброс блока ввода пароля в сеансе пользователя для Archlinux
```bash
faillock --reset
```
#### Получение IP через чтение в файловой системе контейнеров лог-файла cloud-init-output.log
```bash
cat > scripts/ip_check.sh <<'EOF'
#!/bin/bash
# вывод ip контейнеров
for i in $(ls /disk/VMs/overlays/); do
sudo awk '/global/ {print $7}' \
"/disk/VMs/overlays/$i/merged/var/log/cloud-init-output.log" \
| tail -n1; done \
| while read ip_value; do \
echo "$(ssh -n -t -o StrictHostKeyChecking=accept-new \
-i ~/.ssh/id_kvm_host_to_vms "root@$ip_value" \
"hostname")" \
- "$ip_value"; done \
2> /dev/null
EOF

chmod +x scripts/ip_check.sh
```
```bash
scripts/ip_check.sh
```
```
clickhouse - 192.168.89.113
lighthouse - 192.168.89.114
vector - 192.168.89.115
```
#### Скрипт генерации файла
```bash
cat > ansible-local-stand/scripts/hosts_ini_gen.sh <<'EOF'
#!/bin/bash
# Генерация hosts.ini

{
  # Динамическая часть: поиск IP и имен хостов
  for i in $(ls /disk/VMs/overlays/); do
    sudo awk '/global/ {print $7}' \
    "/disk/VMs/overlays/$i/merged/var/log/cloud-init-output.log" \
    | tail -n1; done \
  | while read ip_value; do
    host_name=$(ssh -n -t -o StrictHostKeyChecking=accept-new \
    -i ~/.ssh/id_kvm_host_to_vms "root@$ip_value" \
    "hostname" 2>/dev/null)
    
    # Вывод в формате Ansible inventory
    echo "[$host_name]"
    echo "$ip_value"
    echo ""
  done

  # Статическая часть: группы
  echo "[stack_log:children]"
  echo "clickhouse"
  echo "lighthouse"
  echo "vector"
} > hosts.ini
EOF

chmod +x ansible-local-stand/scripts/hosts_ini_gen.sh

./ansible-local-stand/scripts/hosts_ini_gen.sh

cat hosts.ini
```
```
[clickhouse]
192.168.89.113

[lighthouse]
192.168.89.114

[vector]
192.168.89.115

[stack_log:children]
clickhouse
lighthouse
vector
```