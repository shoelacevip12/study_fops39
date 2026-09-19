resource "yandex_kms_symmetric_key" "sym-kms" {
  default_algorithm = "AES_256"
  description       = "Создание симметричного ключа"
  folder_id         = var.folder_id
  name              = var.symmetric_key_name
  rotation_period   = ""
}
