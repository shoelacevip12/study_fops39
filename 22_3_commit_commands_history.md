# Для домашнего задания 23.2 `Вычислительные мощности. Балансировщики нагрузки`

## commit_89, master Предварительная подготовка

```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master
```

<details>
<summary>
переход на master
</summary>

```log
Уже на «master»
```

</details>

```bash
# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/clopro-homeworks.git


# Удаление всех файлов и каталогов кроме нужных
find clopro-homeworks/ \
-mindepth 1 \
-not -path "*15.3*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем
mv -v clopro-homeworks \
22_3

# Переход в каталог по последней переменной вывода последней команды
cd !$

# Переименование 
mv -v {15.3,README}.md
```

```bash
# Просмотр текущих удаленных репозиториев
git remote -v

# Проверка текущего локального состояния репозитория
git status

git rm -r --cached \
../

git remote -v

# Добавляем ключи агенту ssh от репозитория gitflic и github
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_gitflic_2026_ed25519 \
&& ssh-add ~/.ssh/id_github_2026_ed25519 \
&& ssh-agent -c

# Просмотр различий в рабочей директории и индексов
git diff \
&& git diff --staged

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

git diff \
&& git diff --staged

# Просмотр истории коммитов в кратком формате
git log --oneline

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий
git commit -am 'commit_89, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master \
&& git push \
--set-upstream \
study-fops39_sc \
master
```

## commit_1, `22_3-cloud-org-secur`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 22_3-cloud-org-secur

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавляем ключи агенту ssh от репозитория gitflic и github
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_gitflic_2026_ed25519 \
&& ssh-add ~/.ssh/id_github_2026_ed25519 \
&& ssh-agent -c

# Просмотр различий в рабочей директории и индексов
git diff \
&& git diff --staged

git rm -r --cached \
./ ../

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit1, 22_3-cloud-org-secur' \
; git push \
--set-upstream \
study_fops39 \
22_3-cloud-org-secur \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
22_3-cloud-org-secur \
&& git push \
--set-upstream \
study-fops39_sc \
22_3-cloud-org-secur
```

## commit_2,`22_3-cloud-org-secur`

```bash
mkdir tf

cd !$
```

### `TF-манифест` описания провайдера YC

<details>
<summary>
TF-манифест описания провайдера YC
</summary>

```tf
cat > providers.tf <<'EOF'
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file = file("~/.authorized_key.json")
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
}
EOF
```

</details>

### `TF-манифест` переменных

<details>
<summary>
TF-манифест
</summary>

```tf
cat > variables.tf.tf <<'EOF'
variable "lab22_1" {
  description = "Название лабораторной работы"
  type        = string
  default     = "lab22-1-skv"
}

variable "cloud_id" {
  description = "ID облака"
  type        = string
  default     = "b1g46dhqv17rkjcoc9k7"
}

variable "folder_id" {
  description = "ID папки в облаке"
  type        = string
  default     = "b1g9l0vgsvf6cegkvj1c"
}

variable "service_account_id" {
  description = "ID service account для каталога в облаке"
  type        = string
  default     = "ajen0vmdo7bfr3t4auv7"
}

variable "symmetric_key_name" {
  description = "имя yandex_kms_symmetric_key"
  type        = string
  default     = "sym-kms-den-skv"
}

variable "zone_name" {
  description = "имя Зоны dns"
  type        = string
  default     = "den-skv.ru."
}

variable "default_zone" {
  description = "Зона размещения по умолчанию"
  type        = string
  default     = "ru-central1-a"
}

variable "platform_id" {
  description = "Платформа CPU для всех создаваемых ВМ"
  type        = string
  default     = "standard-v2"
}

variable "disk" {
  description = "Загрузочный диск для всех создаваемых ВМ"
  type        = map(any)
  default = {
    type = "network-hdd"
    size = 20
  }
}

variable "ssh_key_file" {
  description = "Путь к публичному SSH-ключу на компьютере, загружаемому во все ВМ"
  type        = string
  default     = "~/.ssh/id_lab22_1_fops40_ed25519.pub"
}

variable "vm_image_family" {
  type    = string
  default = "lemp"
}

variable "host" {
  description = "Ресурсы для всех создаваемых ВМ"
  type        = map(number)
  default = {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }
}

variable "bucket_name_chipher" {
  description = "Имя S3 бакета"
  type        = string
  default     = "den-skv-chiphers"
}

