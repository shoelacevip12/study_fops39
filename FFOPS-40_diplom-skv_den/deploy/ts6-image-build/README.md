# TS6 deploy - сборка образов TeamSpeak 6 + ts6-manager с вшитым `.env`

Репозиторий сборки стека `teamspeak6` + `ts6-manager` (backend/sidecar/frontend).
Является источником истины для docker-compose и **собранных Dockerfile**: каждый образ
берёт upstream и вшивает переменные окружения из `.env` (включая секреты) через ARG/ENV.

Собранные образы публикуются в локальный Forgejo Container Registry:
`10.8.0.1:3000/diplom/{teamspeak6-server,ts6-backend,ts6-sidecar,ts6-frontend}:<tag>`
(тег `latest` на каждый push, тег `v<версия>` при создании git-тега `v*`).

## Состав

| Файл | Назначение |
|---|---|
| `compose.yaml` | docker-compose стек из 4 сервисов (источник истины) |
| `Dockerfile.teamspeak6` | upstream `teamspeaksystems/teamspeak6-server` + `TSSERVER_*` из `.env` |
| `Dockerfile.backend` | upstream `clusterzx/ts6-manager:backend` + `JWT_SECRET`, `ENCRYPTION_KEY`, `FRONTEND_URL`, `SIDECAR_URL` и др. |
| `Dockerfile.sidecar` | upstream `clusterzx/ts6-manager:sidecar` + `SIDECAR_PORT=9800` |
| `Dockerfile.frontend` | upstream `clusterzx/ts6-manager:frontend` + кастомный `nginx/default.conf` (`/healthz`, прокси `/api`->`backend:3001`) |
| `nginx/default.conf` | nginx-конфиг frontend (SPA-routing + API/WS proxy) |
| `scripts/gen_secrets.sh` | генерация секретов для `.env` |
| `scripts/build_images.sh` | сборка 4 образов из `.env` + push в Forgejo CR |
| `.forgejo/workflows/build.yml` | CI: сборка на push (тег `latest`) и на теги `v*` (тег с версией) |

## Подготовка

```bash
# 1. Сгенерировать секреты
bash scripts/gen_secrets.sh

# 2. Заполнить .env (пример - в .env.example), включая FRONTEND_URL:
#    FRONTEND_URL=http://<NLB_IP>   - адрес web-интерфейса в кластере
#    SIDECAR_URL=http://sidecar:9800
```

`.env` содержит секреты и попадает в слои образов (видны через `docker inspect`).
Для диплома приемлемо: репозиторий и реестр приватные. Ротация = правка `.env` ->
push -> пересборка образов -> тег `v*` -> передеплой.

## Переменные/секреты репозитория (Forgejo -> Settings -> Actions)

| Имя | Тип | Назначение |
|---|---|---|
| `PACKAGE_TOKEN` | secret | PAT `write:package` - docker login + push в CR (единственный обязательный) |

`REGISTRY`/`OWNER` прописаны в `.forgejo/workflows/build.yml` (`10.8.0.1:3000` / `diplom`), checkout идёт через `github.token` - переменные `FORGEJO_URL`/`REGISTRY`/`TOKEN` не требуются.

## Как доставляются образы в кластер

Кластер k3s не достаёт Forgejo CR напрямую (он за VPN). Поэтому репозиторий доставки
[`k8s-deploy`](../k8s-deploy) по тегу `v*` выполняет ansible-плейбук:
`docker pull 10.8.0.1:3000/diplom/*:<версия>` на раннере -> `docker save` -> перенос tar
на все ноды -> `k3s ctr -n k8s.io images import` -> `kubectl apply`.

## Настройка ts6-manager после деплоя

1. Открыть `http://<NLB_IP>/setup` - создать аккаунт администратора панели.
2. Получить API-Key TeamSpeak 6 (изнутри кластера):
   `kubectl run -it --rm ssh-client --image=alpine -n ts6 -- sh`
   -> `apk add openssh-client` -> `ssh -p 10022 serveradmin@teamspeak6`
   (пароль из `.env` `TS6_QUERY_ADMIN_PASSWORD`) -> `apikeyadd scope=manage duration=0`.
3. В ts6-manager: Settings -> Connections -> Add Connection:
   Host `teamspeak6`, Port `10080`, Protocol `HTTP`, API Key - из шага 2.