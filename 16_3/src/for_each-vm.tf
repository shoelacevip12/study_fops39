/* 
Перевод list(object в map(object и обозначаем в locals
Ассоциируем оператором "=>"
vm_name как map-ключ "i.vm_name"
с присвоением значением для "i"
дальнейшее обращение для for_each loop через local
*/
locals {
  to_map = { for i in var.each_vm : i.vm_name => i }
}

data "yandex_compute_image" "ubuntu_2404_lts" {
  for_each = local.to_map
  family   = each.value.family
}

# Создание ВМ for_each loop методом
resource "yandex_compute_instance" "db_vm" {
  for_each = local.to_map

  name        = each.value.vm_name
  platform_id = each.value.platform_id

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts[each.key].image_id
      type     = each.value.type
      size     = each.value.disk_volume
    }
  }

  scheduling_policy {
    preemptible = each.value.preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = each.value.nat
    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }

  metadata = var.vms_ssh
}
