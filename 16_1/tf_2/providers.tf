terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "<зона_доступности_по_умолчанию>"
}

provider "docker" {
  host     = "ssh://skv@${yandex_compute_instance.docker-host.network_interface.0.nat_ip_address}"
  ssh_opts = ["-o", "StrictHostKeyChecking=accept-new", "-i", "~/.ssh/id_lab16_1_fops39_ed25519"]
}
