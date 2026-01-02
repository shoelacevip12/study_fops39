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
    lock_passwd: false
package_update: true
package_upgrade: true
packages:
  - wget
  - curl
  - gnupg
  - software-properties-common
  - python3-psycopg2
  - acl
  - locales-all
runcmd:
  - [ sed, -i, 's/#Port 22/Port 2225/', /etc/ssh/sshd_config ]
  - [ systemctl, restart, sshd ]
EOF

# Добавляем содержимое публичного ключа в cloud-init.yml
sed -i "8s|.*|      - $(cat ~/.ssh/id_cours_fops39_2025_ed25519.pub)|" cloud-init.yml
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
    description    = "Разрешить HTTP доступ к Grafana из интернета"
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = ["0.0.0.0/0"]
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
    description    = "Разрешить HTTP доступ к Kibana из интернета"
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
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
    nat        = true
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
    nat        = true
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
    
    [alb]
    ${yandex_alb_load_balancer.alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address}
    
    [bastion]
    ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}
    
    [webservers]
    ${yandex_compute_instance.web-a.network_interface.0.ip_address} hostname=web-a
    ${yandex_compute_instance.web-b.network_interface.0.ip_address} hostname=web-b
    
    [webservers:vars]
    ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -o StrictHostKeyChecking=accept-new -W %h:%p skv@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'
    
    [monitoring]
    ${yandex_compute_instance.prometheus.network_interface.0.ip_address} hostname=prometheus
    ${yandex_compute_instance.grafana.network_interface.0.ip_address} hostname=grafana
    
    [monitoring:vars]
    ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -o StrictHostKeyChecking=accept-new -W %h:%p skv@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'
    
    [logging]
    ${yandex_compute_instance.elasticsearch.network_interface.0.ip_address} hostname=elasticsearch
    ${yandex_compute_instance.kibana.network_interface.0.ip_address} hostname=kibana
    
    [logging:vars]
    ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -o StrictHostKeyChecking=accept-new -W %h:%p skv@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'
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
```bash
```
