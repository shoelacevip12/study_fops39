# Для домашнего задания 19.1 `Системы мониторинга`

## commit_66, master Предварительная подготовка

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
https://github.com/netology-code/mnt-homeworks.git

# Удаление всех файлов и каталогов кроме каталога 10-monitoring-03-grafana
find mnt-homeworks/ \
-mindepth 1 \
-not -path "*10-monitoring-03-grafana*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 19_2
mv mnt-homeworks/10-monitoring-03-grafana \
19_2

# Переход в каталог по последней переменной вывода последней команды (19_2)
cd !$

rms -rfv help
```

<details>
<summary>
cd в рабочую директорию
</summary>

```log
cd 19_2
```

</details>

```bash
# создание каталогов под скриншоты
mkdir -v img
```

<details>
<summary>
Создание каталога для изображений
</summary>

```log
mkdir: создан каталог 'img'
```

</details>

```bash
# Удаление оставшейся оставшейся части клона репозитория
rm -rfv \
../mnt-homeworks
```

<details>
<summary>
Удаление лишнего для Задания
</summary>

```log
../mnt-homeworks
удалён каталог '../mnt-homeworks'
```

</details>

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
git commit -am 'commit_66_1, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```

## commit_1, `19_2-monitoring_prom_graf`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 19_2-monitoring_prom_graf

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

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий
git commit -am 'commit1, 19_2-monitoring_prom_graf' \
&& git push \
--set-upstream \
study_fops39 \
19_2-monitoring_prom_graf \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
19_2-monitoring_prom_graf
```

## commit_2, `19_2-monitoring_prom_graf`

```bash
ssh-keygen \
-f ~/.ssh/id_19-2_ed25519 \
-t ed25519 -C "19-02"
```

<details>
<summary>
Генерация ключу для работы
</summary>

```log
Generating public/private ed25519 key pair.
Enter passphrase for "/home/shoel/.ssh/id_19-2_ed25519" (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/shoel/.ssh/id_19-2_ed25519
Your public key has been saved in /home/shoel/.ssh/id_19-2_ed25519.pub
The key fingerprint is:
SHA256:avRJjDVk5pUZtS289cjrFPZyrf1nYCGxE3WYWsjJ4uc 19-02
The key's randomart image is:
+--[ED25519 256]--+
|        + oB.+.o.|
|       = .+.Bo+. |
|        +. .+*o  |
|       + .. *=.o |
|      o S  o.o=..|
|     . + .  E.o+.|
|      o o    .+.+|
|     .       o =o|
|              o.=|
+----[SHA256]-----+
```

</details>

```bash
mkdir -v tf

cd !$
```

<details>
<summary>
Формирование cloud-init для базового развертывания ВМ
</summary>

```bash
cat >cloud-init.yml<<'EOF'
#cloud-config
users:
  - name: skv
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ssh-ed25519
    lock_passwd: false
package_update: true
package_upgrade: true
packages:
  - wget
  - curl
  - gnupg
  - software-properties-common
  - python3-psycopg2
  - acl
  - locales-all
EOF

sed -i "8s|.*|      - $(cat ~/.ssh/id_19-2_ed25519.pub)|" cloud-init.yml
```

</details>

```bash
ansible-galaxy collection \
install \
prometheus.prometheus \
grafana.grafana \
--force
```

<details>
<summary>
Обновление модулей коллекции prometheus
</summary>

```log
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Downloading https://galaxy.ansible.com/api/v3/plugin/ansible/content/published/collections/artifacts/prometheus-prometheus-0.30.0.tar.gz to /home/shoel/.ansible/tmp/ansible-local-15245hq2s2v2m/tmpi5n4tw47/prometheus-prometheus-0.30.0-126hee2m
Installing 'prometheus.prometheus:0.30.0' to '/home/shoel/.ansible/collections/ansible_collections/prometheus/prometheus'
Downloading https://galaxy.ansible.com/api/v3/plugin/ansible/content/published/collections/artifacts/grafana-grafana-6.1.0.tar.gz to /home/shoel/.ansible/tmp/ansible-local-15245hq2s2v2m/tmpi5n4tw47/grafana-grafana-6.1.0-vx9s0tmc
prometheus.prometheus:0.30.0 was installed successfully
Installing 'grafana.grafana:6.1.0' to '/home/shoel/.ansible/collections/ansible_collections/grafana/grafana'
grafana.grafana:6.1.0 was installed successfully
'community.general:13.0.1' is already installed, skipping.
'ansible.posix:2.2.0' is already installed, skipping.
'community.grafana:2.3.0' is already installed, skipping.
```

</details>

```bash
git clone \
https://github.com/prometheus-community/ansible.git

rm -rfv ansible/.git
```

<details>
<summary>
удаление кеша git проекта
</summary>

```log
удалён 'ansible/.git/description'
удалён 'ansible/.git/hooks/post-update.sample'
удалён 'ansible/.git/hooks/pre-rebase.sample'
удалён 'ansible/.git/hooks/pre-commit.sample'
удалён 'ansible/.git/hooks/pre-receive.sample'
удалён 'ansible/.git/hooks/commit-msg.sample'
удалён 'ansible/.git/hooks/pre-push.sample'
удалён 'ansible/.git/hooks/applypatch-msg.sample'
удалён 'ansible/.git/hooks/pre-applypatch.sample'
удалён 'ansible/.git/hooks/update.sample'
удалён 'ansible/.git/hooks/fsmonitor-watchman.sample'
удалён 'ansible/.git/hooks/push-to-checkout.sample'
удалён 'ansible/.git/hooks/pre-merge-commit.sample'
удалён 'ansible/.git/hooks/sendemail-validate.sample'
удалён 'ansible/.git/hooks/prepare-commit-msg.sample'
удалён каталог 'ansible/.git/hooks'
удалён 'ansible/.git/info/exclude'
удалён каталог 'ansible/.git/info'
удалён 'ansible/.git/objects/pack/pack-82d0b30c5d6e31e6ae590f368ac6e8df7a99d0b8.pack'
удалён 'ansible/.git/objects/pack/pack-82d0b30c5d6e31e6ae590f368ac6e8df7a99d0b8.rev'
удалён 'ansible/.git/objects/pack/pack-82d0b30c5d6e31e6ae590f368ac6e8df7a99d0b8.idx'
удалён каталог 'ansible/.git/objects/pack'
удалён каталог 'ansible/.git/objects/info'
удалён каталог 'ansible/.git/objects'
удалён 'ansible/.git/refs/heads/main'
удалён каталог 'ansible/.git/refs/heads'
удалён каталог 'ansible/.git/refs/tags'
удалён 'ansible/.git/refs/remotes/origin/HEAD'
удалён каталог 'ansible/.git/refs/remotes/origin'
удалён каталог 'ansible/.git/refs/remotes'
удалён каталог 'ansible/.git/refs'
удалён 'ansible/.git/packed-refs'
удалён 'ansible/.git/logs/refs/remotes/origin/HEAD'
удалён каталог 'ansible/.git/logs/refs/remotes/origin'
удалён каталог 'ansible/.git/logs/refs/remotes'
удалён 'ansible/.git/logs/refs/heads/main'
удалён каталог 'ansible/.git/logs/refs/heads'
удалён каталог 'ansible/.git/logs/refs'
удалён 'ansible/.git/logs/HEAD'
удалён каталог 'ansible/.git/logs'
удалён 'ansible/.git/HEAD'
удалён 'ansible/.git/config'
удалён 'ansible/.git/index'
удалён каталог 'ansible/.git'
```

</details>

```bash
git clone \
git clone https://github.com/grafana/grafana-ansible-collection.git

mv -v grafana-ansible-collection ansible_gr

rm -rfv ansible_gr/.git
```

<details>
<summary>
удаление кеша git проекта
</summary>

```log
renamed 'grafana-ansible-collection' -> 'ansible_gr'
[shoel@shoellin tf]$ rm -rfv ansible_gr/.git
удалён 'ansible_gr/.git/description'
удалён 'ansible_gr/.git/hooks/post-update.sample'
удалён 'ansible_gr/.git/hooks/pre-rebase.sample'
удалён 'ansible_gr/.git/hooks/pre-commit.sample'
удалён 'ansible_gr/.git/hooks/pre-receive.sample'
удалён 'ansible_gr/.git/hooks/commit-msg.sample'
удалён 'ansible_gr/.git/hooks/pre-push.sample'
удалён 'ansible_gr/.git/hooks/applypatch-msg.sample'
удалён 'ansible_gr/.git/hooks/pre-applypatch.sample'
удалён 'ansible_gr/.git/hooks/update.sample'
удалён 'ansible_gr/.git/hooks/fsmonitor-watchman.sample'
удалён 'ansible_gr/.git/hooks/push-to-checkout.sample'
удалён 'ansible_gr/.git/hooks/pre-merge-commit.sample'
удалён 'ansible_gr/.git/hooks/sendemail-validate.sample'
удалён 'ansible_gr/.git/hooks/prepare-commit-msg.sample'
удалён каталог 'ansible_gr/.git/hooks'
удалён 'ansible_gr/.git/info/exclude'
удалён каталог 'ansible_gr/.git/info'
удалён 'ansible_gr/.git/objects/pack/pack-fa4b4e2c010731cdd9c0cef45d16f5b783ef7a48.pack'
удалён 'ansible_gr/.git/objects/pack/pack-fa4b4e2c010731cdd9c0cef45d16f5b783ef7a48.rev'
удалён 'ansible_gr/.git/objects/pack/pack-fa4b4e2c010731cdd9c0cef45d16f5b783ef7a48.idx'
удалён каталог 'ansible_gr/.git/objects/pack'
удалён каталог 'ansible_gr/.git/objects/info'
удалён каталог 'ansible_gr/.git/objects'
удалён 'ansible_gr/.git/refs/heads/main'
удалён каталог 'ansible_gr/.git/refs/heads'
удалён каталог 'ansible_gr/.git/refs/tags'
удалён 'ansible_gr/.git/refs/remotes/origin/HEAD'
удалён каталог 'ansible_gr/.git/refs/remotes/origin'
удалён каталог 'ansible_gr/.git/refs/remotes'
удалён каталог 'ansible_gr/.git/refs'
удалён 'ansible_gr/.git/packed-refs'
удалён 'ansible_gr/.git/logs/refs/remotes/origin/HEAD'
удалён каталог 'ansible_gr/.git/logs/refs/remotes/origin'
удалён каталог 'ansible_gr/.git/logs/refs/remotes'
удалён 'ansible_gr/.git/logs/refs/heads/main'
удалён каталог 'ansible_gr/.git/logs/refs/heads'
удалён каталог 'ansible_gr/.git/logs/refs'
удалён 'ansible_gr/.git/logs/HEAD'
удалён каталог 'ansible_gr/.git/logs'
удалён 'ansible_gr/.git/HEAD'
удалён 'ansible_gr/.git/config'
удалён 'ansible_gr/.git/index'
удалён каталог 'ansible_gr/.git'
```

</details>

```bash
pushd ../..

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
./

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 19_2-monitoring_prom_graf_2' \
&& git push \
--set-upstream \
study_fops39 \
19_2-monitoring_prom_graf \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
19_2-monitoring_prom_graf

popd
```

<details>
<summary>
Возврат в директорию с работой
</summary>

```log
~/nfs_git/gited/19_2/tf
```

</details>

## commit_3, `19_2-monitoring_prom_graf`

<details>
<summary>
tf-файл описания провайдера terraform
</summary>

```bash
cat >providers.tf<<'EOF'
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "<зона_доступности_по_умолчанию>"
}
EOF
```

</details>

---

<details>
<summary>
tf-файл описания основных переменных
</summary>

```bash
cat >variables.tf<<'EOF'
variable "dz" {
  type    = string
  default = "19-02"
}

