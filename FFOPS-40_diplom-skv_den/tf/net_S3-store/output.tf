output "service_account_id" {
  description = "ID созданного Service Account"
  value       = yandex_iam_service_account.sa-storage-access.id
}

output "access_key_id" {
  description = "ID статического ключа доступа к Object Storage"
  value       = yandex_iam_service_account_static_access_key.sa_static_key.access_key
}
output "encrypted_secret_key" {
  description = "Кодированный PGP secret key. Для раскодировки: echo <value> | base64 -d | gpg2 --decrypt"
  value       = yandex_iam_service_account_static_access_key.sa_static_key.encrypted_secret_key
}
output "key_fingerprint" {
  description = "Fingerprint PGP-ключа, использованного для шифрования"
  value       = yandex_iam_service_account_static_access_key.sa_static_key.key_fingerprint
}

output "static_access_key_id" {
  value = yandex_iam_service_account_static_access_key.sa_static_key.id
}


output "network_id" {
  value = yandex_vpc_network.skv-net.id
}

output "k8s_workers_subnet_info" {
  description = "Информация о подсетях рабочих нод (zone и id)"
  value = [
    {
      zone      = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet-main["k8s_worker_zone_a"].id
    },
    {
      zone      = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.subnet-main["k8s_worker_zone_b"].id
    },
    {
      zone      = "ru-central1-d"
      subnet_id = yandex_vpc_subnet.subnet-main["k8s_worker_zone_d"].id
    }
  ]
}

output "worker_sg_id" {
  description = "ID группы безопасности для рабочих нод k8s"
  value       = yandex_vpc_security_group.k8s_worker.id
}