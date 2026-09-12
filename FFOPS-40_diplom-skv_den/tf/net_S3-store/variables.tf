#=========== providers_backend-S3 ==============
variable "cloud_id" {
  description = "ID облака"
  type        = string
}
variable "folder_id" {
  description = "The folder ID"
  type        = string
}
variable "default_zone" {
  description = "Зона размещения по умолчанию"
  type        = string
}

#=========== sa_storage ==============

variable "pgp_key_base64" {
  description = "Публичный PGP-ключ в base64"
  type        = string
  sensitive   = true
}

#=========== s3 ==============
variable "bucket_name_chipher" {
  description = "Имя S3 бакета"
  type        = string
}

#=========== kms ==============
variable "symmetric_key_name" {
  description = "имя yandex_kms_symmetric_key"
  type        = string
}

#=========== network_vpc ==============
variable "network_name" {
  description = "наименование созданной сети"
  type        = string
}

#=========== network_subnet ==============
variable "subnets" {
  description = "подсети для k8s"

  type = map(list(object(
    {
      name = string,
      zone = string,
      cidr = list(string)
    }))
  )

  validation {
    condition     = alltrue([for i in keys(var.subnets) : alltrue([for j in lookup(var.subnets, i) : contains(["ru-central1-a", "ru-central1-b", "ru-central1-d"], j.zone)])])
    error_message = "Ошибка! Зоны не доступны!"
  }
}

#=========== network_external_ipv4_address ==============
variable "external_static_ips" {
  description = "static ips"

  type = map(list(object(
    {
      name = string,
      zone = string
    }))
  )
}

#=========== security_group ==============
variable "white_ips_access_to_master" {
  description = "Ip с доступом до мастера"
  type        = list(string)
}