
resource "yandex_iam_service_account" "sa-storage-access" {
  folder_id   = var.folder_id
  name        = "sa-storage-access"
  description = "Service account для доступа к Object Storage"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_storage_editor" {
  # Сервисному аккаунту назначается роль "storage.editor".
  folder_id  = var.folder_id
  role       = "storage.editor"
  member     = "serviceAccount:${yandex_iam_service_account.sa-storage-access.id}"
  depends_on = [yandex_iam_service_account.sa-storage-access]
}

resource "yandex_resourcemanager_folder_iam_binding" "vpc-public-admin" {
  # Сервисному аккаунту назначается роль "vpc.publicAdmin".
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-storage-access.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-storage-access.id}"
  ]
}

resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
  service_account_id = yandex_iam_service_account.sa-storage-access.id
  description        = "Static access key для доступа к Object Storage"
  pgp_key            = var.pgp_key_base64
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
output "service_account_id" {
  description = "ID созданного Service Account"
  value       = yandex_iam_service_account.sa-storage-access.id
}