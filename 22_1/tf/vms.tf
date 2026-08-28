# Данные об образе ОС для публичной и приватной ВМ
data "yandex_compute_image" "ubuntu_2404_lts" {
  family = "ubuntu-2404-lts"
}

# NAT-инстанс в публичной подсети (192.168.10.254)
resource "yandex_compute_instance" "nat-instance" {
  name        = "nat-instance"
  hostname    = "nat-instance"
  platform_id = "standard-v2"
  zone        = var.default_zone

  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${file("~/.ssh/id_lab22_1_fops40_ed25519.pub")}"
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    ip_address         = "192.168.10.254"
    ip_forwarding      = true
    nat                = true
    security_group_ids = [yandex_vpc_security_group.LAN.id]
  }
}

# Публичная ВМ с публичным IP
resource "yandex_compute_instance" "public-vm" {
  name        = "public-vm"
  hostname    = "public-vm"
  platform_id = "standard-v2"
  zone        = var.default_zone

  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${file("~/.ssh/id_lab22_1_fops40_ed25519.pub")}"
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    ip_address         = "192.168.10.10"
    nat                = true
    security_group_ids = [
      yandex_vpc_security_group.LAN.id,
      yandex_vpc_security_group.host_sg.id
    ]
  }
}

# Приватная ВМ с внутренним IP (выход в интернет через NAT-инстанс)
resource "yandex_compute_instance" "private-vm" {
  name        = "private-vm"
  hostname    = "private-vm"
  platform_id = "standard-v2"
  zone        = var.default_zone

  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${file("~/.ssh/id_lab22_1_fops40_ed25519.pub")}"
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    ip_address         = "192.168.20.10"
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id]
  }
}