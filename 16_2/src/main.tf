resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_.0
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_.1
  platform_id = var.vm_web_.2
  resources {
    cores         = var.vm_web_.3
    memory        = var.vm_web_.4
    core_fraction = var.vm_web_.5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_.6
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

# Подсеть zone B
resource "yandex_vpc_subnet" "skv-locnet-b" {
  name           = var.vm_db_.0
  zone           = var.vm_db_.1
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_db_.2
}

# ВМ netology-develop-platform-db
resource "yandex_compute_instance" "platform2" {
  name        = var.vm_db_.3
  platform_id = var.vm_db_.4
  zone        = var.vm_db_.1
  resources {
    cores         = var.vm_db_.5
    memory        = var.vm_db_.6
    core_fraction = var.vm_db_.7
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_.8
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.skv-locnet-b.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
