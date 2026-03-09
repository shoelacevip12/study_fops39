# Данные об образе ОС
data "yandex_compute_image" "ubuntu_2404_lts" {
  family = "ubuntu-2404-lts"
}

# Docker Host
resource "yandex_compute_instance" "docker-host" {
  name        = "docker"
  hostname    = "docker"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

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
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${file("~/.ssh/id_lab16_1_fops39_ed25519.pub")}"
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-a.id
    nat        = true
    ip_address = "10.10.10.254"
    security_group_ids = [
      yandex_vpc_security_group.host_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Файл hosts для проброса скрипта запуска проекта
resource "local_file" "hosts_docker" {
  content  = <<-EOT
    #!/bin/bash -x
    > ~/.ssh/known_hosts
    # Копирование скрипта запуска лабораторной работы
    rsync -vP -e "ssh \
    -o StrictHostKeyChecking=accept-new \
    -i ~/.ssh/id_lab16_1_fops39_ed25519" \
    lab16_1.sh \
    skv@${yandex_compute_instance.docker-host.network_interface.0.nat_ip_address}:~/

    # Запуск скрипта выполнения работы
    ssh -t -p 22 \
    -o StrictHostKeyChecking=accept-new \
    -i ~/.ssh/id_lab16_1_fops39_ed25519 \
    skv@${yandex_compute_instance.docker-host.network_interface.0.nat_ip_address} \
    "chmod +x lab16_1.sh \
    && bash -c "./lab16_1.sh""
EOT
  filename = "./hosts_docker.sh"
}
