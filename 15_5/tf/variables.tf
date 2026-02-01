variable "lab15_5" {
  type    = string
  default = "lab15-5-skv"
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