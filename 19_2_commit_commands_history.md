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
Обновление модулей коллекции prometheus и grafana
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
https://github.com/grafana/grafana-ansible-collection.git

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
inventory=../hosts.ini
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

<details>
<summary>
Файл playbook установки prometheus
</summary>

```bash
cp -v ansible.cfg ansible/

cat >ansible/prometheus_server.yaml<<'EOF'
#!/usr/bin/env ansible-playbook
---
- hosts: prom-core[0]
  become: yes
  vars:
    prometheus_targets:
      node:
      - targets:
        - localhost:9100
        - "{{ groups['node_exp'][0] }}:9100"
  roles:
    - prometheus

- hosts: node_exp:prom-core[0]
  become: yes
  roles:
    - node_exporter
...
EOF
```

</details>

---

<details>
<summary>
Файл playbook установки grafana
</summary>

```bash
cp -v ansible.cfg ansible_gr/

cat >ansible/prometheus_server.yaml<<'EOF'
#!/usr/bin/env ansible-playbook
---
- hosts: prom-core[0]
  become: yes
  vars:
    grafana_ini:
      security:
        admin_user: admin
        admin_password: test@skv
    grafana_datasources:
      - name: "Prometheus"
        type: "prometheus"
        url: 'http://localhost:9090'
    grafana_deb_url: "https://drive.usercontent.google.com/download?id=10Wo3Dhrian9jF45VxwRjmkZyzxZqFgc3&export=download&authuser=0&confirm=t&uuid=9e8897bf-399b-4531-a2e6-31d77f27dd43&at=AAINaIJK6oaBpb0lKiG6oZqVCAFu%3A1782061744193"
    grafana_deb_file: "grafana_13.0.2_26816849631_linux_amd64.deb"

  pre_tasks:
    - name: Download Grafana DEB package
      get_url:
        url: "{{ grafana_deb_url }}"
        dest: "/tmp/{{ grafana_deb_file }}"
        mode: '0644'
        timeout: 300
        headers:
          Content-Disposition: "attachment"

    - name: Install Grafana from DEB package
      apt:
        deb: "/tmp/{{ grafana_deb_file }}"
        state: present
  roles:
    - grafana
...
EOF
```

</details>

---

<details>
<summary>
Исправление Ansible Такси для роли Grafana под установку из .deb пакета
</summary>

```bash
cat >ansible_gr/roles/grafana/tasks/install.yml<<'EOF'
---
- name: "Remove conflicting grafana packages"
  ansible.builtin.package:
    name: grafana-data
    state: absent

- name: "Prepare zypper"
  when:
    - "ansible_facts['pkg_mgr'] == 'zypper'"
    - "(grafana_manage_repo)"
  environment: "{{ grafana_environment }}"
  block:
    - name: import Grafana RPM Key
      ansible.builtin.rpm_key:
        state: present
        key: "{{ grafana_yum_key }}"

    - name: "Add Grafana zypper repository"
      community.general.zypper_repository:
        name: grafana
        description: grafana
        repo: "{{ grafana_yum_repo }}"
        enabled: true
        disable_gpg_check : "{{ false if (grafana_yum_key) else omit }}"
        runrefresh: true
      when: "(not grafana_rhsm_repo)"

- name: "Prepare yum/dnf"
  when:
    - "ansible_facts['pkg_mgr'] in ['yum', 'dnf']"
    - "(grafana_manage_repo)"
  environment: "{{ grafana_environment }}"
  block:
    - name: "Add Grafana yum/dnf repository"
      ansible.builtin.yum_repository:
        name: grafana
        description: grafana
        baseurl: "{{ grafana_yum_repo }}"
        enabled: true
        gpgkey: "{{ grafana_yum_key | default(omit) }}"
        repo_gpgcheck: "{{ true if (grafana_yum_key) else omit }}"
        gpgcheck: "{{ true if (grafana_yum_key) else omit }}"
      when: "(not grafana_rhsm_repo)"

    - name: "Attach RHSM subscription"
      when: "(grafana_rhsm_subscription)"
      block:
        - name: "Check if Grafana RHSM subscription is enabled"
          ansible.builtin.command:
            cmd: "subscription-manager list --consumed --matches={{ grafana_rhsm_subscription | quote }} --pool-only"
          register: __subscription_manager_consumed
          changed_when: false
          when: (grafana_rhsm_subscription)

        - name: "Find RHSM repo subscription pool id"
          ansible.builtin.command:
            cmd: "subscription-manager list --available --matches={{ grafana_rhsm_subscription | quote }} --pool-only"
          register: __subscription_manager_available
          changed_when: false
          when:
            - "(grafana_rhsm_subscription)"
            - "__subscription_manager_consumed.stdout | length <= 0"

        - name: "Attach RHSM subscription"
          ansible.builtin.command:
            cmd: "subscription-manager attach --pool={{ __subscription_manager_available.stdout }}"
          register: __subscription_manager_attach
          changed_when: "__subscription_manager_attach.stdout is search('Successfully attached a subscription')"
          failed_when: "__subscription_manager_attach.stdout is search('could not be found')"
          when:
            - "(grafana_rhsm_subscription)"
            - "__subscription_manager_consumed.stdout | default() | length <= 0"
            - "__subscription_manager_available.stdout | default() | length > 0"

    - name: "Enable RHSM repository"
      community.general.rhsm_repository:
        name: "{{ grafana_rhsm_repo }}"
        state: enabled
      when: (grafana_rhsm_repo)
EOF
```

