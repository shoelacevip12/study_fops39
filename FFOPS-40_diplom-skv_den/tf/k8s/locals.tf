locals {
  # === ДАННЫЕ ИЗ Remote State ===
  network_output = data.terraform_remote_state.network.outputs

  # Карта подсетей воркеров: Zone -> SubnetID
  worker_subnet_list = zipmap(
    [for subnet in local.network_output.k8s_workers_subnet_info : subnet.zone],
    [for subnet in local.network_output.k8s_workers_subnet_info : subnet.subnet_id]
  )

  # Список зон воркеров
  worker_zones = [for subnet in local.network_output.k8s_workers_subnet_info : subnet.zone]

  # ID сервисного аккаунта
  sa_id = local.network_output.service_account_id

  # ID сети
  network_id = local.network_output.network_id

  # === ДАННЫЕ ДЛЯ МАСТЕР-НОДЫ ===
  master_subnet_id = local.network_output.k8s_master_subnet_info.subnet_id
  master_zone      = local.network_output.k8s_master_subnet_info.zone
  master_zones     = [local.master_zone]

  # === РАБОТА С SSH КЛЮЧОМ И CLOUD-INIT ===
  # Чтение публичного ключа из файла
  ssh_public_key = file(pathexpand(var.ssh_key_file))

  # Генерация cloud-init из шаблона с подстановкой ключа
  user_data_content = templatefile("${path.module}/cloud-init.tmpl", {
    ssh_public_key = local.ssh_public_key
  })

  # Формирование финальных метаданных для ВМ
  common_metadata = {
    user-data          = local.user_data_content
    serial-port-enable = "1"
    ssh-keys           = "skv:${local.ssh_public_key}"
  }
}