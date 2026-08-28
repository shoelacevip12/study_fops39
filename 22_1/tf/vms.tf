data "yandex_compute_image" "ubuntu_2404_lts" {
  family = "ubuntu-2404-lts-oslogin"
}

# Общие метаданные для всех ВМ через locals
locals {
  description = "Указание метаданных через locals до ssh ключа"
  common_metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:${file(var.ssh_key_file)}"
  }
}

resource "yandex_compute_instance" "public-vm" {
  name        = "public-vm"
  hostname    = "public-vm"
  platform_id = var.platform_id
  zone        = var.default_zone

  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = var.disk.type
      size     = var.disk.size
    }
  }

  metadata = local.common_metadata

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat        = true
    security_group_ids = [
      yandex_vpc_security_group.LAN.id,
      yandex_vpc_security_group.host_sg.id
    ]
  }

  allow_stopping_for_update = true

}

resource "yandex_compute_instance" "private-vm" {
  description = "ВМ без прямого выхода в интернет"
  name        = "private-vm"
  hostname    = "private-vm"
  platform_id = var.platform_id
  zone        = var.default_zone

  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = var.disk.type
      size     = var.disk.size
    }
  }

  metadata = local.common_metadata

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    ip_address         = "192.168.20.254"
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id]
  }

  allow_stopping_for_update = true

}