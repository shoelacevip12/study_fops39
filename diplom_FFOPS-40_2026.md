# Для Дипломная работа профессии "DevOps-инженер" `Дипломный практикум в Yandex.Cloud`

## commit_91, master Предварительная подготовка

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
https://github.com/netology-code/devops-diplom-yandexcloud.git


# Удаление всех файлов и каталогов кроме нужных
find devops-diplom-yandexcloud/ \
-mindepth 1 \
-not -path "*README.md*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем
mv -v devops-diplom-yandexcloud \
FFOPS-40_diplom-skv_den

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
git commit -am 'commit_91, master' \
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

## commit_1, `FFOPS-40_diplom-skv_den`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b FFOPS-40_diplom-skv_den

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
git commit -am 'commit1, FFOPS-40_diplom-skv_den' \
; git push \
--set-upstream \
study_fops39 \
FFOPS-40_diplom-skv_den \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
FFOPS-40_diplom-skv_den \
&& git push \
--set-upstream \
study-fops39_sc \
FFOPS-40_diplom-skv_den
```

## commit_2,`FFOPS-40_diplom-skv_den`

```bash
mkdir -p self-host_git_ci_cd
cd self-host_git_ci_cd
```

```bash
# sysctl форвардинг
sudo tee /etc/sysctl.d/99-ipforward.conf << 'EOF'
net.ipv4.ip_forward=1
net.ipv4.conf.all.src_valid_mark=1
EOF
sudo sysctl --system
```

<details>
<summary>
вывод sysctl
</summary>

```log
[sudo] пароль для shoel: 
net.ipv4.ip_forward=1
net.ipv4.conf.all.src_valid_mark=1

* Applying /usr/lib/sysctl.d/10-arch.conf ...
* Applying /etc/sysctl.d/40-hugepage.conf ...
* Applying /usr/lib/sysctl.d/50-coredump.conf ...
* Applying /usr/lib/sysctl.d/50-default.conf ...
* Applying /usr/lib/sysctl.d/50-pid-max.conf ...
* Applying /usr/lib/sysctl.d/60-libvirtd.conf ...
* Applying /etc/sysctl.d/99-ipforward.conf ...
* Applying /etc/sysctl.d/99-kubelet-lxc.conf ...
fs.inotify.max_user_instances = 1024
fs.inotify.max_user_watches = 524288
vm.max_map_count = 1048576
net.ipv4.tcp_keepalive_time = 120
vm.nr_hugepages = 550
kernel.core_pattern = |/usr/lib/systemd/systemd-coredump %P %u %g %s %t %c %h %d %F %I
kernel.core_pipe_limit = 16
fs.suid_dumpable = 2
kernel.sysrq = 16
kernel.core_uses_pid = 1
net.ipv4.conf.default.rp_filter = 2
net.ipv4.conf.br0.rp_filter = 2
net.ipv4.conf.eno1.rp_filter = 2
net.ipv4.conf.lo.rp_filter = 2
net.ipv4.conf.wlo1.rp_filter = 2
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.br0.accept_source_route = 0
net.ipv4.conf.eno1.accept_source_route = 0
net.ipv4.conf.lo.accept_source_route = 0
net.ipv4.conf.wlo1.accept_source_route = 0
net.ipv4.conf.default.promote_secondaries = 1
net.ipv4.conf.br0.promote_secondaries = 1
net.ipv4.conf.eno1.promote_secondaries = 1
net.ipv4.conf.lo.promote_secondaries = 1
net.ipv4.conf.wlo1.promote_secondaries = 1
net.ipv4.ping_group_range = 0 2147483647
net.core.default_qdisc = fq_codel
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
fs.protected_regular = 1
fs.protected_fifos = 1
kernel.pid_max = 4194304
fs.aio-max-nr = 1048576
net.ipv4.ip_forward = 1
net.ipv4.conf.all.src_valid_mark = 1
vm.overcommit_memory = 1
kernel.panic = 10
kernel.panic_on_oops = 1
kernel.keys.root_maxkeys = 1000000
kernel.keys.root_maxbytes = 25000000
```

</details>

### WireGuard in docker

```yaml
# docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.7'
services:
    wg-easy:
        image: ghcr.io/wg-easy/wg-easy:15.4
        container_name: wg-easy
        network_mode: host
        environment:
            - INSECURE=true
            - DISABLE_IPV6=true
        volumes:
            - etc_wireguard:/etc/wireguard
            - /lib/modules:/lib/modules:ro
        cap_add:
            - NET_ADMIN
            - SYS_MODULE
        devices:
            - /dev/net/tun:/dev/net/tun
        restart: unless-stopped

