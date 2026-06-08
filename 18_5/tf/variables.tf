variable "cours-w-skv" {
  type    = string
  default = "cours-fops40-skv"
}

variable "cloud_id" {
  type    = string
  default = "b1g46dhqv17rkjcoc9k7"
}

variable "folder_id" {
  type    = string
  default = "b1g9l0vgsvf6cegkvj1c"
}

variable "host" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }
}
