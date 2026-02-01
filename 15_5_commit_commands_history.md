# Для домашнего задания 15.5
## Предварительная подготовка установка последнего docker compose и github-cli
```bash
# Поиск  установлен ли docker-compose
sudo pacman -Ss \
docker-compose

# Удаление 
sudo pacman -Rnd \
docker-compose
```
### Ручная установка docker compose 
```bash
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v5.0.2/docker-compose-linux-x86_64 \
-o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

# Проверка установленной версии
docker compose version
```
### Установка github-cli и создание форка для для домашнего задания
```bash
sudo pacman -Ss \
github-cli

sudo pacman -Syu \
github-cli

# Авторизация на github
gh auth login
GitHub.com
HTTPS
Yes
Login with a web browser
```
## создание форка работы
```bash
# создание средствами github-cli форка
gh repo fork \
https://github.com/netology-code/shvirtd-example-python.git

cd nfs_git

# клонирование форка со своего репозитория и переименование папки для работы
git clone \
https://github.com/shoelacevip12/shvirtd-example-python.git

mv shvirtd-example-python \
git_lab_15_5

cd !$
```
## Настройка git для работы c github и gitflic 
```bash
git remote -v

# Добавление нового удаленного репозитория https://gitflic.ru
git remote add \
study_fops39_gitflic_ru \
https://gitflic.ru/project/shoelacevip12/shvirtd-example-python.git

# создание gitignore
cat >> .gitignore <<'EOF'
# Игнорировать всю папку:
cache/
.vagrant/
__pycache__/
mysql_D/
master/db/
slave/db/
.terraform/
collections/
galaxy_cache/
tmp/
.vscode/

# игнорировать расширения и файлы:
*.deb
authorized_key.json
.terraform.lock.hcl
tfplan
terraform.tfstate
terraform.tfstate.backup
cloud-init.yml
.terraform.*

# Исключения
EOF
```
## Задача 1
### Создание файла Dockerfile.python multistage вариант
```bash
cat >Dockerfile.python<<'EOF'
# Этап build
FROM python:3.12-slim AS builder
WORKDIR /app
RUN python -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"
COPY . .
RUN --mount=type=cache,target=~/.cache/pip pip install -r requirements.txt

# Этап копирования результатов build И запуск
FROM python:3.12-slim AS worker
WORKDIR /app
COPY --from=builder /app/venv ./venv
COPY --from=builder /app/main.py .
EXPOSE 5000
ENV PATH="/app/venv/bin:$PATH"
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]
EOF
```
### Создание файла .dockerignore
```bash
cat >.dockerignore<<'EOF'
*
!main.py
!requirements.txt
EOF
```

