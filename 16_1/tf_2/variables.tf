variable "lab16_1" {
  type    = string
  default = "lab16-1-skv"
}

variable "cloud_id" {
  type    = string
  default = "b1gkumrn87pei2831blp"
}

variable "folder_id" {
  type    = string
  default = "b1g7qviodfc9v4k81sr5"
}

variable "host" {
  type = map(number)
  default = {
    cores         = 4
    memory        = 4
    core_fraction = 5
  }
}

variable "password_strong" {
  type = map(number)
  default = {
    length      = 16
    min_lower   = 1
    min_upper   = 1
    min_numeric = 1
  }
}
