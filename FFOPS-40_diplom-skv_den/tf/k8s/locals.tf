locals {
  # Все output из состояния tfstate network
  network_output = data.terraform_remote_state.network.outputs

  # Карту подсетей: Zone -> SubnetID
  worker_subnet_list = zipmap(
    [for subnet in local.network_output.k8s_workers_subnet_info : subnet.zone], 
    [for subnet in local.network_output.k8s_workers_subnet_info : subnet.subnet_id]
  )

  # ID сервисного аккаунта напрямую из outputs tfstate network
  sa_id = local.network_output.service_account_id
  
  # При необходимости получить и ключи доступа из tfstate network
  # sa_access_key = local.network_output.access_key_id
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

