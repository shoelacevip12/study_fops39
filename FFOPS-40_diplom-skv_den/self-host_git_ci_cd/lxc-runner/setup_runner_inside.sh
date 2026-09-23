#!/bin/bash
# Установка forgejo-runner и инструментов джоб ВНУТРИ LXC-контейнера ci-runner.
# Запускать как root внутри контейнера:
#   sudo virsh console ci-runner    (или ssh root@192.168.89.20)
#   bash /root/setup_runner_inside.sh
# Перед запуском задать RUNNER_UUID/RUNNER_TOKEN (из forgejo: Admin -> Actions ->
# Create registration token), либо заполнить их потом в /etc/forgejo-runner/runner-config.yml.

set -euo pipefail

echo "==> Базовые пакеты (ALT Linux)"
apt-get update -qq
apt-get install -y -qq git bash curl ca-certificates unzip iproute2

echo "==> forgejo-runner"
RUNNER_VER=${RUNNER_VER:-13.2.0}
if ! command -v forgejo-runner >/dev/null; then
  curl -fsSL "https://code.forgejo.org/forgejo/runner/releases/download/v${RUNNER_VER}/forgejo-runner-${RUNNER_VER}-linux-amd64" \
    -o /usr/local/bin/forgejo-runner
  chmod +x /usr/local/bin/forgejo-runner
fi
forgejo-runner --version

echo "==> Инструменты джоб (terraform, kubectl)"
if ! command -v terraform >/dev/null; then
  curl -fsSL "https://hashicorp-releases.yandexcloud.net/terraform/1.16.4/terraform_1.16.4_linux_amd64.zip" -o /tmp/tf.zip
  unzip -o /tmp/tf.zip -d /usr/local/bin && rm -f /tmp/tf.zip
fi
if ! command -v kubectl >/dev/null; then
  curl -fsSL "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl
fi

echo "==> Конфиг runner (labels БЕЗ docker:// — джобы выполняются прямо в контейнере)"
mkdir -p /etc/forgejo-runner
cat > /etc/forgejo-runner/runner-config.yml <<EOF
runner:
  labels: ["ubuntu", "self-hosted"]
server:
  connections:
    forgejo:
      url: http://10.8.0.1:3000/
      uuid: ${RUNNER_UUID:-REPLACE_UUID}
      token: ${RUNNER_TOKEN:-REPLACE_TOKEN}
EOF

echo "==> systemd unit"
cat > /etc/systemd/system/forgejo-runner.service <<'EOF'
[Unit]
Description=Forgejo Runner
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/forgejo-runner daemon --config /etc/forgejo-runner/runner-config.yml
Restart=always
RestartSec=5
# джобы исполняются от этого пользователя (настройте под себя)
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now forgejo-runner
systemctl status forgejo-runner --no-pager || true

echo
echo "Проверки:"
echo "  curl -s http://10.8.0.1:3000/            # доступность forgejo"
echo "  ip route                                  # должен быть маршрут 10.8.0.0/24 via 192.168.89.193"
echo "  journalctl -u forgejo-runner -f           # 'declared successfully' = подключён"
echo "В forgejo (Admin -> Actions -> Runners) runner должен появиться с метками ubuntu/self-hosted."