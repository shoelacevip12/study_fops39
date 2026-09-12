output "access_key_id" {
  description = "ID статического ключа доступа к Object Storage"
  value       = yandex_iam_service_account_static_access_key.sa_static_key.access_key
}
# output "encrypted_secret_key" {
#   description = "Кодированный PGP secret key. Для раскодировки: echo <value> | base64 -d | gpg2 --decrypt"
#   value       = yandex_iam_service_account_static_access_key.sa_static_key.encrypted_secret_key
# }
output "key_fingerprint" {
  description = "Fingerprint PGP-ключа, использованного для шифрования"
  value       = yandex_iam_service_account_static_access_key.sa_static_key.key_fingerprint
}
output "service_account_id" {
  description = "ID созданного Service Account"
  value       = yandex_iam_service_account.sa-storage-access.id
}