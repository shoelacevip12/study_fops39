# Для Курсового проекта
### commit_29, master
```bash
git checkout master

git branch -v

mkdir -p ./cours_p{,/img}

cd cours_p

git remote -v

git status

git diff && git diff --staged

git add . \
&& git status

git log --oneline

git commit -am 'commit_29, master' \
&& git push --set-upstream study_fops39 master
```
### commit_1, `cours_fops39_2025`
```bash
git log --oneline

git checkout -b cours_fops39_2025

git branch -v

git remote -v

git status

git log --oneline

git add .

git commit -am 'commit_1, cours_fops39_2025' \
&& git push --set-upstream study_fops39 cours_fops39_2025
```
### commit_2, `cours_fops39_2025` Подготовка и запуск стенда
```bash
# вход в папку проекта
cd cours_p

# генерация ключа ssh для подключения через bastion
ssh-keygen -f \
~/.ssh/id_cours_fops39_2025_ed25519 \
-t ed25519 -C "cours_fops39_2025"

# Выставление прав на пару ключей
chmod 600 ~/.ssh/id_cours_fops39_2025_ed25519
chmod 644 ~/.ssh/id_cours_fops39_2025_ed25519.pub

# включаем агента-ssh
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_cours_fops39_2025_ed25519
```
```bash
# содержимое файла cloud-init
cat >cloud-init.yml<<'EOF'
#cloud-config
users:
  - name: skv
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ssh-ed25519 
EOF
```
```bash
# Добавляем содержимое публичного ключа в cloud-init.yml
sed -i "8s|.*|      - $(cat ~/.ssh/id_cours_fops39_2025_ed25519.pub \
                      | tr -d '\n\r')|" \
cloud-init.yml
```
```bash
git branch -v

git remote -v

git status

git log --oneline

git add . .. \
&& git status

git commit -am 'commit_2, cours_fops39_2025' \
&& git push --set-upstream study_fops39 cours_fops39_2025
```
### commit_3, `cours_fops39_2025` Подготовка и запуск стенда
#### Подготовка для работы с yandex cloud
```bash
# Скачиваем скрипт для установки yandex console
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh \
| bash

# Применение новых переменных окружения в текущей сессии
source \
~/.bashrc
```
```bash
# инициализация подключения к уже созданному аккаунту yandex cloud
yc init

#зайти по предоставленной ссылке 
https://oauth.yandex.ru/authorize?response_type=token&client_id=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# для получения OAuth token вида
y0__xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
1
Y
1
```
```bash
# Для вывода Id облака yandex cloud, будет использоваться для взаимодействия с terraform
yc config get cloud-id
b1gkumrn87pei2831blp

# Для вывода Id каталога yandex cloud, будет использоваться для взаимодействия с terraform
yc config get folder-id
b1g7qviodfc9v4k81sr5
```
```bash
git branch -v

git remote -v

git status

git log --oneline

git add . .. \
&& git status

git commit -am 'commit_3, cours_fops39_2025' \
&& git push --set-upstream study_fops39 cours_fops39_2025
```
### commit_4, `cours_fops39_2025` Подготовка и запуск стенда
#### Подготовка для работы с terraform
```bash
# для archlinux установка terraform
sudo pacman -Syu terraform
```
```bash
# в папке с проектом создаем конфигурационный файл .tf:
# source — глобальный адрес источника провайдера.
# required_version — минимальная версия Terraform, с которой совместим провайдер.
# provider — название провайдера.
# zone — зона доступности, в которой по умолчанию будут создаваться все облачные ресурсы.
cat > providers.tf <<'EOF'
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "<зона_доступности_по_умолчанию>"
}
EOF
```
```bash
# в папке с проектом создаем отдельный конфигурационный файл .tf:
# с часто повторяющимися переменными в других файлах .tf
cat > variables.tf <<'EOF'
variable "cours-w-skv" {
  type    = string
  default = "cours-fops39-skv"
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
    cores         = 2
    memory        = 2
    core_fraction = 5
  }
}

variable "srv" {
  type = map(number)
  default = {
    cores         = 4
    memory        = 4
    core_fraction = 20
  }
}
EOF
```

```bash
# в папке с проектом создаем отдельный конфигурационный файл .tf:
# с описанием CIDR локальных сетей в зонах, WAN и NAT маршрутизации
cat > network.tf <<'EOF'
# Общая облачная сеть
resource "yandex_vpc_network" "skv" {
  name = "skv-fops39-${var.cours-w-skv}"
}

# Подсеть zone A
resource "yandex_vpc_subnet" "skv-locnet-a" {
  name           = "skv-fops-${var.cours-w-skv}-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["10.10.10.192/28"]
  route_table_id = yandex_vpc_route_table.route.id
}

# Подсеть zone B
resource "yandex_vpc_subnet" "skv-locnet-b" {
  name           = "skv-fops-${var.cours-w-skv}-ru-central1-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["10.10.10.208/28"]
  route_table_id = yandex_vpc_route_table.route.id
}

# Подсеть zone D
resource "yandex_vpc_subnet" "skv-locnet-d" {
  name           = "skv-fops-${var.cours-w-skv}-ru-central1-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["10.10.10.224/28"]
  route_table_id = yandex_vpc_route_table.route.id
}

# Сеть под NAT для исходящего трафика
resource "yandex_vpc_gateway" "nat-gateway" {
  name = "fops-gateway-${var.cours-w-skv}"
  shared_egress_gateway {}
}

# Шлюз для выхода в WAN
resource "yandex_vpc_route_table" "route" {
  name       = "fops-route-table-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat-gateway.id
  }
}
EOF
```

