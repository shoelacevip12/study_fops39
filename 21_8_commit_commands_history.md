# Для домашнего задания 21.8 `Установка Kubernetes`

## commit_83, master Предварительная подготовка

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
https://github.com/netology-code/kuber-homeworks.git

cd kuber-homeworks

# Удаление всех файлов и каталогов кроме нужных
find kuber-homeworks/ \
-mindepth 1 \
-not -path "*3.2*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем
mv -v kuber-homeworks \
21_8

# Переход в каталог по последней переменной вывода последней команды
cd !$

mv -v 3.2/* ./

# Удаление всех файлов и каталогов кроме нужных
find . \
-mindepth 1 \
-not -path "*3.2.md*" \
-delete

# Переименование 
mv -v {3.2,README}.md
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
git commit -am 'commit_83, master' \
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

## commit_1, `21_8-kubeadm-inst`


```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 21_8-kubeadm-inst

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
git commit -am 'commit1, 21_8-kubeadm-inst' \
&& git push \
--set-upstream \
study_fops39 \
21_8-kubeadm-inst \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_8-kubeadm-inst \
&& git push \
--set-upstream \
study-fops39_sc \
21_8-kubeadm-inst
```

## commit_2,`21_8-kubeadm-inst`


### Удаление кластера kind из предыдущего задания

```bash
# Удаление кластера kind из предыдущего задания
kind delete cluster \
--name="$(kind get clusters |head -n1)"
```

<details>
<summary>
Удаление кластера kind из предыдущего задания
</summary>

```log
Deleting cluster "skv-21-2-k8s-depl" ...
Deleted nodes: ["skv-21-2-k8s-depl-worker2" "skv-21-2-k8s-depl-worker" "skv-21-2-k8s-depl-control-plane"]
```

</details>

### Запуск lcx контейнеров

### Archlinux host libvirt lxc

#### Включение nested виртуализации

```bash
# Включаем агента в текущей оснастке для подключения к хост на archlinux
> ~/.ssh/known_hosts
eval $(ssh-agent) \
&& ssh-add  ~/.ssh/id_kvm_host

# вход на хост по ключу по ssh и вход под суперпользователя
ssh -t \
-i ~/.ssh/id_kvm_host \
-o StrictHostKeyChecking=accept-new \
shoel@192.168.89.193

# Проверка вложенной виртуализации компьютером на процессоре AMD 
# (если intel заменить amd в команде ниже)
sudo cat /sys/module/kvm_amd/parameters/nested

```

<details>
<summary>
Включение nested виртуализации
</summary>

```log
1
```

</details>

```bash
# Предварительно выключить все виртуальные машины на хосте
# и выгрузить модуль ядра kvm для процессора amd
sudo modprobe \
-r \
kvm_amd

# Включение модуля kvm с включенной nested виртуализацией, работающей до перезапуска хоста
sudo modprobe kvm_amd nested=1

# Выставление опции загрузки nested виртуализации в автозапуск
echo "options kvm_amd nested=1" \
| sudo tee /etc/modprobe.d/kvm_amd.conf

ls -l /dev/kvm
```

```log
crw-rw-rw- 1 root kvm 10, 232 авг 25 18:40 /dev/kvm
```

#### Создание сети моста средствами systemd

```bash
# отключаем и останавливаем NetworkManager и связанные службы
systemctl \
disable --now \
NetworkManager \
NetworkManager-wait-online

# Включение и запуск служб управления сетью systemd
systemctl \
enable --now \
systemd-networkd \
systemd-resolved


# Создание Интерфейс моста как устройства
cat >/etc/systemd/network/15-br0.netdev<<'EOF'
[NetDev]
Name=br0
Kind=bridge
EOF

# Привязка в существующем конфиге физического Ethernet к мосту
cat >/etc/systemd/network/10-eno1.network<<'EOF'
[Match]
Name=eno1

[Network]
Bridge=br0
EOF

# Сеть моста, создаем настройки IP
cat > /etc/systemd/network/15-br0.network <<'EOF'
[Match]
Name=br0

[Network]
DHCP=ipv4
EOF

# Перезапуск сетевой службы
systemctl restart \
systemd-networkd
```


```bash
# Поиск пакета libvirt с lxc
sudo pacman -Qi libvirt \
| grep -B10 lxc
```

<details>
<summary>
Поиск пакета libvirt с lxc
</summary>

```log
Название             : libvirt
Версия               : 1:12.6.0-1
Описание             : API for controlling virtualization engines (openvz,kvm,qemu,virtualbox,xen,etc)
Архитектура          : x86_64
URL                  : https://libvirt.org/
Лицензии             : LGPL-2.1-or-later  GPL-3.0-or-later
Группы               : Нет
Предоставляет        : libvirt=12.6.0  libvirt.so=0-64  libvirt-admin.so=0-64  libvirt-lxc.so=0-64  libvirt-qemu.so=0-64
```

</details>>

```bash
# Установка пакета libvirt
sudo pacman -Syu libvirt
```

<details>
<summary>
Установка пакета libvirt
</summary>

```log
...
проверка конфликтов...

Пакеты (1) libvirt-1:12.6.0-1

Будет установлено:  55,22 MiB
Изменение размера:   0,00 MiB

:: Приступить к установке? [Y/n] Y
...
```

</details>

```bash
sudo sh -c "systemctl start libvirtd \
&& systemctl is-active libvirtd" 
```

```log
active
```

```bash
# Получение URI libvirt
virsh -c lxc:/// uri \
| grep lxc
```

<details>
<summary>
Получение URI libvirt
</summary>

```log
lxc:///
```

</details>

```bash
# Проверка прав для libvirt для пользователя НЕ root
virsh -c lxc:/// list --all
```

<details>
<summary>
Проверка прав для libvirt для пользователя НЕ root
</summary>

```log
 ID   Имя   Состояние
-----------------------
```

</details>


### Развертывание ВМ средствами virt-manager, подключение с удаленного хоста


### Управление ВМ средствами virt-manager, подключение с удаленного узла

```bash
eval $(ssh-agent) && ssh-add  ~/.ssh/id_kvm_host
export LIBVIRT_DEFAULT_URI=lxc+ssh://shoel@192.168.89.193/system

virt-manager -c lxc+ssh://shoel@192.168.89.193/system
```

```bash
mkdir local-stand

cd !$
```

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, 21_8-kubeadm-inst' \
&& git push \
--set-upstream \
study_fops39 \
21_8-kubeadm-inst \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_8-kubeadm-inst \
&& git push \
--set-upstream \
study-fops39_sc \
21_8-kubeadm-inst
```

## commit_3,`21_8-kubeadm-inst`

```bash

```

<details>
<summary>

</summary>

```log

```

</details>

```bash

```

<details>
<summary>

</summary>

```log

```

</details>