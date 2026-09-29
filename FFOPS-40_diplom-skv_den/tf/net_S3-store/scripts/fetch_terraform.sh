#!/usr/bin/env bash
# Доставка bin-файла Terraform: registry-first, кэш в registry.
# env: TF_VERSION (обязателен), PACKAGE_TOKEN (fallback TOKEN),
#      FORGEJO_URL, PACKAGE_OWNER, PACKAGE_NAME (опционально).
set -euo pipefail

TF_VERSION="${TF_VERSION:?TF_VERSION не задан}"
FORGEJO_URL="${FORGEJO_URL:-http://10.8.0.1:3000}"
PACKAGE_OWNER="${PACKAGE_OWNER:-diplom}"
PACKAGE_NAME="${PACKAGE_NAME:-terraform-bin}"

FILE="terraform_${TF_VERSION}_linux_amd64.zip"
reg_url="${FORGEJO_URL}/api/packages/${PACKAGE_OWNER}/generic/${PACKAGE_NAME}/${TF_VERSION}/${FILE}"

AUTH=()
if [ -n "${PACKAGE_TOKEN:-}" ]; then
  AUTH=(-u "oauth2:${PACKAGE_TOKEN}")
elif [ -n "${TOKEN:-}" ]; then
  AUTH=(-u "oauth2:${TOKEN}")
fi

if curl -fsSL "${AUTH[@]}" "$reg_url" -o /tmp/tf.zip 2>/dev/null; then
  echo "REG  terraform ${TF_VERSION} (Package Registry)"
else
  rm -f /tmp/tf.zip
  curl -fSL --retry 3 \
    "https://hashicorp-releases.yandexcloud.net/terraform/${TF_VERSION}/${FILE}" \
    -o /tmp/tf.zip
  echo "NET  terraform ${TF_VERSION} (yandex mirror)"
  curl -sfS -X PUT "${AUTH[@]}" "$reg_url" --upload-file /tmp/tf.zip >/dev/null 2>&1 \
    && echo "UPL  terraform ${TF_VERSION} (кэш в registry)" \
    || echo "WARN terraform ${TF_VERSION} (не закэширован)"
fi
test -s /tmp/tf.zip