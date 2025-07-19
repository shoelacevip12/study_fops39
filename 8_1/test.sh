#!/bin/bash

# Random Password Generator
generate_password() {
    local length=${1:-12}
    tr -dc 'A-Za-z0-9!@#$%^&*()' < /dev/urandom | head -c "$length"
    echo
}

# Интерактивная взаимодействие
echo "-------------------"
echo "Генерация случайного пароля"
echo -n "Введите длину пароля (по умолчанию 12): "
read -r length
echo "Ваш сгенерированный пароль: $(generate_password "$length")";