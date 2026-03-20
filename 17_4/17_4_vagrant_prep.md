# Базовое развертывание kvm на libvirt
```bash
sudo virt-install --name clickhouse \
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