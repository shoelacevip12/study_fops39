resource "yandex_vpc_network" "network-main" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "subnet-main" {
  for_each = {
    for k, v in local.subnet_array : "${v.name}" => v
  }
  network_id = yandex_vpc_network.network-main.id
  v4_cidr_blocks = each.value.cidr
  zone           = each.value.zone
  name           = each.value.name
}

resource "yandex_vpc_address" "public_addr" {
  for_each = {
    for v in local.external_ips_array : "${v.name}" => v
  }
  name = each.value.name
  external_ipv4_address {
    zone_id = each.value.zone
  }
}