volumes:
    etc_wireguard:
EOF
```

```bash
# start docker
sudo bash -c \
"systemctl start docker \
&& systemctl is-active docker"
```

<details>
<summary>
вывод docker
</summary>

```log
WARN[0000] /home/shoel/nfs_git/gited/FFOPS-40_diplom-skv_den/self-host_git_ci_cd/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] up 22/22
 ✔ Image ghcr.io/wg-easy/wg-easy:15.4       Pulled                                                                                                                                                       208.2s
 ✔ Volume self-host_git_ci_cd_etc_wireguard Created                                                                                                                                                      0.0s
 ✔ Container wg-easy                        Created 
```

</details>

```bash
ip -br a show br0
```

<details>
<summary>
вывод ip
</summary>

```log
br0              UP             192.168.89.193/24 metric 1024 fe80::f832:c0ff:fe95:76f/64 
```

</details>

![](./FFOPS-40_diplom-skv_den/img/1.gif)

![](./FFOPS-40_diplom-skv_den/img/2gif)

```bash
yay -Ss coredns
```

<details>
<summary>
Поиск пакета coredns в archlinux AUR
</summary>

```log
aur/dotcoredns 1-1 (+0 0.00) [3392d] 
    Tools for running CoreDNS as a regular user
aur/coredns-fanout 1.9.0-1 (+0 0.00) [1670d20h] (сирота в AUR) 
    A DNS server that chains plugins - with module fanout
aur/coredns-openrc 20230319-1 (+0 0.00) [1269d7h] (сирота в AUR) 
    A DNS server that chains plugins - OpenRC init script
aur/coredns-wgsd-git 1.11.1-2 (+1 0.00) [940d3h] 
    A DNS server that chains plugins - with module wgsd
aur/coredns-git 1.12.0.r3.g177253340-1 (+0 0.00) [625d23h] 
    A DNS server that chains plugins
aur/coredns-s6 20220507-1 (+0 0.00) [1585d6h] 
    s6-rc service scripts for coredns
aur/coredns-bin 1.14.7-1 (+7 0.00) [20d17h] 
    A DNS server that chains plugins
aur/coredns 1.14.3-3 (+6 0.00) [137d21h] 
    A DNS server that chains plugins
```

</details>

```bash
# 
yay -Syu coredns-bin

sudo systemctl status coredns

