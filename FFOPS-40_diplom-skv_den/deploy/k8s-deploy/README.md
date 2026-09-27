# k8s-deploy - доставка стека TS6 в кластер k3s

Репозиторий доставки: манифесты k8s для стека `teamspeak6` + `ts6-manager` и деплой по
git-тегу `v*`. Использует собранные образы из Forgejo CR (`10.8.0.1:3000/diplom/*`,
собираются в репозитории [`ts6-image-build`](../ts6-image-build)).

## Как это работает

Кластер k3s не достаёт Forgejo CR напрямую, поэтому workflow деплоя:

1. клонирует `tf-secrets` -> `kubeconfig`;
2. клонирует `ansible-k3s` (только чтение) -> инвентарь `hosts.ini` и `ssh_config_yc_k8s`;
3. запускает `ansible/playbook_ts6_images.yaml` - на раннере `docker pull` образов
   с тегом версии -> `docker save` -> перенос tar на все ноды -> `k3s ctr -n k8s.io images import`;
4. подставляет версию образа в Deployment'ы (`:latest` -> `:v<тег>`);
5. `kubectl apply -f k8s/` -> rollout status.

Манифесты почти без env - переменные окружения (включая секреты) вшиты в образы на этапе сборки.

## Состав

| Файл | Назначение |
|---|---|
| `k8s/namespace.yaml` | namespace `ts6` |
| `k8s/pvc.yaml` | PVC `ts6-data`, `ts6-backend-data`, `ts6-music-data` (local-path) |
| `k8s/deployment-*.yaml` | Deployment для 4 сервисов (`imagePullPolicy: IfNotPresent`) |
| `k8s/service-teamspeak6.yaml` | внутренние порты TS6 (ClusterIP): 10080, 10022, 10011, 41144, 10443, 3478/udp, 5349/udp |
| `k8s/service-teamspeak6-ext.yaml` | наружу: voice 9987/udp -> NodePort 30087, file transfer 30033 -> 30033 |
| `k8s/service-backend.yaml` | ClusterIP `backend`:3001 (**имя строго `backend`** - nginx frontend проксирует на него) |
| `k8s/service-sidecar.yaml` | ClusterIP `sidecar`:9800 |
| `k8s/service-frontend.yaml` | наружу: HTTP 80 -> NodePort 30082 |
| `ansible/playbook_ts6_images.yaml` | импорт образов в containerd нод |
| `.forgejo/workflows/deploy.yml` | CI/CD: деплой по тегу `v*` |

## Публичные точки (через NLB `nlb-k8s-master`)

| Порт NLB | NodePort | Назначение |
|---|---|---|
| 80/tcp | 30082 | web-интерфейс ts6-manager (frontend) |
| 9987/udp | 30087 | голосовой сервер TeamSpeak 6 (листенер NLB временно отключён - YC не даёт создать UDP; вернуть после включения) |
| 30033/tcp | 30033 | file transfer TeamSpeak 6 |
| 30080/tcp | 30080 | Grafana (без изменений) |

## Переменные/секреты репозитория (Forgejo -> Settings -> Actions)

| Имя | Тип | Назначение |
|---|---|---|
| `TOKEN` | secret | PAT: чтение `diplom/tf-secrets` и `diplom/ansible-k3s` |
| `SSH_PRIVATE_KEY` | secret | приватный ключ `~/.ssh/id_lab22_1_fops40_ed25519` |
| `SECRETS_REPO` | var | `diplom/tf-secrets` |
| `ANSIBLE_REPO` | var | `diplom/ansible-k3s` |

## Настройка ts6-manager после деплоя

1. Открыть `http://<NLB_IP>/setup` - создать аккаунт администратора панели.
2. Получить API-Key TeamSpeak 6 (изнутри кластера):
   `kubectl run -it --rm ssh-client --image=alpine -n ts6 -- sh`
   -> `apk add openssh-client` -> `ssh -p 10022 serveradmin@teamspeak6`
   (пароль из `.env` репозитория `ts6-image-build`) -> `apikeyadd scope=manage duration=0`.
3. В ts6-manager: Settings -> Connections -> Add Connection:
   Host `teamspeak6`, Port `10080`, Protocol `HTTP`, API Key - из шага 2.