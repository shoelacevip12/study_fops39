# Для домашнего задания 22.2 `Вычислительные мощности. Балансировщики нагрузки`

## commit_85, master Предварительная подготовка

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
-not -path "*15.2*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем
mv -v clopro-homeworks \
22_2

# Переход в каталог по последней переменной вывода последней команды
cd !$

# Переименование 
mv -v {15.2,README}.md
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
git commit -am 'commit_87, master' \
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

## commit_1, `22_2-cloud-org-vc-balancer`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 22_2-cloud-org-vc-balancer

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
git commit -am 'commit1, 22_2-cloud-org-vc-balancer' \
; git push \
--set-upstream \
study_fops39 \
22_2-cloud-org-vc-balancer \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
22_2-cloud-org-vc-balancer \
&& git push \
--set-upstream \
study-fops39_sc \
22_2-cloud-org-vc-balancer
```

## commit_2,`22_2-cloud-org-vc-balancer`

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

variable "bucket_name" {
  description = "Имя S3 бакета"
  type        = string
  default     = "den-skv-fops40-lab22-2"
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
  bucket                  = var.bucket_name
  default_storage_class   = "STANDARD"
  disabled_statickey_auth = false
  max_size                = 1073741824
  versioning {
    enabled = false
  }
}

# Загрузка файла в S3 бакет с локального диска
resource "yandex_storage_object" "picture" {
  bucket       = yandex_storage_bucket.s3_buck_den_skv_fops40.id
  key          = "image/share_shdevops.png"
  source       = "${path.module}/image/share_shdevops.png"
  content_type = "image/png"
  acl          = "public-read"
  depends_on   = [yandex_storage_bucket.s3_buck_den_skv_fops40]
}
EOF
```

</details>

### `TF-манифест` описания сети

<details>
<summary>
TF-манифест описания сети
</summary>

```tf
cat > network.tf <<'EOF'
resource "yandex_vpc_network" "skv" {
  description = "Сетевой блок VPC skv-fops40-${var.lab22_1}"
  name        = "skv-fops40-${var.lab22_1}"
}

resource "yandex_vpc_subnet" "public" {
  description    = "Подсеть с правом выхода в WAN"
  name           = "skv-fops-${var.lab22_1}-public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
EOF
```

</details>

### `TF-манифест` описания security group

<details>
<summary>
TF-манифест описания security group
</summary>

```tf
cat > security_groups.tf <<'EOF'
resource "yandex_vpc_security_group" "LAN" {
  name       = "LAN-${var.lab22_1}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить весь трафик из внутренних подсетей"
    protocol       = "ANY"
    v4_cidr_blocks = ["192.168.10.0/24"]
    from_port      = 0
    to_port        = 65535
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "host_sg" {
  name       = "host-sg-${var.lab22_1}"
  network_id = yandex_vpc_network.skv.id

  ingress {
    description    = "Разрешить SSH доступ из интернета на порт 22"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
EOF
```

</details>

### `TF-манифест` описания создания инстанс-группы

<details>
<summary>
TF-манифест описания создания инстанс-группы
</summary>

```tf
cat > vms.tf <<'EOF'
data "yandex_compute_image" "ubuntu_lemp" {
  family = var.vm_image_family
}

locals {
  description = "Указание метаданных через locals до ssh ключа"
  common_metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:${file(var.ssh_key_file)}"
  }
}

resource "yandex_compute_instance_group" "ins-gr" {
  name = "ins-gr"
  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  folder_id           = var.folder_id
  service_account_id  = var.service_account_id
  deletion_protection = false

  allocation_policy {
    zones = [
      "ru-central1-a"
    ]
  }

  deploy_policy {
    max_creating     = 1
    max_deleting     = 2
    max_unavailable  = 1
    max_expansion    = 1
    startup_duration = 0
    strategy         = "proactive"
  }

  instance_template {
    platform_id = var.platform_id
    hostname    = "public-vm-{instance.index}"

    resources {
      cores         = var.host.cores
      memory        = var.host.memory
      core_fraction = var.host.core_fraction
      gpus          = 0
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu_lemp.image_id
        type     = var.disk.type
        size     = var.disk.size
      }
    }

    metadata = local.common_metadata

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      network_id = yandex_vpc_network.skv.id
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = false
      security_group_ids = [
        yandex_vpc_security_group.LAN.id,
        yandex_vpc_security_group.host_sg.id
      ]
    }
  }
}
EOF
```

