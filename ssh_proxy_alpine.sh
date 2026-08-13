echo "Подключение к развернотому VPC в Нидерландах"
export IP=xxx.xxx.xxx.xxx
ssh root@$IP

echo "Обновление и установка Openssh для alpine"
apk update && apk upgrade
apk add openssh openrc
# Включаем sshd демон
rc-update add sshd default
rc-service sshd start
exit

echo "генерация пары ssh ключей на локальной машине"
ssh-keygen -t ed25519 -C "ssh_proxy_Netherlands" -f ~/.ssh/id_ed25519 -N ""

echo "отправка публичного ключа на VPC в Нидерландах и подключение по ключу"
ssh-copy-id -i ~/.ssh/id_ed25519.pub root@$IP
ssh -i ~/.ssh/id_ed25519 root@$IP

echo 'backup оригинального конфига ssh, замена на конфиг для проброса трафика и отключение ввода по паролю для alpine'
mv /etc/ssh/sshd_config{,.bak}
cat > /etc/ssh/sshd_config << 'EOF'
#       $OpenBSD: sshd_config,v 1.105 2024/12/03 14:12:47 dtucker Exp $
#
# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.
#
# This sshd was compiled with PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
#
# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.
#
# Include configuration snippets before processing this file to allow the
# snippets to override directives set in this file.
Include /etc/ssh/sshd_config.d/*.conf

#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile      .ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to "no" here!
#PasswordAuthentication yes
PasswordAuthentication no
#PermitEmptyPasswords no

# Change to "no" to disable keyboard-interactive authentication.  Depending on
# the system's configuration, this may involve passwords, challenge-response,
# one-time passwords or some combination of these and other methods.
#KbdInteractiveAuthentication yes
KbdInteractiveAuthentication no

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin prohibit-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
#UsePAM no

#AllowAgentForwarding yes
# Feel free to re-enable these if your use case requires them.
#AllowTcpForwarding no
AllowTcpForwarding yes
#GatewayPorts no
GatewayPorts yes
#X11Forwarding no
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
PrintMotd no
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem       sftp    /usr/lib/ssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server
EOF
rc-service sshd restart
exit

echo "создание OpenRC службы на подключение к туннелю в Нидерландах на УДАЛЁННОЙ машине"
cat > /etc/init.d/ssh-tunnel << 'EOF'
#!/sbin/openrc-run

name="ssh-tunnel"
description="SSH SOCKS туннель в Нидерланды"
command="/usr/bin/ssh"
command_args="-v -D 0.0.0.0:1080 -N \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  -o TCPKeepAlive=yes \
  -o StrictHostKeyChecking=accept-new \
  -o UserKnownHostsFile=${RC_SSH_KEYS_DIR:-/home/${RC_SVCUSER:-root}/.ssh}/known_hosts \
  -i ${RC_SSH_KEYS_DIR:-/home/${RC_SVCUSER:-root}/.ssh}/id_ed25519 \
  ${RC_SSH_LOGIN:-root}@${IP}"
command_background="yes"
pidfile="/run/${RC_SVCNAME}.pid"
command_user="${RC_SVCUSER:-root}"

depend() {
    need net
    after firewall
}
EOF
chmod +x /etc/init.d/ssh-tunnel
# Указываем IP в переменной окружения службы
sed -i "s/\${IP}/${IP}/" /etc/init.d/ssh-tunnel

# Если служба ранее запускалась и упала (crashed), сбросить состояние
rc-service ssh-tunnel zap

echo "добавляем службу в автозагрузку и запускаем через rc-update/rc-service"
rc-update add ssh-tunnel default
rc-service ssh-tunnel start

echo 'создание алиас-команды для запуска/отключения прокси для alpine (клиент)'
cat >> ~/.profile << 'EOF'
alias pr_ssh='source ~/proxy_socks_alpine.sh'
EOF

echo "создание скрипта на подключение к туннелю в Нидерландах с УДАЛЁННОЙ машины (alpine)"
cat > ~/proxy_socks_alpine.sh << 'EOF'
#!/bin/ash

# ============================================================================
#  proxy_socks_alpine.sh  —  клиент для РАБОТЫ С УДАЛЁННОЙ МАШИНЫ
#
#  Этот скрипт запускается НА УДАЛЁННОМ КЛИЕНТЕ (не на сервере!).
#  Он поднимает ЛОКАЛЬНЫЙ SSH SOCKS-туннель до сервера, где крутится
#  служба ssh-tunnel, и использует его как прокси.
#
#  Управление происходит через переменные ниже.
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

# Функция для включения прокси (поднимаем локальный туннель до сервера)
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
            rm -f "$SSH_PID"
        else
            rm -f "$SSH_PID"
        fi
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

echo "Готово! Управление туннелем с УДАЛЁННОЙ машины: pr_ssh"
echo ""
echo "======================================================================="
echo " ВАЖНО: этот скрипт настраивает УДАЛЁННЫЙ КЛИЕНТ (не сам сервер!)"
echo "======================================================================="
echo "Служба ssh-tunnel на сервере по умолчанию слушает 0.0.0.0:1080"
echo "машин. Поэтому клиентский скрипт (~/proxy_socks_alpine.sh) поднимает"
echo "СВОЙ локальный SSH SOCKS-туннель до сервера командой:"
echo "    ssh -f -N -D 1080 sss@xxx.xxx.xxx.xxx"
echo "и использует его как локальный прокси socks5://localhost:1080."
echo ""
echo "ОБРАТИТЕ ВНИМАНИЕ на настройки TUNNEL_HOST/TUNNEL_USER/TUNNEL_KEY"
echo "в начале ~/proxy_socks_alpine.sh — замените их на свои реальные!"
echo ""
echo "Если вы хотите, чтобы служба ssh-tunnel на сервере слушала НА ВСЕХ"
echo "интерфейсах (тогда клиент мог бы обращаться напрямую к IP:1080),"
echo "измените в /etc/init.d/ssh-tunnel:  -D 0.0.0.0:1080"
echo "НО это открывает прокси всей локальной сети — не рекомендуется."
echo "======================================================================="

echo ""
echo "======================================================================="
echo " ОПИСАНИЕ НАСТРОЕК /etc/ssh/sshd_config (Alpine OpenRC)"
echo "======================================================================="
echo "Файл sshd_config полностью перезаписан с реальным содержимым текущего"
echo "конфига. Ниже пояснение всех некомментированных (активных) директив,"
echo "важных для проброса трафика:"
echo ""
echo "  Include /etc/ssh/sshd_config.d/*.conf"
echo "      Подключение дополнительных конфиг-сниппетов (могут переопределять"
echo "      директивы из основного файла)."
echo ""
echo "  AuthorizedKeysFile .ssh/authorized_keys"
echo "      Файл, куда ssh-copy-id кладёт публичный ключ для входа по ключу."
echo ""
echo "  PasswordAuthentication no"
echo "      Отключает вход по паролю (только ключи). Согласуется с туннелем,"
echo "      который подключается через -i ~/.ssh/id_ed25519."
echo ""
echo "  KbdInteractiveAuthentication no"
echo "      Отключает keyboard-interactive аутентификацию (вариант пароля)."
echo ""
echo "  AllowTcpForwarding yes"
echo "      РАЗРЕШАЕТ TCP-проброс - критично для работы SSH SOCKS туннеля"
echo "      (-D 1080). Без этой директивы проброс заблокирован."
echo ""
echo "  GatewayPorts yes"
echo "      Разрешает слушать внешние интерфейсы для переадресованных портов."
echo ""
echo "  X11Forwarding yes"
echo "      Разрешает X11-проброс (GUI-приложения через SSH)."
echo ""
echo "  PrintMotd no"
echo "      Отключает вывод MOTD (баннера входа)."
echo ""
echo "  Subsystem sftp /usr/lib/ssh/sftp-server"
echo "      SFTP-подсистема (правильный путь для Alpine)."
echo ""
echo "Оставшиеся директивы оставлены в закомментированном виде с их"
echo "значениями по умолчанию, т.к. они не мешают работе туннеля и это"
echo "стандартный вид дефолтного конфига OpenSSH."
echo ""
echo "-----------------------------------------------------------------------"
echo " ДИАГНОСТИКА: служба имеет статус 'crashed'"
echo "-----------------------------------------------------------------------"
echo "Основная причина: при первом подключении ssh спрашивает"
echo "    'Are you sure you want to continue connecting (yes/no)?'"
echo "так как хост ещё не добавлен в known_hosts. В фоне служба не может"
echo "ответить на вопрос и падает (crashed)."
echo ""
echo "Решение (уже добавлено в init-скрипт):"
echo "  -o StrictHostKeyChecking=accept-new"
echo "      Автоматически принимает ключ хоста при первом подключении"
echo "      и сохраняет его в known_hosts."
echo "  -o UserKnownHostsFile=/home/USER/.ssh/known_hosts"
echo "      Указывает файл known_hosts для пользователя command_user."
echo ""
echo "Дополнительно добавлено 'rc-service ssh-tunnel zap' перед запуском,"
echo "чтобы сбросить ошибочное состояние 'crashed' после правки init-скрипта."
echo ""
echo "Другие возможные причины crashed:"
echo "  - Неверный путь до приватного ключа (-i)"
echo "  - Недостаточно прав у пользователя command_user на чтение ключа"
echo "  - Ошибка аутентификации на удалённом сервере (ключ не в authorized_keys)"
echo "  - Проверка логов: tail -f /var/log/messages | grep ssh-tunnel"
echo ""
echo "ВАЖНО: конфигурируемые переменные init-скрипта ssh-tunnel:"
echo "  RC_SVCUSER  - локальный пользователь, от имени которого работает ssh"
echo "                (по умолчанию root). Пример: RC_SVCUSER=ssss"
echo "  RC_SSH_LOGIN- пользователь на удалённом сервере"
echo "                (по умолчанию root)."
echo "  RC_SSH_KEYS_DIR - каталог с ключами (по умолчанию"
echo "                /home/USER/.ssh). Полезно, если ключи лежат в"
echo "                /root/.ssh или другом кастомном месте."
echo "  IP          - адрес удалённого сервера (подставляется через sed)."
echo ""
echo "Проверка вручную, как это делает служба:"
echo "  su - USER -s /bin/sh -c 'ssh -v -D 1080 -N ... -i КЛЮЧ LOGIN@IP'"
echo "  Пример неудачной аутентификации (Permission denied) означает, что"
echo "  публичный ключ не добавлен в authorized_keys на удалённом сервере:"
echo "    ssh-copy-id -i ~/.ssh/id_ed25519.pub LOGIN@IP"
echo ""
echo "ТИПОВОЙ СЦЕНАРИЙ (проверен на реальном Alpine-хосте):"
echo "  Ключ лежит в /home/sssss/.ssh/ и публичный ключ добавлен в"
echo "  /home/ssss/.ssh/authorized_keys на сервере. Тогда в init-скрипте:"
echo "      command_user=ssss"
echo "      command_args=\"... -i /home/ssss/.ssh/id_shoelst_2026_ed25519 \\"
echo "        ssss@IP\""
echo "  КРИТИЧНО: LOGIN@IP должен совпадать с пользователем, для которого"
echo "  положен ключ. Если заходить как root - ключ должен быть в"
echo "  /root/.ssh/authorized_keys. Несовпадение даёт Permission denied"
echo "  и статус 'crashed'. В новой версии скрипта это настраивается"
echo "  переменной RC_SSH_LOGIN (или RC_SSH_KEYS_DIR для каталога ключей)."
echo "======================================================================="