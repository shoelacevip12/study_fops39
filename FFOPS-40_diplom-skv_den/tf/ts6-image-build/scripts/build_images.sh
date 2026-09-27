#!/usr/bin/env bash
# Сборка 4 образов стека ts6 с вшитым .env (ARG/ENV) и публикация в Forgejo CR.
# Использование: bash scripts/build_images.sh [tag]  (tag по умолчанию: latest)
set -euo pipefail

TAG="${1:-latest}"
REGISTRY="${REGISTRY:-10.8.0.1:3000}"
OWNER="${OWNER:-diplom}"

# Единый источник build-args — .env
set -a
# shellcheck disable=SC1091
source ./.env
set +a

build_and_push() {
  local name="$1" dockerfile="$2"
  local ref="${REGISTRY}/${OWNER}/${name}:${TAG}"
  echo "==> build ${ref} (${dockerfile})"
  docker build \
    --build-arg JWT_SECRET="${JWT_SECRET:-}" \
    --build-arg ENCRYPTION_KEY="${ENCRYPTION_KEY:-}" \
    --build-arg FRONTEND_URL="${FRONTEND_URL:-http://localhost:3000}" \
    --build-arg SIDECAR_URL="${SIDECAR_URL:-http://sidecar:9800}" \
    --build-arg TSSERVER_QUERY_ADMIN_PASSWORD="${TSSERVER_QUERY_ADMIN_PASSWORD:-}" \
    -f "${dockerfile}" \
    -t "${ref}" \
    .
  docker push "${ref}"
}

build_and_push teamspeak6-server Dockerfile.teamspeak6
build_and_push ts6-backend      Dockerfile.backend
build_and_push ts6-sidecar      Dockerfile.sidecar
build_and_push ts6-frontend     Dockerfile.frontend

echo "OK: все образы опубликованы в ${REGISTRY}/${OWNER} (tag=${TAG})"