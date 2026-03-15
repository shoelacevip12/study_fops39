resource "yandex_compute_disk" "dobavo4_disk" {
  count = var.disk_count["disk_add"].count
  name  = "${var.disk_count["disk_add"].name}-${count.index + 1}"
  type  = var.disk_count["disk_add"].type
  size  = var.disk_count["disk_add"].size
}

resource "yandex_compute_instance" "storage" {
  name        = var.vm_storage
  platform_id = var.vms_resources["vm_web"].platform_id
  resources {
    cores         = var.vms_resources["vm_web"].cores
    memory        = var.vms_resources["vm_web"].memory
    core_fraction = var.vms_resources["vm_web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vms_resources["vm_web"].preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vms_resources["vm_web"].nat
    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }

  metadata = var.vms_ssh

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.dobavo4_disk
    content {
      disk_id = secondary_disk.value.id
    }
  }
}
