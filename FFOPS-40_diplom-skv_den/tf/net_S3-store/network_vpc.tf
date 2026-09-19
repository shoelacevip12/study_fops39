resource "yandex_vpc_network" "skv-net" {
  name = var.network_name
}

resource "yandex_vpc_gateway" "nat-gateway" {
  description = "NAT-шлюз для выхода в WAN из подсетей"
  name        = var.nat_gateway_name
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "route" {
  description = "Таблица маршрутизации для skv-net"
  name        = var.route_table_name
  network_id  = yandex_vpc_network.skv-net.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat-gateway.id
  }
}

resource "yandex_vpc_subnet" "subnet-main" {
  for_each = {
    for k, v in local.subnet_array : "${v.name}" => v
  }
  network_id     = yandex_vpc_network.skv-net.id
  v4_cidr_blocks = each.value.cidr
  zone           = each.value.zone
  name           = each.value.name
  route_table_id = yandex_vpc_route_table.route.id
}