### Запуск сборки и запуск контейнера
```bash
# Старт службы
sudo systemctl \
start \
docker

# Запуск сборки и присвоение тега
docker build \
-t skv-python-app \
-f Dockerfile.python \
.

# Запуск контейнера
docker run \
-p 5000:5000 \
skv-python-app
```
## для github и gitflic
```bash
git add . \
&& git status

git remote -v

# Создание коммита со всеми изменениями и отправка в удаленные репозиторий
git commit -am 'commit_1_upd1, main' \
&& git push --set-upstream origin main \
&& git push --set-upstream study_fops39_gitflic_ru main
```
```bash
cat > compose.yaml <<'EOF'
version: '3.8'
# лимиты ресурсов
x-deploy: &deploy-skv
  deploy:
    resources:
      limits:
        cpus: "0.7"
        memory: 256M
      reservations:
        cpus: "0.25"
        memory: 128M
# Условия перезапуска
x-restart: &restart
  restart: unless-stopped
# override других compose файлов
include: 
  -  proxy.yaml
# Основной конфиг запуска служб
services:
  db:
    image: mysql:8.0
    <<: [*deploy-skv, *restart]
    container_name: mysql-db
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      MYSQL_ROOT_HOST: "%"
    networks:
      backend:
        ipv4_address: 172.20.0.10

  web:
    build:
      context: .
      dockerfile: Dockerfile.python
    container_name: python-web
    <<: [*deploy-skv, *restart]
    depends_on:
      - db
    environment:
      MYSQL_HOST: db
      MYSQL_PORT: 3306
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    networks:
      backend:
        ipv4_address: 172.20.0.5
    ports:
      - "5000:5000"
EOF

# Проверка и вывод запуска контейнеров
docker compose config

# Запуск контейнеров
docker compose up -d

# Вход в базу данных контейнера mysql-db
docker exec -ti \
mysql-db \
mysql -uroot \
-p$(grep "ROOT_PASSWORD" .env \
    | cut -d '"' -f 2) && 

# Вывод таблицы requests базы virtd
show databases; use virtd; show tables; SELECT * from requests LIMIT 60;
```
## для github и gitflic
```bash
git add . \
&& git status

git remote -v

# Создание коммита со всеми изменениями и отправка в удаленные репозиторий
git commit -am 'commit_2, main' \
&& git push --set-upstream origin main \
&& git push --set-upstream study_fops39_gitflic_ru main
```
## Yandex Cloud ВМ
### Подготовка. Создание пары ключей ssh
```bash
mkdir tf
cd !$

# генерация ключа ssh для подключения
ssh-keygen -f \
~/.ssh/id_lab15_5_fops39_ed25519 \
-t ed25519 -C "lab15_5_fops39"

# Выставление прав на пару ключей
chmod 600 ~/.ssh/id_lab15_5_fops39_ed25519
chmod 644 ~/.ssh/id_lab15_5_fops39_ed25519.pub

# включаем агента-ssh
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_lab15_5_fops39_ed25519
```
### cloud-init для проброса публичного ключа
```bash
# Создание формы для заполнения
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

# Добавляем содержимое публичного ключа в cloud-init.yml
sed -i "8s|.*|      - $(cat ~/.ssh/id_lab15_5_fops39_ed25519.pub \
                      | tr -d '\n\r')|" \
cloud-init.yml
```
### Подготовка для работы с yandex cloud
```bash
# Скачиваем скрипт для установки yandex console
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh \
| bash

# для archlinux установка terraform
sudo pacman -Syu \
terraform

# Применение новых переменных окружения в текущей сессии
source \
~/.bashrc

# указываем источник (yandex cloud)
cat > ~/.terraformrc << 'EOF'
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
EOF

# Инициализация Terraform конфигурации
terraform init

# инициализация подключения к уже созданному аккаунту yandex cloud
yc init
```
```bash
# Для вывода Id облака yandex cloud, будет использоваться для взаимодействия с terraform
yc config get cloud-id

# Для вывода Id каталога yandex cloud, будет использоваться для взаимодействия с terraform
yc config get folder-id
```
### Создание TF конфига
#### Описание провайдера для работы с yandex-cloud
```bash
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
#### Описание часто повторяющихся переменных в других файлах .tf
```bash
cat > variables.tf <<'EOF'
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
EOF
```
#### Описание WAN и NAT маршрутизации
```bash
cat > network.tf <<'EOF'
# Общая облачная сеть
resource "yandex_vpc_network" "skv" {
  name = "skv-fops39-${var.lab15_5}"
}

# Подсеть zone D
resource "yandex_vpc_subnet" "skv-locnet-d" {
  name           = "skv-fops-${var.lab15_5}-ru-central1-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["10.10.10.192/26"]
  route_table_id = yandex_vpc_route_table.route.id
}

# Сеть под NAT для исходящего трафика
resource "yandex_vpc_gateway" "nat-gateway" {
  name = "fops-gateway-${var.lab15_5}"
  shared_egress_gateway {}
}

