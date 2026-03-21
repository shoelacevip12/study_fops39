# Базовое развертывание kvm на libvirt
```bash
sudo virt-install --name clickhouse2 \
--ram 4096 \
--vcpus=2 \
--disk pool=VMs,size=40,bus=virtio,format=qcow2 \
--cdrom /home/shoel/iso/ubuntu-24.04.4-live-server-amd64.iso \
--os-type=linux \
--os-variant=ubuntu24.04 \
--graphics vnc \
--network bridge=br0 \
--boot uefi
```
# Создание нескольких машин
```bash
cat >vagrantfile <<'EOF'
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Путь к ISO образу Ubuntu 24.04
  ubuntu_iso_path = "/home/shoel/iso/ubuntu-24.04.4-live-server-amd64.iso"

  # Общие настройки для провайдера libvirt
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = "kvm"
    libvirt.uri = 'qemu:///system'

    # Характеристики 4 ГБ ОЗУ
    # 2 vCPU
    # Прямой Проброс CPU хоста
    # включение вложенной виртуализации
    libvirt.memory = 4096
    libvirt.cpus = 2
    libvirt.cpu_mode = 'host-passthrough'
    libvirt.nested = true

    # Настройка загрузки с диска и CDROM
    libvirt.boot 'hd'
    libvirt.disk_driver :cache => 'none'
    libvirt.disk_bus = "virtio"
    libvirt.boot 'cdrom'

    # Управление сетью через внешний мост, а не через Vagrant
    libvirt.management_network_mode = "none"
    libvirt.nic_model_type = "virtio"

    # Настройка диска
    libvirt.storage :file, :size => '40G', :type => 'qcow2', :bus => 'virtio'
  end

  # --- Создание ВМ для ubuntu_s с именами из списка ---
  vm_names = ["clickhouse", "vector", "lighthouse"]

  vm_names.each do |name| # Используем переменную name внутри цикла
    config.vm.define "#{name}" do |node_2|
      node_2.vm.hostname = "#{name}" # Устанавливаем имя хоста для ВМ
      node_2.vm.communicator = "none" # Отключаем стандартный communicator (SSH), так как используется ISO

      # Подключение к существующему мосту br0
      node_2.vm.network "public_network",
                        dev: "br0",
                        type: "bridge",
                        mode: "bridge"

      # Настройки провайдера libvirt для конкретной ВМ
      node_2.vm.provider :libvirt do |libvirt_specific|
        # Указываем ISO образ
        libvirt_specific.storage :file, :device => :cdrom, :path => ubuntu_iso_path
        libvirt_specific.storage_pool_name = "VMs"
      end

      # Заглушка для provisioner
      node_2.vm.provision "shell", inline: "echo '#{name} VM created.'", run: "never"
    end
  end
end
EOF
```
# Запуск создания VM на kvm vagrant`ом
```bash
sudo vagrant up
```
```bash
# playbook на создание машин
cat > create-vm.yaml <<'EOF'
---
- name: Развертывание ВМ на libvirt
  hosts: localhost
  connection: local
  gather_facts: false
  become: true

  vars:
    # Общие настройки для всех машин
    vm_defaults:
      memory_kib: 4194304
      vcpu: 2
      disk_base_path: "/disk/VMs"
      disk_suffix: "-1.qcow2"
      bridge: "br0"
      # uefi firmware
      efi_code: "/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd"
      efi_vars_template: "/usr/share/edk2/x64/OVMF_VARS.4m.fd"

    # Список машин с уникальными значениями
    vms_list:
      - name: "clickhouse"
        mac_address: "52:54:00:64:ad:4b"
        uuid: "0f2b0f74-7d65-4d1b-a954-aa4488980438"
      
      - name: "vector"
        mac_address: "52:54:00:64:ad:4c"
        uuid: "11111111-7d65-4d1b-a954-aa4488980438"
      
      - name: "lighthouse"
        mac_address: "52:54:00:64:ad:4d"
        uuid: "22222222-7d65-4d1b-a954-aa4488980438"
    
    iso_path: "/home/shoel/iso/ubuntu-24.04.4-live-server-amd64.iso"
    
  tasks:
    - name: Наличие дисков
      file:
        path: "{{ vm_defaults.disk_base_path }}"
        state: directory
        mode: '0755'

    - name: Shell на создание образов для ВМ
      command: >
        qemu-img create -f qcow2 
        {{ vm_defaults.disk_base_path }}/{{ item.name }}{{ vm_defaults.disk_suffix }} 20G
        creates={{ vm_defaults.disk_base_path }}/{{ item.name }}{{ vm_defaults.disk_suffix }}
      loop: "{{ vms_list }}"
      loop_control:
        label: "{{ item.name }}"

    - name: Создание ВМ на основе шаблона XML
      community.libvirt.virt:
        command: define
        xml: "{{ lookup('template', 'templates/vm_config.xml.j2') }}"
        uri: "qemu:///system"
      loop: "{{ vms_list }}"
      loop_control:
        label: "{{ item.name }}"
      vars:
        # Объединяем общие настройки с  уникальными настройками конкретной машины
        # Переменные из item (имя, mac) имеют приоритет и перезапишут default при конфликте
        vm: "{{ vm_defaults | combine(item) }}"

    - name: Запуск kvm машин
      community.libvirt.virt:
        name: "{{ item.name }}"
        state: running
        uri: "qemu:///system"
      loop: "{{ vms_list }}"
      loop_control:
        label: "{{ item.name }}"
...
EOF

# Создание из xml шаблона kvm машины для Libvirt
# предварительно протестирован из-под bash установки
cat > templates/vm_config.xml.j2 <<EOF
<domain type='kvm'>
  <!-- Используем переменные из объединенного объекта vm -->
  <name>{{ vm.name }}</name>
  <uuid>{{ vm.uuid }}</uuid>
  
  <metadata>
    <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
      <libosinfo:os id="http://ubuntu.com/ubuntu/24.04"/>
    </libosinfo:libosinfo>
  </metadata>
  
  <!-- Параметризация ресурсов из vm -->
  <memory unit='KiB'>{{ vm.memory_kib }}</memory>
  <currentMemory unit='KiB'>{{ vm.memory_kib }}</currentMemory>
  <vcpu placement='static'>{{ vm.vcpu }}</vcpu>
  
  <os firmware='efi'>
    <type arch='x86_64' machine='pc-q35-10.2'>hvm</type>
    <firmware>
      <feature enabled='no' name='enrolled-keys'/>
      <feature enabled='yes' name='secure-boot'/>
    </firmware>
    <!-- Пути к EFI из дефолтов -->
    <loader readonly='yes' secure='yes' type='pflash' format='raw'>{{ vm.efi_code }}</loader>
    <!-- NVRAM уникален по имени ВМ -->
    <nvram template='{{ vm.efi_vars_template }}' templateFormat='raw' format='raw'>/var/lib/libvirt/qemu/nvram/{{ vm.name }}_VARS.fd</nvram>
    <boot dev='hd'/>
  </os>
  
  <features>
    <acpi/>
    <apic/>
    <smm state='on'/>
  </features>
  
  <cpu mode='host-passthrough' check='none' migratable='on'/>
  <clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  
  <pm>
    <suspend-to-mem enabled='no'/>
    <suspend-to-disk enabled='no'/>
  </pm>
  
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='{{ iso_path }}'/>  
      <target dev='sda' bus='sata'/>
      <address type='drive' controller='0' bus='0' target='0' unit='0'/>
    </disk>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' discard='unmap'/>
      <source file='{{ vm.disk_base_path }}/{{ vm.name }}{{ vm.disk_suffix }}'/>
      <target dev='vda' bus='virtio'/>
      <address type='pci' domain='0x0000' bus='0x04' slot='0x00' function='0x0'/>
    </disk>
    <controller type='usb' index='0' model='qemu-xhci' ports='15'>
      <address type='pci' domain='0x0000' bus='0x02' slot='0x00' function='0x0'/>
    </controller>
    <controller type='pci' index='0' model='pcie-root'/>
    <controller type='pci' index='1' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='1' port='0x10'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0' multifunction='on'/>
    </controller>
    <controller type='pci' index='14' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='14' port='0x1d'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x5'/>
    </controller>
    <controller type='sata' index='0'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x1f' function='0x2'/>
    </controller>
    <controller type='virtio-serial' index='0'>
      <address type='pci' domain='0x0000' bus='0x03' slot='0x00' function='0x0'/>
    </controller>
    
    <!-- Сеть: используем переменные из vm -->
    <interface type='bridge'>
      <mac address='{{ vm.mac_address }}'/>
      <source bridge='{{ vm.bridge }}'/>
      <model type='virtio'/>
      <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
    </interface>
    
    <serial type='pty'>
      <target type='isa-serial' port='0'>
        <model name='isa-serial'/>
      </target>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <channel type='unix'>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
      <address type='virtio-serial' controller='0' bus='0' port='1'/>
    </channel>
    <input type='tablet' bus='usb'>
      <address type='usb' bus='0' port='1'/>
    </input>
    <input type='mouse' bus='ps2'/>
    <input type='keyboard' bus='ps2'/>
    <graphics type='vnc' port='-1' autoport='yes'>
      <listen type='address'/>
    </graphics>
    <audio id='1' type='none'/>
    <video>
      <model type='virtio' heads='1' primary='yes'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x0'/>
    </video>
    <watchdog model='itco' action='reset'/>
    <memballoon model='virtio'>
      <address type='pci' domain='0x0000' bus='0x05' slot='0x00' function='0x0'/>
    </memballoon>
    <rng model='virtio'>
      <backend model='random'>/dev/urandom</backend>
      <address type='pci' domain='0x0000' bus='0x06' slot='0x00' function='0x0'/>
    </rng>
  </devices>
</domain>
EOF

# Запуск playbook от имени суперпользователя с запросом пароля
ansible-playbook -b -K create-vm.yaml
```
```
BECOME password: 
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Развертывание ВМ на libvirt] *************************************************************

TASK [Наличие дисков] **************************************************************************
ok: [localhost]

TASK [Shell на создание образов для ВМ] ********************************************************
changed: [localhost] => (item=clickhouse)
changed: [localhost] => (item=vector)
changed: [localhost] => (item=lighthouse)

TASK [Создание ВМ на основе шаблона XML] *******************************************************
[WARNING]: Deprecation warnings can be disabled by setting `deprecation_warnings=False` in ansible.cfg.
[DEPRECATION WARNING]: Importing 'to_native' from 'ansible.module_utils._text' is deprecated. This feature will be removed from ansible-core version 2.24. Use ansible.module_utils.common.text.converters instead.
changed: [localhost] => (item=clickhouse)
changed: [localhost] => (item=vector)
changed: [localhost] => (item=lighthouse)

TASK [Запуск kvm машин] **************************************************************************
changed: [localhost] => (item=clickhouse)
changed: [localhost] => (item=vector)
changed: [localhost] => (item=lighthouse)

PLAY RECAP ****************************************************************************************
localhost                  : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```