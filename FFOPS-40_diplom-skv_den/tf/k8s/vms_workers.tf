resource "yandex_compute_instance_group" "ins-gr_workers" {
  name =  var.group_name_prefix
  
  # Политика масштабирования
  scale_policy {
    fixed_scale {
      size = var.scale_policy_size
    }
  }

  folder_id           = var.folder_id
  service_account_id  = local.sa_id # Берем из remote state
  deletion_protection = false

  # Политика размещения: используем зоны из tfstate network
  allocation_policy {
    zones = local.worker_zones
  }

  deploy_policy {
    max_creating     = var.deploy_pol.max_creating
    max_deleting     = var.deploy_pol.max_deleting
    max_unavailable  = var.deploy_pol.max_unavailable
    max_expansion    = var.deploy_pol.max_expansion
    startup_duration = var.deploy_pol.startup_duration
    strategy         = var.deploy_pol.strategy
  }

  instance_template {
    platform_id = var.platform_id
    hostname    = "worker-{instance.index}"

    resources {
      cores         = var.host.cores
      memory        = var.host.memory
      core_fraction = var.host.core_fraction
      gpus          = var.host.gpus
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.debian-13.image_id
        type     = var.disk.type
        size     = var.disk.size
      }
    }

    metadata = local.common_metadata

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      network_id = local.network_id
      subnet_ids = values(local.worker_subnet_list)
      security_group_ids = [local.network_output.worker_sg_id]
      nat = false
    }
  }
}