</details>

### `TF-манифест` Network balancer в YC

<details>
<summary>
TF-манифест Network balancer в YC
</summary>

```tf
cat > nlb.tf <<'EOF'
resource "yandex_lb_target_group" "tg-ins-gr" {
  description = "Создание Целевой группы"
  name        = "tg-ins-gr"
  folder_id   = var.folder_id

  dynamic "target" {
    for_each = yandex_compute_instance_group.ins-gr.instances
    content {
      subnet_id = yandex_vpc_subnet.public.id # Используется та же подсеть, что и инстанс-группа
      address   = target.value.network_interface[0].ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "nlb-public" {
  description         = "создание Network Load Balancer"
  name                = "nlb-public"
  folder_id           = var.folder_id
  deletion_protection = false

  # Обработчик входящего трафика
  listener {
    name        = "http-listener"
    port        = 80 # Порт балансировщика (внешний)
    target_port = 80 # Порт на виртуальных машинах
    protocol    = "tcp"

    # Автоматическое назначение Внешний IPv4 адреса
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  listener {
    name        = "listener-https"
    port        = 443
    protocol    = "tcp"
    target_port = 443
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  listener {
    name        = "listener-ssh"
    port        = 22
    protocol    = "tcp"
    target_port = 22
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # Подключение целевой группы и healthcheck
  attached_target_group {
    target_group_id = yandex_lb_target_group.tg-ins-gr.id

    healthcheck {
      name                = "http-health-check"
      interval            = 5
      timeout             = 3
      unhealthy_threshold = 3
      healthy_threshold   = 2

      http_options {
        port = 80  # Порт для проверки на ВМ
        path = "/" # Путь для HTTP проверки
      }
    }
  }

  depends_on = [yandex_compute_instance_group.ins-gr]
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
output "public_image_url" {
  description = "Публичная ссылка на изображение"
  value       = "https://storage.yandexcloud.net/${yandex_storage_bucket.s3_buck_den_skv_fops40.id}/image/share_shdevops.png"
}

output "nlb_external_ip" {
  description = "Внешний IP адрес балансировщика"
  value = length(yandex_lb_network_load_balancer.nlb-public.listener) > 0 ? (
    [for l in yandex_lb_network_load_balancer.nlb-public.listener :
      [for e in l.external_address_spec : e.address][0]
    ][0]
  ) : null
}
EOF
```

</details>

### `yaml-манифест` cloud-init файла

<details>
<summary>
Yaml-манифест шаблона создания пользователя в группе sudo и настройка сайта nginx
</summary>

```yaml
cat > ./cloud-init.yml <<'EOF'
#cloud-config
users:
  - name: skv
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ssh-ed25519 
ssh_pwauth: false
package_update: true
package_upgrade: true
write_files:
  - path: "/var/www/html/index.nginx-debian.html"
    permissions: "0644"
    content: |
      <!DOCTYPE html>
      <html>
      <head>
          <title>Welcome Fops40-2026!</title>
          <style>
              body {
                  display: flex;
                  justify-content: center;
                  align-items: center;
                  height: 100vh;
                  margin: 0;
                  background-color: #f4f4f4;
              }
              img {
                  max-width: 90%;
                  height: auto;
                  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
              }
          </style>
      </head>
      <body>
          <img src="https://storage.yandexcloud.net/den-skv-fops40-lab22-2/image/share_shdevops.png" alt="Welcome DEN">
      </body>
      </html>
    defer: true
runcmd:
  - ["systemctl", "restart", "nginx"]
EOF
```

</details>

```bash
# Добавляем содержимое публичного ключа в cloud-init.yml
sed -i "8s|.*|      - $(cat ~/.ssh/id_lab22_1_fops40_ed25519.pub \
                      | tr -d '\n\r')|" \
cloud-init.yml
```

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

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 22_2-cloud-org-vc-balancer' \
; git push \
--set-upstream \
study_fops39 \
22_2-cloud-org-vc-balancer \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
22_2-cloud-org-vc-balancer \
&& git push \
--set-upstream \
study-fops39_sc \
22_2-cloud-org-vc-balancer
```

## commit_3,`22_2-cloud-org-vc-balancer`

## commit_88, master

```bash
git checkout master

git branch -v

git merge 22_2-cloud-org-vc-balancer

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

terraform init --upgrade && terraform validate && terraform fmt && terraform plan -out=tfplan