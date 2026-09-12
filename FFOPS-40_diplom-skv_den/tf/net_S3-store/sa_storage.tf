
resource "yandex_iam_service_account" "sa-storage-access" {
  folder_id   = var.folder_id
  name        = "sa-storage-access"
  description = "Service account для доступа к Object Storage"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_storage_editor" {
  # Сервисному аккаунту назначается роль "storage.admin".
  folder_id  = var.folder_id
  role       = "storage.admin"
  member     = "serviceAccount:${yandex_iam_service_account.sa-storage-access.id}"
  depends_on = [yandex_iam_service_account.sa-storage-access]
}

resource "yandex_resourcemanager_folder_iam_member" "sa_encrypterDecrypter" {
  /*
Сервисному аккаунту назначается роль "kms.keys.encrypterDecrypter".

KMS_ID=abjbpu5tk0dfbcfceku2
SA_ID=ajevuvi14s54jikil9m0

yc kms symmetric-key add-access-binding "$KMS_ID" \
--role kms.keys.encrypterDecrypter \
--service-account-id "$SA_ID"
*/
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa-storage-access.id}"
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
