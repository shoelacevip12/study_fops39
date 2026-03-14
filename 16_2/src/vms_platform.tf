variable "vm_db_" {
  type = tuple([
    string,
    string,
    list(string),
    string,
    string
  ])
  default = [
    "skv-locnet-b",
    "ru-central1-b",
    ["10.0.2.0/26"],
    "netology-develop-platform-db",
    "standard-v2"
  ]
}