EOF
```bash
# в папке с проектом создаем отдельный конфигурационный файл .tf:
# с описанием security group для локальных и публичных сетей с разграничением доступа по портам и протоколам 
cat > security_groups.tf <<'EOF'
# Security Group для LAN (внутреннее взаимодействие между сервисами)
resource "yandex_vpc_security_group" "LAN" {
  name       = "LAN-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить весь трафик из внутренней сети"
    protocol       = "ANY"
    v4_cidr_blocks = ["10.10.10.192/26"]
    from_port      = 0
    to_port        = 65535
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Security Group для Bastion Host (только SSH с перенаправлением порта)
resource "yandex_vpc_security_group" "bastion_sg" {
  name       = "bastion-sg-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить SSH доступ из интернета на порт 2225"
    protocol       = "TCP"
    port           = 2225
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Разрешить SSH доступ из интернета на порт 22"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Разрешить для проброса доступ из интернета на порт 3000"
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Разрешить для проброса доступ из интернета на порт 5601"
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Security Group для веб-серверов
resource "yandex_vpc_security_group" "web_sg" {
  name       = "web-sg-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить HTTP трафик из ALB"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["10.10.10.192/26", "198.18.235.0/24", "198.18.248.0/24"]
  }

  ingress {
    description    = "Разрешить HTTPS трафик из ALB"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["10.10.10.192/26", "198.18.235.0/24", "198.18.248.0/24"]
  }

  ingress {
    description       = "Разрешить SSH доступ только с bastion host"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Security Group для Prometheus
resource "yandex_vpc_security_group" "prometheus_sg" {
  name       = "prometheus-sg-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить доступ к Prometheus из Grafana"
    protocol       = "TCP"
    port           = 9090
    v4_cidr_blocks = ["10.10.10.192/26"]
  }

  ingress {
    description       = "Разрешить SSH доступ только с bastion host"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Разрешить сбор метрик с веб-серверов"
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.10.10.192/26"]
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Security Group для Grafana (публичный доступ на порт 3000)
resource "yandex_vpc_security_group" "grafana_sg" {
  name       = "grafana-sg-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description       = "Разрешить доступ к Grafana только с bastion host"
    protocol          = "TCP"
    port              = 3000
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  ingress {
    description       = "Разрешить SSH доступ только с bastion host"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Разрешить доступ к Prometheus"
    protocol       = "TCP"
    port           = 9090
    v4_cidr_blocks = ["10.10.10.192/26"]
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Security Group для Elasticsearch
resource "yandex_vpc_security_group" "elasticsearch_sg" {
  name       = "elasticsearch-sg-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить доступ к Elasticsearch из Kibana и веб-серверов"
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["10.10.10.192/26"]
  }

  ingress {
    description       = "Разрешить SSH доступ только с bastion host"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Security Group для Kibana (публичный доступ на порт 5601)
resource "yandex_vpc_security_group" "kibana_sg" {
  name       = "kibana-sg-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description       = "Разрешить доступ к Kibana только с bastion host"
    protocol          = "TCP"
    port              = 5601
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  ingress {
    description       = "Разрешить SSH доступ только с bastion host"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Разрешить доступ к Elasticsearch"
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["10.10.10.192/26"]
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Security Group для ALB (Application Load Balancer) - ПОЛНОСТЬЮ ИСПРАВЛЕНА
resource "yandex_vpc_security_group" "alb_sg" {
  name       = "alb-sg-${var.cours-w-skv}"
  network_id = yandex_vpc_network.skv.id

  # Разрешить HTTP трафик из интернета
  ingress {
    description    = "Разрешить HTTP трафик из интернета"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Разрешить HTTPS трафик из интернета
  ingress {
    description    = "Разрешить HTTPS трафик из интернета"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Разрешить health checks для HTTP
  ingress {
    description    = "Разрешить health checks от Yandex ALB (HTTP)"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
  }

  # Разрешить health checks для HTTPS
  ingress {
    description    = "Разрешить health checks от Yandex ALB (HTTPS)"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
  }

  # Разрешить health checks для ICMP (ping)
  ingress {
    description    = "Разрешить ICMP health checks от Yandex ALB"
    protocol       = "ICMP"
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
  }

  # Разрешить health checks на все порты (рекомендуется Yandex)
  ingress {
    description    = "Разрешить все health checks от Yandex ALB"
    protocol       = "ANY"
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
    from_port      = 0
    to_port        = 65535
  }

  # Разрешить исходящий трафик к веб-серверам на HTTP
  egress {
    description    = "Разрешить трафик к веб-серверам (HTTP)"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["10.10.10.192/26"]
  }

  # Разрешить исходящий трафик к веб-серверам на HTTPS
  egress {
    description    = "Разрешить трафик к веб-серверам (HTTPS)"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["10.10.10.192/26"]
  }
}
EOF
```
```bash
cat > alb.tf << 'EOF'
# Целевая группа для веб-серверов
resource "yandex_alb_target_group" "web_tg" {
  name = "web-tg-${var.cours-w-skv}"

  target {
    subnet_id  = yandex_vpc_subnet.skv-locnet-a.id
    ip_address = "10.10.10.201" # Nginx-web1 в зоне А
  }

  target {
    subnet_id  = yandex_vpc_subnet.skv-locnet-b.id
    ip_address = "10.10.10.211" # Nginx-web2 в зоне Б
  }
}

# Группа бэкендов для ALB
resource "yandex_alb_backend_group" "web_bg" {
  name = "web-bg-${var.cours-w-skv}"

  http_backend {
    name             = "web-backend"
    weight           = 100
    port             = 80
    target_group_ids = [yandex_alb_target_group.web_tg.id]

    healthcheck {
      timeout             = "2s"
      interval            = "5s"
      healthy_threshold   = 2
      unhealthy_threshold = 2
      healthcheck_port    = 80

      http_healthcheck {
        path = "/"
      }
    }
  }
}

# HTTP роутер
resource "yandex_alb_http_router" "web_router" {
  name = "web-router-${var.cours-w-skv}"
  labels = {
    env = var.cours-w-skv
  }
}

# Виртуальный хост для HTTP роутера
resource "yandex_alb_virtual_host" "web_host" {
  name           = "web-host-${var.cours-w-skv}"
  http_router_id = yandex_alb_http_router.web_router.id
  authority      = ["*"]

  route {
    name = "default-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web_bg.id
      }
    }
  }
}

# Application Load Balancer (alb)
resource "yandex_alb_load_balancer" "alb" {
  name        = "alb-${var.cours-w-skv}"
  description = "ALB для распределения трафика на веб-серверы"
  labels = {
    env = var.cours-w-skv
  }

  network_id = yandex_vpc_network.skv.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.skv-locnet-a.id
    }
    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.skv-locnet-b.id
    }
  }

  listener {
    name = "http-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80, 443]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web_router.id
      }
    }
  }

  security_group_ids = [
    yandex_vpc_security_group.alb_sg.id
  ]

  # Явное указание зависимостей для порядка создания
  depends_on = [
    yandex_vpc_security_group.alb_sg,
    yandex_vpc_security_group.web_sg,
    yandex_alb_backend_group.web_bg,
    yandex_alb_target_group.web_tg
  ]
}
EOF
```
```bash
# в папке с проектом создаем отдельный конфигурационный файл .tf:
# где будет расписан какой образ из репозитория будет использоваться
# с какими параметрами
# Сетями
# Будет созданы виртуальные машины
cat > vms.tf <<'EOF'
# Данные об образе ОС
data "yandex_compute_image" "ubuntu_2404_lts" {
  family = "ubuntu-2404-lts"
}

# Bastion Host
resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  platform_id = "standard-v2"
  zone        = "ru-central1-d"

  resources {
    cores         = var.srv.cores
    memory        = var.srv.memory
    core_fraction = var.srv.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${file("~/.ssh/id_cours_fops39_2025_ed25519.pub")}"
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-d.id
    nat        = true
    ip_address = "10.10.10.230"
    security_group_ids = [
      yandex_vpc_security_group.bastion_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Веб-сервер 1
resource "yandex_compute_instance" "web-a" {
  name        = "web-a"
  hostname    = "web-a"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-a.id
    nat        = false
    ip_address = "10.10.10.201"
    security_group_ids = [
      yandex_vpc_security_group.web_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Веб-сервер 2
resource "yandex_compute_instance" "web-b" {
  name        = "web-b"
  hostname    = "web-b"
  platform_id = "standard-v2"
  zone        = "ru-central1-b"

  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-b.id
    nat        = false
    ip_address = "10.10.10.211"
    security_group_ids = [
      yandex_vpc_security_group.web_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Prometheus
resource "yandex_compute_instance" "prometheus" {
  name        = "prometheus"
  hostname    = "prometheus"
  platform_id = "standard-v2"
  zone        = "ru-central1-d"

  resources {
    cores         = var.srv.cores
    memory        = var.srv.memory
    core_fraction = var.srv.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-d.id
    nat        = false
    ip_address = "10.10.10.231"
    security_group_ids = [
      yandex_vpc_security_group.prometheus_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Grafana
resource "yandex_compute_instance" "grafana" {
  name        = "grafana"
  hostname    = "grafana"
  platform_id = "standard-v2"
  zone        = "ru-central1-d"

  resources {
    cores         = var.srv.cores
    memory        = var.srv.memory
    core_fraction = var.srv.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-d.id
    nat        = false
    ip_address = "10.10.10.232"
    security_group_ids = [
      yandex_vpc_security_group.grafana_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Elasticsearch
resource "yandex_compute_instance" "elasticsearch" {
  name        = "elasticsearch"
  hostname    = "elasticsearch"
  platform_id = "standard-v2"
  zone        = "ru-central1-d"

  resources {
    cores         = var.srv.cores
    memory        = var.srv.memory
    core_fraction = var.srv.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 30
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-d.id
    nat        = false
    ip_address = "10.10.10.233"
    security_group_ids = [
      yandex_vpc_security_group.elasticsearch_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Kibana
resource "yandex_compute_instance" "kibana" {
  name        = "kibana"
  hostname    = "kibana"
  platform_id = "standard-v2"
  zone        = "ru-central1-d"

  resources {
    cores         = var.srv.cores
    memory        = var.srv.memory
    core_fraction = var.srv.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-d.id
    nat        = false
    ip_address = "10.10.10.234"
    security_group_ids = [
      yandex_vpc_security_group.kibana_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Файл hosts для Ansible
resource "local_file" "hosts_ans" {
  content = <<-EOT
    [all:vars]
    ansible_user=skv
    ansible_ssh_private_key_file="~/.ssh/id_cours_fops39_2025_ed25519"
    
    [bastion]
    ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}
    
    [webservers]
    web-a ansible_host=${yandex_compute_instance.web-a.network_interface.0.ip_address}
    web-b ansible_host=${yandex_compute_instance.web-b.network_interface.0.ip_address}
    
    [webservers:vars]
    ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -o StrictHostKeyChecking=accept-new -W %h:%p -i ~/.ssh/id_cours_fops39_2025_ed25519 skv@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'
    
    [monitoring]
    prometheus ansible_host=${yandex_compute_instance.prometheus.network_interface.0.ip_address}
    grafana ansible_host=${yandex_compute_instance.grafana.network_interface.0.ip_address}
    
    [monitoring:vars]
    ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -o StrictHostKeyChecking=accept-new -W %h:%p -i ~/.ssh/id_cours_fops39_2025_ed25519 skv@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'
    
    [logging]
    elasticsearch ansible_host=${yandex_compute_instance.elasticsearch.network_interface.0.ip_address}
    kibana ansible_host=${yandex_compute_instance.kibana.network_interface.0.ip_address}
    
    [logging:vars]
    ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -o StrictHostKeyChecking=accept-new -W %h:%p -i ~/.ssh/id_cours_fops39_2025_ed25519 skv@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'
  EOT

  filename = "./hosts.ini"
}
```