coredns --version
```

<details>
<summary>
вывод systemctl status coredns
</summary>

```log
○ coredns.service - CoreDNS DNS server
     Loaded: loaded (/usr/lib/systemd/system/coredns.service; disabled; preset: dis>
     Active: inactive (dead)
       Docs: https://coredns.io

CoreDNS-1.14.7
linux/amd64, go1.26.6, 427fc80
```

</details>

```bash
# 
sudo tee /etc/coredns/db.den-skv.ru << 'EOF'
; $ORIGIN задает суффикс по умолчанию для неполных имен в этом файле
$ORIGIN den-skv.ru.
; SOA (Start of Authority) обязательная запись для любой DNS-зоны
; Формат: primary-ns admin-email (serial refresh retry expire minimum-ttl)
; admin-email: точка вместо @, т. е. admin.den-skv.ru = admin@den-skv.ru
@   IN SOA ns.den-skv.ru. admin.den-skv.ru. (
        2025010101  ; serial — увеличивайте при каждом изменении зоны
        3600        ; refresh — как часто secondary DNS проверяет обновления (нам неважно)
        600         ; retry — интервал повтора при неудаче
        86400       ; expire — через сколько secondary перестает отдавать зону
        60          ; minimum TTL — время жизни negative-кеша
    )
; NS указывает authoritative nameserver для зоны
@   IN NS  ns.den-skv.ru.
; A-записи: имя = IPv4-адрес внутри VPN
; Все сервисы живут на одном VPS, поэтому все указывают на 10.8.0.1
ns      IN A 10.8.0.1
git     IN A 10.8.0.1
EOF
```

```bash
# 
sudo tee ./etc/coredns/Corefile << 'EOF'
. {
    bind 10.8.0.1                      # слушаем только на WireGuard-интерфейсе
    file /etc/coredns/db.den-skv.ru den-skv.ru
    forward . 192.168.89.1         # upstream для остальных имен через местный DNS-сервер
    cache 30
    errors
}
EOF
```

```bash
# 
sudo tree /etc/coredns/

# 
ip -br a show wg0

# 
ip -br a show br0

# 
docker ps -a
```

<details>
<summary>
Связка WireGuard VPN и CoreDNS
</summary>

```log
/etc/coredns/
├── Corefile
└── db.den-skv.ru

1 directory, 2 files
wg0              UNKNOWN        10.8.0.1/24 
br0              UP             192.168.89.193/24 metric 1024 fe80::f832:c0ff:fe95:76f/64 
CONTAINER ID   IMAGE                          COMMAND                  CREATED          STATUS                    PORTS     NAMES
0fddff54c316   ghcr.io/wg-easy/wg-easy:15.4   "docker-entrypoint.s…"   47 minutes ago   Up 47 minutes (healthy)             wg-eas
```

</details>

```bash
sudo systemctl edit coredns
```

```
### Editing /etc/systemd/system/coredns.service.d/override.conf
### Anything between here and the comment below will become the contents of the drop-in file

[Unit]
After=network.target
After=docker.service

[Service]
Restart=
Restart=on-failure
RestartSec=5

### Edits below this comment will be discarded
...
```

```bash 
sudo systemctl cat coredns

sudo systemctl daemon-reload

sudo systemctl restart coredns

sudo systemctl status coredns
```

<details>
<summary>
CoreDNS systemd unit file
</summary>

```log
# /usr/lib/systemd/system/coredns.service
[Unit]
Description=CoreDNS DNS server
Documentation=https://coredns.io
After=network.target

[Service]
PermissionsStartOnly=true
LimitNOFILE=1048576
LimitNPROC=512
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
NoNewPrivileges=true
User=coredns
ExecStart=/usr/bin/coredns -conf=/etc/coredns/Corefile
ExecReload=/bin/kill -SIGUSR1 $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target

# /etc/systemd/system/coredns.service.d/override.conf
[Unit]
After=network.target
After=docker.service

[Service]
Restart=
Restart=on-failure
RestartSec=5
● coredns.service - CoreDNS DNS server
     Loaded: loaded (/usr/lib/systemd/system/coredns.service; disabled; preset: disabled)
    Drop-In: /etc/systemd/system/coredns.service.d
             └─override.conf
     Active: active (running) since Tue 2026-09-08 23:16:49 MSK; 26ms ago
 Invocation: 9f8aa1b41e46498aaf1bb6d88b9f71cc
       Docs: https://coredns.io
   Main PID: 107165 (coredns)
      Tasks: 1 (limit: 18205)
     Memory: 1.4M (peak: 2.3M)
        CPU: 8ms
     CGroup: /system.slice/coredns.service
             └─107165 /usr/bin/coredns -conf=/etc/coredns/Corefile

сен 08 23:16:49 shoellin systemd[1]: Started CoreDNS DNS server.
```

</details>

```bash
host git.den-skv.ru 10.8.0.1

host ya.ru 10.8.0.1
```

<details>
<summary>
Проверка работы CoreDNS
</summary>

```log
Using domain server:
Name: 10.8.0.1
Address: 10.8.0.1#53
Aliases: 

git.den-skv.ru has address 10.8.0.1

Using domain server:
Name: 10.8.0.1
Address: 10.8.0.1#53
Aliases: 

ya.ru has address 77.88.44.242
ya.ru has address 5.255.255.242
ya.ru has address 77.88.55.242
ya.ru has IPv6 address 2a02:6b8::2:242
ya.ru mail is handled by 10 mx.yandex.ru.
```

</details>

```bash
# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. ../.. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit2, FFOPS-40_diplom-skv_den' \
; git push \
--set-upstream \
study_fops39 \
FFOPS-40_diplom-skv_den \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
FFOPS-40_diplom-skv_den \
&& git push \
--set-upstream \
study-fops39_sc \
FFOPS-40_diplom-skv_den
```

## commit_3,`FFOPS-40_diplom-skv_den`
