# Общая облачная сеть
resource "yandex_vpc_network" "skv" {
  name = "skv-fops39-${var.cours-w-skv}"
}

# Подсеть zone A
resource "yandex_vpc_subnet" "skv-locnet-a" {
  name           = "skv-fops-${var.cours-w-skv}-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["10.10.10.192/28"]
  route_table_id = yandex_vpc_route_table.route.id
}

# Подсеть zone B
resource "yandex_vpc_subnet" "skv-locnet-b" {
  name           = "skv-fops-${var.cours-w-skv}-ru-central1-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["10.10.10.208/28"]
  route_table_id = yandex_vpc_route_table.route.id
}

# Подсеть zone D
resource "yandex_vpc_subnet" "skv-locnet-d" {
  name           = "skv-fops-${var.cours-w-skv}-ru-central1-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["10.10.10.224/28"]
  route_table_id = yandex_vpc_route_table.route.id
}

# Сеть под NAT для исходящего трафика
resource "yandex_vpc_gateway" "nat-gateway" {
  name = "fops-gateway-${var.cours-w-skv}"
  shared_egress_gateway {}
}

# Шлюз для выхода в WAN
resource "yandex_vpc_route_table" "route" {
  name       = "fops-route-table-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat-gateway.id
  }
}