# Данные об образе ОС
data "yandex_compute_image" "ubuntu_2404_lts" {
  family = "ubuntu-2404-lts"
}

# Bastion Host
resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  platform_id = "standard-v2"
  zone        = "ru-central1-d"

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
    ssh-keys           = "ubuntu:${file("~/.ssh/id_cours_fops39_2025_ed25519.pub")}"
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-d.id
    nat        = true
    ip_address = "10.10.10.230"
    security_group_ids = [
      yandex_vpc_security_group.bastion_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Веб-сервер 1
resource "yandex_compute_instance" "web-a" {
  name        = "web-a"
  hostname    = "web-a"
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
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-a.id
    nat        = false
    ip_address = "10.10.10.201"
    security_group_ids = [
      yandex_vpc_security_group.web_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Веб-сервер 2
resource "yandex_compute_instance" "web-b" {
  name        = "web-b"
  hostname    = "web-b"
  platform_id = "standard-v2"
  zone        = "ru-central1-b"

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
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-b.id
    nat        = false
    ip_address = "10.10.10.211"
    security_group_ids = [
      yandex_vpc_security_group.web_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Prometheus
resource "yandex_compute_instance" "prometheus" {
  name        = "prometheus"
  hostname    = "prometheus"
  platform_id = "standard-v2"
  zone        = "ru-central1-d"

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

  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-d.id
    nat        = false
    ip_address = "10.10.10.231"
    security_group_ids = [
      yandex_vpc_security_group.prometheus_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Grafana
resource "yandex_compute_instance" "grafana" {
  name        = "grafana"
  hostname    = "grafana"
  platform_id = "standard-v2"
  zone        = "ru-central1-d"

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

  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-d.id
    nat        = true
    ip_address = "10.10.10.232"
    security_group_ids = [
      yandex_vpc_security_group.grafana_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Elasticsearch
resource "yandex_compute_instance" "elasticsearch" {
  name        = "elasticsearch"
  hostname    = "elasticsearch"
  platform_id = "standard-v2"
  zone        = "ru-central1-d"

  resources {
    cores         = var.srv.cores
    memory        = var.srv.memory
    core_fraction = var.srv.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 30
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-d.id
    nat        = false
    ip_address = "10.10.10.233"
    security_group_ids = [
      yandex_vpc_security_group.elasticsearch_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Kibana
resource "yandex_compute_instance" "kibana" {
  name        = "kibana"
  hostname    = "kibana"
  platform_id = "standard-v2"
  zone        = "ru-central1-d"

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

  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-d.id
    nat        = true
    ip_address = "10.10.10.234"
    security_group_ids = [
      yandex_vpc_security_group.kibana_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Файл hosts для Ansible
resource "local_file" "hosts_ans" {
  content = <<-EOT
    [all:vars]
    ansible_user=skv
    ansible_ssh_private_key_file="~/.ssh/id_cours_fops39_2025_ed25519"
    
    [alb]
    ${yandex_alb_load_balancer.alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address}
    
    [bastion]
    ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}
    
    [webservers]
    ${yandex_compute_instance.web-a.network_interface.0.ip_address} hostname=web-a
    ${yandex_compute_instance.web-b.network_interface.0.ip_address} hostname=web-b
    
    [webservers:vars]
    ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -o StrictHostKeyChecking=accept-new -W %h:%p skv@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'
    
    [monitoring]
    ${yandex_compute_instance.prometheus.network_interface.0.ip_address} hostname=prometheus
    ${yandex_compute_instance.grafana.network_interface.0.ip_address} hostname=grafana
    
    [monitoring:vars]
    ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -o StrictHostKeyChecking=accept-new -W %h:%p skv@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'
    
    [logging]
    ${yandex_compute_instance.elasticsearch.network_interface.0.ip_address} hostname=elasticsearch
    ${yandex_compute_instance.kibana.network_interface.0.ip_address} hostname=kibana
    
    [logging:vars]
    ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -o StrictHostKeyChecking=accept-new -W %h:%p skv@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'
  EOT

  filename = "./hosts.ini"
}
