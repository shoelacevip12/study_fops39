# tf-net-S3-store - сеть и Object Storage

Провайдер Yandex Cloud, состояние - в S3 (`tfstate-skv`, ключ `diplom/network.tfstate`).

## Файлы конфигурации

| Файл | Назначение |
|---|---|
| `variables.tf` | Описание всех переменных |
| `terraform.tfvars` | Параметры бакета, KMS, сети, подсетей, NAT, security groups |
| `terraform.tfvars.secret` | Чувствительные данные |
| `providers_backend-S3.tf` | Провайдер Yandex и S3-backend |
| `network_vpc.tf`, `security_groups.tf`, `s3.tf`, `kms.tf`, `sa_storage.tf`, `sleep_timer.tf`, `locals.tf`, `output.tf` | Инфраструктура и выходные данные |

`terraform.tfvars.secret` **не хранится в git** - он поставляется из приватного репозитория секретов.

## Приватный репозиторий секретов

Структура репозитория (пример: `admin/tf-secrets`):

```
tf-secrets/
└── tf-net-S3-store/
    └── terraform.tfvars.secret
```

Содержимое `tf-net-S3-store/terraform.tfvars.secret` (пример):

```hcl
cloud_id       = "b1g..."
folder_id      = "b1g..."
default_zone   = "ru-central1-a"
pgp_key_base64 = "mDME..."
```

## CI/CD (Forgejo Actions)

Workflow: `.forgejo/workflows/terraform.yml`.

Секреты (Settings -> Actions -> Secrets):

| Секрет | Значение |
|---|---|
| `TOKEN` | Personal Access Token (scope `read:repository`) с доступом к репозиторию секретов |
| `PACKAGE_TOKEN` | Глобальный PAT (scope `write:package`) - кэш бинаря Terraform в Package Registry (`terraform-bin/<версия>`); без него кэширование не работает |
| `SA_STORAGE_KEY` | Содержимое `~/.sa_storage.key` (статический S3-ключ для backend) |
| `YC_AUTHORIZED_KEY` | Содержимое `~/.authorized_key.json` (ключ сервисного аккаунта) |

Переменные (Settings -> Actions -> Variables):

| Переменная | Пример |
|---|---|
| `SECRETS_REPO` | `diplom/tf-secrets` |
| `SECRETS_PATH` | `tf-net-S3-store` |
| `K8S_REPO` | `diplom/tf-k8s` - целевой репозиторий для финального шага-триггера |

Шаг "Подготовка секретов" клонирует `SECRETS_REPO`, копирует `terraform.tfvars.secret` в корень проекта и раскладывает ключевые файлы по путям, ожидаемым в `providers_backend-S3.tf` (`~/.sa_storage.key`, `~/.authorized_key.json`).

Шаг "Установка Terraform" берёт бинарь из Package Registry (`terraform-bin/<TF_VERSION>`, скрипт [`scripts/fetch_terraform.sh`](scripts/fetch_terraform.sh)); при отсутствии скачивает с yandex-зеркала и кэширует обратно (первый прогон медленный, последующие - из локального реестра).

## Режимы передачи переменных

- **Совместный:** `terraform.tfvars` + `terraform.tfvars.secret`. `terraform.tfvars` загружается автоматически; `terraform.tfvars.secret` передаётся через `-var-file` и при конфликте значений имеет приоритет.
- **Только `terraform.tfvars.secret`:** файл `terraform.tfvars` отсутствует; приватный `terraform.tfvars.secret` должен содержать все обязательные переменные.

Команда одинакова для обоих режимов: `terraform plan -var-file=terraform.tfvars.secret -out=tfplan`.

## Локальный запуск

Держите локальную копию `terraform.tfvars.secret` (файл в `.gitignore`, в git не попадёт):

```bash
terraform init -reconfigure
terraform plan -var-file=terraform.tfvars.secret
terraform apply -var-file=terraform.tfvars.secret
```