</details>

---

<details>
<summary>
Исправление Ansible главной Такси для роли Grafana под установку из .deb пакета
</summary>

```bash
cat >ansible_gr/roles/grafana/tasks/main.yml<<'EOF'
---
- name: Inherit default vars
  ansible.builtin.set_fact:
    grafana_ini: "{{ grafana_ini_default | ansible.builtin.combine(grafana_ini | default({}), recursive=true) }}"
  no_log: "{{ 'false' if lookup('env', 'CI') else 'true' }}"
  tags:
    - always
- name: "Gather variables for each operating system"
  ansible.builtin.include_vars: "{{ distrovars }}"
  vars:
    distrovars: "{{ lookup('first_found', params, errors='ignore') }}"
    params:
      skip: true
      files:
        - "{{ ansible_facts['distribution'] | lower }}-{{ ansible_facts['distribution_version'] | lower }}.yml"
        - "{{ ansible_facts['distribution'] | lower }}-{{ ansible_facts['distribution_major_version'] | lower }}.yml"
        - "{{ ansible_facts['os_family'] | lower }}-{{ ansible_facts['distribution_major_version'] | lower }}.yml"
        - "{{ ansible_facts['distribution'] | lower }}.yml"
        - "{{ ansible_facts['os_family'] | lower }}.yml"
      paths:
        - "vars/distro"
  tags:
    - grafana_configure
    - grafana_datasources
    - grafana_notifications
    - grafana_dashboards

- name: Preflight
  ansible.builtin.include_tasks:
    file: preflight.yml
    apply:
      tags:
        - grafana_configure
        - grafana_datasources
        - grafana_notifications
        - grafana_dashboards

- name: Configure
  ansible.builtin.include_tasks:
    file: configure.yml
    apply:
      become: true
      tags:
        - grafana_configure

- name: Plugins
  ansible.builtin.include_tasks:
    file: plugins.yml
    apply:
      tags:
        - grafana_configure
  when: "grafana_plugins != []"

- name: "Restart grafana before configuring datasources and dashboards"
  ansible.builtin.meta: flush_handlers
  tags:
    - grafana_configure
    - grafana_datasources
    - grafana_notifications
    - grafana_dashboards
    - grafana_run

- name: "Wait for grafana to start"
  ansible.builtin.wait_for:
    host: "{{ grafana_ini.server.http_addr if grafana_ini.server.protocol is undefined or grafana_ini.server.protocol in ['http', 'https'] else omit }}"
    port: "{{ grafana_ini.server.http_port if grafana_ini.server.protocol is undefined or grafana_ini.server.protocol in ['http', 'https'] else omit }}"
    path: "{{ grafana_ini.server.socket | default() if grafana_ini.server.protocol is defined and grafana_ini.server.protocol == 'socket' else omit }}"
  tags:
    - grafana_configure
    - grafana_datasources
    - grafana_notifications
    - grafana_dashboards
    - grafana_run

- name: "Api keys"
  ansible.builtin.include_tasks:
    file: api_keys.yml
    apply:
      tags:
        - grafana_configure
        - grafana_run
  when: "grafana_api_keys | length > 0"

- name: Datasources
  ansible.builtin.include_tasks:
    file: datasources.yml
    apply:
      tags:
        - grafana_configure
        - grafana_datasources
        - grafana_run
  when: "grafana_datasources != []"

- name: Notifications
  ansible.builtin.include_tasks:
    file: notifications.yml
    apply:
      tags:
        - grafana_configure
        - grafana_notifications
        - grafana_run
  when: "grafana_alert_notifications | length > 0 or grafana_alert_resources | length > 0"

- name: Find dashboards to be provisioned
  ansible.builtin.find:
    paths: "{{ grafana_dashboards_dir }}"
    recurse: true
    patterns: "*.json"
  delegate_to: localhost
  become: false
  register: __found_dashboards

- name: Dashboards
  ansible.builtin.include_tasks:
    file: dashboards.yml
    apply:
      tags:
        - grafana_configure
        - grafana_dashboards
        - grafana_run
  when: "grafana_dashboards | length > 0 or __found_dashboards['files'] | length > 0"
EOF
```

