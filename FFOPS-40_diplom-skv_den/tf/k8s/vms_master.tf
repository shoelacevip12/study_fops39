resource "yandex_compute_instance_group" "ins-gr_master" {
  name = var.master_group_name_prefix
  
  # Политика масштабирования 1 нода
  scale_policy {
    fixed_scale {
      size = var.master_scale_policy_size
    }
  }

  folder_id           = var.folder_id
  service_account_id  = local.sa_id
  deletion_protection = false

  # Политика размещения - только зона мастера
  allocation_policy {
    zones = local.master_zones
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
    hostname    = "master-node" # Фиксированное имя

    resources {
      cores         = var.master_host.cores
      memory        = var.master_host.memory
      core_fraction = var.master_host.core_fraction
      gpus          = 0
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
      network_id         = local.network_id
      subnet_ids         = [local.master_subnet_id]
      security_group_ids = [local.network_output.master_sg_id]
      nat                = false
    }
  }
}
