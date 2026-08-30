resource "yandex_storage_bucket" "s3_buck_den_skv_fops40" {
  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.sym-kms.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  bucket                  = var.bucket_name_chipher
  default_storage_class   = "STANDARD"
  disabled_statickey_auth = false
  max_size                = 1073741824
  versioning {
    enabled = false
  }

  depends_on = [yandex_kms_symmetric_key.sym-kms]

}

# Загрузка файла в зашифрованный S3 бакет с локального диска
resource "yandex_storage_object" "files-pic" {
  bucket       = yandex_storage_bucket.s3_buck_den_skv_fops40.id
  key          = "files/share_shdevops.png"
  source       = "${path.module}/files/share_shdevops.png"
  content_type = "image/png"
  acl          = "public-read"
  depends_on   = [yandex_storage_bucket.s3_buck_den_skv_fops40]
}

resource "yandex_storage_bucket" "s3_buck_den_skv_html" {
  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }

  website {
    index_document = "index.html"
  }

  bucket                  = var.bucket_name_html
  default_storage_class   = "STANDARD"
  disabled_statickey_auth = false
  max_size                = 1073741824
  versioning {
    enabled = false
  }

  https {
    certificate_id = yandex_cm_certificate.le-cert.id
  }

}

# Загрузка файла в S3 бакет с локального диска
resource "yandex_storage_object" "files-pic-non-chip" {
  bucket       = yandex_storage_bucket.s3_buck_den_skv_html.id
  key          = "files/share_shdevops.png"
  source       = "${path.module}/files/share_shdevops.png"
  content_type = "image/png"
  acl          = "public-read"
  depends_on   = [yandex_storage_bucket.s3_buck_den_skv_html]
}

# Загрузка html-файла в S3 бакет с локального диска
resource "yandex_storage_object" "files-html" {
  bucket       = yandex_storage_bucket.s3_buck_den_skv_html.id
  key          = "index.html"
  source       = "${path.module}/files/index.html"
  content_type = "text/html"
  acl          = "public-read"
  depends_on   = [yandex_storage_bucket.s3_buck_den_skv_html]
}