</details>

---

```bash
yc components update

export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

terraform init
```

<details>
<summary>
Лог инициализации terraform
</summary>

```log
Initializing provider plugins found in the configuration...
- Finding latest version of yandex-cloud/yandex...
- Finding latest version of hashicorp/local...
- Installing yandex-cloud/yandex v0.209.0...
- Installed yandex-cloud/yandex v0.209.0 (unauthenticated)
- Installing hashicorp/local v2.9.0...
- Installed hashicorp/local v2.9.0 (unauthenticated)

Initializing the backend...


Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

╷
│ Warning: Incomplete lock file information for providers
│ 
│ Due to your customized provider installation methods, Terraform was forced to calculate lock file checksums locally for the following providers:
│   - hashicorp/local
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

</details>

```bash
terraform validate \
&& terraform fmt  \
&& terraform init --upgrade \
&& terraform plan -out=tfplan
```

<details>
<summary>
Лог проверок, авто-форматирования и создания plan запуска
</summary>

```log
Success! The configuration is valid.

Initializing provider plugins found in the configuration...
- Finding latest version of hashicorp/local...
- Finding latest version of yandex-cloud/yandex...
- Using previously-installed hashicorp/local v2.9.0
- Using previously-installed yandex-cloud/yandex v0.209.0

Initializing the backend...



Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
data.yandex_compute_image.ubuntu_2404_lts: Reading...
data.yandex_compute_image.ubuntu_2404_lts: Read complete after 1s [id=fd8tm4ja1he7v7vknauu]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.hosts-ans will be created
  + resource "local_file" "hosts-ans" {
      + content              = (known after apply)
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "./hosts.ini"
      + id                   = (known after apply)
    }

  # yandex_compute_instance.node-epx will be created
  + resource "yandex_compute_instance" "node-epx" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hardware_generation       = (known after apply)
      + hostname                  = "node-epx"
      + id                        = (known after apply)
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "user-data"          = <<-EOT
                #cloud-config
                users:
                  - name: skv
                    groups: sudo
                    shell: /bin/bash
                    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
                    ssh_authorized_keys:
                      - ssh-ed25519 XXXXXXXxxxxXXXXxxXXXXXxxXXxXXxxXxXXXxxXXxxxxxXxxxXXxxxxXXXXxxxXXXxxx 19-02
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
            EOT
        }
      + name                      = "node-epx"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8tm4ja1he7v7vknauu"
              + name        = (known after apply)
              + size        = 10
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options (known after apply)

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy (known after apply)

      + resources {
          + core_fraction = 5
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_compute_instance.prom-core will be created
  + resource "yandex_compute_instance" "prom-core" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hardware_generation       = (known after apply)
      + hostname                  = "prom-core"
      + id                        = (known after apply)
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "user-data"          = <<-EOT
                #cloud-config
                users:
                  - name: skv
                    groups: sudo
                    shell: /bin/bash
                    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
                    ssh_authorized_keys:
                      - ssh-ed25519 XXXXXXXxxxxXXXXxxXXXXXxxXXxXXxxXxXXXxxXXxxxxxXxxxXXxxxxXXXXxxxXXXxxx 19-02
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
            EOT
        }
      + name                      = "prom-core"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8tm4ja1he7v7vknauu"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options (known after apply)

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy (known after apply)

      + resources {
          + core_fraction = 20
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_vpc_gateway.nat_gateway will be created
  + resource "yandex_vpc_gateway" "nat_gateway" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "fops-gateway-19-02"

      + shared_egress_gateway {}
    }

  # yandex_vpc_network.skv will be created
  + resource "yandex_vpc_network" "skv" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "skv-fops39-19-02"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_route_table.route will be created
  + resource "yandex_vpc_route_table" "route" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "fops-route-table-19-02"
      + network_id = (known after apply)

      + static_route {
          + destination_prefix = "0.0.0.0/0"
          + gateway_id         = (known after apply)
            # (1 unchanged attribute hidden)
        }
    }

  # yandex_vpc_security_group.LAN will be created
  + resource "yandex_vpc_security_group" "LAN" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "LAN-19-02"
      + network_id = (known after apply)
      + status     = (known after apply)

      + egress {
          + description       = "Permit ANY"
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + protocol          = "ANY"
          + to_port           = 65535
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }

      + ingress {
          + description       = "Allow 10.10.10.0/26"
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + protocol          = "ANY"
          + to_port           = 65535
          + v4_cidr_blocks    = [
              + "10.10.10.0/26",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
    }

  # yandex_vpc_security_group.nod_gra will be created
  + resource "yandex_vpc_security_group" "nod_gra" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "nod_gra-19-02"
      + network_id = (known after apply)
      + status     = (known after apply)

      + egress (known after apply)

      + ingress {
          + description       = "Allow HTTP"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 80
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
      + ingress {
          + description       = "Allow HTTPS"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 443
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
      + ingress {
          + description       = "Allow Prometheus"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 9090
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "10.10.10.0/26",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
      + ingress {
          + description       = "Node Exporter"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 9100
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "10.10.10.0/26",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
    }

  # yandex_vpc_security_group.prom-core will be created
  + resource "yandex_vpc_security_group" "prom-core" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "prom-core-19-02"
      + network_id = (known after apply)
      + status     = (known after apply)

      + egress (known after apply)

      + ingress {
          + description       = "Allow 0.0.0.0/0"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 22
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
      + ingress {
          + description       = "Allow HTTP"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 80
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
      + ingress {
          + description       = "Allow HTTPS"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 443
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
      + ingress {
          + description       = "Allow Prometheus"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 9090
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
      + ingress {
          + description       = "Grafana веб UI"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 3000
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
      + ingress {
          + description       = "Node Exporter"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 9100
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
    }

  # yandex_vpc_subnet.skv_a will be created
  + resource "yandex_vpc_subnet" "skv_a" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "skv-fops-19-02-ru-central1-a"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "10.10.10.0/28",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 10 to add, 0 to change, 0 to destroy.

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan
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
git commit -am 'commit3, 19_2-monitoring_prom_graf_2' \
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

## commit_4, `19_2-monitoring_prom_graf`

```bash

export ANSIBLE_ALLOW_BROKEN_CONDITIONALS=true

terraform apply "tfplan"
```

```bash
rm ~/.ssh/known_hosts \
; eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_19-2_ed25519 \
&& for d in {120..1}; do \
echo -n "Лучше подождать чем получить ошибку =): $d сек." \
; sleep 1 \
; echo -ne "\r"; done \
&& ssh -o StrictHostKeyChecking=no -i \
~/.ssh/id_19-2_ed25519 -A skv@$(awk 'NR==5' hosts.ini | cut -d' ' -f1) hostnamectl \
&& yc compute instance list

sed -i 's/Description=Prometheus/Description=Prometheus Service Netology Lesson 19.2 — [Скворцов Д.В.]/g' \
"ansible/roles/prometheus/templates/prometheus.service.j2"

sed -i 's/Description=Prometheus Node Exporter/Description=Node Exporter Netology Lesson 19.2 — [Скворцов Д.В.]/g' \
"ansible/roles/node_exporter/templates/node_exporter.service.j2"
```