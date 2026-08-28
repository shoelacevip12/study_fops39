resource "yandex_vpc_network" "skv" {
  description = "Сетевой блок VPC skv-fops40-${var.lab22_1}"
  name        = "skv-fops40-${var.lab22_1}"
}

resource "yandex_vpc_subnet" "public" {
  description    = "Подсеть с правом выхода в WAN"
  name           = "skv-fops-${var.lab22_1}-public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "private" {
  description    = "Подсеть Без права выхода в WAN напрямую"
  name           = "skv-fops-${var.lab22_1}-private"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.route.id
}

resource "yandex_vpc_gateway" "nat-gateway" {
  description = "NAT-шлюз для выхода в WAN из private подсети"
  name        = "fops-gateway-${var.lab22_1}"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "route" {
  description = "Таблица маршрутизации для skv-fops-${var.lab22_1}"
  name        = "fops-route-table-${var.lab22_1}"
  network_id  = yandex_vpc_network.skv.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat-gateway.id
  }
}