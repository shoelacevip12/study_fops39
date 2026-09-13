#=========== providers_backend-S3 ==============
variable "cloud_id" {
  description = "ID облака Yandex Cloud"
  type        = string
}

variable "folder_id" {
  description = "ID каталога Yandex Cloud"
  type        = string
}

variable "default_zone" {
  description = "Зона размещения по умолчанию"
  type        = string
}

#=========== terraform_remote_state ==============
variable "network_state_key" {
  description = "Путь к файлу состояния tfstate network в S3"
  type        = string
}

variable "network_bucket_name" {
  description = "Имя S3 бакета, где хранится состояние tfstate network"
  type        = string
}

#============

variable "ssh_key_file" {
  description = "Путь к публичному SSH-ключу на компьютере, загружаемому во все ВМ"
  type        = string   
  sensitive   = true
}

variable "vm_image_family" {
  type    = string
}

variable "host" {
  description = "Ресурсы для всех создаваемых ВМ"
  type        = map(number)
}

variable "deploy_pol" {
  description = "Политика развертывания ВМ"
  type        = map(any)
}

variable "platform_id" {
  description = "Платформа YC для ВМ"
  type        = string
}

variable "disk" {
  description = "Параметры диска для ВМ"
  type = object({
    type = string
    size = number
  })
}

variable "group_name_prefix" {
  type    = string
}

variable "scale_policy_size" {
  type    = number
}