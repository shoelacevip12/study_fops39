terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoints = {
      s3 = var.s3.endpoints[0]
    }
    bucket     = var.s3.bucket
    region     = var.s3.region
    key        = var.s3.key
    shared_credentials_file = var.s3.shared_credentials_file

    skip_region_validation      = var.s3.skip_region_validation
    skip_credentials_validation = var.s3.skip_credentials_validation
  }
}

provider "yandex" {
  service_account_key_file = file("~/.authorized_key.json")
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
}
