##Правила NAT
#Разрешаем Всем Входящие соединения по 22 порту по протоколу TCP, необходимо для proxy-jump до сети 10.10.10.0/26
#Разрешаем Всем входящие соединения по протоколу TCP по 80,443 портам
#Разрешаем Всем входящие соединения по протоколу TCP по 3000
resource "yandex_vpc_security_group" "prom-core" {
  name       = "prom-core-${var.dz}"
  network_id = yandex_vpc_network.skv.id
  ingress {
    description    = "Allow 0.0.0.0/0"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Grafana веб UI"
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow Prometheus"
    protocol       = "TCP"
    port           = 9090
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Node Exporter"
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#Разрешаем всем из-под внутренних подсетей zone A,B,D выход на любые ресурсы по любому протоколу
resource "yandex_vpc_security_group" "LAN" {
  name       = "LAN-${var.dz}"
  network_id = yandex_vpc_network.skv.id
  ingress {
    description    = "Allow 10.10.10.0/26"
    protocol       = "ANY"
    v4_cidr_blocks = ["10.10.10.0/26"]
    from_port      = 0
    to_port        = 65535
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}

#Разрешаем любые входящие соединения по протоколу TCP по 80,443 портам
#Разрешаем входящие из-под сети 10.10.10.0/26 по TCP Протоколу до порта 9090
#Разрешаем входящие из-под сети 10.10.10.0/26 по TCP Протоколу до порта 9100
resource "yandex_vpc_security_group" "nod_gra" {
  name       = "nod_gra-${var.dz}"
  network_id = yandex_vpc_network.skv.id


  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description    = "Allow Prometheus"
    protocol       = "TCP"
    port           = 9090
    v4_cidr_blocks = ["10.10.10.0/26"]
  }

  ingress {
    description    = "Node Exporter"
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.10.10.0/26"]
  }
}
