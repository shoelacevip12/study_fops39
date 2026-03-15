# Домашнее задание к занятию «`Управляющие конструкции в коде Terraform`» `Скворцов Денис`

### Цели задания

1. Отработать основные принципы и методы работы с управляющими конструкциями Terraform.
2. Освоить работу с шаблонизатором Terraform (Interpolation Syntax).

------

### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Доступен исходный код для выполнения задания в директории [**03/src**](https://github.com/netology-code/ter-homeworks/tree/main/03/src).
4. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

------

### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
Убедитесь что ваша версия **Terraform** ~>1.12.0
Теперь пишем красивый код, хардкод значения не допустимы!
------

### Задание 1

1. Изучите проект.
2. Инициализируйте проект, выполните код. 


Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud .

```bash
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

![](img/1.png)

------

### Задание 2

1. Создайте файл count-vm.tf. Опишите в нём создание двух **одинаковых** ВМ  web-1 и web-2 (не web-0 и web-1) с минимальными параметрами, используя мета-аргумент **count loop**. Назначьте ВМ созданную в первом задании группу безопасности.(как это сделать узнайте в документации провайдера yandex/compute_instance )
2. Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ для баз данных с именами "main" и "replica" **разных** по cpu/ram/disk_volume , используя мета-аргумент **for_each loop**. Используйте для обеих ВМ одну общую переменную типа:
```
variable "each_vm" {
  type = list(object({  vm_name=string, cpu=number, ram=number, disk_volume=number }))
}
```  
При желании внесите в переменную все возможные параметры.
4. ВМ из пункта 2.1 должны создаваться после создания ВМ из пункта 2.2.
5. Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2.
6. Инициализируйте проект, выполните код.

------

```bash
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
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```
```bash
# отображение созданных вм YC консоли
yc compute \
instance \
list
```
|          ID          |       NAME        |    ZONE ID    | STATUS  |  EXTERNAL IP  | INTERNAL IP |
|----------------------|---------------------|---------------|---------|---------------|-------------|
| fhm6n5abaa8mm5q4btrp | skv-develop-web-1 | ru-central1-a | RUNNING | 62.84.116.211 | 10.0.1.16   |
| fhmjkn5en8njp6q9kkek | skv-develop-web-2 | ru-central1-a | RUNNING | 93.77.185.215 | 10.0.1.28   |

![](img/2.png)

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

# Добавляем в конфиг для count.tf depends_on для запуска после ресурсов с переменными db_vm
sed -i '/"web" {/r /dev/stdin' count-vm.tf << 'EOF'
  # Для создания после ресурсов db_vm
  depends_on = [
    yandex_compute_instance.db_vm
  ]
EOF


# Проверка прописанных переменных
terraform validate \
&& terraform fmt \
&& terraform plan -out=tfplan
```
```
Success! The configuration is valid.
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
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```
```bash
# отображение созданных вм YC консоли
yc compute \
instance \
list
```

|          ID          |        NAME         |    ZONE ID    | STATUS  |  EXTERNAL IP  | INTERNAL IP |
|----------------------|---------------------|---------------|---------|---------------|-------------|
| fhm6fpcf7okfji5igm4d | skv-develop-main    | ru-central1-a | RUNNING | 93.77.188.121 | 10.0.1.15   |
| fhm6n5abaa8mm5q4btrp | skv-develop-web-1   | ru-central1-a | RUNNING | 62.84.116.211 | 10.0.1.16   |
| fhm9sldatnjnrs0thsvj | skv-develop-replica | ru-central1-a | RUNNING |               | 10.0.1.35   |
| fhmjkn5en8njp6q9kkek | skv-develop-web-2   | ru-central1-a | RUNNING | 93.77.185.215 | 10.0.1.28   |

![](img/3.png)


### Задание 3

1. Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле **disk_vm.tf** .
2. Создайте в том же файле **одиночную**(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage"  . Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

```bash
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
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```
```bash
# отображение созданных вм YC консоли
yc compute \
instance \
list
```

|          ID          |        NAME         |    ZONE ID    | STATUS  |  EXTERNAL IP  | INTERNAL IP |
|----------------------|---------------------|---------------|---------|---------------|-------------|
| fhm6fpcf7okfji5igm4d | skv-develop-main    | ru-central1-a | RUNNING | 93.77.188.121 | 10.0.1.15   |
| fhm6n5abaa8mm5q4btrp | skv-develop-web-1   | ru-central1-a | RUNNING | 62.84.116.211 | 10.0.1.16   |
| fhm9sldatnjnrs0thsvj | skv-develop-replica | ru-central1-a | RUNNING |               | 10.0.1.35   |
| fhmjkn5en8njp6q9kkek | skv-develop-web-2   | ru-central1-a | RUNNING | 93.77.185.215 | 10.0.1.28   |
| fhmkf8flraaqsv5gauqp | storage             | ru-central1-a | RUNNING | 158.160.32.10 | 10.0.1.4    |


```bash
# отображение созданных дисков в YC консоли
yc compute \
disk \
list
```
|          ID          |    NAME    |    SIZE     |     ZONE      | STATUS |     INSTANCE IDS     | PLACEMENT GROUP | DESCRIPTION |
|----------------------|------------|-------------|---------------|--------|----------------------|-----------------|-------------|
| fhm144lhkheougqrc4ug |            | 10737418240 | ru-central1-a | READY  | fhm6n5abaa8mm5q4btrp |                 |             |
| fhm1k1n6h8d2imhfiv49 |            | 10737418240 | ru-central1-a | READY  | fhmkf8flraaqsv5gauqp |                 |             |
| fhm5ghm8gnjn0eqdal2o |            | 10737418240 | ru-central1-a | READY  | fhmjkn5en8njp6q9kkek |                 |             |
| fhm8ghrkvf2apjah2pig | skv-disk-2 |  1073741824 | ru-central1-a | READY  | fhmkf8flraaqsv5gauqp |                 |             |
| fhmd1d81rkql57hpslt1 |            | 16106127360 | ru-central1-a | READY  | fhm6fpcf7okfji5igm4d |                 |             |
| fhmebd3ardnt2sjq8vj8 |            | 10737418240 | ru-central1-a | READY  | fhm9sldatnjnrs0thsvj |                 |             |
| fhmi2drr6ofvgd26vthf | skv-disk-3 |  1073741824 | ru-central1-a | READY  | fhmkf8flraaqsv5gauqp |                 |             |
| fhmo1bafl00njejvrgco | skv-disk-1 |  1073741824 | ru-central1-a | READY  | fhmkf8flraaqsv5gauqp |                 |             |


![](img/4.png) ![](img/5.png)

------

### Задание 4

1. В файле ansible.tf создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demo).
Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.
2. Инвентарь должен содержать 3 группы и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.
3. Добавьте в инвентарь переменную  [**fqdn**](https://cloud.yandex.ru/docs/compute/concepts/network#hostname).
``` 
[webservers]
web-1 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
web-2 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[databases]
main ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
replica ansible_host<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[storage]
storage ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
```
Пример fqdn: ```web1.ru-central1.internal```(в случае указания переменной hostname(не путать с переменной name)); ```fhm8k1oojmm5lie8i22a.auto.internal```(в случае отсутствия переменной hostname - автоматическая генерация имени,  зона изменяется на auto). нужную вам переменную найдите в документации провайдера или terraform console.
4. Выполните код. Приложите скриншот получившегося файла. 

Для общего зачёта создайте в вашем GitHub-репозитории новую ветку terraform-03. Закоммитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.   
**Удалите все созданные ресурсы**.

```bash
# создание файла hosts.ini через local_file
cat > inventory.tf <<'EOF'
# через locals Преобразовываем обращение к переменным как к list
locals {
  # web - list
  web_instances = yandex_compute_instance.web
  # db_vm - преобразование map в list через values()
  db_instances = values(yandex_compute_instance.db_vm)
  # storage - из одного объекта формируем list []
  storage_instance = [yandex_compute_instance.storage]
  # Объединение в общий instances list
  all_instances = concat(local.web_instances, local.db_instances, local.storage_instance)
}

# Создание динамичного hosts.ini через tftpl файл
resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl", {
    web     = local.web_instances,
    db      = local.db_instances,
    storage = local.storage_instance
  })

  filename = "${abspath(path.module)}/hosts.ini"
}
EOF

# создание файла шаблона содержимого
cat > hosts.tftpl <<'EOF'
[web]

%{~ for i in web ~}
 ${i.name}   ansible_host=${i.network_interface[0].nat_ip_address != "" ? i.network_interface[0].nat_ip_address : i.network_interface[0].ip_address} fqdn=${i.fqdn}
%{ endfor ~}

[db]

%{~ for i in db ~}
 ${i.name}   ansible_host=${i.network_interface[0].nat_ip_address != "" ? i.network_interface[0].nat_ip_address : i.network_interface[0].ip_address} fqdn=${i.fqdn}
%{ endfor ~}

[storage]

%{~ for i in storage ~}
 ${i.name}   ansible_host=${i.network_interface[0].nat_ip_address != "" ? i.network_interface[0].nat_ip_address : i.network_interface[0].ip_address} fqdn=${i.fqdn}
%{ endfor ~}

[all:vars]

ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_lab16_1_fops39_ed25519
EOF

# Проверка прописанных переменных
terraform validate \
&& terraform fmt \
&& terraform plan -out=tfplan
```
```
Success! The configuration is valid.

data.yandex_compute_image.ubuntu_2404_lts["skv-develop-main"]: Reading...
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu_2404_lts["skv-develop-replica"]: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enpkp07cuvrvmcgjsiln]
yandex_compute_disk.dobavo4_disk[1]: Refreshing state... [id=fhm8ghrkvf2apjah2pig]
yandex_compute_disk.dobavo4_disk[2]: Refreshing state... [id=fhmi2drr6ofvgd26vthf]
yandex_compute_disk.dobavo4_disk[0]: Refreshing state... [id=fhmo1bafl00njejvrgco]
data.yandex_compute_image.ubuntu: Read complete after 0s [id=fd8gq5886iaaakiqhsjn]
data.yandex_compute_image.ubuntu_2404_lts["skv-develop-main"]: Read complete after 0s [id=fd8gq5886iaaakiqhsjn]
data.yandex_compute_image.ubuntu_2404_lts["skv-develop-replica"]: Read complete after 0s [id=fd8gq5886iaaakiqhsjn]
yandex_vpc_subnet.develop: Refreshing state... [id=e9br1c8fes5avhndifp2]
yandex_vpc_security_group.example: Refreshing state... [id=enp6b9a4ei2uuuu2s937]
yandex_compute_instance.db_vm["skv-develop-replica"]: Refreshing state... [id=fhm9sldatnjnrs0thsvj]
yandex_compute_instance.db_vm["skv-develop-main"]: Refreshing state... [id=fhm6fpcf7okfji5igm4d]
yandex_compute_instance.storage: Refreshing state... [id=fhmkf8flraaqsv5gauqp]
yandex_compute_instance.web[1]: Refreshing state... [id=fhmjkn5en8njp6q9kkek]
yandex_compute_instance.web[0]: Refreshing state... [id=fhm6n5abaa8mm5q4btrp]
...
Terraform will perform the following actions:

  # local_file.hosts_templatefile will be created
  + resource "local_file" "hosts_templatefile" {
      + content              = <<-EOT
            [web]
             skv-develop-web-1   ansible_host=62.84.116.211 fqdn=fhm6n5abaa8mm5q4btrp.auto.internal
             skv-develop-web-2   ansible_host=93.77.185.215 fqdn=fhmjkn5en8njp6q9kkek.auto.internal
            
            [db]
             skv-develop-main   ansible_host=93.77.188.121 fqdn=fhm6fpcf7okfji5igm4d.auto.internal
             skv-develop-replica   ansible_host=10.0.1.35 fqdn=fhm9sldatnjnrs0thsvj.auto.internal
            
            [storage]
             storage   ansible_host=158.160.32.10 fqdn=fhmkf8flraaqsv5gauqp.auto.internal
            
            [all:vars]
            
            ansible_user=ubuntu
            ansible_ssh_private_key_file=~/.ssh/id_lab16_1_fops39_ed25519
        EOT
...
      + filename             = "/home/shoel/nfs_git/gited/16_3/src/hosts.ini"
...

Plan: 1 to add, 0 to change, 0 to destroy.
```
```bash
# Применение файла запуска terraform
terraform apply "tfplan"
```
```
local_file.hosts_templatefile: Creating...
local_file.hosts_templatefile: Creation complete after 0s [id=7e3dc046a8b329d03d5bf61f3d4c98fc09aec2c2]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

![](img/6.png)

------

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 


