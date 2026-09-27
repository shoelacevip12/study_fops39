# ansible-k3s - развёртывание кластера K3s

Playbook для развёртывания кластера K3s + Calico + Ingress NGINX + мониторинг (kube-prometheus-stack / Grafana) на ВМ, созданных проектом `tf-k8s`. Инвентарь: 1 мастер + 3 воркера.

## Инвентарь и доступ

- [`hosts.ini`](hosts.ini) - группы `masters` и `workers`. Генерируется джобой `tf-k8s` и коммитится в этот репозиторий.
- SSH: пользователь `skv`, приватный ключ `~/.ssh/id_lab22_1_fops40_ed25519`, конфиг [`ssh_config_yc_k8s`](ssh_config_yc_k8s) (публикуется джобой `tf-k8s`).

## Ключевая конфигурация - [`ansible.cfg`](ansible.cfg)

- `inventory = ./hosts.ini`;
- `roles_path = ./roles` - роль `k3s_cluster`;
- `vault_password_file = ./va_pa` - пароль ansible-vault. Файл `va_pa` **в git не хранится**: в CI копируется из приватного `tf-secrets` (`${SECRETS_PATH}/va_pa`), локально - кладёт оператор;
- `ssh_args = -F ~/.ssh/config_yc_k8s` - SSH-конфиг, опубликованный джобой `tf-k8s`;
- `become = true` (sudo) - роль требует root-прав на узлах.

## Что делает playbook

[`playbook_main.yaml`](playbook_main.yaml) (`hosts: all`, `vars_files: group_vars/all.yml`) запускает роль [`roles/k3s_cluster`](roles/k3s_cluster) по шагам:

1. **prereq** - настройка cgroups, отключение swap;
2. **install** - установка K3s (мастер/воркеры), helm, calicoctl;
3. **config** - конфиги нод, генерация токена, подключение воркеров к мастеру;
4. **calico** - установка Calico CNI (flannel отключён);
5. **ingress_nginx** - установка Ingress Controller (traefik отключён);
6. **monitoring** - helm-чарт `kube-prometheus-stack`; Grafana - Service `NodePort`, порт **30080** на мастере (задача только на группе `masters`);
7. **fetch_kubeconfig** - сборка локального `~/.kube/config`.

Отключаемые компоненты K3s: `traefik`, `servicelb`, `metrics-server`, `flannel`. Сетевые CIDR: pod `10.20.0.0/16`, service `10.21.0.0/16`.

Параметры роли - [`roles/k3s_cluster/defaults/main.yml`](roles/k3s_cluster/defaults/main.yml), константы - [`roles/k3s_cluster/vars/main.yml`](roles/k3s_cluster/vars/main.yml). Секреты (`k3s_token`, `grafana_admin_user/password`) зашифрованы в [`group_vars/all/vault`](group_vars/all/vault).

## Цепочка CI/CD

1. `tf-net-S3-store` apply - сеть, подсети, S3, сервисные аккаунты;
2. `tf-k8s` apply - ВМ, NLB, cloud-init;
3. Джоба `tf-k8s` публикует инвентарь: `hosts.ini` + `ssh_config_yc_k8s` -> коммит в этот репозиторий;
4. Push в этот репозиторий запускает [`.forgejo/workflows/ansible.yml`](.forgejo/workflows/ansible.yml) - развёртывание кластера (джоба выполняется в контейнере `10.8.0.1:3000/diplom/ubuntu-act:latest`):
   - подготовка SSH (ключ из секрета `SSH_PRIVATE_KEY` + `ssh_config_yc_k8s`);
   - получение пароля vault: клонирование `SECRETS_REPO`, копирование `${SECRETS_PATH}/va_pa`;
   - установка Ansible, доставка артефактов роли ([`scripts/fetch_artifacts.sh`](scripts/fetch_artifacts.sh));
   - запуск playbook;
   - публикация `~/.kube/config` -> `tf-secrets/k8s/kubeconfig`;
   - проверка кластера (`kubectl get nodes`, `kubectl get pods -A`).

## Секреты и переменные (Settings -> Actions)

