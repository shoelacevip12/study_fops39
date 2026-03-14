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
  name        = local.platf_name[0].p1
  platform_id = var.vm_web_.2
  resources {
    cores         = var.vms_resources["vm_web"].cores
    memory        = var.vms_resources["vm_web"].memory
    core_fraction = var.vms_resources["vm_web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_.3
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = var.vms_ssh

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
  name        = local.platf_name[1].p2
  platform_id = var.vm_db_.4
  zone        = var.vm_db_.1
  resources {
    cores         = var.vms_resources["vm_db"].cores
    memory        = var.vms_resources["vm_db"].memory
    core_fraction = var.vms_resources["vm_db"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_.3
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.skv-locnet-b.id
    nat       = true
  }

  metadata = var.vms_ssh
}
