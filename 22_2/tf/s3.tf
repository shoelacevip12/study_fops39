resource "yandex_storage_bucket" "s3_buck_den_skv_fops40" {
  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }
  bucket                  = var.bucket_name
  default_storage_class   = "STANDARD"
  disabled_statickey_auth = false
  max_size                = 1073741824
  versioning {
    enabled = false
  }
}

# Загрузка файла в S3 бакет с локального диска
resource "yandex_storage_object" "picture" {
  bucket       = yandex_storage_bucket.s3_buck_den_skv_fops40.id
  key          = "image/share_shdevops.png"
  source       = "${path.module}/image/share_shdevops.png"
  content_type = "image/png"
  acl          = "public-read"
  depends_on   = [yandex_storage_bucket.s3_buck_den_skv_fops40]
}