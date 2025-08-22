#считываем данные об образе ОС
data "yandex_compute_image" "ubuntu_2404_lts" {
  family = "ubuntu-2404-lts-oslogin"
}

resource "yandex_compute_instance" "Prom-core" {
  name        = "Prom-core"
  hostname    = "Prom-core"
  platform_id = "standard-v2"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = var.srv.cores
    memory        = var.srv.memory
    core_fraction = var.srv.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.skv_a.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.Prom-core.id]
  }
}


resource "yandex_compute_instance" "node-epx" {
  name        = "host-a"
  hostname    = "host-a"
  platform_id = "standard-v2"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!


  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.skv_a.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.nod_gra.id]
  }
}


resource "local_file" "hosts-ans" {
  content  = <<-XYZ
  [all:vars]
  ansible_user=skv
  ansible_ssh_private_key_file=~/.ssh/id_09-4_ed25519
  [Prom-core]
  ${yandex_compute_instance.Prom-core.network_interface.0.nat_ip_address}
  ${yandex_compute_instance.Prom-core.network_interface.0.ip_address} 

  [node_exp]
  ${yandex_compute_instance.node-epx.network_interface.0.ip_address}

  [node_exp:vars]
  ansible_ssh_common_args = '-o ProxyCommand="ssh -p 22 -o StrictHostKeyChecking=accept-new -W %h:%p -q skv@${yandex_compute_instance.Prom-core.network_interface.0.nat_ip_address}"'
    XYZ
  filename = "./hosts.ini"
}