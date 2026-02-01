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

# Добавление пользователя в группу docker
sudo usermod -aG \
docker \
skv

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

echo -e \
"\nФайл compose.yaml найден."

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