# Шлюз для выхода в WAN
resource "yandex_vpc_route_table" "route" {
  name       = "fops-route-table-${var.lab15_5}"
  network_id = yandex_vpc_network.skv.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat-gateway.id
  }
}
EOF
```
#### Описание security group для публичной сети с разграничением доступа по портам и протоколам
```bash
cat > security_groups.tf <<'EOF'
# Security Group для хоста docker
# Security Group для LAN (внутреннее взаимодействие между сервисами)
resource "yandex_vpc_security_group" "LAN" {
  name       = "LAN-${var.lab15_5}"
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

resource "yandex_vpc_security_group" "host_sg" {
  name       = "host-sg-${var.lab15_5}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить SSH доступ из интернета на порт 22"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Разрешить для проброса доступ из интернета на порт 8090"
    protocol       = "TCP"
    port           = 8090
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
EOF
```
#### Главный файл terraform описания создания виртуальной машины
```bash
cat > vms.tf <<'EOF'
# Данные об образе ОС
data "yandex_compute_image" "ubuntu_2404_lts" {
  family = "ubuntu-2404-lts"
}

# Docker Host
resource "yandex_compute_instance" "docker-host" {
  name        = "docker"
  hostname    = "docker"
  platform_id = "standard-v2"
  zone        = "ru-central1-d"

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
    ssh-keys           = "ubuntu:${file("~/.ssh/id_lab15_5_fops39_ed25519.pub")}"
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.skv-locnet-d.id
    nat        = true
    ip_address = "10.10.10.254"
    security_group_ids = [
      yandex_vpc_security_group.host_sg.id,
      yandex_vpc_security_group.LAN.id
    ]
  }
}

# Файл hosts для проброса скрипта запуска проекта
resource "local_file" "hosts_docker" {
  content  = <<-EOT
    #!/bin/bash
    > ~/.ssh/known_hosts
    # Копирование скрипта запуска лабораторной работы
    rsync -vP -e "ssh \
    -o StrictHostKeyChecking=accept-new \
    -i ~/.ssh/id_lab15_5_fops39_ed25519" \
    lab15_5.sh
    skv@${yandex_compute_instance.docker-host.network_interface.0.nat_ip_address}:~/ \

    # Запуск скрипта выполнения работы
    ssh -t -p 22 \
    -o StrictHostKeyChecking=accept-new \
    -i ~/.ssh/id_lab15_5_fops39_ed25519 \
    skv@${yandex_compute_instance.docker-host.network_interface.0.nat_ip_address} \
    "chmod +x lab15_5.sh \
    && bash -c "./lab15_5.sh""
EOT
  filename = "../hosts_docker.sh"
}

# Файл hosts для проброса скрипта запуска проекта
resource "local_file" "_checker" {
  content  = <<-EOT
    #!/bin/bash
    # Запуск скрипта выполнения работ удаленного контекста
    ssh -t -p 22 \
    -o StrictHostKeyChecking=accept-new \
    -i ~/.ssh/id_lab15_5_fops39_ed25519 \
    skv@${yandex_compute_instance.docker-host.network_interface.0.nat_ip_address} \
    "bash -c "cd /opt/shvirtd-example-python && docker ps -a \
    && docker exec -ti \
    mysql-db \
    mysql -uroot \
    -p$(grep "ROOT_PASSWORD" .env \
        | cut -d '"' -f 2)""
EOT
  filename = "../rem_context_checker.sh"
}
EOF
```
#### Создание Скрипта запуска работы на удаленном сервере
```bash
cat > ../lab15_5.sh <<'EOT'
#!/bin/bash
REPO_URL="https://gitflic.ru/project/shoelacevip12/shvirtd-example-python.git"
TARGET_DIR="/opt/shvirtd-example-python"
DOCKER_COMPOSE_CMD="docker compose"
DOCKER_COMPOSE_FILE="$TARGET_DIR/compose.yaml"

# добавление репозитория docker
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

# Установка docker и и плагинов
sudo apt install -y \
docker-ce \
docker-ce-cli \
containerd.io \
docker-buildx-plugin \
docker-compose-plugin

echo -e "\nсостояние запуска docker:"
sudo systemctl is-active docker

# Клонирование репозитория
if [ -d "$TARGET_DIR" ]; then
    echo "Каталог $TARGET_DIR уже существует. удаляем содержимое..."
    sudo rm -rf "$TARGET_DIR"
    echo "Клонируем репозиторий в $TARGET_DIR..."
    sudo git clone "$REPO_URL" "$TARGET_DIR"
    if [ $? -ne 0 ]; then
        echo "Ошибка: Не удалось клонировать репозиторий."
        exit 1
    fi
else
    echo "Клонируем репозиторий в $TARGET_DIR..."
    sudo git clone "$REPO_URL" "$TARGET_DIR"
    if [ $? -ne 0 ]; then
        echo "Ошибка: Не удалось клонировать репозиторий."
        exit 1
    fi
fi

# Смена владельца папки проекта
sudo chown skv:skv -R \
/opt/shvirtd-example-python

echo "Репозиторий успешно скопирован."

# Проверка наличия файла compose 
if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then
    echo "Ошибка: Файл $DOCKER_COMPOSE_FILE не найден."
    exit 1
fi

echo -e "\nФайл compose.yaml найден."

# Добавление пользователя в группу docker
sudo usermod -aG \
docker \
skv

# Запуск docker docker compose 
echo -e "n\Переходим в каталог $TARGET_DIR и запускаем $DOCKER_COMPOSE_FILE..."
cd "$TARGET_DIR"
$DOCKER_COMPOSE_CMD up -d
if [ $? -ne 0 ]; then
    echo "Ошибка: Не удалось запустить $DOCKER_COMPOSE_FILE"
fi
echo "Лабораторный Проект запущен"
EOT
```
## для github и gitflic
```bash
git add . \
&& git status

git remote -v

# Создание коммита со всеми изменениями и отправка в удаленные репозиторий
git commit -am 'commit_3, main_update2' \
&& git push --set-upstream origin main \
&& git push --set-upstream study_fops39_gitflic_ru main
```
### Запуск ВМ 
```bash
# Проверка tf файлов проекта и создание файла запуска terraform
cd tf
terraform validate \
&& terraform fmt  \
&& terraform init --upgrade \
&& terraform plan -out=tfplan

# Применение файла запуска terraform
terraform apply "tfplan"

# Чистка известных хостов для подключения по ssh
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_lab15_5_fops39_ed25519
cd ..
> ~/.ssh/known_hosts
# Удаленные контексты
./hosts_docker.sh
./rem_context_checker.sh
```
## для github и gitflic
```bash
git add . \
&& git status

git remote -v

# Создание коммита со всеми изменениями и отправка в удаленные репозиторий
git commit -am 'commit_4, main' \
&& git push --set-upstream origin main \
&& git push --set-upstream study_fops39_gitflic_ru main
```
### скачивание через save слои контейнера
```bash
# Скачиваем образ последнего доступного terraform с hub.docker.com
docker pull \
hashicorp/terraform:latest

# Скачиваем и запускам образ dive с указанием на скаченный terraform
docker run -ti --rm -v \
/var/run/docker.sock:/var/run/docker.sock \
wagoodman/dive \
hashicorp/terraform:latest

# Копируем идентификатор слоя расположения terraform слоя COPY 
ba8da9a9f1ceccdea7ffbee7dbd1d76def077e82545afaf6b669ceee89295b18

# Извлекаем образ докера в архив
mkdir tmp
cd !$

docker image save \
-o ./image.tar.gz \
hashicorp/terraform:latest

# распаковка архива
tar xf image.tar.gz

# Ищем все слои кроме того что нужно и удаляем
find . \
-mindepth 3 \
-not -name 'ba8da9a9f1ceccdea7ffbee7dbd1d76def077e82545afaf6b669ceee89295b18' \
-delete

# извлекаем содержимое нужного слоя
tar xf blobs/sha256/ba8da9a9f1ceccdea7ffbee7dbd1d76def077e82545afaf6b669ceee89295b18

file bin/terraform
```
### Копируем по известным путям содержимое каталога контейнера в текущую папку
```bash
docker ps -lq

ll terraform

# создаем контейнер
docker run -ti \
hashicorp/terraform:latest

# Копируем по известным путям содержимое каталога контейнера в текущую папку
docker cp \
"$(docker ps -lq)":/bin/terraform ./

ll terraform
```
## для github и gitflic
```bash
git add . \
&& git status

git remote -v

# Создание коммита со всеми изменениями и отправка в удаленные репозиторий
git commit -am 'commit_5, main' \
&& git push --set-upstream origin main \
&& git push --set-upstream study_fops39_gitflic_ru main
```
### commit_45, master
```bash
cd ~/nfs_git/gited/15_5

git checkout master

git branch -v

git clone \
https://gitflic.ru/project/shoelacevip12/shvirtd-example-python.git

rm -rf \
shvirtd-example-python/.git

mv shvirtd-example-python/README{,_proj}.md

mv shvirtd-example-python/* .

rm -rf \
shvirtd-example-python

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_45, master' \
&& git push --set-upstream study_fops39 master \
&& git push --set-upstream study_fops39_gitflic_ru master
```