```bash
git branch -v

git remote -v

git status

git log --oneline

git add . .. \
&& git status

git commit -am 'commit_4, cours_fops39_2025' \
&& git push --set-upstream study_fops39 cours_fops39_2025
```
### commit_5, `cours_fops39_2025` Подготовка и запуск стенда
#### Подготовка по ansible
##### Создание основного конфига ansible с готовыми преднастройками
```bash
# где:
# "home=./" Выставляем домашний каталог проекта текущий каталог
# "ssh_agent=auto" Выставляем автоматический запуск ssh-agent при подключении к узлам
# "host_key_checking=False" Отключаем запрос fingerprints при подключении по ssh к Управляемым хостам
# "roles_path=./roles" Выставляем папку расположения ролей
# "inventory=./hosts.ini" Выставляем ранее созданный файл Управляемых хостов как по умолчанию
# "interpreter_python = auto_silent" Убрать предупреждение про Python
#  вместо ansible-config init --disabled -t all > ansible.cfg
cat > ansible.cfg <<"EOF"
[defaults]
home=./
inventory=./hosts.ini
roles_path=./roles
host_key_checking=False
interpreter_python = auto_silent
[privilege_escalation]
[persistent_connection]
[connection]
ssh_agent=auto
[colors]
[selinux]
[diff]
[galaxy]
[inventory]
[netconf_connection]
[paramiko_connection]
host_key_checking=False
[jinja2]
[tags]
[runas_become_plugin]
[su_become_plugin]
[sudo_become_plugin]
[callback_tree]
[ssh_connection]
host_key_checking=False
[winrm]
[inventory_plugins]
[inventory_plugin_script]
[inventory_plugin_yaml]
[url_lookup]
[powershell]
[vars_host_group_vars]
EOF
```
#### Создание роли
```bash
# Создаем папку расположения ролей проекта
mkdir roles

# Генерация шаблона(файлов и папок) роли в папку ./roles 
ansible-galaxy init roles/fops39_skv_2025

rm -rf roles/fops39_skv_2025/{files,meta,README.md,tests}
```
#### Создание playbook
```bash
# Создание файла основной логики выполняемого процесса playbook
# C указанием списка ролей где название берется из названия каталога
cat > ./cours_proj.yaml<< 'EOF'
---
- name: Развертывание инфраструктуры курсового проекта
  hosts: all
  become: yes
  gather_facts: yes
  vars_files:
    - group_vars/all.yml
  roles:
    - fops39_skv_2025
EOF
```
#### Создание общих переменных для всех групп ролей и tasks
```bash
mkdir -p group_vars

cat > group_vars/all.yml << 'EOF'
---
# включаем(true)\выключаем(false) задачи роли
dist_upd: true           # Установка и обновление пакетов всех машин
port_forwards: true      # проброс портов 3000,5601 для Grafana и Kibana на bastion хосте
EOF
```
#### Создано обращение к отдельным файлам задач для роли fops39_skv_2025
```bash
cat > ./roles/fops39_skv_2025/tasks/main.yml << 'EOF'
---
- name: Обновление и установка основных пакетов
  include_tasks:
    file: upd_inst.yml
  when: dist_upd | bool

- name: Проброс портов bastion
  include_tasks: port_forwards.yml
  when:
    - port_forwards | bool
    - inventory_hostname in groups['bastion']
EOF
```
#### Создание файлов с отдельными задачами к которому идет обращение в ../tasks/main.yml
##### для обновления пакетов и установка необходимого минимума
```bash
cat > ./roles/fops39_skv_2025/tasks/upd_inst.yml << 'EOF'
---
- name: Обновление пакетов
  apt:
    update_cache: yes
    upgrade: dist
    cache_valid_time: 3600

- name: Установка базовых утилит
  apt:
    name:
      - wget
      - curl
      - gnupg
      - software-properties-common
      - python3-psycopg2
      - acl
      - locales-all
      - autossh
      - net-tools
    state: present

- name: Генерация русской локали
  shell: |
    echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
  args:
    executable: /bin/bash

- name: Установка часового пояса
  timezone:
    name: Europe/Moscow
EOF
```
##### Задача для проброса grafana и kibana через bastion хост
```bash
cat > ./roles/fops39_skv_2025/tasks/port_forwards.yml << 'EOF'
---
# - name: Debug hostvars
#   debug:
#     msg:
#       - "grafana IP: {{ hostvars['grafana'].ansible_host }}"
#       - "kibana IP: {{ hostvars['kibana'].ansible_host }}"
#   delegate_to: localhost
#   run_once: true

- name: Генерация SSH ключей для пользователя skv
  community.crypto.openssh_keypair:
    path: /home/skv/.ssh/id_rsa
    owner: skv
    group: skv
    mode: '0600'
  register: ssh_key

- name: Чтение содержимого публичного ключа с целевого хоста
  slurp:
    src: /home/skv/.ssh/id_rsa.pub
  register: public_key_content
  changed_when: false

- name: Добавление публичного ключа в authorized_keys
  authorized_key:
    user: skv
    state: present
    key: "{{ public_key_content.content | b64decode }}"

- name: Настройка правильных прав доступа для .ssh директории
  file:
    path: /home/skv/.ssh
    owner: skv
    group: skv
    mode: '0700'
    recurse: yes

- name: Настройка SSH для разрешения проброса портов на все интерфейсы
  lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^GatewayPorts'
    line: 'GatewayPorts yes'
    state: present
  notify: start_autossh

- name: Создание autossh службы для Grafana
  copy:
    content: |
      [Unit]
      Description=AutoSSH tunnel for Grafana
      After=network.target

      [Service]
      User=skv
      ExecStart=/usr/bin/autossh -M 0 -N -L 0.0.0.0:3000:{{ hostvars['grafana'].ansible_host }}:3000 localhost -o StrictHostKeyChecking=no -o ServerAliveInterval=30
      Restart=always
      RestartSec=10

      [Install]
      WantedBy=multi-user.target
    dest: /etc/systemd/system/autossh-grafana.service
    mode: '0644'
    owner: root
    group: root
  notify: start_autossh

- name: Создание autossh службы для Kibana
  copy:
    content: |
      [Unit]
      Description=AutoSSH tunnel for Kibana
      After=network.target

      [Service]
      User=skv
      ExecStart=/usr/bin/autossh -M 0 -N -L 0.0.0.0:5601:{{ hostvars['kibana'].ansible_host }}:5601 localhost -o StrictHostKeyChecking=no -o ServerAliveInterval=30
      Restart=always
      RestartSec=10

      [Install]
      WantedBy=multi-user.target
    dest: /etc/systemd/system/autossh-kibana.service
    mode: '0644'
    owner: root
    group: root
  notify: start_autossh

- name: Конфигурация SSH для внутренних служб
  copy:
    content: |
      Host *.internal
        ProxyJump skv@localhost
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null
    dest: /home/skv/.ssh/config
    owner: skv
    group: skv
    mode: '0600'
EOF
```
##### Обработчик для роли fops39_skv_2025
```bash
cat >./roles/fops39_skv_2025/handlers/main.yml <<'EOF'
#SPDX-License-Identifier: MIT-0
---
- name: Запуск autossh служб обработчиком
  systemd:
    name: "{{ item }}"
    state: restarted
    enabled: yes
    masked: no
    daemon_reload: yes
  loop:
    - autossh-grafana.service
    - autossh-kibana.service
    - ssh.service
  listen: start_autossh
EOF
```
#### Установка и настройка Nginx 
##### Переименовываем подготовленный файл сайта в шаблон .j2
```bash
mv ./roles/fops39_skv_2025/templates/index.html{,.j2}
```
##### Создадим файл конфигурации nginx как шаблон
```bash
cat > ./roles/fops39_skv_2025/templates/nginx.conf.j2 << 'EOF'
server {
    listen 80;
    listen [::]:80;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404; #
    }

    location ~ /\.ht {
        deny all;
    }

    # Предотвращение распространённых атак
    location = /favicon.ico {
        log_not_found off;
    }

    location = /robots.txt {
        allow all; #
    }

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    
    server_tokens off;
}
EOF
```
##### Включение новой задачи в основной файл задач
```bash
cat >> ./roles/fops39_skv_2025/tasks/main.yml << 'EOF'

- name: Установка и настройка nginx
  include_tasks: install_nginx.yml
  when:
    - install_nginx | bool
    - inventory_hostname in groups['webservers']
EOF
```
##### Добавление включения\выключения переменной для установки nginx
```bash
echo -e \
"\ninstall_nginx: true  # установка и настройка nginx сервера" \
>> group_vars/all.yml
```
##### файл установки nginx в папке задач роли
```bash
cat > ./roles/fops39_skv_2025/tasks/install_nginx.yml << 'EOF'
---
- name: Установка nginx на веб-сервера
  apt:
    name: nginx
    state: present
    update_cache: no

- name: Копирование конфигурации nginx
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/sites-available/default
    owner: root
    group: root
    mode: '0644'
  notify: restart_nginx

- name: Создание директории для сайта
  file:
    path: /var/www/html
    state: directory
    owner: www-data
    group: www-data
    mode: '0755'

- name: Копирование главной страницы сайта
  template:
    src: index.html.j2
    dest: /var/www/html/index.html
    owner: www-data
    group: www-data
    mode: '0644'
  notify: restart_nginx

- name: Настройка прав доступа к директории логов
  file:
    path: /var/log/nginx
    mode: '0755'
    owner: www-data
    group: adm
    recurse: yes
  notify: restart_nginx

- name: Запуск Nginx
  systemd:
    name: nginx
    state: started
    enabled: yes
    masked: no
    daemon_reload: yes
  notify: restart_nginx
EOF
```
##### Обработчик для перезапуска nginx
```bash
cat >> ./roles/fops39_skv_2025/handlers/main.yml << 'EOF'

- name: Перезапуск nginx
  systemd:
    name: nginx
    state: restarted
    enabled: yes
    masked: no
    daemon_reload: yes
  listen: restart_nginx
EOF
```
```bash
git add . .. \
&& git status

git commit -am 'commit_5, cours_fops39_2025' \
&& git push --set-upstream study_fops39 cours_fops39_2025
```
### commit_6, `cours_fops39_2025` Подготовка и запуск стенда
#### Подготовка ansible ELK
##### Добавляем в основную задачу подзадачи
```bash
cat >> ./roles/fops39_skv_2025/tasks/main.yml << 'EOF'

- name: Установка ELK стека для logging хостов
  block:
    - name: Установка Elasticsearch
      include_tasks: elasticsearch.yml
      when: inventory_hostname == 'elasticsearch'

    - name: Установка Kibana
      include_tasks: kibana.yml
      when: inventory_hostname == 'kibana'
  when:
    - inst_elk_stack | bool

- name: Установка Filebeat
  include_tasks: filebeat.yml
  when:
    - inst_filebeat | bool
    - inventory_hostname in groups['webservers']
EOF
```
##### Создание общих переменных для всех групп ролей и tasks на включение выключения выполнения операций по развертыванию ELK и filebeat
```bash
cat >> group_vars/all.yml <<"EOF"

inst_elk_stack: true  # установка ELK"
inst_filebeat: true  # установка filebeat"
EOF
```
##### Создаем переменные по умолчанию в роли для ELK компонентов
```bash
# Переменные для Elasticsearch
cat >> ./roles/fops39_skv_2025/vars/main.yml << 'EOF'

elasticsearch_version: "9.2.3"
elasticsearch_deb_url: "https://drive.usercontent.google.com/download?id=1JT64hgo5h_vuSVdcEHTp38E2KKvZYUSQ&export=download&authuser=0&confirm=t&uuid=b8108253-504a-4018-8a3e-ad29864bdbde&at=ANTm3cylPIjDcgI9iM9I4hSwlGhB%3A1767798169738"
elasticsearch_deb_file: "elasticsearch-{{ elasticsearch_version }}-amd64.deb"
elasticsearch_checksum_url: "https://drive.usercontent.google.com/download?id=1MVeawsJEjjZHv0vGWzEa5vaEJ2lX1-eK"
elasticsearch_checksum_file: "elasticsearch-{{ elasticsearch_version }}-amd64.deb.sha512"
EOF
```
```bash
# Переменные для Kibana
cat >> ./roles/fops39_skv_2025/vars/main.yml << 'EOF'

kibana_version: "9.2.3"
kibana_deb_url: "https://drive.usercontent.google.com/download?id=1ntG0JUFYnn8RQjAuTxZTKcyIyXsjRIbt&export=download&authuser=0&confirm=t&uuid=7d2caffc-8289-4dde-9502-556e598566e4&at=ANTm3cxCjX58M20YqewDTuGhXv47%3A1767798520197"
kibana_deb_file: "kibana-{{ kibana_version }}-amd64.deb"
EOF
```
```bash
# Переменные для Filebeat
cat >> ./roles/fops39_skv_2025/vars/main.yml << 'EOF'

filebeat_version: "9.2.3"
filebeat_deb_url: "https://drive.usercontent.google.com/download?id=1oc1mkRzUV_2b-6Ul0FsSu4xfFap7anR9&export=download&authuser=0&confirm=t&uuid=56c3d441-9b3f-4497-957b-ea4c1c292828&at=ANTm3cxIQ5mSthC6M-NMYDHiWXaj%3A1767798607518"
filebeat_deb_file: "filebeat-{{ filebeat_version }}-amd64.deb"
EOF
```

