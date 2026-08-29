data "yandex_compute_image" "ubuntu_lemp" {
  family = var.vm_image_family
}

locals {
  description = "Указание метаданных через locals до ssh ключа"
  common_metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:${file(var.ssh_key_file)}"
  }
}

resource "yandex_compute_instance_group" "ins-gr" {
  name = "ins-gr"
  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  folder_id           = var.folder_id
  service_account_id  = var.service_account_id
  deletion_protection = false

  allocation_policy {
    zones = [
      "ru-central1-a"
    ]
  }

  deploy_policy {
    max_creating     = 1
    max_deleting     = 2
    max_unavailable  = 1
    max_expansion    = 1
    startup_duration = 0
    strategy         = "proactive"
  }

  instance_template {
    platform_id = var.platform_id
    hostname    = "public-vm-{instance.index}"

    resources {
      cores         = var.host.cores
      memory        = var.host.memory
      core_fraction = var.host.core_fraction
      gpus          = 0
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu_lemp.image_id
        type     = var.disk.type
        size     = var.disk.size
      }
    }

    metadata = local.common_metadata

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      network_id = yandex_vpc_network.skv.id
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = false
      security_group_ids = [
        yandex_vpc_security_group.LAN.id,
        yandex_vpc_security_group.host_sg.id
      ]
    }
  }
}