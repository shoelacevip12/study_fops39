data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = var.network_bucket_name
    region = "ru-central1"
    key    = var.network_state_key

    shared_credentials_files = ["~/.sa_storage.key"]

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
  }
}

data "yandex_compute_image" "debian-13" {
  family = var.vm_image_family
}