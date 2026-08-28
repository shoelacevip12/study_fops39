# Общая облачная сеть (пустая VPC)
resource "yandex_vpc_network" "skv" {
  name = "skv-fops40-${var.lab22_1}"
}

# Публичная подсеть
resource "yandex_vpc_subnet" "public" {
  name           = "skv-fops-${var.lab22_1}-public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Приватная подсеть (весь исходящий трафик направляется в NAT-инстанс)
resource "yandex_vpc_subnet" "private" {
  name           = "skv-fops-${var.lab22_1}-private"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.route.id
}

# Route table: статический маршрут всего исходящего трафика private сети в NAT-инстанс
resource "yandex_vpc_route_table" "route" {
  name       = "fops-route-table-${var.lab22_1}"
  network_id = yandex_vpc_network.skv.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}