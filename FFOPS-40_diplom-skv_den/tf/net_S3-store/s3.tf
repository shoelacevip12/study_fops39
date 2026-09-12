resource "yandex_storage_bucket" "tfstate" {
  anonymous_access_flags {
    read        = false
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

  bucket                  = var.bucket_name_chipher.bucket
  default_storage_class   = var.bucket_name_chipher.default_storage_class
  disabled_statickey_auth = var.bucket_name_chipher.disabled_statickey_auth
  max_size                = var.bucket_name_chipher.max_size
  versioning {
    enabled = var.bucket_name_chipher.versioning
  }

  depends_on = [yandex_kms_symmetric_key.sym-kms]

}
