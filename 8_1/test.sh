#!/bin/bash

# Random Password Generator
generate_password() {
    local length=${1:-12}
    tr -dc 'A-Za-z0-9!@#$%^&*()' < /dev/urandom | head -c "$length"
    echo
}

# Вызов функции с длиной пароля (по умолчанию 12)
generate_password "$@"
