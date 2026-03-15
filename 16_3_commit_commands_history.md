# Для домашнего задания 16.3 `Управляющие конструкции в коде Terraform`
## commit_54, master Предварительная подготовка
```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master
```
```
Уже на «master»
```
```bash
# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/ter-homeworks.git

# Удаление всех файлов и каталогов кроме каталога 03 и его содержимого
find ter-homeworks/ \
-mindepth 1 \
-not -path "*03*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 16_3
mv ter-homeworks/03 16_3

# Переход в каталог по последней переменной вывода последней команды (16_3)
cd !$

# создание каталогов под скриншоты
mkdir img

# Подготовка отчета для сдачи
mv {hw-03,README}.md
```
```
cd 16_3
```
```bash
# Удаление оставшейся оставшейся части клона репозитория
rm -rf \
../ter-homeworks

# Просмотр текущих удаленных репозиториев
git remote -v

# Проверка текущего локального состояния репозитория
git status

git remote -v

# Просмотр различий в рабочей директории и индексов
git diff \
&& git diff --staged

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . \
&& git status
```
```
Текущая ветка: master
Эта ветка соответствует «study_fops39_gitflic_ru/master».

Изменения, которые будут включены в коммит:
  (используйте «git restore --staged <файл>...», чтобы убрать из индекса)
        новый файл:    demo/.gitignore
        ...
        новый файл:    src/variables.tf

Неотслеживаемые файлы:
  (используйте «git add <файл>...», чтобы добавить в то, что будет включено в коммит)
        ../16_3_commit_commands_history.md
```
```bash
git diff \
&& git diff --staged

# Просмотр истории коммитов в кратком формате
git log --oneline

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий
git commit -am 'commit_54, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```
## commit_1, `16_3-terr_construct`
```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 16_3-terr_construct

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . ../16_3_commit_commands_history.md \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am '16_3-terr_construct' \
&& git push \
--set-upstream \
study_fops39 \
16_3-terr_construct \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
16_3-terr_construct
```
## commit_2, `16_3-terr_construct`
```bash
# Дислокация кода для работы в репозитории
cd src

# Смена требований к версии terraform c 1.12.X, на 1.X
sed -i 's/1.12.0/1.12/' \
providers.tf

# Добавление переменных значений default к переменным cloud_id и folder_id
sed -i '/\/cloud\/get-id"/a\
  default     = "'"$YC_CLOUD_ID"'"
' variables.tf

sed -i '/\/folder\/get-id"/a\
  default     = "'"$YC_FOLDER_ID"'"
' variables.tf


# Проверка наличия файла авторизации
file ~/.authorized_key.json
```
```
/home/shoel/.authorized_key.json: JSON text data
```
```bash
# вывод о конфигурации работы с YC
yc config list
```
```
service-account-key:
  id: ajexxxxxxxxxxxx7o215
  service_account_id: ajexxxxxxxxxxxx3micr
  created_at: "2026-03-10T19:16:05.289441568Z"
  key_algorithm: RSA_2048
  public_key: |
    -----BEGIN PUBLIC KEY-----

    -----END PUBLIC KEY-----
  private_key: |
    PLEASE DO NOT REMOVE THIS LINE! Yandex.Cloud SA Key ID <ajexxxxxxxxxxxx7o215>
    -----BEGIN PRIVATE KEY-----

    -----END PRIVATE KEY-----
cloud-id: b1gkumrn87pei2831blp
folder-id: b1g7qviodfc9v4k81sr5
compute-default-zone: ru-central1-a
```

```bash
# замена авторизации по token на файл авторизации сервисного аккаунта
sed -i 's|token     = var.token|service_account_key_file = file("~/.authorized_key.json")|' \
providers.tf

# Удаление в variable.tf переменной token
# Где:
# /variable "token" {/ - находит начало блока
# ,/^}/ - указывает диапазон до строки, содержащей только закрывающую фигурную скобку }
sed -i '/variable "token" {/,/^}/d' \
variables.tf
```

