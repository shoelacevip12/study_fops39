variable "lab22_1" {
  description = "Название лабораторной работы"
  type        = string
  default     = "lab22-1-skv"
}

variable "cloud_id" {
  description = "ID облака"
  type        = string
  default     = "b1g46dhqv17rkjcoc9k7"
}

variable "folder_id" {
  description = "ID папки в облаке"
  type        = string
  default     = "b1g9l0vgsvf6cegkvj1c"
}

variable "service_account_id" {
  description = "ID service account для каталога в облаке"
  type        = string
  default     = "ajen0vmdo7bfr3t4auv7"
}

variable "default_zone" {
  description = "Зона размещения по умолчанию"
  type        = string
  default     = "ru-central1-a"
}

variable "platform_id" {
  description = "Платформа CPU для всех создаваемых ВМ"
  type        = string
  default     = "standard-v2"
}

variable "disk" {
  description = "Загрузочный диск для всех создаваемых ВМ"
  type        = map(any)
  default = {
    type = "network-hdd"
    size = 20
  }
}

variable "ssh_key_file" {
  description = "Путь к публичному SSH-ключу на компьютере, загружаемому во все ВМ"
  type        = string
  default     = "~/.ssh/id_lab22_1_fops40_ed25519.pub"
}

variable "vm_image_family" {
  type    = string
  default = "lemp"
}

variable "host" {
  description = "Ресурсы для всех создаваемых ВМ"
  type        = map(number)
  default = {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }
}

variable "bucket_name" {
  description = "Имя S3 бакета"
  type        = string
  default     = "den-skv-fops40-lab22-2"
}