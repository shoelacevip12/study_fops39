# Генерация паролей
resource "random_password" "mysql_root_password" {
  length      = var.password_strong.length
  special     = true
  min_lower   = var.password_strong.min_lower
  min_upper   = var.password_strong.min_upper
  min_numeric = var.password_strong.min_numeric
}

resource "random_password" "mysql_password" {
  length      = var.password_strong.length
  special     = true
  min_lower   = var.password_strong.min_lower
  min_upper   = var.password_strong.min_upper
  min_numeric = var.password_strong.min_numeric
}

# MySQL контейнер
resource "docker_image" "mysql" {
  name         = "mysql:8"
  keep_locally = true
}

resource "docker_container" "mysql" {
  name     = "db-skv"
  image    = docker_image.mysql.image_id
  must_run = true

  ports {
    internal = 3306
    external = 3306
    ip       = "127.0.0.1"
    protocol = "tcp"
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root_password.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_password.result}",
    "MYSQL_ROOT_HOST=%"
  ]

  restart = "always"
}

# Для вывода паролей через output
output "mysql_root_password" {
  value     = random_password.mysql_root_password.result
  sensitive = true
}

output "mysql_password" {
  value     = random_password.mysql_password.result
  sensitive = true
}

output "container_name" {
  value     = docker_container.mysql.name
  sensitive = true
}
