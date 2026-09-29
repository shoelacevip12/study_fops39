resource "yandex_lb_target_group" "tg-k8s-master" {
  description = "Целевая группа для мастер-ноды k8s"
  name        = "tg-k8s-master"
  folder_id   = var.folder_id

  dynamic "target" {
    for_each = yandex_compute_instance_group.ins-gr_master.instances
    content {
      subnet_id = local.master_subnet_id # Та же подсеть, что и инстанс-группа мастера
      address   = target.value.network_interface[0].ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "nlb-k8s-master" {
  description         = "Network Load Balancer для доступа к мастер-ноде k8s (kubectl/ssh/grafana)"
  name                = "nlb-k8s-master"
  folder_id           = var.folder_id
  deletion_protection = false

  # lifecycle {
  #   ignore_changes = [listener]
  # }

  # Обработчик для kube-apiserver
  listener {
    name        = "listener-kube-api"
    port        = 6443 # внешний Порт балансировщика
    target_port = 6443 # kube-apiserver Порт на мастер-ноде
    protocol    = "tcp"

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # Обработчик для SSH
  listener {
    name        = "listener-ssh"
    port        = 22
    target_port = 22
    protocol    = "tcp"

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # Обработчик для Grafana NodePort
  listener {
    name        = "listener-grafana-nodeport"
    port        = 30080 # внешний порт балансировщика
    target_port = 30080 # NodePort сервиса grafana на мастер-ноде
    protocol    = "tcp"

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # Обработчик для frontend ts6-manager
  listener {
    name        = "listener-ts6-http"
    port        = 80     # внешний порт балансировщика
    target_port = 30082  # NodePort сервиса frontend
    protocol    = "tcp"

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # Обработчик для voice TeamSpeak 6
  listener {
    name        = "listener-ts6-voice"
    port        = 9987   # внешний порт балансировщика
    target_port = 30087  # NodePort сервиса teamspeak6 (voice)
    protocol    = "udp"
  
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # Обработчик для file transfer TeamSpeak 6
  listener {
    name        = "listener-ts6-file"
    port        = 30033  # внешний порт балансировщика
    target_port = 30033  # NodePort сервиса teamspeak6 (file transfer)
    protocol    = "tcp"

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # Подключение целевой группы и healthcheck
  attached_target_group {
    target_group_id = yandex_lb_target_group.tg-k8s-master.id

    healthcheck {
      name                = "tcp-health-check"
      interval            = 5
      timeout             = 3
      unhealthy_threshold = 3
      healthy_threshold   = 2

      tcp_options {
        port = 22 # Проверка доступности по ssh
      }
    }
  }

  depends_on = [yandex_compute_instance_group.ins-gr_master]
}