##### Добавление постоянных переменных в роли для конфигурации ELK
```bash
cat >> ./roles/fops39_skv_2025/defaults/main.yml <<'EOF'

# ELK Stack набор переменных
elasticsearch_cluster_name: "es_SKV-DV"
elasticsearch_network_host: "0.0.0.0"
elasticsearch_http_port: 9200
elasticsearch_discovery_type: "single-node"
elasticsearch_xpack_security_enabled: false
elasticsearch_xpack_security_transport_ssl_enabled: false
elasticsearch_xpack_security_http_ssl_enabled: false
elasticsearch_xpack_security_authc_api_key_enabled: true
elasticsearch_indices_query_bool_max_clause_count: 3072

kibana_server_port: 5601
kibana_server_host: "0.0.0.0"
kibana_elasticsearch_host: "http://{{ hostvars['elasticsearch'].ansible_host }}:9200"
kibana_xpack_security_enabled: false
EOF
```
##### Создаем файл задач для установки elasticsearch
```bash
cat > ./roles/fops39_skv_2025/tasks/elasticsearch.yml << 'EOF'
---
- name: Скачивание Elasticsearch DEB пакета
  get_url:
    url: "{{ elasticsearch_deb_url }}"
    dest: "/tmp/{{ elasticsearch_deb_file }}"
    mode: '0644'
    timeout: 300
    headers:
      Content-Disposition: "attachment"
  register: elasticsearch_download
  until: elasticsearch_download is succeeded
  retries: 3
  delay: 10

- name: Скачивание файла контрольной суммы Elasticsearch
  get_url:
    url: "{{ elasticsearch_checksum_url }}"
    dest: "/tmp/{{ elasticsearch_checksum_file }}"
    mode: '0644'
    timeout: 60
    headers:
      Content-Disposition: "attachment"
  register: checksum_download
  until: checksum_download is succeeded
  retries: 3
  delay: 5

- name: Проверка контрольной суммы Elasticsearch
  shell: |
    cd /tmp
    shasum -a 512 -c {{ elasticsearch_checksum_file }}
  args:
    executable: /bin/bash
  register: checksum_result
  failed_when: checksum_result.rc != 0
  changed_when: false

- name: Установка Elasticsearch из DEB пакета
  apt:
    deb: "/tmp/{{ elasticsearch_deb_file }}"
    state: present
    update_cache: yes

- name: Конфигурация Elasticsearch
  template:
    src: elasticsearch.j2
    dest: /etc/elasticsearch/elasticsearch.yml
    owner: root
    group: elasticsearch
    mode: '0644'
  notify: restart_elasticsearch

- name: Настройка прав доступа к данным Elasticsearch
  file:
    path: /var/lib/elasticsearch
    owner: elasticsearch
    group: elasticsearch
    mode: '0755'
    recurse: yes
    state: directory
  notify: restart_elasticsearch

- name: Запуск elasticsearch
  systemd:
    name: elasticsearch
    state: started
    daemon_reload: yes
  notify: restart_elasticsearch
EOF
```
##### Шаблон конфигурации Elasticsearch
```bash
cat > ./roles/fops39_skv_2025/templates/elasticsearch.j2 << 'EOF'
#----------------------- Elasticsearch Configuration -----------------------
cluster.name: {{ elasticsearch_cluster_name }}
node.name: "{{ inventory_hostname }}"
network.host: {{ elasticsearch_network_host }}
http.port: {{ elasticsearch_http_port }}
discovery.type: {{ elasticsearch_discovery_type }}
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
node.roles: [master, data, ingest]

# ОТКЛЮЧЕНИЕ ВСЕХ КОМПОНЕНТОВ БЕЗОПАСНОСТИ
xpack.security.enabled: {{ elasticsearch_xpack_security_enabled }}
xpack.security.transport.ssl.enabled: {{ elasticsearch_xpack_security_transport_ssl_enabled }}
xpack.security.http.ssl.enabled: {{ elasticsearch_xpack_security_http_ssl_enabled }}
xpack.security.authc.api_key.enabled: {{ elasticsearch_xpack_security_authc_api_key_enabled }}

# Настройки памяти и производительности
indices.query.bool.max_clause_count: {{ elasticsearch_indices_query_bool_max_clause_count }}
EOF
```
##### Создаем файл задач для установки kibana
```bash
cat > ./roles/fops39_skv_2025/tasks/kibana.yml << 'EOF'
---
- name: Скачивание Kibana DEB пакета
  get_url:
    url: "{{ kibana_deb_url }}"
    dest: "/tmp/{{ kibana_deb_file }}"
    mode: '0644'
    timeout: 300
    headers:
      Content-Disposition: "attachment"
  register: kibana_download
  until: kibana_download is succeeded
  retries: 3
  delay: 10

- name: Установка Kibana из DEB пакета
  apt:
    deb: "/tmp/{{ kibana_deb_file }}"
    state: present

- name: Конфигурация Kibana
  template:
    src: kibana.j2
    dest: /etc/kibana/kibana.yml
    owner: root
    group: kibana
    mode: '0644'
  notify: restart_kibana

- name: Запуск kibana
  systemd:
    name: kibana
    state: started
    daemon_reload: yes
  notify: restart_kibana
EOF
```
##### Шаблон конфигурации Kibana
```bash
cat > ./roles/fops39_skv_2025/templates/kibana.j2 << 'EOF'
#----------------------- Kibana Configuration -----------------------
server.port: {{ kibana_server_port }}
server.host: "{{ kibana_server_host }}"
elasticsearch.hosts: ["{{ kibana_elasticsearch_host }}"]
EOF
```
##### Создаем файл задач для установки filebeat на webservers
```bash
cat > ./roles/fops39_skv_2025/tasks/filebeat.yml << 'EOF'
---
- name: Скачивание Filebeat DEB пакета
  get_url:
    url: "{{ filebeat_deb_url }}"
    dest: "/tmp/{{ filebeat_deb_file }}"
    mode: '0644'
    timeout: 300
    headers:
      Content-Disposition: "attachment"
  register: filebeat_download
  until: filebeat_download is succeeded
  retries: 3
  delay: 10

- name: Установка Filebeat из DEB пакета
  apt:
    deb: "/tmp/{{ filebeat_deb_file }}"
    state: present

- name: Конфигурация Filebeat для Nginx
  template:
    src: filebeat.yml.j2
    dest: /etc/filebeat/filebeat.yml
    owner: root
    group: root
    mode: '0644'
  notify: restart_filebeat

- name: Включение модуля nginx для Filebeat
  command: filebeat modules enable nginx
  args:
    creates: /etc/filebeat/modules.d/nginx.yml
  notify: restart_filebeat

- name: Загрузка шаблонов индексов в Elasticsearch
  command: >
    filebeat setup --index-management
    -E setup.ilm.enabled=false
    -E output.elasticsearch.hosts=["{{ hostvars['elasticsearch'].ansible_host }}:9200"]
  retries: 5
  delay: 10
  register: filebeat_setup
  until: filebeat_setup is succeeded
  changed_when: true
  notify: restart_filebeat
EOF
```
##### Шаблон конфигурации Filebeat
```bash
cat > ./roles/fops39_skv_2025/templates/filebeat.yml.j2 << 'EOF'
#----------------------- Filebeat Configuration -----------------------
filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: true

filebeat.inputs:
- type: filestream
  id: nginx-access-logs
  enabled: true
  paths:
    - /var/log/nginx/access.log
  fields:
    service: nginx
    log_type: access
  fields_under_root: true
  close_inactive: 5m

- type: filestream
  id: nginx-error-logs
  enabled: true
  paths:
    - /var/log/nginx/error.log
  fields:
    service: nginx
    log_type: error
  fields_under_root: true
  close_inactive: 5m

output.elasticsearch:
  hosts: ["{{ hostvars['elasticsearch'].ansible_host }}:9200"]
  indices:
    - index: "logs-nginx-access-%{+yyyy.MM.dd}"
      when.equals:
        log_type: "access"
    - index: "logs-nginx-error-%{+yyyy.MM.dd}"
      when.equals:
        log_type: "error"

processors:
  - add_host_metadata: {}
  - add_cloud_metadata: {}
EOF
```
##### Обработчики для задач ELK и агентов
```bash
cat >> ./roles/fops39_skv_2025/handlers/main.yml << 'EOF'


- name: Перезапуск elasticsearch
  systemd:
    name: elasticsearch
    state: restarted
    daemon_reload: yes
  listen: restart_elasticsearch

- name: Проверка работы Elasticsearch
  uri:
    url: "http://localhost:9200"
    status_code: 200
    timeout: 30
  register: elasticsearch_status
  until: elasticsearch_status.status == 200
  retries: 10
  delay: 5
  when: not ansible_check_mode
  listen: restart_elasticsearch

- name: Перезапуск kibana
  systemd:
    name: kibana
    state: restarted
    daemon_reload: yes
  listen: restart_kibana

- name: Проверка работы Kibana
  uri:
    url: "http://localhost:5601/api/status"
    status_code: 200
    timeout: 30
  register: kibana_status
  until: kibana_status.status == 200
  retries: 10
  delay: 5
  when: not ansible_check_mode
  listen: restart_kibana

- name: Перезапуск filebeat
  systemd:
    name: filebeat
    state: restarted
    daemon_reload: yes
  listen: restart_filebeat
EOF
```
```bash
git add . .. \
&& git status

git commit -am 'commit_6, cours_fops39_2025' \
&& git push --set-upstream study_fops39 cours_fops39_2025
```
### commit_7, `cours_fops39_2025` Подготовка и запуск стенда
#### Подготовка ansible через коллекции ansible-galaxy prometheus
```bash
# Скачивание коллекции prometheus
ansible-galaxy collection \
install prometheus.prometheus \
-p ./collections

# "collections_paths=./collections" Выставляем папку расположения коллекций
sed -i '/.\/roles$/a \
collections_paths=./collections' \
ansible.cfg
```
##### Создание отдельного playbook для установки Prometheus и Node Exporter
```bash
cat>./prometheus_server.yaml<<'EOF'
---
- name: Установка Prometheus
  hosts: prometheus
  become: yes
  gather_facts: yes

  roles:
    - prometheus.prometheus.prometheus

- name: Установка Node Exporter
  hosts: webservers:prometheus
  become: yes
  gather_facts: yes
  roles:
    - prometheus.prometheus.node_exporter
EOF
```
##### Добавляем в главный Playbook для установки Prometheus и Node Exporter
```bash
cat>> cours_proj.yaml <<'EOF'


- name: Установка Prometheus и Node Exporter
  import_playbook: prometheus_server.yaml
  when: install_prometheus | bool
EOF
```
##### Создание общей переменной для всех групп ролей и tasks на включение выключения выполнения операций по развертыванию Prometheus и Node Exporter
```bash
echo -e \
"\ninstall_prometheus: true  # установка Prometheus и Node Exporter" \
>> group_vars/all.yml
```
```bash
git add . .. \
&& git status

git commit -am 'commit_6, cours_fops39_2025' \
&& git push --set-upstream study_fops39 cours_fops39_2025
```

