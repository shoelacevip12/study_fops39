#!/usr/bin/env bash
# Доставка артефактов роли k3s_cluster в roles/k3s_cluster/files/.
# По порядку приоритета для каждого файла:
#   1) файл уже на месте -> пропустить;
#   2) Forgejo Package Registry -> скачивание;
#   3) upstream -> скачивание + кэш в registry.
#
# env: PACKAGE_TOKEN (глобальный PAT со скоупом write:package;),
#      FORGEJO_URL, PACKAGE_OWNER, PACKAGE_NAME, PACKAGE_VERSION.
set -euo pipefail

DEST="roles/k3s_cluster/files"
FORGEJO_URL="${FORGEJO_URL:-http://10.8.0.1:3000}"
PACKAGE_OWNER="${PACKAGE_OWNER:-diplom}"
PACKAGE_NAME="${PACKAGE_NAME:-k3s-artifacts}"
PACKAGE_VERSION="${PACKAGE_VERSION:-v1}"

declare -A SRC=(
  ["calico.yaml"]="https://raw.githubusercontent.com/projectcalico/calico/v3.32.2/manifests/calico.yaml"
  ["k3s"]="https://github.com/k3s-io/k3s/releases/latest/download/k3s"
  ["kubectl-calico"]="https://github.com/projectcalico/calico/releases/latest/download/calicoctl-linux-amd64"
  ["cni-plugins-linux-amd64.tgz"]="https://github.com/containernetworking/plugins/releases/download/v1.9.1/cni-plugins-linux-amd64-v1.9.1.tgz"
  ["helm.tar.gz"]="https://get.helm.sh/helm-v4.3.0-linux-amd64.tar.gz"
  ["ingress-nginx.yaml"]="https://raw.githubusercontent.com/kubernetes/ingress-nginx/refs/heads/main/deploy/static/provider/baremetal/deploy.yaml"
)

AUTH=()
if [ -n "${PACKAGE_TOKEN:-}" ]; then
  AUTH=(-u "oauth2:${PACKAGE_TOKEN}")
elif [ -n "${TOKEN:-}" ]; then
  AUTH=(-u "oauth2:${TOKEN}")
fi

mkdir -p "$DEST"

for f in "${!SRC[@]}"; do
  if [ -s "$DEST/$f" ]; then
    echo "SKIP $f (уже есть)"
    continue
  fi
  reg_url="${FORGEJO_URL}/api/packages/${PACKAGE_OWNER}/generic/${PACKAGE_NAME}/${PACKAGE_VERSION}/${f}"
  if curl -fsSL "${AUTH[@]}" "$reg_url" -o "$DEST/$f" 2>/dev/null; then
    echo "REG  $f (Package Registry)"
  else
    rm -f "$DEST/$f"
    curl -fSL --retry 3 "${SRC[$f]}" -o "$DEST/$f"
    echo "NET  $f (upstream)"
    curl -sfS -X PUT "${AUTH[@]}" "$reg_url" --upload-file "$DEST/$f" >/dev/null 2>&1 \
      && echo "UPL  $f (кэш в registry)" \
      || echo "WARN $f (не закэширован в registry)"
  fi
  test -s "$DEST/$f"
done

ls -la "$DEST"