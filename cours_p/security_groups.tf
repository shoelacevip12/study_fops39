# Security Group для LAN (внутреннее взаимодействие между сервисами)
resource "yandex_vpc_security_group" "LAN" {
  name       = "LAN-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить весь трафик из внутренней сети"
    protocol       = "ANY"
    v4_cidr_blocks = ["10.10.10.192/26"]
    from_port      = 0
    to_port        = 65535
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Security Group для Bastion Host (только SSH с перенаправлением порта)
resource "yandex_vpc_security_group" "bastion_sg" {
  name       = "bastion-sg-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить SSH доступ из интернета на порт 2225"
    protocol       = "TCP"
    port           = 2225
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Разрешить SSH доступ из интернета на порт 22"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Security Group для веб-серверов
resource "yandex_vpc_security_group" "web_sg" {
  name       = "web-sg-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить HTTP трафик из ALB"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["10.10.10.192/26", "198.18.235.0/24", "198.18.248.0/24"]
  }

  ingress {
    description    = "Разрешить HTTPS трафик из ALB"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["10.10.10.192/26", "198.18.235.0/24", "198.18.248.0/24"]
  }

  ingress {
    description       = "Разрешить SSH доступ только с bastion host"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Security Group для Prometheus
resource "yandex_vpc_security_group" "prometheus_sg" {
  name       = "prometheus-sg-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить доступ к Prometheus из Grafana"
    protocol       = "TCP"
    port           = 9090
    v4_cidr_blocks = ["10.10.10.192/26"]
  }

  ingress {
    description       = "Разрешить SSH доступ только с bastion host"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Разрешить сбор метрик с веб-серверов"
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.10.10.192/26"]
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Security Group для Grafana (публичный доступ на порт 3000)
resource "yandex_vpc_security_group" "grafana_sg" {
  name       = "grafana-sg-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description       = "Разрешить доступ к Grafana только с bastion host"
    protocol          = "TCP"
    port              = 3000
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  ingress {
    description       = "Разрешить SSH доступ только с bastion host"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Разрешить доступ к Prometheus"
    protocol       = "TCP"
    port           = 9090
    v4_cidr_blocks = ["10.10.10.192/26"]
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Security Group для Elasticsearch
resource "yandex_vpc_security_group" "elasticsearch_sg" {
  name       = "elasticsearch-sg-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить доступ к Elasticsearch из Kibana и веб-серверов"
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["10.10.10.192/26"]
  }

  ingress {
    description       = "Разрешить SSH доступ только с bastion host"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Security Group для Kibana (публичный доступ на порт 5601)
resource "yandex_vpc_security_group" "kibana_sg" {
  name       = "kibana-sg-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description       = "Разрешить доступ к Kibana только с bastion host"
    protocol          = "TCP"
    port              = 5601
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  ingress {
    description       = "Разрешить SSH доступ только с bastion host"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Разрешить доступ к Elasticsearch"
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["10.10.10.192/26"]
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Security Group для ALB (Application Load Balancer) - ПОЛНОСТЬЮ ИСПРАВЛЕНА
resource "yandex_vpc_security_group" "alb_sg" {
  name       = "alb-sg-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  # Разрешить HTTP трафик из интернета
  ingress {
    description    = "Разрешить HTTP трафик из интернета"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Разрешить HTTPS трафик из интернета
  ingress {
    description    = "Разрешить HTTPS трафик из интернета"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Разрешить health checks для HTTP
  ingress {
    description    = "Разрешить health checks от Yandex ALB (HTTP)"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
  }

  # Разрешить health checks для HTTPS
  ingress {
    description    = "Разрешить health checks от Yandex ALB (HTTPS)"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
  }

  # Разрешить health checks для ICMP (ping)
  ingress {
    description    = "Разрешить ICMP health checks от Yandex ALB"
    protocol       = "ICMP"
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
  }

  # Разрешить health checks на все порты (рекомендуется Yandex)
  ingress {
    description    = "Разрешить все health checks от Yandex ALB"
    protocol       = "ANY"
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
    from_port      = 0
    to_port        = 65535
  }

  # Разрешить исходящий трафик к веб-серверам на HTTP
  egress {
    description    = "Разрешить трафик к веб-серверам (HTTP)"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["10.10.10.192/26"]
  }

  # Разрешить исходящий трафик к веб-серверам на HTTPS
  egress {
    description    = "Разрешить трафик к веб-серверам (HTTPS)"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["10.10.10.192/26"]
  }
}