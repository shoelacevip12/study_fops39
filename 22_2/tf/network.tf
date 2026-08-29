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