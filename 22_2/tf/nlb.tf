resource "yandex_lb_target_group" "tg-ins-gr" {
  description = "Создание Целевой группы"
  name        = "tg-ins-gr"
  folder_id   = var.folder_id

  dynamic "target" {
    for_each = yandex_compute_instance_group.ins-gr.instances
    content {
      subnet_id = yandex_vpc_subnet.public.id # Используется та же подсеть, что и инстанс-группа
      address   = target.value.network_interface[0].ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "nlb-public" {
  description         = "создание Network Load Balancer"
  name                = "nlb-public"
  folder_id           = var.folder_id
  deletion_protection = false

  # Обработчик входящего трафика
  listener {
    name        = "http-listener"
    port        = 80 # Порт балансировщика (внешний)
    target_port = 80 # Порт на виртуальных машинах
    protocol    = "tcp"

    # Автоматическое назначение Внешний IPv4 адреса
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  listener {
    name        = "listener-https"
    port        = 443
    protocol    = "tcp"
    target_port = 443
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  listener {
    name        = "listener-ssh"
    port        = 22
    protocol    = "tcp"
    target_port = 22
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # Подключение целевой группы и healthcheck
  attached_target_group {
    target_group_id = yandex_lb_target_group.tg-ins-gr.id

    healthcheck {
      name                = "http-health-check"
      interval            = 5
      timeout             = 3
      unhealthy_threshold = 3
      healthy_threshold   = 2

      http_options {
        port = 80  # Порт для проверки на ВМ
        path = "/" # Путь для HTTP проверки
      }
    }
  }

  depends_on = [yandex_compute_instance_group.ins-gr]
}