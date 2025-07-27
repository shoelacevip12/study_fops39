echo "Подключение к развернотому VPC в Нидерландах" 
IP=xxx.xxx.xxx.xxx
ssh root@$IP

echo "Обновление и установка Openssh для ubuntu"
sudo apt update && sudo apt upgrade -y
sudo apt install openssh-server -y
exit

echo "генерация пары ssh ключей на локальной машине"
ssh-keygen -t ed25519 -C "ssh_proxy_Netherlands"
~/.ssh/ssh_id_ed25519

echo "отправка отправка публичного ключа на VPC в Нидерландах и подключение по ключу"
ssh-copy-id -i ~/.ssh/ssh_id_ed25519.pub root@$IP
ssh -i ~/.ssh/ssh_id_ed25519 root@$IP

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

echo "создание systemd службы на подключение к туннелю в Нидерландах на локально машине"
cat > ~/.config/systemd/user/ssh-tunnel.service << 'EOF'
[Unit]
Description=SSH SOCKS туннель в Нидерланды
After=network.target

[Service]
Type=simple
Environment="TERM=xterm"
Environment="HOME=%h"
Environment="IP=xxx.xxx.xxx.xxx"
ExecStart=/usr/bin/ssh -v -D 1080 -N \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  -o TCPKeepAlive=yes \
  -i /home/%u/.ssh/ssh_id_ed25519 \
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

echo "создание скрипта на подключение к туннелю в Нидерландах на локально машине"
cat > ~/proxy_socks.sh << 'EOF'
#!/bin/bash

# Проверяем установлен ли curl
if ! command -v curl &> /dev/null; then
    echo "Ошибка: curl не установлен. Установите curl для работы скрипта." >&2
    exit 1
fi

# Функция проверки IP
check_ip() {
    echo -n "Текущий IP: "
    curl -s -m 5 --retry 1 2ip.ru || echo "Не удалось определить IP"
    echo
}

# Функция для включения прокси
enable_proxy() {
    echo -n "Включаем SSH-туннель... "
    if systemctl --user enable --now ssh-tunnel.service; then
        export ALL_PROXY="socks5://localhost:1080"
        echo "Успешно! ALL_PROXY установлен."
        echo "Проверяем работу прокси..."
        for d in $(seq 0 25 100); do 
        echo "$d% - подготовка к запуску"  && sleep 1 ; 
        done
        check_ip
        return 0
    else
        echo "Ошибка включения сервиса!" >&2
        return 1
    fi
}

# Функция для выключения прокси
disable_proxy() {
    echo -n "Выключаем SSH-туннель... "
    unset ALL_PROXY
    if systemctl --user disable --now ssh-tunnel.service; then
        echo "Успешно! ALL_PROXY удалён."
        echo "Проверяем прямое подключение..."
        for d in $(seq 0 50 100); do 
        echo "$d% - выключаем туннель"  && sleep 1 ; 
        done
        check_ip
        return 0
    else
        echo "Ошибка выключения сервиса!" >&2
        return 1
    fi
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
