###cloud vars

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
  default     = "b1gkumrn87pei2831blp"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
  default     = "b1g7qviodfc9v4k81sr5"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

# Объединение в единую map-переменную vms_resources
variable "vms_resources" {
  type = map(object({
    family        = string
    count         = number
    name          = string
    platform_id   = string
    cores         = number
    memory        = number
    core_fraction = number
    preemptible   = bool
    nat           = bool
  }))
  default = {
    vm_web = {
      family        = "ubuntu-2404-lts-oslogin"
      count         = 2
      name          = "skv-develop-web"
      platform_id   = "standard-v2"
      cores         = 2
      memory        = 3
      core_fraction = 5
      preemptible   = true
      nat           = true
    }
  }
}

#  Отдельный map(object) переменной для блока metadata
variable "vms_ssh" {
  type = map(any)
  default = {
    serial-port-enable = 1
    "ssh-keys"         = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMT2pZfiY4KUIeybtsJjbp42JjiUySw5e34KiNprFsc lab16_1_fops39"
  }
}

# Объединение в единую list(object -переменную each_vm
variable "each_vm" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    type          = string
    disk_volume   = number
    family        = string
    platform_id   = string
    core_fraction = number
    preemptible   = bool
    nat           = bool
  }))

  default = [
    {
      vm_name       = "skv-develop-main"
      cpu           = 4
      ram           = 4
      type          = "network-hdd"
      disk_volume   = 15
      family        = "ubuntu-2404-lts-oslogin"
      platform_id   = "standard-v3"
      core_fraction = 20
      preemptible   = true
      nat           = true
    },
    {
      vm_name       = "skv-develop-replica"
      cpu           = 2
      ram           = 3
      type          = "network-hdd"
      disk_volume   = 10
      family        = "ubuntu-2404-lts-oslogin"
      platform_id   = "standard-v2"
      core_fraction = 5
      preemptible   = true
      nat           = false
    }
  ]
}

# Объявление единой map-переменной для дисков
variable "disk_count" {
  type = map(object({
    count = number
    name  = string
    type  = string
    size  = number
  }))
  default = {
    disk_add = {
      count = 3
      name  = "skv-disk"
      type  = "network-hdd"
      size  = 1
    }
  }
}
variable "vm_storage" {
  type        = string
  default     = "storage"
  description = "VM 3aDaHue 3 name"
}
