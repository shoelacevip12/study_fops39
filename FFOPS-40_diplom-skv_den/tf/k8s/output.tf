output "nlb_master_ip" {
  description = "Публичный IP Network Load Balancer"
  value       = local.master_nlb_ip
}

output "ansible_masters" {
  description = "Список мастер-нод для Ansible"
  value = [
    for instance in yandex_compute_instance_group.ins-gr_master.instances : {
      name = instance.name
      ip   = local.master_nlb_ip
    }
  ]
  depends_on = [yandex_lb_network_load_balancer.nlb-k8s-master]
}

output "ansible_workers" {
  description = "Список воркер-нод для Ansible"
  value = [
    for instance in yandex_compute_instance_group.ins-gr_workers.instances : {
      name = instance.name
      ip   = instance.network_interface[0].ip_address
    }
  ]
  depends_on = [yandex_compute_instance_group.ins-gr_workers]
}

output "ssh_user" {
  value       = "skv"
  description = "Пользователь SSH по умолчанию"
}


# Вывод инструкции по настройке SSH
output "ssh_config_instruction" {
  description = "Инструкция по добавлению настроек SSH для доступа к воркерам"
  value       = <<-EOT
    =========================================
    НАСТРОЙКА SSH ДЛЯ ДОСТУПА К WORKER-НОДАМ
    =========================================
    
    1. Файл с конфигурацией ssh создан здесь:
       ${pathexpand("~")}/.ssh/config_yc_k8s
    
    2. Добавить следующую строку в !НАЧАЛО! вашего ~/.ssh/config:
       Include ~/.ssh/config_yc_k8s
    
       ИЛИ скопируйте содержимое созданного файла вручную в ~/.ssh/config.

       cat ~/.ssh/config_yc_k8s | tee -a ~/.ssh/config

    3. Запуск Ansible:
       ansible all -m ping -i ../ansible/hosts.ini
    EOT
}