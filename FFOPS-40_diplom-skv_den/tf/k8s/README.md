# tf-k8s - Terraform-конфигурация кластера Kubernetes

Провайдер Yandex Cloud, состояние - в S3 (`tfstate-skv`).

## Файлы конфигурации

| Файл | Назначение |
|---|---|
| `variables.tf` | Описание всех переменных |
| `terraform.tfvars` | Нечувствительные параметры |
| `terraform.tfvars.secret` | Чувствительные данные |
| `providers_backend-S3.tf` | Провайдер Yandex и S3-backend |
| `data.tf`, `locals.tf` | Данные и локальные вычисления |
| `vms_master.tf`, `vms_workers.tf`, `nlb_master.tf`, `ansible_hosts.tf`, `hosts.tftpl`, `cloud-init.tmpl`, `ssh_config.tf`, `output.tf` | Инфраструктура и выходные данные |

`terraform.tfvars.secret` **не хранится в git** - он поставляется из приватного репозитория секретов.

## Приватный репозиторий секретов

Структура репозитория (пример: `diplom/tf-secrets`):

```
tf-secrets/
└── tf-k8s/
    └── terraform.tfvars.secret
```

Содержимое `tf-k8s/terraform.tfvars.secret` (пример):

```hcl
cloud_id           = "b1g..."
folder_id          = "b1g..."
default_zone       = "ru-central1-a"
network_state_key  = "diplom/network.tfstate"
network_bucket_name = "tfstate-skv"
ssh_key_file       = "~/.ssh/id_lab22_1_fops40_ed25519.pub"
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
| `SSH_PUB_KEY` | Публичный ключ (копия `~/.ssh/id_lab22_1_fops40_ed25519.pub`); путь должен совпадать со значением `ssh_key_file` |

Переменные (Settings -> Actions -> Variables):

| Переменная | Пример |
|---|---|
| `SECRETS_REPO` | `admin/tf-secrets` |
| `SECRETS_PATH` | `tf-k8s` |

Шаг "Подготовка секретов" клонирует `SECRETS_REPO`, копирует `terraform.tfvars.secret` в корень проекта и раскладывает ключевые файлы по путям, ожидаемым в `providers_backend-S3.tf` (`~/.sa_storage.key`, `~/.authorized_key.json`, `~/.ssh/id_lab22_1_fops40_ed25519.pub`).

Шаг "Установка Terraform" берёт бинарь из Package Registry (`terraform-bin/<TF_VERSION>`, скрипт [`scripts/fetch_terraform.sh`](scripts/fetch_terraform.sh)); при отсутствии скачивает с yandex-зеркала и кэширует обратно.

## Режимы передачи переменных

- **Совместный (по умолчанию):** `terraform.tfvars` + `terraform.tfvars.secret`. `terraform.tfvars` загружается автоматически; `terraform.tfvars.secret` передаётся через `-var-file` и при конфликте значений имеет приоритет.
- **Только `terraform.tfvars.secret`:** файл `terraform.tfvars` отсутствует; приватный `terraform.tfvars.secret` должен содержать все обязательные переменные.

Команда одинакова для обоих режимов: `terraform plan -var-file=terraform.tfvars.secret -out=tfplan`.

## Локальный запуск

Держите локальную копию `terraform.tfvars.secret` (файл в `.gitignore`, в git не попадёт):

```bash
terraform init -reconfigure
terraform plan -var-file=terraform.tfvars.secret
terraform apply -var-file=terraform.tfvars.secret
```