### commit_7, `cours_fops39_2025` Подготовка и запуск стенда
#### Подготовка ansible nginx log-exporter
##### Добавление задачи в основной файл роли
```bash
cat >> ./roles/fops39_skv_2025/tasks/main.yml << 'EOF'

- name: Установка prometheus-nginxlog-exporter
  include_tasks: nginxlog_exporter.yml
  when:
    - inst_nginxlog_exporter | bool
    - inventory_hostname in groups['webservers']
EOF
```
##### Создание общей переменной для всех групп ролей и tasks на включение\выключения выполнения операций по развертыванию nginxlog_exporter
```bash
echo -e "\ninst_nginxlog_exporter: true  # установка nginxlog_exporter" \
>> group_vars/all.yml
```
##### Постоянные переменные для nginxlog-exporter в файл переменных основной роли
```bash
cat >> ./roles/fops39_skv_2025/vars/main.yml << 'EOF'

# prometheus-nginxlog-exporter
nginxlog_exporter_version: "1.11.0"
nginxlog_exporter_deb_url: "https://github.com/martin-helmich/prometheus-nginxlog-exporter/releases/download/v{{ nginxlog_exporter_version }}/prometheus-nginxlog-exporter_{{ nginxlog_exporter_version }}_linux_amd64.deb"
nginxlog_exporter_deb_file: "prometheus-nginxlog-exporter_{{ nginxlog_exporter_version }}_linux_amd64.deb"
nginxlog_exporter_listen_port: 4040
nginxlog_exporter_config_file: "/etc/prometheus-nginxlog-exporter.hcl"
EOF
```
##### Файла задач для установки nginxlog-exporter
```bash
cat > ./roles/fops39_skv_2025/tasks/nginxlog_exporter.yml << 'EOF'
---
- name: Скачивание prometheus-nginxlog-exporter DEB пакета
  get_url:
    url: "{{ nginxlog_exporter_deb_url }}"
    dest: "/tmp/{{ nginxlog_exporter_deb_file }}"
    mode: '0644'
    timeout: 300
  register: download_result
  until: download_result is succeeded
  retries: 3
  delay: 10

- name: Установка prometheus-nginxlog-exporter из DEB пакета
  apt:
    deb: "/tmp/{{ nginxlog_exporter_deb_file }}"
    state: present

- name: Конфигурация для prometheus-nginxlog-exporter
  template:
    src: nginxlog_exporter.hcl.j2
    dest: "{{ nginxlog_exporter_config_file }}"
    owner: root
    group: root
    mode: '0644'
  notify: restart_nginxlog_exporter

- name: Запуск и включение prometheus-nginxlog-exporter
  systemd:
    name: prometheus-nginxlog-exporter
    state: started
    enabled: yes
    daemon_reload: yes
  notify: restart_nginxlog_exporter
EOF
```
##### Шаблон конфигурационного файла
```bash
cat > ./roles/fops39_skv_2025/templates/nginxlog_exporter.hcl.j2 << 'EOF'
listen {
  port = {{ nginxlog_exporter_listen_port }}
  address = "0.0.0.0"
  metrics_endpoint = "/metrics"
}

namespace "nginx" {
  format = "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\" \"$http_x_forwarded_for\""
  
  source {
    files = [
      "/var/log/nginx/access.log*"
    ]
  }
  
  labels {
    app = "nginx"
    environment = "production"
    host = "{{ inventory_hostname }}"
  }
  
  relabel "method" {
    from = "request_method"
  }
  
  relabel "path" {
    from = "request_uri"
    match "^/[^/]+/[^/]+/[^/]+" {
      replacement = "/:path"
    }
    match "^/[^/]+/[^/]+" {
      replacement = "/:path"
    }
    match "^/[^/]+" {
      replacement = "/:path"
    }
  }
  
  relabel "status" {
    from = "status"
  }
  
  histogram_buckets = [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0]
}
EOF
```
##### Обработчик для перезапуска сервиса nginxlog-exporter
```bash
cat >> ./roles/fops39_skv_2025/handlers/main.yml << 'EOF'

- name: Перезапуск prometheus-nginxlog-exporter
  systemd:
    name: prometheus-nginxlog-exporter
    state: restarted
    enabled: yes
    masked: no
    daemon_reload: yes
  listen: restart_nginxlog_exporter
EOF
```
##### Создание общих переменных для хоста prometheus
```bash
mkdir -p host_vars

cat > host_vars/prometheus.yml << 'EOF'
---
prometheus_targets:
  node:
    - targets:
        - localhost:9100
        - "{{ hostvars['web-a'].ansible_host }}:9100"
        - "{{ hostvars['web-b'].ansible_host }}:9100"
nginxlog:
  - targets:
      - "{{ hostvars['web-a'].ansible_host }}:4040"
      - "{{ hostvars['web-b'].ansible_host }}:4040"
    labels:
      service: "nginxlog_exporter"
EOF
```

