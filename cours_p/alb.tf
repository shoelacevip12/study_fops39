# Целевая группа для веб-серверов
resource "yandex_alb_target_group" "web_tg" {
  name = "web-tg-${var.cours-w-skv}"

  target {
    subnet_id  = yandex_vpc_subnet.skv-locnet-a.id
    ip_address = "10.10.10.201" # Nginx-web1 в зоне А
  }

  target {
    subnet_id  = yandex_vpc_subnet.skv-locnet-b.id
    ip_address = "10.10.10.211" # Nginx-web2 в зоне Б
  }
}

# Группа бэкендов для ALB
resource "yandex_alb_backend_group" "web_bg" {
  name = "web-bg-${var.cours-w-skv}"

  http_backend {
    name             = "web-backend"
    weight           = 100
    port             = 80
    target_group_ids = [yandex_alb_target_group.web_tg.id]

    healthcheck {
      timeout             = "2s"
      interval            = "5s"
      healthy_threshold   = 2
      unhealthy_threshold = 2
      healthcheck_port    = 80

      http_healthcheck {
        path = "/"
      }
    }
  }
}

# HTTP роутер
resource "yandex_alb_http_router" "web_router" {
  name = "web-router-${var.cours-w-skv}"
  labels = {
    env = var.cours-w-skv
  }
}

# Виртуальный хост для HTTP роутера
resource "yandex_alb_virtual_host" "web_host" {
  name           = "web-host-${var.cours-w-skv}"
  http_router_id = yandex_alb_http_router.web_router.id
  authority      = ["*"]

  route {
    name = "default-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web_bg.id
      }
    }
  }
}

# Application Load Balancer (alb)
resource "yandex_alb_load_balancer" "alb" {
  name        = "alb-${var.cours-w-skv}"
  description = "ALB для распределения трафика на веб-серверы"
  labels = {
    env = var.cours-w-skv
  }

  network_id = yandex_vpc_network.skv.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.skv-locnet-a.id
    }
    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.skv-locnet-b.id
    }
  }

  listener {
    name = "http-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80, 443]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web_router.id
      }
    }
  }

  security_group_ids = [
    yandex_vpc_security_group.alb_sg.id
  ]

  # Явное указание зависимостей для порядка создания
  depends_on = [
    yandex_vpc_security_group.alb_sg,
    yandex_vpc_security_group.web_sg,
    yandex_alb_backend_group.web_bg,
    yandex_alb_target_group.web_tg
  ]
}