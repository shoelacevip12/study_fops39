resource "time_sleep" "wait_for_nat" {
  create_duration = "180s"
  depends_on = [
    yandex_compute_instance.team-c-vm-nexus,
    yandex_compute_instance.team-c-con-srv
  ]
}

# teamcity сервер
resource "yandex_compute_instance" "team-c-con-srv" {
  name        = "team-c-con-srv"
  hostname    = "team-c-con-srv"
  platform_id = "standard-v2"
  zone        = "ru-central1-b"

  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      name       = "team-c-disk-srv"
      type       = "network-hdd"
      size       = 20
      block_size = 4096
      image_id   = "fd8r4e7rkb7mj8rc046f"
    }
    auto_delete = true
  }

  metadata = {
    user-data                    = file("./cloud-init.yml")
    serial-port-enable           = 1
    ssh-keys                     = "ubuntu:${file("~/.ssh/id_skv_VKR_vpn.pub")}"
    docker-container-declaration = "spec:\n  containers:\n  - image: jetbrains/teamcity-server\n"
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.skv-locnet-b.id
    # nat        = false
    nat        = true
    ip_address = "10.10.10.254"
    security_group_ids = [
      yandex_vpc_security_group.host-sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# teamcity агент
resource "yandex_compute_instance" "team-c-con-agent" {
  name        = "team-c-con-agent"
  hostname    = "team-c-con-agent"
  platform_id = "standard-v2"
  zone        = "ru-central1-b"

  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      name       = "team-c-disk-agent"
      type       = "network-hdd"
      size       = 20
      block_size = 4096
      image_id   = "fd8r4e7rkb7mj8rc046f"
    }
    auto_delete = true
  }

  metadata = {
    user-data                    = file("./cloud-init.yml")
    serial-port-enable           = 1
    ssh-keys                     = "ubuntu:${file("~/.ssh/id_skv_VKR_vpn.pub")}"
    docker-container-declaration = "spec:\n  containers:\n  - image: jetbrains/teamcity-agent\n    env:\n    - name: SERVER_URL\n      value: http://${yandex_compute_instance.team-c-con-srv.network_interface[0].ip_address}:8111\n  restartPolicy: Always\n"
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.skv-locnet-b.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id]
  }
}

# Данные об образе ОС
data "yandex_compute_image" "centos_7_oslogin" {
  family = "centos-7-oslogin"
}

# VM nexus
resource "yandex_compute_instance" "team-c-vm-nexus" {
  name        = "team-c-vm-nexus"
  hostname    = "team-c-vm-nexus"
  platform_id = "standard-v2"
  zone        = "ru-central1-b"

  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos_7_oslogin.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${file("~/.ssh/id_skv_VKR_vpn.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.skv-locnet-b.id
    # nat       = false
    nat = true
    security_group_ids = [
      yandex_vpc_security_group.host-vm-sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}