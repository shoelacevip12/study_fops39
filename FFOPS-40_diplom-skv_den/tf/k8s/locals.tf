locals {
  # Все output из состояния tfstate network
  network_output = data.terraform_remote_state.network.outputs

  # Карту подсетей: Zone -> SubnetID (для воркеров)
  worker_subnet_list = zipmap(
    [for subnet in local.network_output.k8s_workers_subnet_info : subnet.zone], 
    [for subnet in local.network_output.k8s_workers_subnet_info : subnet.subnet_id]
  )

  # ID сервисного аккаунта напрямую из outputs tfstate network
  sa_id = local.network_output.service_account_id
  
  # Информация о подсети мастера (из новых output)
  master_subnet_id   = local.network_output.k8s_master_subnet_info.subnet_id
  master_zone        = local.network_output.k8s_master_subnet_info.zone
  
  # Список зон для мастера (всего одна зона)
  master_zones       = [local.master_zone]
}

locals {
  description = "Указание метаданных через locals до ssh ключа"
  common_metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
    ssh-keys           = "skv:${file(var.ssh_key_file)}"
  }
}

locals {
  worker_zones = [for subnet in local.network_output.k8s_workers_subnet_info : subnet.zone]
  security_group_ids = []
  network_id = local.network_output.network_id
}