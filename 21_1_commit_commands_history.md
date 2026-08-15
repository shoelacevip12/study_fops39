# Для домашнего задания 21.1 `Базовые объекты K8S`

## commit_72, master Предварительная подготовка

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

# Удаление всех файлов и каталогов кроме нужных
find kuber-homeworks/ \
-mindepth 1 \
-not -path "*1.2*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем
mv -v kuber-homeworks \
21_1

# Переход в каталог по последней переменной вывода последней команды
cd !$
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
git commit -am 'commit_72, master' \
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

## commit_1, `21_1-pods-bases`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 21_1-pods-bases

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
git commit -am 'commit1, 21_1-pods-bases' \
&& git push \
--set-upstream \
study_fops39 \
21_1-pods-bases \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_1-pods-bases \
&& git push \
--set-upstream \
study-fops39_sc \
21_1-pods-bases
```

## commit_2,`21_1-pods-bases`

```bash
# Поиск пакета kubectl в репозиториях
sudo pacman -Ss kubectl
```

<details>
<summary>
поиск пакета kubectl
</summary>

```log
extra/krew 0.5.0-1 (kubectl-plugins)
    Find and install kubectl plugins
extra/kubectl 1.36.3-1 (kubernetes-tools) [установлен]
    A command line tool for communicating with a Kubernetes API server
extra/kubectl-cert-manager 1.13.3-2 (kubectl-plugins)
    Automatically provision and manage TLS certificates in Kubernetes
extra/kubectl-ingress-nginx 1.12.0-2 (kubectl-plugins)
    kubectl plugin for managing NGINX Ingress Controller for Kubernetes
extra/kubectx 0.11.0-1
    Utility to manage and switch between kubectl contexts and Kubernetes namespaces
```

</details>

```bash
# Обновление и установка пакета kubectl
sudo pacman -Syu kubectl
```

<details>
<summary>
установка kubectl
</summary>

```log
Будет установлено:  85,08 MiB

:: Приступить к установке? [Y/n] Y
(1/1) проверка ключей                                                                [################################################] 100%
(1/1) проверка целостности пакета                                                    [################################################] 100%
(1/1) загрузка файлов пакетов                                                        [################################################] 100%
(1/1) проверка конфликтов файлов                                                     [################################################] 100%
(1/1) проверка доступного места                                                      [################################################] 100%
:: Обработка изменений пакета...
(1/1) установка kubectl                                                              [################################################] 100%
:: Запуск post-transaction hooks...
(1/1) Arming ConditionNeedsUpdate...
```

</details>

```bash
# Проверка версии установленного kubectl
kubectl version --client
```

<details>
<summary>
проверка версии kubectl
</summary>

```log
Client Version: v1.36.3
Kustomize Version: v5.8.1
```

</details>

```bash
# Поиск пакета kind (Kubernetes IN Docker) в репозиториях
sudo pacman -Ss kind | grep -B1 Docker
```

<details>
<summary>
поиск пакета kind
</summary>

```log
extra/kind 0.32.0-2
    Kubernetes IN Docker - local clusters for testing Kubernetes
```

</details>

```bash
# Обновление и установка пакета kind
sudo pacman -Syu kind
```

<details>
<summary>
установка kind
</summary>

```log
Пакеты (1) kind-0.32.0-2

Будет установлено:  10,14 MiB

:: Приступить к установке? [Y/n] Y
(1/1) проверка ключей                                                                [################################################] 100%
(1/1) проверка целостности пакета                                                    [################################################] 100%
(1/1) загрузка файлов пакетов                                                        [################################################] 100%
(1/1) проверка конфликтов файлов                                                     [################################################] 100%
(1/1) проверка доступного места                                                      [################################################] 100%
:: Обработка изменений пакета...
(1/1) установка kind                                                                 [################################################] 100%
Дополнительные зависимости для 'kind'
    docker: docker node provider [установлено]
    podman: podman node provider [установлено]
    nerdctl: nerdctl node provider
:: Запуск post-transaction hooks...
(1/1) Arming ConditionNeedsUpdate...
```

</details>

```bash
# Добавление модуля overlay в систему
echo 'overlay' \
| sudo tee /etc/modules-load.d/overlay.conf

# Пересборка initramfs образов
sudo mkinitcpio -P
```

<details>
<summary>
пересборка initramfs
</summary>

```log
overlay

==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'default'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux -g /boot/initramfs-linux.img
==> Starting build: '7.1.8-arch1-3'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
  -> Running build hook: [autodetect]
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
  -> Running build hook: [keyboard]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux.img'
  -> Early uncompressed CPIO image generation successful
==> Initcpio image generation successful
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'fallback'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux -g /boot/initramfs-linux-fallback.img -S autodetect
==> Starting build: '7.1.8-arch1-3'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
  -> Running build hook: [keyboard]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-fallback.img'
  -> Early uncompressed CPIO image generation successful
==> Initcpio image generation successful
==> Building image from preset: /etc/mkinitcpio.d/linux-zen.preset: 'default'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux-zen -g /boot/initramfs-linux-zen.img
==> Starting build: '7.1.8-zen1-3-zen'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
  -> Running build hook: [autodetect]
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
  -> Running build hook: [keyboard]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-zen.img'
  -> Early uncompressed CPIO image generation successful
==> Initcpio image generation successful
==> Building image from preset: /etc/mkinitcpio.d/linux-zen.preset: 'fallback'
==> Using default configuration file: '/etc/mkinitcpio.conf'
  -> -k /boot/vmlinuz-linux-zen -g /boot/initramfs-linux-zen-fallback.img -S autodetect
==> Starting build: '7.1.8-zen1-3-zen'
  -> Running build hook: [base]
  -> Running build hook: [systemd]
  -> Running build hook: [microcode]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
  -> Running build hook: [keyboard]
  -> Running build hook: [sd-vconsole]
  -> Running build hook: [block]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-zen-fallback.img'
  -> Early uncompressed CPIO image generation successful
==> Initcpio image generation successful
```

</details>

```bash
sudo reboot
```

```bash
# Проверка загрузки модуля overlay
sudo lsmod \
| grep overlay
```

<details>
<summary>
проверка модуля overlay
</summary>

```log
overlay               270336  0
```

</details>

```bash
# Запуск docker и проверка его активности
sudo bash -c "systemctl start docker && systemctl is-active docker"
```

<details>
<summary>
запуск и проверка docker
</summary>

```log
active
```

</details>

```
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit1, 21_1-pods-bases' \
&& git push \
--set-upstream \
study_fops39 \
21_1-pods-bases \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
21_1-pods-bases \
&& git push \
--set-upstream \
study-fops39_sc \
21_1-pods-bases
```

## commit_3,`21_1-pods-bases`