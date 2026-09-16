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

  # === ДАННЫЕ ДЛЯ ANSIBLE ===
  nlb_listeners      = [for l in yandex_lb_network_load_balancer.nlb-k8s-master.listener : l]
  kube_api_listener  = length(local.nlb_listeners) > 0 ? local.nlb_listeners[0] : null
  external_addresses = local.kube_api_listener != null ? [for e in local.kube_api_listener.external_address_spec : e.address] : []
  master_nlb_ip      = length(local.external_addresses) > 0 ? local.external_addresses[0] : ""

  # Путь к приватному ключу
  private_ssh_key_path = replace(var.ssh_key_file, ".pub", "")
}

locals {
  # Путь к домашней директории пользователя
  home_dir = pathexpand("~")

  # Полный путь к файлу конфигурации SSH
  ssh_config_fragment_path = "${local.home_dir}/.ssh/config_yc_k8s"

  # Приватный ключ (без .pub)
  private_key_path = replace(var.ssh_key_file, ".pub", "")
  # Раскрытие тильду в пути к ключу для файла конфига
  resolved_key_path = startswith(local.private_key_path, "~") ? "${local.home_dir}${substr(local.private_key_path, 1, -1)}" : local.private_key_path
}