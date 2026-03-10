# Для домашнего задания 16.2
## commit_52, master Предварительная подготовка
```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master
```
```
Уже на «master»
Эта ветка соответствует «study_fops39_gitflic_ru/master».
```
```bash
# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/ter-homeworks.git

# Удаление всех файлов и каталогов кроме каталога 02 и его содержимого
find ter-homeworks/ \
-mindepth 1 \
-not -path "*02*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 16_2
mv ter-homeworks/02 16_2

# Переход в каталог по последней переменной вывода последней команды (16_2)
cd !$
```
```
cd 16_2
```
```bash
# Удаление оставшейся оставшейся части клона репозитория
rm -rf \
../ter-homeworks

# Просмотр текущих удаленных репозиториев
git remote -v

# Проверка текущего локального состояния репозитория
git status
```
```
Текущая ветка: master
Эта ветка соответствует «study_fops39_gitflic_ru/master».

Изменения, которые не в индексе для коммита:
  (используйте «git add/rm <файл>...», чтобы добавить или удалить файл из индекса)
  (используйте «git restore <файл>...», чтобы отменить изменения в рабочем каталоге)
        удалено:       ../16_1/tf_2/hosts_docker.sh

Неотслеживаемые файлы:
  (используйте «git add <файл>...», чтобы добавить в то, что будет включено в коммит)
        ./
        ../16_2_commit_commands_history.md

индекс пуст (используйте «git add» и/или «git commit -a»)
```
```bash
# для отмены изменений в каталоге
git restore \
./16_1/tf_2/hosts_docker.sh

# Проверка что что файл прошлой работы hosts_docker.sh был исключен для изменений
git status
```
```
Текущая ветка: master
Эта ветка соответствует «study_fops39_gitflic_ru/master».

Неотслеживаемые файлы:
  (используйте «git add <файл>...», чтобы добавить в то, что будет включено в коммит)
        ./
        ../16_2_commit_commands_history.md

индекс пуст, но есть неотслеживаемые файлы
(используйте «git add», чтобы проиндексировать их)
```
```bash
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
        новый файл:    demo/demostration1.tf
        новый файл:    demo/demostration2.tf
        новый файл:    demo/providers.tf
        новый файл:    hw-02.md
        новый файл:    src/.gitignore
        новый файл:    src/.terraformrc
        новый файл:    src/console.tf
        новый файл:    src/locals.tf
        новый файл:    src/main.tf
        новый файл:    src/outputs.tf
        новый файл:    src/providers.tf
        новый файл:    src/variables.tf

Неотслеживаемые файлы:
  (используйте «git add <файл>...», чтобы добавить в то, что будет включено в коммит)
        ../16_2_commit_commands_history.md
```
```bash
git diff \
&& git diff --staged

# Просмотр истории коммитов в кратком формате
git log --oneline

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий
git commit -am 'commit_52, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```
## commit_1, `16_2-terr_osnovy`
```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 16_2-terr_osnovy

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . ../16_2_commit_commands_history.md \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am '16_2-terr_osnovy' \
&& git push \
--set-upstream \
study_fops39 \
16_2-terr_osnovy \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
16_2-terr_osnovy
```
## commit_2, `16_2-terr_osnovy`
```bash
# Изменение под типовую работу наименование файла с заданием
mv {hw-02,README}.md

# Дислокация кода работы репозитория
cd src

# Создание сервисного аккаунта по ранее подключенному yandex cloud
yc iam \
service-account \
create \
--name skv-seracc
```
```
id: ajexxxxxxxxxxxx3micr
folder_id: b1g7qviodfc9v4k81sr5
created_at: "2026-03-10T19:04:52Z"
name: skv-seracc
```
```bash
# Добавление сервисного аккаунта в заранее созданную группу с правами admin на организацию
# Где:
# --id — идентификатор группы с выданными правами admin. Обязательный параметр.
# --organization-id — идентификатор организации. Обязательный параметр.
# --subject-id — идентификатор участника, которого добавляют в группу.

yc organization-manager group add-members \
--id ajexxxxxxxxxxxxxdk37 \
--organization-id bpxxxxxxxxxxxxxxxk2m \
--subject-id ajexxxxxxxxxxxx3micr

# Создание json ключа к сервисному аккаунту c использованием переменных в ~/.bashrc Для YC
yc iam key create \
--service-account-name $(yc iam \
                        service-account \
                        --folder-id  $YC_FOLDER_ID list \
                        | awk '/skv/{print $4}') \
--output ~/.authorized_key.json \
--folder-id $YC_FOLDER_ID
```
```
id: ajexxxxxxxxxxxx7o215
service_account_id: ajexxxxxxxxxxxx3micr
created_at: "2026-03-10T19:16:05.289441568Z"
key_algorithm: RSA_2048
```
```bash
# Проверка наличия файла
file ~/.authorized_key.json
```
```
/home/shoel/.authorized_key.json: JSON text data
```
```bash
# применение сервисного ключа для работы из консоли YC
yc config set \
service-account-key \
~/.authorized_key.json

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
# использование ранее сгенерированного ключа в файле tf для переменных variables.tf
sed -i "s|<your_ssh_ed25519_key>|\
$(cat ~/.ssh/id_lab16_1_fops39_ed25519.pub)|" \
variables.tf

# Смена требований к версии terraform c 1.2.X, на 1.X
sed -i 's/1.12.0/1.12/' \
providers.tf

# Добавление переменных значений default к переменным cloud_id и folder_id
sed -i '/\/cloud\/get-id"/a\
  default     = "'"$YC_CLOUD_ID"'"
' variables.tf

sed -i '/\/folder\/get-id"/a\
  default     = "'"$YC_FOLDER_ID"'"
' variables.tf

# исправление параметров развертывания ВМ указания правильной платформы
sed -i 's/standart-v4/standard-v2/' \
main.tf

# исправление параметров развертывания ВМ правильное количество ядер для standard-v2
sed -i 's/s         = 1/s         = 2/' \
main.tf

# Инициализация Terraform конфигурации
terraform init
```
```
Initializing the backend...
Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.191.0...
- Installed yandex-cloud/yandex v0.191.0 (unauthenticated)
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
```
```bash
# Проверка tf файлов проекта и создание файла запуска terraform
terraform init --upgrade \
&& terraform validate \
&& terraform fmt \
&& terraform plan -out=tfplan
```
```
Success! The configuration is valid.

data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 0s [id=fd8vn6ra61c01hq58q75]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.platform will be created
  + resource "yandex_compute_instance" "platform" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hardware_generation       = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "ssh-keys"           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMT2pZfiY4KUIeybtsJjbp42JjiUySw5e34KiNprFsc lab16_1_fops39"
        }
      + name                      = "netology-develop-platform-web"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8vn6ra61c01hq58q75"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options (known after apply)

      + network_interface {
          + index          = (known after apply)
          + ip_address     = (known after apply)
          + ipv4           = true
          + ipv6           = (known after apply)
          + ipv6_address   = (known after apply)
          + mac_address    = (known after apply)
          + nat            = true
          + nat_ip_address = (known after apply)
          + nat_ip_version = (known after apply)
          + subnet_id      = (known after apply)
        }

      + placement_policy (known after apply)

      + resources {
          + core_fraction = 5
          + cores         = 2
          + memory        = 1
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_vpc_network.develop will be created
  + resource "yandex_vpc_network" "develop" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "develop"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.develop will be created
  + resource "yandex_vpc_subnet" "develop" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "develop"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan
```
```bash
# Применение файла запуска terraform
terraform apply "tfplan"
```
```
yandex_vpc_network.develop: Creating...
yandex_vpc_network.develop: Creation complete after 3s [id=enpq6g30sdfklkf272f5]
yandex_vpc_subnet.develop: Creating...
yandex_vpc_subnet.develop: Creation complete after 0s [id=e9bbuaoq63v9trubk0ch]
yandex_compute_instance.platform: Creating...
yandex_compute_instance.platform: Still creating... [00m10s elapsed]
yandex_compute_instance.platform: Still creating... [00m20s elapsed]
yandex_compute_instance.platform: Still creating... [00m30s elapsed]
yandex_compute_instance.platform: Still creating... [00m40s elapsed]
yandex_compute_instance.platform: Creation complete after 40s [id=fhmg9nh2d1jdb234gdh3]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```
```bash
#
terraform destroy

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
git add . ../16_2_commit_commands_history.md \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am '16_2-terr_osnovy_2' \
&& git push \
--set-upstream \
study_fops39 \
16_2-terr_osnovy \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
16_2-terr_osnovy
```