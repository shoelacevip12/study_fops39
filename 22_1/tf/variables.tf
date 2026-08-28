variable "lab22_1" {
  type    = string
  default = "lab22-1-skv"
}

variable "cloud_id" {
  type    = string
  default = "b1g46dhqv17rkjcoc9k7"
}

variable "folder_id" {
  type    = string
  default = "b1g9l0vgsvf6cegkvj1c"
}

variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}

# Ресурсы для всех создаваемых ВМ
variable "host" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }
}