resource "yandex_storage_bucket" "tfstate" {
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
