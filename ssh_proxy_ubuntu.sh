echo "Подключение к развернотому VPC в Нидерландах"
export IP=xxx.xxx.xxx.xxx
ssh root@$IP

echo "Обновление и установка Openssh для ubuntu"
sudo apt update && sudo apt upgrade -y
sudo apt install openssh-server -y
exit

echo "генерация пары ssh ключей на локальной машине"
ssh-keygen -t ed25519 -C "ssh_proxy_Netherlands" -f ~/.ssh/id_ed25519 -N ""

echo "отправка отправка публичного ключа на VPC в Нидерландах и подключение по ключу"
ssh-copy-id -i ~/.ssh/id_ed25519.pub root@$IP
ssh -i ~/.ssh/id_ed25519 root@$IP

echo 'backup оригинального конфига ssh, замена на конфиг для проброса трафика и отключение ввода по паролю для ubuntu'
sudo mv /etc/ssh/sshd_config{,.bak}
sudo cat > /etc/ssh/sshd_config << 'EOF'
Include /etc/ssh/sshd_config.d/*.conf
PermitRootLogin yes
PasswordAuthentication no
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
AllowTcpForwarding yes
GatewayPorts yes
X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp  /usr/lib/openssh/sftp-server
EOF
sudo systemctl restart ssh
exit

echo "создание systemd службы на подключение к туннелю в Нидерландах на УДАЛЁННОЙ машине"
cat > ~/.config/systemd/user/ssh-tunnel.service << EOF
[Unit]
Description=SSH SOCKS туннель в Нидерланды
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
Environment="TERM=xterm"
Environment="HOME=%h"
ExecStart=/usr/bin/ssh -v -D 0.0.0.0:1080 -N \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  -o TCPKeepAlive=yes \
  -i /home/%u/.ssh/id_ed25519 \
  root@$IP
Restart=always
RestartSec=10
MemoryLimit=100M

[Install]
WantedBy=default.target
EOF

echo 'создание алиас-команды для запуска\отключения прокси и небольшой фикс для запуска службы на arch'
cat >> ~/.bashrc << 'EOF'
alias pr_ssh='source ~/proxy_socks.sh'

# Fix for systemd user services
if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
    export DBUS_SESSION_BUS_ADDRESS=unix:path=${XDG_RUNTIME_DIR}/bus
fi
EOF

echo "создание скрипта на подключение к туннелю в Нидерландах с УДАЛЁННОЙ машины"
cat > ~/proxy_socks.sh << 'EOF'
#!/bin/bash

# ============================================================================
#  proxy_socks.sh  —  клиент для РАБОТЫ С УДАЛЁННОЙ МАШИНЫ
#
#  Этот скрипт запускается НА УДАЛЁННОМ КЛИЕНТЕ (не на сервере !).
#  Он поднимает ЛОКАЛЬНЫЙ SSH SOCKS-туннель до сервера, где крутится
#  служба ssh-tunnel, и использует его как прокси.
# ============================================================================

# --- Настройки (замените на свои) ------------------------------------------
TUNNEL_HOST="xxx.xxx.xxx.xxx"        # адрес сервера, где живёт ssh-tunnel
TUNNEL_USER="ssss"                 # пользователь на TUNNEL_HOST
TUNNEL_KEY="$HOME/.ssh/id_shoelst_2026_ed25519"  # путь до приватного ключа
TUNNEL_PORT="1080"                  # локальный порт SOCKS-прокси
# ----------------------------------------------------------------------------

# Проверяем установлен ли ssh
if ! command -v ssh > /dev/null 2>&1; then
    echo "Ошибка: ssh не установлен. Установите openssh-client." >&2
    exit 1
fi
# Проверяем установлен ли curl
if ! command -v curl > /dev/null 2>&1; then
    echo "Ошибка: curl не установлен. Установите curl для работы скрипта." >&2
    exit 1
fi

# PID-файл локального туннеля
SSH_PID="$HOME/.ssh-tunnel-client.pid"

# Функция проверки IP
check_ip() {
    echo -n "Текущий IP: "
    curl -s -m 5 --retry 1 2ip.ru || echo "Не удалось определить IP"
    echo
}

# Функция для включения прокси (поднимаем локальный туннель до удаленного)
enable_proxy() {
    # Если туннель уже поднят — не запускаем второй раз
    if [ -f "$SSH_PID" ] && kill -0 "$(cat "$SSH_PID")" 2>/dev/null; then
        echo "SSH-туннель уже запущен (pid $(cat "$SSH_PID"))."
        export ALL_PROXY="socks5://localhost:$TUNNEL_PORT"
        echo "ALL_PROXY установлен."
        check_ip
        return 0
    fi

    echo -n "Поднимаем локальный SSH-туннель до $TUNNEL_HOST... "
    ssh -f -N -D "$TUNNEL_PORT" \
        -o ExitOnForwardFailure=yes \
        -o ServerAliveInterval=30 \
        -o ServerAliveCountMax=3 \
        -o TCPKeepAlive=yes \
        -o StrictHostKeyChecking=accept-new \
        -o UserKnownHostsFile="$HOME/.ssh/known_hosts" \
        -i "$TUNNEL_KEY" \
        -p 22 \
        "$TUNNEL_USER@$TUNNEL_HOST"

    if [ $? -ne 0 ]; then
        echo "Ошибка: не удалось поднять туннель." >&2
        return 1
    fi

    # ssh -f -N не отдаёт PID напрямую; находим его через pgrep
    PID=$(pgrep -f "ssh -f -N -D $TUNNEL_PORT" | head -n1)
    if [ -n "$PID" ]; then
        echo "$PID" > "$SSH_PID"
    fi

    echo "Успешно!"
    export ALL_PROXY="socks5://localhost:$TUNNEL_PORT"
    echo "ALL_PROXY установлен."
    echo "Проверяем работу прокси..."
    if curl -s -m 10 -x "socks5://localhost:$TUNNEL_PORT" https://2ip.ru > /dev/null; then
        check_ip
        return 0
    else
        echo "Туннель не работает, прокси не установлен." >&2
        unset ALL_PROXY
        disable_proxy
        return 1
    fi
}

# Функция для выключения прокси (гасим локальный туннель)
disable_proxy() {
    echo -n "Выключаем SSH-туннель... "
    unset ALL_PROXY
    if [ -f "$SSH_PID" ]; then
        PID=$(cat "$SSH_PID")
        if kill -0 "$PID" 2>/dev/null; then
            kill "$PID"
        fi
        rm -f "$SSH_PID"
        echo "Успешно! ALL_PROXY удалён."
    else
        # fallback: гасим по имени процесса
        pkill -f "ssh -f -N -D $TUNNEL_PORT" 2>/dev/null
        echo "Успешно! ALL_PROXY удалён."
    fi
    echo "Проверяем прямое подключение..."
    check_ip
    return 0
}

# Меню выбора
PS3="Выберите действие (1-3): "
options=(
    "Включить SSH-туннель и установить прокси"
    "Выключить SSH-туннель и удалить прокси"
    "Выход"
)

select opt in "${options[@]}"; do
    case $REPLY in
        1) enable_proxy; break;;
        2) disable_proxy; break;;
        3) echo "Выход"; exit 0;;
        *) echo "Неправильный выбор, попробуйте снова";;
    esac
done
EOF

echo ""
echo "======================================================================="
echo " ВАЖНО: оба скрипта теперь настраивают УДАЛЁННЫЙ КЛИЕНТ"
echo "======================================================================="
echo "Служба ssh-tunnel на сервере по умолчанию слушает только loopback"
echo "(127.0.0.1:1080) — к ней НЕЛЬЗЯ обратиться напрямую с других машин."
echo ""
echo "Поэтому клиентский скрипт (~/proxy_socks.sh) поднимает СВОЙ локальный"
echo "SSH SOCKS-туннель до сервера командой:"
echo "    ssh -f -N -D 1080 ssss@xxx.xxx.xxx.xxx"
echo "и использует его как локальный прокси socks5://localhost:1080."
echo ""
echo "ОБРАТИТЕ ВНИМАНИЕ на настройки TUNNEL_HOST/TUNNEL_USER/TUNNEL_KEY"
echo "в начале ~/proxy_socks.sh — замените их на свои реальные!"
echo ""
echo "Если хотите, чтобы служба ssh-tunnel на сервере слушала НА ВСЕХ"
echo "интерфейсах (тогда клиент мог бы обращаться напрямую к IP:1080),"
echo "измените в unit-файле:  -D 0.0.0.0:1080"
echo "НО это открывает прокси всей локальной сети — не рекомендуется."
echo ""
echo "Аналог для Alpine Linux (OpenRC): ssh_proxy_alpine.sh"
echo "  - Скрипт прокси: ~/proxy_socks_alpine.sh, алиас pr_ssh в ~/.profile"
echo "  - Управление происходит без systemd — локальный туннель гасится/поднимается"
echo "    напрямую (ssh -f -N -D), поэтому OpenRC/systemd не требуется на клиенте."
echo "======================================================================="
