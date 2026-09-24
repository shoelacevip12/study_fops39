#!/bin/bash
# Установка forgejo-runner ВНУТРИ LXC-контейнера ci-runner.
# Джобы исполняются ПРЯМО в контейнере (метки ubuntu/self-hosted, без docker://).
# Запускать как root внутри контейнера:
#   ssh root@192.168.89.20   (или: sudo virsh console ci-runner)
#   RUNNER_UUID=<uuid> RUNNER_TOKEN=<token> bash /root/setup_runner_inside.sh
#
# uuid/token: forgejo -> Admin -> Actions -> Runners -> Create registration token
#
# Terraform/kubectl здесь НЕ устанавливаются: их ставит сам workflow
# (шаг «Установка Terraform» - зеркало
# hashicorp-releases.yandexcloud.net). python3 нужен шагу «Подготовка секретов»
# для проверки ~/.authorized_key.json.

set -euo pipefail

RUNNER_VER=${RUNNER_VER:-13.2.0}
: "${RUNNER_UUID:?задайте RUNNER_UUID (forgejo: Create registration token)}"
: "${RUNNER_TOKEN:?задайте RUNNER_TOKEN}"

echo "==> Пакеты ALT Linux"
apt-get update -qq
apt-get install -y -qq git bash curl ca-certificates unzip python3 iproute2

echo "==> forgejo-runner v${RUNNER_VER}"
if ! command -v forgejo-runner >/dev/null; then
  curl -fsSL "https://code.forgejo.org/forgejo/runner/releases/download/v${RUNNER_VER}/forgejo-runner-${RUNNER_VER}-linux-amd64" \
    -o /usr/local/bin/forgejo-runner
  chmod +x /usr/local/bin/forgejo-runner
fi
forgejo-runner --version

echo "==> Конфиг runner: прямые метки (без docker://)"
mkdir -p /etc/forgejo-runner
cat > /etc/forgejo-runner/runner-config.yml <<EOF
runner:
  labels: ["ubuntu", "self-hosted"]
server:
  connections:
    forgejo:
      url: http://10.8.0.1:3000/
      uuid: ${RUNNER_UUID}
      token: ${RUNNER_TOKEN}
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
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now forgejo-runner
systemctl --no-pager status forgejo-runner || true

echo
echo "Проверки:"
echo "  curl -s http://10.8.0.1:3000/            # доступность forgejo"
echo "  ip route                                  # должен быть маршрут 10.8.0.0/24 via 192.168.89.193"
echo "  journalctl -u forgejo-runner -f           # 'declared successfully' = подключён"
echo "В forgejo (Admin -> Actions -> Runners) runner появится с метками ubuntu/self-hosted."
echo "Workflow tf-репозиториев используют runs-on: ubuntu - джобы уйдут на этот runner."