variable "cloud_id" {
  type    = string
  default = "b1g46dhqv17rkjcoc9k7"
}

variable "folder_id" {
  type    = string
  default = "b1g9l0vgsvf6cegkvj1c"
}

variable "host" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }
}

variable "srv" {
  type = map(number)
  default = {
    cores         = 4
    memory        = 4
    core_fraction = 20
  }
}
EOF
```

</details>

---

<details>
<summary>
tf-файл описания сети
</summary>

```bash
cat >network.tf<<'EOF'
#Общая облачная сеть yandex
resource "yandex_vpc_network" "skv" {
  name = "skv-fops39-${var.dz}"
}

#Подсеть zone A
resource "yandex_vpc_subnet" "skv_a" {
  name           = "skv-fops-${var.dz}-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.skv.id
  v4_cidr_blocks = ["10.10.10.0/28"]
  route_table_id = yandex_vpc_route_table.route.id
}

#Сеть под NAT
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "fops-gateway-${var.dz}"
  shared_egress_gateway {}
}

#Шлюз для выхода в WAN
resource "yandex_vpc_route_table" "route" {
  name       = "fops-route-table-${var.dz}"
  network_id = yandex_vpc_network.skv.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}
EOF
```

</details>

---

<details>
<summary>
tf-файл описания сетевого доступа
</summary>

```bash
cat >security_groups.tf<<'EOF'
##Правила NAT
#Разрешаем Всем Входящие соединения по 22 порту по протоколу TCP, необходимо для proxy-jump до сети 10.10.10.0/26
#Разрешаем Всем входящие соединения по протоколу TCP по 80,443 портам
#Разрешаем Всем входящие соединения по протоколу TCP по 3000
resource "yandex_vpc_security_group" "prom-core" {
  name       = "prom-core-${var.dz}"
  network_id = yandex_vpc_network.skv.id
  ingress {
    description    = "Allow 0.0.0.0/0"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Grafana веб UI"
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow Prometheus"
    protocol       = "TCP"
    port           = 9090
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Node Exporter"
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#Разрешаем всем из-под внутренних подсетей zone A,B,D выход на любые ресурсы по любому протоколу
resource "yandex_vpc_security_group" "LAN" {
  name       = "LAN-${var.dz}"
  network_id = yandex_vpc_network.skv.id
  ingress {
    description    = "Allow 10.10.10.0/26"
    protocol       = "ANY"
    v4_cidr_blocks = ["10.10.10.0/26"]
    from_port      = 0
    to_port        = 65535
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}

#Разрешаем любые входящие соединения по протоколу TCP по 80,443 портам
#Разрешаем входящие из-под сети 10.10.10.0/26 по TCP Протоколу до порта 9090
#Разрешаем входящие из-под сети 10.10.10.0/26 по TCP Протоколу до порта 9100
resource "yandex_vpc_security_group" "nod_gra" {
  name       = "nod_gra-${var.dz}"
  network_id = yandex_vpc_network.skv.id


  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description    = "Allow Prometheus"
    protocol       = "TCP"
    port           = 9090
    v4_cidr_blocks = ["10.10.10.0/26"]
  }

  ingress {
    description    = "Node Exporter"
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.10.10.0/26"]
  }
}
EOF
```

</details>

---

<details>
<summary>
tf-файл описания развертываемых ресурсов
</summary>

```bash
cat >vms.tf<<'EOG'
#считываем данные об образе ОС
data "yandex_compute_image" "ubuntu_2404_lts" {
  family = "ubuntu-2404-lts-oslogin"
}

resource "yandex_compute_instance" "prom-core" {
  name        = "prom-core"
  hostname    = "prom-core"
  platform_id = "standard-v2"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = var.srv.cores
    memory        = var.srv.memory
    core_fraction = var.srv.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.skv_a.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.prom-core.id]
  }
}


