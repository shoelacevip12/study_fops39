#Общая облачная сеть yandex
resource "yandex_vpc_network" "skv" {
  name = "skv-fops39-${var.dz}"
}

#Подсеть zone A
resource "yandex_vpc_subnet" "skv_a" {
  name           = "skv-fops-${var.dz}-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["10.10.10.0/28"]
  route_table_id = yandex_vpc_route_table.route.id
}

# #Подсеть zone B
# resource "yandex_vpc_subnet" "skv_b" {
#   name           = "skv-fops-${var.dz}-ru-central1-b"
#   zone           = "ru-central1-b"
#   network_id     = yandex_vpc_network.skv.id
#   v4_cidr_blocks = ["10.10.10.16/28"]
#   route_table_id = yandex_vpc_route_table.route.id
# }

# #Подсеть zone D
# resource "yandex_vpc_subnet" "skv_d" {
#   name           = "skv-fops-${var.dz}-ru-central1-d"
#   zone           = "ru-central1-d"
#   network_id     = yandex_vpc_network.skv.id
#   v4_cidr_blocks = ["10.10.10.32/28"]
#   route_table_id = yandex_vpc_route_table.route.id
# }

#Сеть под NAT
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "fops-gateway-${var.dz}"
  shared_egress_gateway {}
}

#Шлюз для выхода в WAN
resource "yandex_vpc_route_table" "route" {
  name       = "fops-route-table-${var.dz}"
  network_id = yandex_vpc_network.skv.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

##Правила NAT
#Разрешаем Всем Входящие соединения по 22 порту по протоколу TCP, необходимо для proxy-jump до сети 10.10.10.0/26
#Разрешаем Всем входящие соединения по протоколу TCP по 80,443 портам
#Разрешаем Всем входящие соединения по протоколу TCP по 10051
resource "yandex_vpc_security_group" "zab-serv" {
  name       = "zab-serv-${var.dz}"
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
    description    = "Allow zabbix-agent"
    protocol       = "TCP"
    port           = 10051
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # egress {
  #   description    = "Permit ANY"
  #   protocol       = "ANY"
  #   v4_cidr_blocks = ["10.10.10.0/26"]
  #   from_port      = 0
  #   to_port        = 65535
  # }
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
#Разрешаем входящие из-под сети 10.10.10.0/26 по TCP Протоколу до порта 5432
#Разрешаем входящие из-под сети 10.10.10.0/26 по TCP Протоколу до порта 10050
resource "yandex_vpc_security_group" "host_db" {
  name       = "host-db${var.dz}"
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

  # ingress {
  #   description    = "Allow PostgreSQL"
  #   protocol       = "TCP"
  #   port           = 5432
  #   v4_cidr_blocks = ["0.0.0.0/0"]
  #}

  ingress {
    description    = "Allow zabbix-agent"
    protocol       = "TCP"
    port           = 10050
    v4_cidr_blocks = ["10.10.10.0/26"]
  }
}