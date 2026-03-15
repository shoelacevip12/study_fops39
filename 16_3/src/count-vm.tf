data "yandex_compute_image" "ubuntu" {
  family = var.vms_resources["vm_web"].family
}
resource "yandex_compute_instance" "web" {
  count       = var.vms_resources["vm_web"].count
  name        = "${var.vms_resources["vm_web"].name}-${count.index + 1}"
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

}