### Секреты

| Секрет | Значение |
|---|---|
| `TOKEN` | PAT с правом чтения `tf-secrets` и push в `tf-secrets` (для публикации kubeconfig) |
| `PACKAGE_TOKEN` | Глобальный PAT с правом `write:package` - доступ к Package Registry |
| `SSH_PRIVATE_KEY` | Приватный ключ доступа к ВМ (содержимое `~/.ssh/id_lab22_1_fops40_ed25519`) |

### Переменные

| Переменная | Пример | Примечание |
|---|---|---|
| `SECRETS_REPO` | `diplom/tf-secrets` | обязательная |
| `SECRETS_PATH` | `ansible-k3s` | путь до `va_pa` внутри `SECRETS_REPO` |
| `FORGEJO_URL` (зарезервированный префикс) | `http://10.8.0.1:3000` дефолт в скрипте | имя с префиксом `FORGEJO_` в Forgejo неразрешено создавать |
| `PACKAGE_OWNER` | `diplom` | опциональна, дефолт `diplom` |
| `PACKAGE_NAME` | `k3s-artifacts` | опциональна, дефолт `k3s-artifacts` |
| `PACKAGE_VERSION` | `v1` | опциональна, дефолт `v1` |

## Артефакты роли (`roles/k3s_cluster/files/`)

Бинарники и манифесты в git не хранятся (`.gitignore`). Доставку выполняет шаг "Артефакты роли" ([`scripts/fetch_artifacts.sh`](scripts/fetch_artifacts.sh)) в порядке:

1. файл уже на месте - пропуск;
2. Forgejo Package Registry (generic-пакет `PACKAGE_NAME`/`PACKAGE_VERSION` у `PACKAGE_OWNER`) - скачивание;
3. upstream (пиннированные версии из скрипта) - скачивание + кэширование обратно в registry.

Список файлов: `calico.yaml`, `k3s`, `kubectl-calico`, `cni-plugins-linux-amd64.tgz`, `helm.tar.gz`, `ingress-nginx.yaml`.

Кастомный скрипт установки [`roles/k3s_cluster/files/install.sh`](roles/k3s_cluster/files/install.sh) закоммичен в репозиторий (не скачивается из upstream).

Первичная загрузка в Package Registry (один раз, с машины оператора):

```bash
for f in calico.yaml k3s kubectl-calico cni-plugins-linux-amd64.tgz helm.tar.gz ingress-nginx.yaml; do
  curl -X PUT "http://10.8.0.1:3000/api/packages/diplom/generic/k3s-artifacts/v1/$f" \
    -u oauth2:"$PACKAGE_TOKEN" --upload-file "roles/k3s_cluster/files/$f"
done
```

>Если registry пуст и upstream недоступен из раннера - джоба не сможет доставить файлы (первый бутстрап желательно сделать с машины оператора).

## Локальный запуск

Роль использует коллекции `community.general` и `ansible.posix` ([`requirements.yml`](requirements.yml)):

```bash
# полный дистрибутив с коллекциями
pip install ansible

# или
ansible-galaxy collection install -r requirements.yml

# Пароль vault: файл va_pa в git не хранится
# CI берёт его из tf-secrets
printf '%s' 'ВАШ_ПАРОЛЬ_VAULT' > ./va_pa && chmod 600 ./va_pa

ansible-playbook -i ./hosts.ini playbook_main.yaml
```

## Как оператор получает файлы

- Инвентарь и SSH-конфиг - из клона этого репозитория:

  ```bash
  git pull
  cat ssh_config_yc_k8s >> ~/.ssh/config
  
  # или 
  sed 's#/root/#~/' ssh_config_yc_k8s
  ```

- kubeconfig - из приватного `tf-secrets`:

  ```bash
  git clone ssh://git@git.den-skv.ru:6722/diplom/tf-secrets.git
  export KUBECONFIG=$PWD/tf-secrets/k8s/kubeconfig
  kubectl get nodes
  ```

- Grafana: `http://<IP_мастера>:30080` (учётная запись - в `group_vars/all/vault`).