variable "bucket_name_html" {
  description = "Имя S3 бакета"
  type        = string
  default     = "den-skv.ru"
}
EOF
```

</details>

### `TF-манифест` Создание S3 Хранилища

<details>
<summary>
TF-манифест S3 Хранилища
</summary>

```tf
cat > ./s3.tf <<'EOF'
resource "yandex_storage_bucket" "s3_buck_den_skv_fops40" {
  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.sym-kms.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  bucket                  = var.bucket_name_chipher
  default_storage_class   = "STANDARD"
  disabled_statickey_auth = false
  max_size                = 1073741824
  versioning {
    enabled = false
  }

  depends_on = [yandex_kms_symmetric_key.sym-kms]

}

# Загрузка файла в зашифрованный S3 бакет с локального диска
resource "yandex_storage_object" "files-pic" {
  bucket       = yandex_storage_bucket.s3_buck_den_skv_fops40.id
  key          = "files/share_shdevops.png"
  source       = "${path.module}/files/share_shdevops.png"
  content_type = "image/png"
  acl          = "public-read"
  depends_on   = [yandex_storage_bucket.s3_buck_den_skv_fops40]
}

resource "yandex_storage_bucket" "s3_buck_den_skv_html" {
  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }

  website {
    index_document = "index.html"
  }

  bucket                  = var.bucket_name_html
  default_storage_class   = "STANDARD"
  disabled_statickey_auth = false
  max_size                = 1073741824
  versioning {
    enabled = false
  }

  https {
    certificate_id = yandex_cm_certificate.le-cert.id
  }

}

# Загрузка файла в S3 бакет с локального диска
resource "yandex_storage_object" "files-pic-non-chip" {
  bucket       = yandex_storage_bucket.s3_buck_den_skv_html.id
  key          = "files/share_shdevops.png"
  source       = "${path.module}/files/share_shdevops.png"
  content_type = "image/png"
  acl          = "public-read"
  depends_on   = [yandex_storage_bucket.s3_buck_den_skv_html]
}

# Загрузка html-файла в S3 бакет с локального диска
resource "yandex_storage_object" "files-html" {
  bucket       = yandex_storage_bucket.s3_buck_den_skv_html.id
  key          = "index.html"
  source       = "${path.module}/files/index.html"
  content_type = "text/html"
  acl          = "public-read"
  depends_on   = [yandex_storage_bucket.s3_buck_den_skv_html]
}
EOF
```

</details>

### `TF-манифест` описания симметричного ключа в KMS

<details>
<summary>
TF-манифест описания симметричного ключа в KMS
</summary>

```tf
cat > kms.tf <<'EOF'
resource "yandex_kms_symmetric_key" "sym-kms" {
  default_algorithm = "AES_256"
  description       = "Создание симметричного ключа"
  folder_id         = var.folder_id
  name              = var.symmetric_key_name
  rotation_period   = ""
}
EOF
```

</details>

### `TF-манифест` описания публично dns зоны в YC

<details>
<summary>
TF-манифест описания публично dns зоны в YC
</summary>

```tf
cat > dns.tf <<'EOF'
resource "yandex_dns_zone" "zone-dns1" {
  description = "Зона DNS ${var.zone_name}"
  folder_id   = var.folder_id
  public      = true
  zone        = var.zone_name
}

resource "yandex_dns_recordset" "dns-cname-le" {
  description = "DNS запись для Let's Encrypt"
  zone_id     = yandex_dns_zone.zone-dns1.id
  name        = yandex_cm_certificate.le-cert.challenges[0].dns_name
  type        = yandex_cm_certificate.le-cert.challenges[0].dns_type
  data        = [yandex_cm_certificate.le-cert.challenges[0].dns_value]
  ttl         = 600

  depends_on = [yandex_cm_certificate.le-cert]
}

resource "yandex_dns_recordset" "dns-aname-html" {
  description = "DNS запись для index.html"
  zone_id     = yandex_dns_zone.zone-dns1.id
  name        = var.zone_name
  type        = "ANAME"
  data        = [yandex_storage_bucket.s3_buck_den_skv_html.website_endpoint]
  ttl         = 600

  depends_on = [yandex_storage_object.files-html]
}
EOF
```

</details>

### `TF-манифест` описания создания сертификата для DNS Let`s encrypt

<details>
<summary>
TF-манифест описания создания сертификата для DNS Let`s encrypt
</summary>

```tf
cat > certificate.tf <<'EOF'
resource "yandex_cm_certificate" "le-cert" {
  name    = "den-skv"
  domains = ["den-skv.ru"]

  managed {
    challenge_type = "DNS_CNAME"
    # challenge_type  = "HTTP"
    challenge_count = 1
  }
}

