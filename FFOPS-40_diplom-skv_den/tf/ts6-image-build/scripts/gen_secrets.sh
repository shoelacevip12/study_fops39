#!/usr/bin/env bash
# Генерация секретов для .env (JWT_SECRET, ENCRYPTION_KEY, TS6_QUERY_ADMIN_PASSWORD)
# Использование: bash scripts/gen_secrets.sh
set -euo pipefail

echo "JWT_SECRET=$(openssl rand -hex 32)"
echo "ENCRYPTION_KEY=$(openssl rand -hex 32)"
echo "TS6_QUERY_ADMIN_PASSWORD=$(openssl rand -base64 18 | tr -dc 'A-Za-z0-9' | head -c 24)"