```bash
# Инициализация Terraform конфигурации и авто-форматирование конфигов работы
terraform init \
&& terraform validate \
&& terraform fmt
```
```
Initializing the backend...
Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.191.0
...
Terraform has been successfully initialized!
...
Success! The configuration is valid.

providers.tf
security.tf
```
```bash
# создание файла плана запуска terraform
terraform plan -out=tfplan
```
```
# yandex_vpc_network.develop will be created
...
# yandex_vpc_security_group.example will be created
...
# yandex_vpc_subnet.develop will be created
...
Plan: 3 to add, 0 to change, 0 to destroy.
```
```bash
# Применение файла запуска terraform
terraform apply "tfplan"
```
```
yandex_vpc_network.develop: Creating...
yandex_vpc_network.develop: Creation complete after 2s [id=enpkp07cuvrvmcgjsiln]
yandex_vpc_subnet.develop: Creating...
yandex_vpc_security_group.example: Creating...
yandex_vpc_subnet.develop: Creation complete after 0s [id=e9br1c8fes5avhndifp2]
yandex_vpc_security_group.example: Creation complete after 2s [id=enp6b9a4ei2uuuu2s937]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```
```bash
cd ..

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . ../16_3_commit_commands_history.md \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am '16_3-terr_construct_3' \
&& git push \
--set-upstream \
study_fops39 \
16_3-terr_construct \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
16_3-terr_construct
```
## commit_3, `16_3-terr_construct`
```bash
cd -

# Описание общей переменной  map(object ресурсов web
cat >> variables.tf <<'EOF'

# Объединение в единую map-переменную vms_resources
variable "vms_resources" {
  type = map(object({
    family        = string
    count         = number
    name          = string
    platform_id   = string
    cores         = number
    memory        = number
    core_fraction = number
    preemptible   = bool
    nat           = bool
  }))
  default = {
    vm_web = {
      family        = "ubuntu-2404-lts-oslogin"
      count         = 2
      name          = "skv-develop-web"
      platform_id   = "standard-v2"
      cores         = 2
      memory        = 3
      core_fraction = 5
      preemptible   = true
      nat           = true
    }
  }
}

#  Отдельный map(object) переменной для блока metadata
variable "vms_ssh" {
  type = map(any)
  default = {
    serial-port-enable = 1
    "ssh-keys"         = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMT2pZfiY4KUIeybtsJjbp42JjiUySw5e34KiNprFsc lab16_1_fops39"
  }
}
EOF

# Описание создания ВМ с использованием переменных
cat > count-vm.tf <<'EOF'
data "yandex_compute_image" "ubuntu" {
  family = var.vms_resources["vm_web"].family
}
resource "yandex_compute_instance" "web" {
  count = var.vms_resources["vm_web"].count
  name        = "${var.vms_resources["vm_web"].name}-${count.index + 1}"
  platform_id = var.vms_resources["vm_web"].platform_id
  resources {
    cores         = var.vms_resources["vm_web"].cores
    memory        = var.vms_resources["vm_web"].memory
    core_fraction = var.vms_resources["vm_web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vms_resources["vm_web"].preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vms_resources["vm_web"].nat
    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }

  metadata = var.vms_ssh

}
EOF

# Проверка прописанных переменных
terraform validate \
&& terraform fmt \
&& terraform plan -out=tfplan
```
```
Success! The configuration is valid.

...

Terraform will perform the following actions:

  # yandex_compute_instance.web[0] will be created
  + resource "yandex_compute_instance" "web" {
      ...
      + name                      = "skv-develop-web-1"
      ...
      + network_interface {
        ...
          + security_group_ids = [
              + "enp6b9a4ei2uuuu2s937",
            ]
      ...
    }

  # yandex_compute_instance.web[1] will be created
  + resource "yandex_compute_instance" "web" {
      ...
      + name                      = "skv-develop-web-2"
      ...
      + network_interface {
        ...
          + security_group_ids = [
              + "enp6b9a4ei2uuuu2s937",
            ]
      ...
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```
```bash
# Применение файла запуска terraform
terraform apply "tfplan"
```
```
yandex_compute_instance.web[1]: Creating...
yandex_compute_instance.web[0]: Creating...
yandex_compute_instance.web[1]: Creation complete after 1m58s [id=fhmjkn5en8njp6q9kkek]
yandex_compute_instance.web[0]: Creation complete after 1m58s [id=fhm6n5abaa8mm5q4btrp]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```
```bash
# отображение созданных вм YC консоли
yc compute \
instance \
list
```
```
+----------------------+-------------------+---------------+---------+---------------+-------------+
|          ID          |       NAME        |    ZONE ID    | STATUS  |  EXTERNAL IP  | INTERNAL IP |
+----------------------+-------------------+---------------+---------+---------------+-------------+
| fhm6n5abaa8mm5q4btrp | skv-develop-web-1 | ru-central1-a | RUNNING | 62.84.116.211 | 10.0.1.16   |
| fhmjkn5en8njp6q9kkek | skv-develop-web-2 | ru-central1-a | RUNNING | 93.77.185.215 | 10.0.1.28   |
+----------------------+-------------------+---------------+---------+---------------+-------------+
```
```bash
# Описание общей переменной  list(object ресурсов web
cat >> variables.tf <<'EOF'

# Объединение в единую list(object -переменную each_vm
variable "each_vm" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    type          = string
    disk_volume   = number
    family        = string
    platform_id   = string
    core_fraction = number
    preemptible   = bool
    nat           = bool
  }))

  default = [
    {
      vm_name       = "skv-develop-main"
      cpu           = 4
      ram           = 4
      type          = "network-hdd"
      disk_volume   = 15 
      family        = "ubuntu-2404-lts-oslogin"
      platform_id   = "standard-v3"
      core_fraction = 20
      preemptible   = true
      nat           = true
    },
    {
      vm_name       = "skv-develop-replica"
      cpu           = 2
      ram           = 3
      type          = "network-hdd"
      disk_volume   = 10
      family        = "ubuntu-2404-lts-oslogin"
      platform_id   = "standard-v2"
      core_fraction = 5
      preemptible   = true
      nat           = false
    }
  ]
}
EOF

# Описание создания ВМ с использованием переменных
# Используем итератор for для списка вывода var.each_vm,
# чтобы получить map(object для переменной for_each
# Создание ВМ for_each loop методом
cat > for_each-vm.tf <<'EOF'
/* 
Перевод list(object в map(object и обозначаем в locals
Ассоциируем оператором "=>"
vm_name как map-ключ "i.vm_name"
с присвоением значением для "i"
дальнейшее обращение для for_each loop через local
*/
locals {
  to_map = { for i in var.each_vm : i.vm_name => i }
}

data "yandex_compute_image" "ubuntu_2404_lts" {
  for_each = local.to_map
  family   = each.value.family
}

# Создание ВМ for_each loop методом
resource "yandex_compute_instance" "db_vm" {
  for_each = local.to_map

  name        = each.value.vm_name
  platform_id = each.value.platform_id

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts[each.key].image_id
      type     = each.value.type
      size     = each.value.disk_volume
    }
  }

  scheduling_policy {
    preemptible = each.value.preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = each.value.nat
    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }

  metadata = var.vms_ssh
}
EOF

# Проверка прописанных переменных
terraform validate \
&& terraform fmt \
&& terraform plan -out=tfplan
```
```
Success! The configuration is valid.

data.yandex_compute_image.ubuntu_2404_lts["skv-develop-main"]: Reading...
data.yandex_compute_image.ubuntu_2404_lts["skv-develop-replica"]: Reading...
data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enpkp07cuvrvmcgjsiln]
data.yandex_compute_image.ubuntu_2404_lts["skv-develop-replica"]: Read complete after 0s [id=fd8gq5886iaaakiqhsjn]
data.yandex_compute_image.ubuntu_2404_lts["skv-develop-main"]: Read complete after 0s [id=fd8gq5886iaaakiqhsjn]
data.yandex_compute_image.ubuntu: Read complete after 0s [id=fd8gq5886iaaakiqhsjn]
yandex_vpc_subnet.develop: Refreshing state... [id=e9br1c8fes5avhndifp2]
yandex_vpc_security_group.example: Refreshing state... [id=enp6b9a4ei2uuuu2s937]
yandex_compute_instance.web[1]: Refreshing state... [id=fhmjkn5en8njp6q9kkek]
yandex_compute_instance.web[0]: Refreshing state... [id=fhm6n5abaa8mm5q4btrp]

....

Terraform will perform the following actions:
  # yandex_compute_instance.db_vm["skv-develop-main"] will be created
  + resource "yandex_compute_instance" "db_vm" {
...
      + name                      = "skv-develop-main"
...
      + platform_id               = "standard-v3"
....

      + boot_disk {
...
              + size        = 15
...
        }
...
      + network_interface {
...
          + nat                = true
...
        }
...
      + resources {
          + core_fraction = 20
          + cores         = 4
          + memory        = 4
        }
...
    }
  # yandex_compute_instance.db_vm["skv-develop-replica"] will be created
  + resource "yandex_compute_instance" "db_vm" {
...
      + name                      = "skv-develop-replica"
...
      + platform_id               = "standard-v2"
...
      + boot_disk {
...
              + size        = 10
...
    }
      + network_interface {
...
          + nat                = false
      + resources {
          + core_fraction = 5
          + cores         = 2
          + memory        = 3
        }
...
    }
Plan: 2 to add, 0 to change, 0 to destroy.
```
```bash
# Применение файла запуска terraform
terraform apply "tfplan"
```
```
yandex_compute_instance.db_vm["skv-develop-main"]: Creating...
yandex_compute_instance.db_vm["skv-develop-replica"]: Creating...
yandex_compute_instance.db_vm["skv-develop-replica"]: Creation complete after 29s [id=fhm9sldatnjnrs0thsvj]
yandex_compute_instance.db_vm["skv-develop-main"]: Creation complete after 32s [id=fhm6fpcf7okfji5igm4d]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```
```bash
# отображение созданных вм YC консоли
yc compute \
instance \
list
```
```
---------------------------------------------+---------------+---------+---------------+-------------+
|          ID          |        NAME         |    ZONE ID    | STATUS  |  EXTERNAL IP  | INTERNAL IP |
+----------------------+---------------------+---------------+---------+---------------+-------------+
| fhm6fpcf7okfji5igm4d | skv-develop-main    | ru-central1-a | RUNNING | 93.77.188.121 | 10.0.1.15   |
| fhm6n5abaa8mm5q4btrp | skv-develop-web-1   | ru-central1-a | RUNNING | 62.84.116.211 | 10.0.1.16   |
| fhm9sldatnjnrs0thsvj | skv-develop-replica | ru-central1-a | RUNNING |               | 10.0.1.35   |
| fhmjkn5en8njp6q9kkek | skv-develop-web-2   | ru-central1-a | RUNNING | 93.77.185.215 | 10.0.1.28   |
+----------------------+---------------------+---------------+---------+---------------+-------------+
```
```bash
cd ..

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . ../16_3_commit_commands_history.md \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am '16_3-terr_construct_3' \
&& git push \
--set-upstream \
study_fops39 \
16_3-terr_construct \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
16_3-terr_construct
```
## commit_4, `16_3-terr_construct`
```bash
# Добавляем в конфиг для count depends_on для запуска после ресурсов с переменными db_vm
sed -i '/"web" {/r /dev/stdin' count-vm.tf << 'EOF'
  # Для создания после ресурсов db_vm
  depends_on = [
    yandex_compute_instance.db_vm
  ]
EOF

# Описание общей переменной  map(object ресурсов для создания дисков методом count
cat >> variables.tf <<'EOF'

# Объявление единой map-переменной для дисков
variable "disk_count" {
  type = map(object({
    count         = number
    name          = string
    type          = string
    size          = number
  }))
  default = {
    disk_add = {
      count         = 3
      name          = "skv-disk"
      type          = "network-hdd"
      size          = 1
    }
  }
}
EOF

# Создание ресурса дисков методом count
cat > disk_vm.tf <<'EOF'
resource "yandex_compute_disk" "dobavo4_disk" {
  count    = var.disk_count["disk_add"].count
  name     = "${var.disk_count["disk_add"].name}-${count.index + 1}"
  type     = var.disk_count["disk_add"].type
  size     = var.disk_count["disk_add"].size
}
EOF

# создаем переменную для имени одиночной ВМ storage
cat >> variables.tf <<'EOF'
variable "vm_storage" {
  type        = string
  default     = "storage"
  description = "VM 3aDaHue 3 name"
}
EOF

# Создаем ВМ используя переменные ранее созданные для вм vm_web
cat >> disk_vm.tf <<'EOF'

resource "yandex_compute_instance" "storage" {
  name        = var.vm_storage
  platform_id = var.vms_resources["vm_web"].platform_id
  resources {
    cores         = var.vms_resources["vm_web"].cores
    memory        = var.vms_resources["vm_web"].memory
    core_fraction = var.vms_resources["vm_web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vms_resources["vm_web"].preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vms_resources["vm_web"].nat
    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }

  metadata = var.vms_ssh

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.dobavo4_disk
    content {
      disk_id = secondary_disk.value.id
    }
  }
}
EOF
```
```bash
# Проверка прописанных переменных
terraform validate \
&& terraform fmt \
&& terraform plan -out=tfplan
```
```
Success! The configuration is valid.

data.yandex_compute_image.ubuntu_2404_lts["skv-develop-main"]: Reading...
data.yandex_compute_image.ubuntu_2404_lts["skv-develop-replica"]: Reading...
data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enpkp07cuvrvmcgjsiln]
data.yandex_compute_image.ubuntu_2404_lts["skv-develop-main"]: Read complete after 0s [id=fd8gq5886iaaakiqhsjn]
data.yandex_compute_image.ubuntu: Read complete after 0s [id=fd8gq5886iaaakiqhsjn]
data.yandex_compute_image.ubuntu_2404_lts["skv-develop-replica"]: Read complete after 0s [id=fd8gq5886iaaakiqhsjn]
yandex_vpc_subnet.develop: Refreshing state... [id=e9br1c8fes5avhndifp2]
yandex_vpc_security_group.example: Refreshing state... [id=enp6b9a4ei2uuuu2s937]
yandex_compute_instance.db_vm["skv-develop-replica"]: Refreshing state... [id=fhm9sldatnjnrs0thsvj]
yandex_compute_instance.db_vm["skv-develop-main"]: Refreshing state... [id=fhm6fpcf7okfji5igm4d]
yandex_compute_instance.web[0]: Refreshing state... [id=fhm6n5abaa8mm5q4btrp]
yandex_compute_instance.web[1]: Refreshing state... [id=fhmjkn5en8njp6q9kkek]

Terraform will perform the following actions:

  # yandex_compute_disk.dobavo4_disk[0] will be created
  + resource "yandex_compute_disk" "dobavo4_disk" {
...
      + name        = "skv-disk-1"
...
      + size        = 1
...
    }

  # yandex_compute_disk.dobavo4_disk[1] will be created
  + resource "yandex_compute_disk" "dobavo4_disk" {
...
      + name        = "skv-disk-2"
...
      + size        = 1
...
    }

  # yandex_compute_disk.dobavo4_disk[2] will be created
  + resource "yandex_compute_disk" "dobavo4_disk" {
...
      + name        = "skv-disk-3"
...
      + size        = 1
...
    }

  # yandex_compute_instance.storage will be created
  + resource "yandex_compute_instance" "storage" {
...

      + secondary_disk {
...
        }
      + secondary_disk {
...
        }
      + secondary_disk {
...
        }
    }

Plan: 4 to add, 0 to change, 0 to destroy.
```
```bash
# Применение файла запуска terraform
terraform apply "tfplan"
```
```
yandex_compute_disk.dobavo4_disk[2]: Creating...
yandex_compute_disk.dobavo4_disk[0]: Creating...
yandex_compute_disk.dobavo4_disk[1]: Creating...
yandex_compute_disk.dobavo4_disk[2]: Creation complete after 6s [id=fhmi2drr6ofvgd26vthf]
yandex_compute_disk.dobavo4_disk[0]: Creation complete after 6s [id=fhmo1bafl00njejvrgco]
yandex_compute_disk.dobavo4_disk[1]: Creation complete after 6s [id=fhm8ghrkvf2apjah2pig]
yandex_compute_instance.storage: Creating...
yandex_compute_instance.storage: Creation complete after 37s [id=fhmkf8flraaqsv5gauqp]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```
```bash
# отображение созданных вм YC консоли
yc compute \
instance \
list
```
```
+----------------------+---------------------+---------------+---------+---------------+-------------+
|          ID          |        NAME         |    ZONE ID    | STATUS  |  EXTERNAL IP  | INTERNAL IP |
+----------------------+---------------------+---------------+---------+---------------+-------------+
| fhm6fpcf7okfji5igm4d | skv-develop-main    | ru-central1-a | RUNNING | 93.77.188.121 | 10.0.1.15   |
| fhm6n5abaa8mm5q4btrp | skv-develop-web-1   | ru-central1-a | RUNNING | 62.84.116.211 | 10.0.1.16   |
| fhm9sldatnjnrs0thsvj | skv-develop-replica | ru-central1-a | RUNNING |               | 10.0.1.35   |
| fhmjkn5en8njp6q9kkek | skv-develop-web-2   | ru-central1-a | RUNNING | 93.77.185.215 | 10.0.1.28   |
| fhmkf8flraaqsv5gauqp | storage             | ru-central1-a | RUNNING | 158.160.32.10 | 10.0.1.4    |
+----------------------+---------------------+---------------+---------+---------------+-------------+
```
```bash
# отображение созданных дисков в YC консоли
yc compute \
disk \
list
```
```
+----------------------+------------+-------------+---------------+--------+----------------------+-----------------+-------------+
|          ID          |    NAME    |    SIZE     |     ZONE      | STATUS |     INSTANCE IDS     | PLACEMENT GROUP | DESCRIPTION |
+----------------------+------------+-------------+---------------+--------+----------------------+-----------------+-------------+
| fhm144lhkheougqrc4ug |            | 10737418240 | ru-central1-a | READY  | fhm6n5abaa8mm5q4btrp |                 |             |
| fhm1k1n6h8d2imhfiv49 |            | 10737418240 | ru-central1-a | READY  | fhmkf8flraaqsv5gauqp |                 |             |
| fhm5ghm8gnjn0eqdal2o |            | 10737418240 | ru-central1-a | READY  | fhmjkn5en8njp6q9kkek |                 |             |
| fhm8ghrkvf2apjah2pig | skv-disk-2 |  1073741824 | ru-central1-a | READY  | fhmkf8flraaqsv5gauqp |                 |             |
| fhmd1d81rkql57hpslt1 |            | 16106127360 | ru-central1-a | READY  | fhm6fpcf7okfji5igm4d |                 |             |
| fhmebd3ardnt2sjq8vj8 |            | 10737418240 | ru-central1-a | READY  | fhm9sldatnjnrs0thsvj |                 |             |
| fhmi2drr6ofvgd26vthf | skv-disk-3 |  1073741824 | ru-central1-a | READY  | fhmkf8flraaqsv5gauqp |                 |             |
| fhmo1bafl00njejvrgco | skv-disk-1 |  1073741824 | ru-central1-a | READY  | fhmkf8flraaqsv5gauqp |                 |             |
+----------------------+------------+-------------+---------------+--------+----------------------+-----------------+-------------+
```
```bash
cd ..

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . ../16_3_commit_commands_history.md \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am '16_3-terr_construct_4' \
&& git push \
--set-upstream \
study_fops39 \
16_3-terr_construct \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
16_3-terr_construct
```
## commit_5, `16_3-terr_construct`
```bash