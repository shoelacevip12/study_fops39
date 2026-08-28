//
// Создание нового IAM Service Account (SA).
//
resource "yandex_iam_service_account" "admin" {
  name        = "servacca2"
  description = "service account to manage VMs"
  folder_id = "b1g9l0vgsvf6cegkvj1c"
}
