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