data "yandex_cm_certificate" "den-skv-cm-data" {
  depends_on      = [yandex_dns_recordset.dns-cname-le]
  certificate_id  = yandex_cm_certificate.le-cert.id
  wait_validation = false
}
EOF
```

</details>

### `TF-манифест` output

<details>
<summary>
TF-манифест output
</summary>

```tf
cat > output.tf <<'EOF'
output "public_image_chipher" {
  description = "Публичная ссылка на изображение"
  value       = "https://storage.yandexcloud.net/${yandex_storage_bucket.s3_buck_den_skv_fops40.id}/files/share_shdevops.png"
}

output "public_html_url" {
  description = "Публичная ссылка на изображение"
  value       = "https://storage.yandexcloud.net/${yandex_storage_bucket.s3_buck_den_skv_html.id}/index.html"
}

output "public_image_url" {
  description = "Публичная ссылка на изображение"
  value       = "https://storage.yandexcloud.net/${yandex_storage_bucket.s3_buck_den_skv_html.id}/files/share_shdevops.png"
}


output "cert-id" {
  description = "Certificate ID"
  value       = yandex_cm_certificate.le-cert.id
}
EOF
```

</details>


```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 22_3-cloud-org-secur

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавляем ключи агенту ssh от репозитория gitflic и github
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_gitflic_2026_ed25519 \
&& ssh-add ~/.ssh/id_github_2026_ed25519 \
&& ssh-agent -c

# Просмотр различий в рабочей директории и индексов
git diff \
&& git diff --staged

git rm -r --cached \
./ ../

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 22_3-cloud-org-secur' \
; git push \
--set-upstream \
study_fops39 \
22_3-cloud-org-secur \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
22_3-cloud-org-secur \
&& git push \
--set-upstream \
study-fops39_sc \
22_3-cloud-org-secur
```

## commit_3,`22_3-cloud-org-secur`

### Добавление ssh ключа в агента-ssh

```bash
# Добавляем в ssh-agent
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_lab22_1_fops40_ed25519
```

<details>
<summary>
Вывод о добавление ssh ключа в агента-ssh
</summary>

```log
Agent pid 50274
Identity added: /home/shoel/.ssh/id_lab22_1_fops40_ed25519 (lab22_1_fops40)
```

</details>

### Запуск terraform проекта

```bash
cd tf

tree
```

<details>
<summary>
Вывод о содержимом каталога с проектом terraform
</summary>

```log
.
├── certificate.tf
├── dns.tf
├── files
│   ├── index.html
│   └── share_shdevops.png
├── kms.tf
├── output.tf
├── providers.tf
├── s3.tf
└── variables.tf

2 directories, 9 files
```

</details>

```bash
# Проверка tf файлов проекта
terraform init --upgrade \
&& terraform validate
```

<details>
<summary>
Лог об успешности проверок terraform и tf-файлов
</summary>

```log
Initializing the backend...

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.224.0...
- Installed yandex-cloud/yandex v0.224.0 (unauthenticated)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

╷
│ Warning: Incomplete lock file information for providers
│ 
│ Due to your customized provider installation methods, Terraform was forced to calculate lock file checksums locally for the following providers:
│   - yandex-cloud/yandex
│ 
│ The current .terraform.lock.hcl file only includes checksums for linux_amd64, so Terraform running on another platform will fail to install these providers.
│ 
│ To calculate additional checksums for another platform, run:
│   terraform providers lock -platform=linux_amd64
│ (where linux_amd64 is the platform to generate)
╵
Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Success! The configuration is valid.
```

</details>

```bash
# Авто-форматирование конфига и создание файла запуска terraform
terraform fmt \
&& terraform plan -out=tfplan
```

```bash
# Запуск Создания ресурсов на YC
terraform apply "tfplan"
```

[результат работы проекта](22_3/README.md)

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit3, 22_3-cloud-org-secur' \
; git push \
--set-upstream \
study_fops39 \
22_3-cloud-org-secur \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
22_3-cloud-org-secur \
&& git push \
--set-upstream \
study-fops39_sc \
22_3-cloud-org-secur
```

## commit_90, master

```bash
git checkout master

git branch -v

git merge 22_3-cloud-org-secur

git branch -v

git status

git diff \
&& git diff \
--staged

git add . \
&& git status

git log --oneline

git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master \
&& git push \
--set-upstream \
study-fops39_sc \
master

git add . \
&& git status \
&& git commit --amend --no-edit \
&& git push \
--set-upstream \
study_fops39 \
master --force \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master --force \
&& git push \
--set-upstream \
study-fops39_sc \
master --force
```