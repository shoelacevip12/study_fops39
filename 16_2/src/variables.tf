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
  description = "VPC network & subnet name"
}


###ssh vars


variable "vm_web_" {
  type = tuple([
    string,
    string,
    string,
    bool
  ])
  default = [
    "ubuntu-2004-lts",
    "netology-develop-platform-web",
    "standard-v2",
    true
  ]
}

# Объединение в единую map-переменную vms_resources "cores","memory","core_fraction"
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number

  }))

  default = {
    vm_web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    },
    vm_db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
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