```bash
git add . .. \
&& git status

git commit -am 'commit_7, cours_fops39_2025' \
&& git push --set-upstream study_fops39 cours_fops39_2025
```

### commit_8, `cours_fops39_2025` Подготовка и запуск стенда
#### Подготовка ansible через коллекции ansible-galaxy grafana
```bash
# Скачивание коллекции grafana
ansible-galaxy collection \
install grafana.grafana \
-p ./collections
```
##### Создание общих переменных для хоста grafana
```bash
mkdir -p host_vars

cat > host_vars/grafana.yml << 'EOF'
---
grafana_version: "12.3.1"  # Версия Grafana
grafana_admin_user: "admin"
grafana_admin_password: "test@skv"
grafana_deb_url: "https://drive.usercontent.google.com/download?id=1VjodTd3ro6mCUCmyJWkcY0c4XRjc34yO&export=download&confirm=t&uuid=3c0f5a8b-e769-4e13-a774-a01ec7e04b03&at=ANTm3cy8tILZs5QZQAb61Bz1itWH%3A1767616590783"
grafana_deb_file: "grafana_12.3.1_20271043721_linux_amd64"
grafana_ini:
  security:
    admin_user: "{{ grafana_admin_user }}"
    admin_password: "{{ grafana_admin_password }}"
grafana_datasources:
  - name: "Prometheus"
    type: "prometheus"
    url: "http://{{ hostvars['prometheus'].ansible_host }}:9090"
EOF
```
##### Создание отдельного playbook для установки Grafana
```bash
cat > ./grafana_server.yaml << 'EOF'
---
- name: Установка Grafana
  hosts: grafana
  become: yes
  gather_facts: yes
  
  pre_tasks:
    - name: скачивание Grafana DEB пакета
      get_url:
        url: "{{ grafana_deb_url }}"
        dest: "/tmp/{{ grafana_deb_file }}"
        mode: '0644'
        timeout: 300
        headers:
          Content-Disposition: "attachment"

    - name: Установка Grafana из DEB пакета
      apt:
        deb: "/tmp/{{ grafana_deb_file }}"
        state: present

  roles:
    - grafana.grafana.grafana
EOF
```
##### Добавление в основной playbook grafana
```bash
cat >> cours_proj.yaml << 'EOF'


- name: Установка Grafana
  import_playbook: grafana_server.yaml
  when: install_grafana | bool
EOF
```
##### Создание общей переменной для всех групп ролей и tasks на включение выключения выполнения операций по развертыванию Grafana
```bash
echo -e "\ninstall_grafana: true  # установка Grafana" \
>> group_vars/all.yml
```
##### Удаление блока добавления репозитория grafana "Add Grafana apt repository" в tasks роли коллекции
```bash
sed -i '/Add Grafana apt repository/,+17d' \
./collections/ansible_collections/grafana/grafana/roles/grafana/tasks/install.yml
```
```bash
git add . .. \
&& git status

git commit -am 'commit_8, cours_fops39_2025' \
&& git push --set-upstream study_fops39 cours_fops39_2025
```
### commit_9, `cours_fops39_2025`
```bash
# Привязка коммита к локальной ветке
git switch -C cours_fops39_2025

# Отправка изменения с перезаписью удалённой ветки
git push --force-with-lease study_fops39 cours_fops39_2025

git add . .. \
&& git status

git commit -am 'commit_9_update_8, cours_fops39_2025' \
&& git push --set-upstream study_fops39 cours_fops39_2025
```

