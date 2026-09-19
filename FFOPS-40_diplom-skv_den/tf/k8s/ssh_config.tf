resource "local_file" "ssh_config_fragment" {
  content = <<-EOT
# Сгенерировано Terraform для кластера K8s YC
# Дата генерации: ${timestamp()}

Host bastion-k8s-${var.folder_id}
    HostName ${local.master_nlb_ip}
    User skv
    IdentityFile ${local.resolved_key_path}
    StrictHostKeyChecking accept-new
    IdentitiesOnly yes

# Шаблон для всех воркеров в приватной подсети 10.10.10.0/24
Host 10.10.10.*
    ProxyJump bastion-k8s-${var.folder_id}
    User skv
    IdentityFile ${local.resolved_key_path}
    StrictHostKeyChecking accept-new
    IdentitiesOnly yes
  EOT

  filename        = local.ssh_config_fragment_path
  file_permission = "0600"
}