resource "yandex_compute_instance" "node-epx" {
  name        = "node-epx"
  hostname    = "node-epx"
  platform_id = "standard-v2"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!


  resources {
    cores         = var.host.cores
    memory        = var.host.memory
    core_fraction = var.host.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.skv_a.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.nod_gra.id]
  }
}


resource "local_file" "hosts-ans" {
  content  = <<-XYZ
  [all:vars]
  ansible_user=skv
  ansible_ssh_private_key_file=~/.ssh/id_19-2_ed25519
  [prom-core]
  ${yandex_compute_instance.prom-core.network_interface.0.nat_ip_address}
  ${yandex_compute_instance.prom-core.network_interface.0.ip_address} 

  [node_exp]
  ${yandex_compute_instance.node-epx.network_interface.0.ip_address}

  [node_exp:vars]
  ansible_ssh_common_args = '-o ProxyCommand="ssh -p 22 -o StrictHostKeyChecking=accept-new -W %h:%p -q skv@${yandex_compute_instance.prom-core.network_interface.0.nat_ip_address}"'
    XYZ
  filename = "./hosts.ini"
}
EOG
```

</details>

---

<details>
<summary>
Файл ansible.cfg для текущего задания
</summary>

```bash
cat >ansible.cfg<<'EOF'
[defaults]
inventory=./hosts.ini
host_key_checking=False
interpreter_python=auto_silent
deprecation_warnings=False
retry_files_enabled=False
callback_enabled=profile_tasks
[privilege_escalation]
[persistent_connection]
[connection]
[colors]
[selinux]
[diff]
[galaxy]
[inventory]
[netconf_connection]
[paramiko_connection]
[jinja2]
[tags]
[runas_become_plugin]
[su_become_plugin]
[sudo_become_plugin]
[callback_tree]
[ssh_connection]
[winrm]
[inventory_plugins]
[inventory_plugin_script]
[inventory_plugin_yaml]
[url_lookup]
[powershell]
[vars_host_group_vars]
EOF
```

</details>

---