```bash
# Проверка tf файлов проекта и создание файла запуска terraform
terraform validate \
&& terraform fmt  \
&& terraform init --upgrade \
&& terraform plan -out=tfplan

# Применение файла запуска terraform
terraform apply "tfplan"

# Чистка известных хостов для подключения по ssh
> ~/.ssh/known_hosts

# Запуск Ansible ролей
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_cours_fops39_2025_ed25519 \
&& > ~/.ssh/known_hosts \
&& ansible-playbook cours_proj.yaml
```
```bash
# Запускам агента-ssh с прописанным ключем
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_cours_fops39_2025_ed25519

# Тестовое подключение рабочих машин
ssh -t -o StrictHostKeyChecking=accept-new -i \
~/.ssh/id_cours_fops39_2025_ed25519 \
skv@"$(grep -A1 "bastion" hosts.ini \
      | tail -n1)" \
      hostnamectl \
&& yc compute instance list

for ip in {201,211,231,232,233,234}; do \
ssh -t -o StrictHostKeyChecking=accept-new \
-J skv@"$(grep -A1 "bastion" hosts.ini \
      | tail -n1)" \
skv@10.10.10.$ip \
"hostnamectl | head -n1"; \
done

# Запуск Ansible ролей
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_cours_fops39_2025_ed25519 \
&& > ~/.ssh/known_hosts \
&& ansible-playbook cours_proj.yaml --syntax-check \
&& ansible-playbook cours_proj.yaml --syntax-check
```