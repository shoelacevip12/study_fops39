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

### Подготовка к работе self-hosted git сервера за VPN

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

#### WireGuard in docker

```yaml
# docker-compose.yml
cat > docker-compose.yml << 'EOF'
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
        healthcheck: 
            # Ждём, пока wg0 получит адрес 10.8.0.1
            test: ["CMD-SHELL", "ip -4 addr show wg0 | grep -q '10.8.0.1'"]
            interval: 10s
            timeout: 3s
            retries: 15
            start_period: 30s

volumes:
    etc_wireguard:
EOF
```

```bash
# start docker
sudo bash -c \
"systemctl start docker \
&& systemctl is-active docker"

docker compose up -d
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
br0   UP   192.168.89.193/24 metric 1024 fe80::f832:c0ff:fe95:76f/64 
```

</details>

#### Установка локального DNS на Coredns

```bash
# Поиск в Пользовательских репозиториях Archlinux
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
# Установка Coredns и обновление системы 
yay -Syu coredns-bin

# Проверка установленной службы
sudo systemctl status coredns

# Проверка установленного Coredns
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
# Создание зоны в локальном DNS den-skv.ru и записей прямого просмотра
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
# Настройка и Привязка DNS сервера к VPN сети, созданной зоне и перенаправление запросов на внешний DNS
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
# Вывод полученных файлов
sudo tree /etc/coredns/

# Проверка наличия поднятого туннеля на WG
ip -br a show wg0

# Проверка работы основного интерфейса хоста
ip -br a show br0

# Проверка запущенного VPN службы на докере
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
# Drop-in редактирование systemd-службы coredns с изменением требований запуска и перезапуска
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
# Проверка наличия Drop-in изменений в  systemd-службе coredns
sudo systemctl cat coredns

# Обновление информации об измененной службе
sudo systemctl daemon-reload

# Пробный запуск службы
sudo systemctl restart coredns

# Проверка статуса coredns
sudo systemctl status coredns

# Установка в автозагрузку
sudo systemctl enable coredns
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

Created symlink '/etc/systemd/system/multi-user.target.wants/coredns.service' → '/usr/lib/systemd/system/coredns.service'.
```

</details>

#### Проверка работы coredns на хостовой машине

```bash
# Проверка резолвинага по dns A записи
host git.den-skv.ru 10.8.0.1

# Проверка работы forwarding запросов на внешние DNS
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

### Git Commit изменений

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

### NFS файловое хранилище

```bash
# вывод рабочего интерфейса сети Сервера
ip -br a show bond0

# Проверка настроек экспорта FS nfs
sudo exportfs -vra

# конфиг настроек экспорта
sudo cat /etc/exports
```

<details>
<summary>
Вывод настроек NFS экспорта с сервера
</summary>

```log
bond0  UP  192.168.89.246/24

exporting 192.168.89.0/24:/volume1/iso
exporting 192.168.89.0/24:/volume1/git

/volume1/git    192.168.89.0/24(rw,async,no_wdelay,crossmnt,all_squash,insecure_locks,sec=sys,anonuid=1024,anongid=100)
/volume1/iso    192.168.89.0/24(rw,async,no_wdelay,crossmnt,all_squash,insecure_locks,sec=sys,anonuid=1024,anongid=100)
```

</details>

### Сервер forgejo

```bash
pwd

showmount -e 192.168.89.246

cat /etc/fstab | grep git

ls -ld

mkdir -pv ./postgres-data

mkdir -pv ~/forgejo-data
```

<details>
<summary>
Подготовка каталогов для работы forgejo и PG БД
</summary>

```log
/home/shoel/nfs_git/gited/FFOPS-40_diplom-skv_den/self-host_git_ci_cd

Export list for 192.168.89.246:
/volume1/iso 192.168.89.0/24
/volume1/git 192.168.89.0/24

192.168.89.246:/volume1/git /home/shoel/nfs_git nfs rw,soft,intr,noatime,nodev,nosuid 0 0

drwxrwxrwx 1 1024 100 152 сен  8 23:46 .

mkdir: создан каталог './postgres-data'
mkdir: создан каталог '/home/shoel/forgejo-data'
```

</details>

```yaml
# docker-compose-forgejo.yml
cat > docker-compose-forgejo.yml << 'EOF'
include:
  - docker-compose.yml
services:
  server:
    image: data.forgejo.org/forgejo/forgejo:16.0.3
    container_name: forgejo
    restart: always
    depends_on:
      wg-easy:
        condition: service_healthy
      db:
        condition: service_healthy
    networks:
      - forgejo
    environment:
      - USER_UID=1000
      - USER_GID=1000
      - FORGEJO__database__DB_TYPE=postgres
      - FORGEJO__database__HOST=db:5432
      - FORGEJO__database__NAME=forgejo
      - FORGEJO__database__USER=forgejo
      - FORGEJO__database__PASSWD=${DB_PASSWORD}
      - FORGEJO__server__ROOT_URL=http://git.den-skv.ru/
      - FORGEJO__server__SSH_DOMAIN=git.den-skv.ru
      - FORGEJO__server__SSH_PORT=6722
      - FORGEJO__actions__ENABLED=true
    volumes:
      - ~/forgejo-data:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "10.8.0.1:3000:3000"   # внутренний HTTP;
      - "10.8.0.1:6722:22"      # git over ssh, только через VPN

  db:
    image: postgres:18-alpine
    container_name: forgejo-db
    user: "1024:100"
    restart: unless-stopped
    depends_on:
      wg-easy:
        condition: service_healthy
    networks:
      - forgejo
    environment:
      - POSTGRES_USER=forgejo
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - POSTGRES_DB=forgejo
      - PGDATA=/var/lib/postgresql/data/pgdata
    volumes:
      - ./postgres-data:/var/lib/postgresql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U forgejo"]
      interval: 15s
      timeout: 3s
      retries: 3
      start_period: 40s

networks:
  forgejo:
EOF
```

```bash
# Генерация пароля для базы данных
echo "DB_PASSWORD=$(openssl rand -hex 24)" \
> .env
```

```bash
docker-compose -f docker-compose-forgejo.yml up -d
```

<details>
<summary>
Docker forgejo с postgres 18
</summary>

```log
[+] up 20/20
 ⠏ Image data.forgejo.org/forgejo/forgejo:16.0.3 [⣿⣿⣿⣿⣿⣄⣿⣿⣿] 54.81MB / 82.05MB Pulling                                                      [+] up 18/20
 ⠋ Image data.forgejo.org/forgejo/forgejo:16.0.3 [⣿⣿⣿⣿⣿⣄⣿⣿⣿] 54.81MB / 82.05MB Pulling                              [+] up 18/20             148.1s
 ⠙ Image data.forgejo.org/forgejo/forgejo:16.0.3 [⣿⣿⣿⣿⣿⣄⣿⣿⣿] 54.81MB / 82.05MB Pulling                     [+] up 18/20 148.2s               107.7s
 ⠹ Image data.forgejo.org/forgejo/forgejo:16.0.3 [⣿⣿⣿⣿⣿⣄⣿⣿⣿] 54.81MB / 82.05MB Pulling                148.[+] up 18/20  107.7s
 ⠇ Image data.forgejo.org/forgejo/forgejo:16.0.3 [⣿⣿⣿⣿⣿⣿⣿⣿⣿] 82.05MB / 82.05MB Pulling              317.9s
[+] up 22/23tgres:18-alpine                                                    Pulled               107.7s
 ✔ Image data.forgejo.org/forgejo/forgejo:16.0.3 Pulled                                             317.9s
 ✔ Image postgres:18-alpine                      Pulled                                             107.7s
 ✔ Network self-host_git_ci_cd_forgejo           Created                                              0.0s
 ⠹ Container forgejo-db                          Starting                                             0.2s
 ✔ Container forgejo                             Created                                              0.0s
 ✔ Container forgejo-db                          Started                                              0.2s
 ✔ Container forgejo                             Started                                              0.2s
```

</details>

```bash
# Проверка готовности git-сервера forgejo
docker-compose -f docker-compose-forgejo.yml logs -f server
```

<details>
<summary>
готовность git-сервера forgejo
</summary>

```log
forgejo  | Generating /data/ssh/ssh_host_ed25519_key...
forgejo  | Generating /data/ssh/ssh_host_rsa_key...
forgejo  | 2026/09/09 00:01:03 ...nvironment-to-ini.go:104:runEnvironmentToIni() [I] Settings saved to: "/data/gitea/conf/app.ini"
forgejo  | Generating /data/ssh/ssh_host_ecdsa_key...
forgejo  | Server listening on :: port 22.
forgejo  | Server listening on 0.0.0.0 port 22.
forgejo  | 2026/09/09 00:01:03 cmd/web.go:250:runWeb() [I] Starting Forgejo on PID: 16
forgejo  | 2026/09/09 00:01:03 cmd/web.go:114:showWebStartupMessage() [I] Forgejo version: 16.0.3+gitea-1.22.0 built with GNU Make 4.4.1, go1.26.7 : bindata, timetzdata, sqlite, sqlite_unlock_notify
forgejo  | 2026/09/09 00:01:03 cmd/web.go:115:showWebStartupMessage() [I] * RunMode: prod
forgejo  | 2026/09/09 00:01:03 cmd/web.go:116:showWebStartupMessage() [I] * AppPath: /usr/local/bin/gitea
forgejo  | 2026/09/09 00:01:03 cmd/web.go:117:showWebStartupMessage() [I] * WorkPath: /data/gitea
forgejo  | 2026/09/09 00:01:03 cmd/web.go:118:showWebStartupMessage() [I] * CustomPath: /data/gitea
forgejo  | 2026/09/09 00:01:03 cmd/web.go:119:showWebStartupMessage() [I] * ConfigFile: /data/gitea/conf/app.ini
forgejo  | 2026/09/09 00:01:03 cmd/web.go:120:showWebStartupMessage() [I] Prepare to run install page
forgejo  | 2026/09/09 00:01:04 cmd/web.go:315:listen() [I] Listen: http://0.0.0.0:3000
forgejo  | 2026/09/09 00:01:04 cmd/web.go:319:listen() [I] AppURL(ROOT_URL): http://git.den-skv.ru/
forgejo  | 2026/09/09 00:01:04 ...s/graceful/server.go:50:NewServer() [I] Starting new Web server: tcp:0.0.0.0:3000 on PID: 16
```

</details>

```bash
# Проверка готовности базы данных
docker-compose -f docker-compose-forgejo.yml logs -f db
```

<details>
<summary>
готовность базы данных
</summary>

```log
forgejo-db  | chmod: /var/run/postgresql: Operation not permitted
forgejo-db  | The files belonging to this database system will be owned by user "postgres".
forgejo-db  | This user must also own the server process.
forgejo-db  | 
forgejo-db  | The database cluster will be initialized with locale "en_US.utf8".
forgejo-db  | The default database encoding has accordingly been set to "UTF8".
forgejo-db  | The default text search configuration will be set to "english".
forgejo-db  | 
forgejo-db  | Data page checksums are enabled.
forgejo-db  | 
forgejo-db  | fixing permissions on existing directory /var/lib/postgresql/data/pgdata ... ok
forgejo-db  | creating subdirectories ... ok
forgejo-db  | selecting dynamic shared memory implementation ... posix
forgejo-db  | selecting default "max_connections" ... 100
forgejo-db  | selecting default "shared_buffers" ... 128MB
forgejo-db  | selecting default time zone ... UTC
forgejo-db  | creating configuration files ... ok
forgejo-db  | running bootstrap script ... ok
forgejo-db  | sh: locale: not found
forgejo-db  | 2026-09-09 17:24:44.403 UTC [25] WARNING:  no usable system locales were found
forgejo-db  | performing post-bootstrap initialization ... ok
forgejo-db  | syncing data to disk ... ok
forgejo-db  | 
forgejo-db  | 
forgejo-db  | Success. You can now start the database server using:
forgejo-db  | 
forgejo-db  |     pg_ctl -D /var/lib/postgresql/data/pgdata -l logfile start
forgejo-db  | 
forgejo-db  | initdb: warning: enabling "trust" authentication for local connections
forgejo-db  | initdb: hint: You can change this by editing pg_hba.conf or using the option -A, or --auth-local and --auth-host, the next time you run initdb.
forgejo-db  | waiting for server to start....2026-09-09 17:24:47.364 UTC [32] LOG:  starting PostgreSQL 18.6 on x86_64-pc-linux-musl, compiled by gcc (Alpine 15.2.0) 15.2.0, 64-bit
forgejo-db  | 2026-09-09 17:24:47.367 UTC [32] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
forgejo-db  | 2026-09-09 17:24:47.377 UTC [38] LOG:  database system was shut down at 2026-09-09 17:24:46 UTC
forgejo-db  | 2026-09-09 17:24:47.387 UTC [32] LOG:  database system is ready to accept connections
forgejo-db  |  done
forgejo-db  | server started
forgejo-db  | 2026-09-09 17:24:47.565 UTC [53] FATAL:  database "forgejo" does not exist
forgejo-db  | CREATE DATABASE
forgejo-db  | 
forgejo-db  | 
forgejo-db  | /usr/local/bin/docker-entrypoint.sh: ignoring /docker-entrypoint-initdb.d/*
forgejo-db  | 
forgejo-db  | waiting for server to shut down....2026-09-09 17:24:48.096 UTC [32] LOG:  received fast shutdown request
forgejo-db  | 2026-09-09 17:24:48.097 UTC [32] LOG:  aborting any active transactions
forgejo-db  | 2026-09-09 17:24:48.099 UTC [32] LOG:  background worker "logical replication launcher" (PID 41) exited with exit code 1
forgejo-db  | 2026-09-09 17:24:48.100 UTC [36] LOG:  shutting down
forgejo-db  | 2026-09-09 17:24:48.100 UTC [36] LOG:  checkpoint starting: shutdown immediate
forgejo-db  | 2026-09-09 17:24:48.256 UTC [36] LOG:  checkpoint complete: wrote 943 buffers (5.8%), wrote 3 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=0.131 s, sync=0.020 s, total=0.156 s; sync files=303, longest=0.001 s, average=0.001 s; distance=4362 kB, estimate=4362 kB; lsn=0/1BA8858, redo lsn=0/1BA8858
forgejo-db  | 2026-09-09 17:24:48.346 UTC [32] LOG:  database system is shut down
forgejo-db  |  done
forgejo-db  | server stopped
forgejo-db  | 
forgejo-db  | PostgreSQL init process complete; ready for start up.
forgejo-db  | 
forgejo-db  | 2026-09-09 17:24:48.432 UTC [1] LOG:  starting PostgreSQL 18.6 on x86_64-pc-linux-musl, compiled by gcc (Alpine 15.2.0) 15.2.0, 64-bit
forgejo-db  | 2026-09-09 17:24:48.432 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
forgejo-db  | 2026-09-09 17:24:48.432 UTC [1] LOG:  listening on IPv6 address "::", port 5432
forgejo-db  | 2026-09-09 17:24:48.441 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
forgejo-db  | 2026-09-09 17:24:48.456 UTC [61] LOG:  database system was shut down at 2026-09-09 17:24:48 UTC
forgejo-db  | 2026-09-09 17:24:48.466 UTC [1] LOG:  database system is ready to accept connections
```

</details>

![](./FFOPS-40_diplom-skv_den/img/1.gif)

![](./FFOPS-40_diplom-skv_den/img/2.gif)

![](./FFOPS-40_diplom-skv_den/img/3.gif)

![](./FFOPS-40_diplom-skv_den/img/4.gif)

### Git Commit изменений

```bash
git rm -r --cached \
./ ../

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
FFOPS-40_diplom-skv_den \
&& git push \
--set-upstream \
ffops40-diplom \
FFOPS-40_diplom-skv_den
```

## commit_3,`FFOPS-40_diplom-skv_den`

### Проверка работоспособности git сервера

```bash
# Генерация ssh-ключа для git сервера
ssh-keygen \
-f ~/.ssh/id_forgejo_git_ed25519 \
-t ed25519 \
-C "forgejo_git"

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_forgejo_git_ed25519
```

<details>
<summary>
Вывод генерации ключа
</summary>

```log
Generating public/private ed25519 key pair.
Enter passphrase for "/home/shoel/.ssh/id_forgejo_git_ed25519" (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/shoel/.ssh/id_forgejo_git_ed25519
Your public key has been saved in /home/shoel/.ssh/id_forgejo_git_ed25519.pub
The key fingerprint is:
SHA256:6qvlatW53xruvrApp5vPrMbsGmSSWkVntU9FWGRQcB0 forgejo_git
The key's randomart image is:
+--[ED25519 256]--+
|               . |
|                 |
|                 |
|   o             |
|          .      |
| o +             |
|.                |
|                 |
|                 |
+----[SHA256]-----+
```

</details>

![](./FFOPS-40_diplom-skv_den/img/5.gif)

```bash
git remote -v

git remote add ffops40-diplom ssh://git@git.den-skv.ru:6722/denskv/work_progress_cmd_log.git

git remote -v

git add . .. ../.. \
&& git status

git commit -am 'commit3_test, FFOPS-40_diplom-skv_den' \
; git push \
--set-upstream \
ffops40-diplom \
FFOPS-40_diplom-skv_den
```

![](./FFOPS-40_diplom-skv_den/img/6.gif)

### Git Commit изменений

```bash
git rm -r --cached \
./ ../

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. ../.. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit3, FFOPS-40_diplom-skv_den' \
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
FFOPS-40_diplom-skv_den \
&& git push \
--set-upstream \
ffops40-diplom \
FFOPS-40_diplom-skv_den
```

## commit_4,`FFOPS-40_diplom-skv_den`

### Развертывание FORGEJO runner

```bash
# каталог для данных runner
mkdir -pv ~/data-runner/.cache

# Генерируем файл конфигурации раннера
docker run --rm data.forgejo.org/forgejo/runner:13 \
forgejo-runner generate-config > ~/data-runner/runner-config.yml

# смена прав на неппривилигированного пользователя контейнера с UID/GUID 1001 
sudo chown -Rv 1001:1001 /home/shoel/data-runner

sudo chmod -v 775 /home/shoel/data-runner/.cache

sudo chmod -v g+s /home/shoel/data-runner/.cache
```

<details>
<summary>
каталог для runner
</summary>

```log
mkdir: создан каталог '/home/shoel/data-runner'

mkdir: создан каталог '/home/shoel/data-runner/.cache'

Unable to find image 'data.forgejo.org/forgejo/runner:13' locally
13: Pulling from forgejo/runner
55afa1ecc21d: Already exists 
13ef92308689: Pull complete 
35cc8c60d093: Pull complete 
6146ea618b55: Pull complete 
Digest: sha256:c4af85fd9f0dd03788676a534781a87c71aa2c6a37737143e017eb94d4312952
Status: Downloaded newer image for data.forgejo.org/forgejo/runner:13

изменён владелец '/home/shoel/data-runner/runner-config.yml' с shoel:shoel на 1001:1001

изменён владелец '/home/shoel/data-runner/.cache' с shoel:shoel на 1001:1001

изменён владелец '/home/shoel/data-runner' с shoel:shoel на 1001:1001

права доступа '/home/shoel/data-runner/.cache' изменены с 0755 (rwxr-xr-x) на 0775 (rwxrwxr-x)

права доступа '/home/shoel/data-runner/.cache' изменены с 0775 (rwxrwxr-x) на 2775 (rwxrwsr-x)
```

</details>

```yaml
cat > docker-compose-forgejo-runner.yml <<'EOF'
include:
  - docker-compose-forgejo.yml
services:
  docker-in-docker:
    image: docker:dind
    depends_on:
      server:
        condition: service_started
    container_name: 'docker_dind'
    privileged: 'true'
    command: ['dockerd', '-H', 'tcp://0.0.0.0:2375', '--tls=false']
    restart: 'unless-stopped'

  runner:
    image: 'data.forgejo.org/forgejo/runner:13'
    links:
      - docker-in-docker
    depends_on:
      docker-in-docker:
        condition: service_started
    container_name: 'runner'
    environment:
      DOCKER_HOST: tcp://docker-in-docker:2375
    user: 1001:1001
    volumes:
      - ~/data-runner:/data
    restart: 'unless-stopped'
    command: 'forgejo-runner daemon --config runner-config.yml'
EOF
```

```bash
# Создание настроек для подключения в роли runnera
sudo tee ~/data-runner/runner-config.yml <<'EOF'
runner:
  labels: ["docker:docker://ghcr.io/catthehacker/ubuntu:act-latest"]

server:
  connections:
    forgejo:
      url: http://10.8.0.1:3000/   # внутренний HTTP
      uuid: 308d588e-5379-4e69-8234-b85c0027d7a4
      token: c08ad111cf3b1801107aae9759d9af984bfe590c
EOF
```

```bash
docker-compose -f docker-compose-forgejo-runner.yml up -d
```

<details>
<summary>
Лог запуска runner
</summary>

```log
[+] up 23/23
 ✔ Image docker:dind                   Pulled    19.2s
 ✔ Container forgejo-db                Healthy   1.1s
 ✔ Container wg-easy                   Healthy   1.1s
 ✔ Container forgejo                   Running   0.0s
 ✔ Network self-host_git_ci_cd_default Created   0.0s
 ✔ Container docker_dind               Started   1.2s
 ✔ Container runner                    Started   1.3s
```

</details>

![](./FFOPS-40_diplom-skv_den/img/7.gif)

### Git Commit изменений

```bash
git rm -r --cached \
./ ../

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. ../.. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit4, FFOPS-40_diplom-skv_den' \
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
FFOPS-40_diplom-skv_den \
&& git push \
--set-upstream \
ffops40-diplom \
FFOPS-40_diplom-skv_den
```

## commit_5,`FFOPS-40_diplom-skv_den`

```bash
mkdir -p .forgejo/workflows
```

> Заменить `your-deployment-name`, `your-container-name`, `your-namespace` в workflow на новые значения

``` bash
cat > .forgejo/workflows/ci.yaml <<'EOF'
name: CI/CD Pipeline

on:
  push:
    branches:
      - '**'  # Любой коммит в любую ветку
    tags:
      - 'v*'  # Любой тег вида v1.0.0, v2.3.4 и т.д.

env:
  REGISTRY: git.den-skv.ru:3000
  IMAGE_NAME: ${{ forgejo.repository }}

jobs:
  # ========================================
  # Job 1: Сборка и push Docker образа
  # Запускается при любом коммите и создании тега
  # ========================================
  build:
    runs-on: docker
    container:
      image: ghcr.io/catthehacker/ubuntu:act-latest
      options: --privileged
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
        with:
          driver-opts: network=host

      - name: Log in to Forgejo Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ forgejo.actor }}
          password: ${{ secrets.FORGEJO_TOKEN }}

      - name: Extract metadata (tags, labels)
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            # При push тега v1.0.0 → образ с тегом v1.0.0 и latest
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=semver,pattern={{major}}
            # При push в ветку → образ с тегом ветки
            type=ref,event=branch
            # При push тега → также latest
            type=raw,value=latest,enable=${{ startsWith(forgejo.ref, 'refs/tags/v') }}
            # Всегда добавлять SHA коммита
            type=sha,prefix=

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=registry,ref=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:buildcache
          cache-to: type=registry,ref=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:buildcache,mode=max

      - name: Image digest
        run: echo "Image pushed with tags ${{ steps.meta.outputs.tags }}"

  # ========================================
  # Job 2: Деплой в Kubernetes
  # Запускается ТОЛЬКО при создании тега v*
  # ========================================
  deploy:
    runs-on: docker
    container:
      image: ghcr.io/catthehacker/ubuntu:act-latest
    needs: build
    if: startsWith(forgejo.ref, 'refs/tags/v')
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Extract version from tag
        id: version
        run: |
          # Извлекаем версию из тега (v1.0.0 → 1.0.0)
          VERSION=${GITHUB_REF#refs/tags/v}
          echo "version=$VERSION" >> $GITHUB_OUTPUT
          echo "Deploying version: $VERSION"

      - name: Install kubectl
        run: |
          curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
          chmod +x kubectl
          mv kubectl /usr/local/bin/

      - name: Configure kubectl
        run: |
          # Создаём директорию для kubeconfig
          mkdir -p $HOME/.kube

          # Декодируем kubeconfig из secrets
          echo "${{ secrets.KUBE_CONFIG }}" | base64 -d > $HOME/.kube/config
          chmod 600 $HOME/.kube/config

      - name: Deploy to Kubernetes
        run: |
          VERSION=${{ steps.version.outputs.version }}
          IMAGE="${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:$VERSION"

          echo "Deploying image: $IMAGE"

          # Обновляем образ в deployment
          # Заменить 'your-deployment-name' и 'your-namespace' на новые значения
          kubectl set image deployment/your-deployment-name \
            your-container-name=$IMAGE \
            -n your-namespace

          # Ждём завершения rollout
          kubectl rollout status deployment/your-deployment-name -n your-namespace --timeout=300s

          echo "Deployment completed successfully!"

      - name: Verify deployment
        run: |
          kubectl get pods -n your-namespace
          kubectl get services -n your-namespace

  # ========================================
  # Job 3: Уведомление об успехе
  # ========================================
  notify:
    runs-on: docker
    needs: [build, deploy]
    if: success() && startsWith(forgejo.ref, 'refs/tags/v')
    steps:
      - name: Notify deployment success
        run: |
          echo "Deployment successful!"
          echo "Version: ${{ github.ref_name }}"
          echo "Image: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.ref_name }}"
EOF
```

```bash
git add .forgejo/workflows/ci.yaml
git commit -m "Add CI/CD pipeline"
git push

git tag v1.0.0
git push ffops40-diplom v1.0.0
```

### Создание terraform ресурсов

```bash
mkdir -pv tf/{net_store,k8s}

cd tf/net_store
```

### Описание сети и tfsate хранилища

#### Генерация Ключа GPG

```bash
# Интерактивная генерирация ключа GPG
gpg2 --full-generate-key
```

<details>
<summary>
Сгенерировать ключ GPG
</summary>

```log
gpg (GnuPG) 2.4.9; Copyright (C) 2025 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Выберите тип ключа:
   (1) RSA and RSA
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (9) ECC (sign and encrypt) *default*
  (10) ECC (только для подписи)
  (14) Existing key from card
Ваш выбор? 9
Выберите эллиптическую кривую:
   (1) Curve 25519 *default*
   (4) NIST P-384
   (6) Brainpool P-256
Ваш выбор? 1
Выберите срок действия ключа.
         0 = не ограничен
      <n>  = срок действия ключа - n дней
      <n>w = срок действия ключа - n недель
      <n>m = срок действия ключа - n месяцев
      <n>y = срок действия ключа - n лет
Срок действия ключа? (0) 
Срок действия ключа не ограничен
Все верно? (y/N) y

GnuPG должен составить идентификатор пользователя для идентификации ключа.

Ваше полное имя: denskv
Адрес электронной почты: shoelacevip12@gmail.com
Примечание: denskv
Вы выбрали следующий идентификатор пользователя:
    "denskv (denskv) <shoelacevip12@gmail.com>"

Сменить (N)Имя, (C)Примечание, (E)Адрес; (O)Принять/(Q)Выход? O
Необходимо получить много случайных чисел. Желательно, чтобы Вы
в процессе генерации выполняли какие-то другие действия (печать
на клавиатуре, движения мыши, обращения к дискам); это даст генератору
случайных чисел больше возможностей получить достаточное количество энтропии.
Необходимо получить много случайных чисел. Желательно, чтобы Вы
в процессе генерации выполняли какие-то другие действия (печать
на клавиатуре, движения мыши, обращения к дискам); это даст генератору
случайных чисел больше возможностей получить достаточное количество энтропии.
gpg: создан каталог '/home/shoel/.gnupg/openpgp-revocs.d'
gpg: сертификат отзыва записан в '/home/shoel/.gnupg/openpgp-revocs.d/CC1A1DA66D05E943B17BDB820186BF84DFD06287.rev'.
открытый и секретный ключи созданы и подписаны.

pub   ed25519 2026-09-12 [SC]
      CC1A1DA66D05E943B17BDB820186BF84DFD06287
uid                      denskv (denskv) <shoelacevip12@gmail.com>
sub   cv25519 2026-09-12 [E]
```

![](./FFOPS-40_diplom-skv_den/img/1.png)

</details>

```bash
# список GPG-ключей
gpg2 --list-secret-keys
```

<details>
<summary>
Список GPG-ключей
</summary>

```log
gpg: проверка таблицы доверия
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: глубина: 0  достоверных:   1  подписанных:   0  доверие: 0-, 0q, 0n, 0m, 0f, 1u
[keyboxd]
---------
sec   ed25519 2026-09-12 [SC]
      CC1A1DA66D05E943B17BDB820186BF84DFD06287
uid         [  абсолютно ] denskv (denskv) <shoelacevip12@gmail.com>
ssb   cv25519 2026-09-12 [E]
```

</details>

```bash
# получить публичный GPG-ключ в base64 без --armor
gpg2 --export 'CC1A1DA66D05E943B17BDB820186BF84DFD06287' | base64 -w0
```

<details>
<summary>
публичный GPG-ключ в base64
</summary>

```log
LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgptRE1FYXFWNWZoWUpLd1lCQkFIYVJ3OEJBUWRBUVArRjVjNjdDUU83TVVzTWMwdyt5OEpwRFVkdGhoVGhBa0VrCncvTWQ3TSswS1dSbGJuTnJkaUFvWkdWdWMydDJLU0E4YzJodlpXeGhZMlYyYVhBeE1rQm5iV0ZwYkM1amIyMCsKaUpBRUV4WUtBRGdXSVFUTUdoMm1iUVhwUTdGNzI0SUJocitFMzlCaWh3VUNhcVY1ZmdJYkF3VUxDUWdIQWdZVgpDZ2tJQ3dJRUZnSURBUUllQVFJWGdBQUtDUkFCaHIrRTM5QmloLytpQVFET1FoTUsycWVOdnhtUjlFKzdGeFIvCklUMXlrQVZ6MGJxUUo1TzRlenVqdWdFQXRIVnVEV0lERkxxaDJpUlA4MUs1RnhxbUhZTnpjMFJ6QW9Ua3lXQzQKNkFlNE9BUnFwWGwrRWdvckJnRUVBWmRWQVFVQkFRZEFJT09MQ3VCZ2doL0RnVTRySGk5dVZFTmV4TDRaSkduQwpaS1ZDcncveHlEY0RBUWdIaUhnRUdCWUtBQ0FXSVFUTUdoMm1iUVhwUTdGNzI0SUJocitFMzlCaWh3VUNhcVY1CmZnSWJEQUFLQ1JBQmhyK0UzOUJpaHpZeEFRQ0ttVTc3c1JaZ0lsVFU2cWkyWnBwQXBpQXQ4bXZsZ2lkc0RESFYKU3lPMDdBRUFuUjJaOEtyUVpLNGwzY3dYUytHVjNSSFpPWmFzT1pNODlXcjl0M1hpOXdJPQo9STBWbQotLS0tLUVORCBQR1AgUFVCTElDIEtFWSBCTE9D
```

</details>

### Git Commit изменений

```bash
git rm -r --cached \
./ ../

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. ../.. \
&& git status

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий на новую ветку
git commit -am 'commit5, FFOPS-40_diplom-skv_den' \
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
FFOPS-40_diplom-skv_den \
&& git push \
--set-upstream \
ffops40-diplom \
FFOPS-40_diplom-skv_den
```

## commit_6,`FFOPS-40_diplom-skv_den`

### `TF-манифест` описания провайдера YC с бэкендом

<details>
<summary>
TF-манифест описания провайдера YC
</summary>

```tf
cat > providers_backend-S3.tf <<'EOF'
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket                   = "tfstate-skv"
    region                   = "ru-central1"
    key                      = "diplom/network.tfstate"
    shared_credentials_files = ["~/.sa_storage.key"]

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
  }
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

### `TF-манифест` объявления переменных

<details>
<summary>
TF-манифест объявления переменных
</summary>

```tf
cat > variables.tf <<'EOF'
#=========== providers_backend-S3 ==============
variable "cloud_id" {
  description = "ID облака"
  type        = string
}
variable "folder_id" {
  description = "The folder ID"
  type        = string
}
variable "default_zone" {
  description = "Зона размещения по умолчанию"
  type        = string
}

#=========== sa_storage ==============

variable "pgp_key_base64" {
  description = "Публичный PGP-ключ в base64"
  type        = string
  sensitive   = true
}

#=========== s3 ==============
variable "bucket_name_chipher" {
  description = "Имя S3 бакета"
  type        = string
}

#=========== kms ==============
variable "symmetric_key_name" {
  description = "имя yandex_kms_symmetric_key"
  type        = string
}

#=========== network_vpc ==============
variable "network_name" {
  description = "наименование созданной сети"
  type        = string
}

#=========== network_subnet ==============
variable "subnets" {
  description = "подсети для k8s"

  type = map(list(object(
    {
      name = string,
      zone = string,
      cidr = list(string)
    }))
  )

  validation {
    condition     = alltrue([for i in keys(var.subnets) : alltrue([for j in lookup(var.subnets, i) : contains(["ru-central1-a", "ru-central1-b", "ru-central1-d"], j.zone)])])
    error_message = "Ошибка! Зоны не доступны!"
  }
}

#=========== network_external_ipv4_address ==============
variable "external_static_ips" {
  description = "static ips"

  type = map(list(object(
    {
      name = string,
      zone = string
    }))
  )
}

#=========== security_group ==============
variable "white_ips_access_to_master" {
  description = "Ip с доступом до мастера"
  type        = list(string)
}
EOF
```

</details>

### `TF-манифест` locls значений

<details>
<summary>
TF-манифест локальных значений
</summary>

```tf
cat > locals.tf <<'EOF'
locals {
  subnet_array = flatten([for k, v in var.subnets : [for j in v : {
    name = j.name
    zone = j.zone
    cidr = j.cidr
    }
  ]])
  external_ips_array = flatten([for k, v in var.external_static_ips : [for j in v : {
    name = j.name
    zone = j.zone
    }
  ]])
}
EOF
```

</details>

### `TF-манифест` создания VPC сети, подсетей и публичных адресов

<details>
<summary>
TF-манифест создания VPC сети, подсетей и публичных адресов
</summary>

```tf
cat > network_vpc.tf <<'EOF'
resource "yandex_vpc_network" "skv-net" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "subnet-main" {
  for_each = {
    for k, v in local.subnet_array : "${v.name}" => v
  }
  network_id     = yandex_vpc_network.skv-net.id
  v4_cidr_blocks = each.value.cidr
  zone           = each.value.zone
  name           = each.value.name
}

resource "yandex_vpc_address" "public_addr" {
  for_each = {
    for v in local.external_ips_array : "${v.name}" => v
  }
  name = each.value.name
  external_ipv4_address {
    zone_id = each.value.zone
  }
}
EOF
```

</details>

### `TF-манифест` создания симметричного KMS-ключа

<details>
<summary>
TF-манифест создания симметричного KMS-ключа
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

### `TF-манифест` создания сервисного аккаунта для доступа к Object Storage

<details>
<summary>
TF-манифест создания сервисного аккаунта для доступа к Object Storage
</summary>

```tf
cat > sa_storage.tf <<'EOF'

resource "yandex_iam_service_account" "sa-storage-access" {
  folder_id   = var.folder_id
  name        = "sa-storage-access"
  description = "Service account для доступа к Object Storage"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_storage_editor" {
  # Сервисному аккаунту назначается роль "storage.admin".
  folder_id  = var.folder_id
  role       = "storage.admin"
  member     = "serviceAccount:${yandex_iam_service_account.sa-storage-access.id}"
  depends_on = [yandex_iam_service_account.sa-storage-access]
}

resource "yandex_resourcemanager_folder_iam_member" "sa_encrypterDecrypter" {
  /*
Сервисному аккаунту назначается роль "kms.keys.encrypterDecrypter".

KMS_ID=abjbpu5tk0dfbcfceku2
SA_ID=ajevuvi14s54jikil9m0

yc kms symmetric-key add-access-binding "$KMS_ID" \
--role kms.keys.encrypterDecrypter \
--service-account-id "$SA_ID"
*/
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa-storage-access.id}"
}



resource "yandex_resourcemanager_folder_iam_binding" "vpc-public-admin" {
  # Сервисному аккаунту назначается роль "vpc.publicAdmin".
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-storage-access.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-storage-access.id}"
  ]
}

resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
  service_account_id = yandex_iam_service_account.sa-storage-access.id
  description        = "Static access key для доступа к Object Storage"
  pgp_key            = var.pgp_key_base64
}

EOF
```

</details>

### `TF-манифест` группы доступа

<details>
<summary>
TF-манифест групп доступа
</summary>

```tf
cat > security_groups.tf <<'EOF'
resource "yandex_vpc_security_group" "internal" {
  name        = "internal"
  description = "Доступность для внутренней сети"
  network_id  = yandex_vpc_network.skv-net.id
  labels = {
    firewall = "yc_internal"
  }
  ingress {
    protocol          = "ANY"
    description       = "self"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  egress {
    protocol          = "ANY"
    description       = "self"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
}

resource "yandex_vpc_security_group" "k8s_master" {
  name        = "k8s-master"
  description = "Доступность для мастера k8s"
  network_id  = yandex_vpc_network.skv-net.id
  labels = {
    firewall = "k8s-master"
  }
  ingress {
    protocol       = "TCP"
    description    = "доступ до api k8s"
    v4_cidr_blocks = var.white_ips_access_to_master
    port           = 443
  }
  ingress {
    protocol          = "TCP"
    description       = "доступ до api k8s из Yandex load balancer"
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
}

resource "yandex_vpc_security_group" "k8s_worker" {
  name        = "k8s-worker"
  description = "Доступность для рабочих нод"
  network_id  = yandex_vpc_network.skv-net.id
  labels = {
    firewall = "k8s-worker"
  }
  ingress {
    protocol       = "ANY"
    description    = "any connections"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
  egress {
    protocol       = "ANY"
    description    = "any connections"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
EOF
```

</details>

### `TF-манифест` создания S3-бакета

<details>
<summary>
TF-манифест создания S3-бакета
</summary>

```tf
cat > s3.tf <<'EOF'
resource "yandex_storage_bucket" "tfstate" {
  anonymous_access_flags {
    read        = false
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
EOF
```

</details>

### `tfvars-файл` значений переменных поумолчанию

<details>
<summary>
tfvars-файл значений переменных поумолчанию
</summary>

```tf
cat > terraform.tfvars <<'EOF'
#=========== providers_backend-S3 ===========
cloud_id     = "b1g46dhqv17rkjcoc9k7"
folder_id    = "b1g9l0vgsvf6cegkvj1c"
default_zone = "ru-central1-a"

#=========== sa_storage ==============

pgp_key_base64 = "mDMEaqV5fhYJKwYBBAHaRw8BAQdAQP+F5c67CQO7MUsMc0w+y8JpDUdthhThAkEkw/Md7M+0KWRlbnNrdiAoZGVuc2t2KSA8c2hvZWxhY2V2aXAxMkBnbWFpbC5jb20+iJAEExYKADgWIQTMGh2mbQXpQ7F724IBhr+E39BihwUCaqV5fgIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRABhr+E39Bih/+iAQDOQhMK2qeNvxmR9E+7FxR/IT1ykAVz0bqQJ5O4ezujugEAtHVuDWIDFLqh2iRP81K5FxqmHYNzc0RzAoTkyWC46Ae4OARqpXl+EgorBgEEAZdVAQUBAQdAIOOLCuBggh/DgU4rHi9uVENexL4ZJGnCZKVCrw/xyDcDAQgHiHgEGBYKACAWIQTMGh2mbQXpQ7F724IBhr+E39BihwUCaqV5fgIbDAAKCRABhr+E39BihzYxAQCKmU77sRZgIlTU6qi2ZppApiAt8mvlgidsDDHVSyO07AEAnR2Z8KrQZK4l3cwXS+GV3RHZOZasOZM89Wr9t3Xi9wI="

#=========== s3 ==============
bucket_name_chipher = "tfstate-skv"

#=========== kms ==============
symmetric_key_name = "sym-kms-den-skv"

#=========== network_vpc ===========
network_name = "skv-net"

#=========== network_subnet ===========
subnets = {
  "k8s_master" = [
    {
      name = "k8s_master_zone_a"
      zone = "ru-central1-a"
      cidr = ["10.10.10.0/28"]
    }
  ],
  "k8s_workers" = [
    {
      name = "k8s_worker_zone_a"
      zone = "ru-central1-a"
      cidr = ["10.10.10.16/28"]
    },
    {
      name = "k8s_worker_zone_b"
      zone = "ru-central1-b"
      cidr = ["10.10.10.32/28"]
    },
    {
      name = "k8s_worker_zone_d"
      zone = "ru-central1-d"
      cidr = ["10.10.10.48/28"]
    }
  ],
}

#=========== network_external_ipv4_address ===========
external_static_ips = {
  ingress_lb = [
    {
      name = "ingress_lb_zone_ru_central1_a"
      zone = "ru-central1-a"
    }
  ]
}

#=========== security_group ===========
white_ips_access_to_master = [
  "127.0.0.1/32",
  "0.0.0.0/0"
]

# white_ips_access_to_master = [
#   "127.0.0.1/32",
#   "$YOUR_IP/32"
#   ]
EOF
```

</details>

### Инициализация и запуск

```bash
yc components update

yc storage bucket create --name tfstate-skv

yc iam service-account create --name sa-storage-access

yc resource-manager folder add-access-binding \
$(yc resource-manager folder list | awk '/ACTIVE/ {print $2}') \
--role storage.admin \
--service-account-id $(yc iam service-account list | awk '/sa-storage-access/ {print $2}')
```

<details>
<summary>
Лог создания бакета и сервис аккаунта
</summary>

```log
Installing yc 1.34.0 ...
Update is complete!
Please reload your shell for changes to take place.
Now we have zsh completion. Type "echo 'source /home/shoel/yandex-cloud/completion.zsh.inc' >>  ~/.zshrc" to install it

name: tfstate-skv
folder_id: b1g9l0vgsvf6cegkvj1c
anonymous_access_flags: {}
default_storage_class: STANDARD
versioning: VERSIONING_DISABLED
created_at: "2026-09-12T19:30:27.404220Z"
resource_id: e3eovi75ndgdinekmgl3

done (2s)
id: ajeoimlfbtl0sab6ln8a
folder_id: b1g9l0vgsvf6cegkvj1c
created_at: "2026-09-12T19:42:26Z"
name: sa-storage-access
status: ACTIVE

done (2s)
{}
```

</details>

```bash
yc resource-manager folder add-access-binding \
"$(yc resource-manager folder list | awk '/ACTIVE/ {print $2}')" \
--role storage.editor \
--service-account-id \
"$(yc iam service-account list | awk '/sa-storage-access/ {print $2}')"

yc iam access-key create \
--service-account-name sa-storage-access \
--description "terraform backend"
```

<details>
<summary>
Лог добавления прав и создания ключа доступа
</summary>

```log
done (2s)
effective_deltas:
  - action: ADD
    access_binding:
      role_id: storage.editor
      subject:
        id: ajeoimlfbtl0sab6ln8a
        type: serviceAccount

access_key:
  id: ajegvl9pirj12gb1hp9m
  service_account_id: ajeoimlfbtl0sab6ln8a
  created_at: "2026-09-12T19:52:52.974704596Z"
  description: terraform backend
  key_id: YCAJEJyV6VU4oe14uT0xhP9s7
secret:
```

</details>

```bash
cat > ~/.sa_storage.key <<EOF
[default]
aws_access_key_id = $(yc iam access-key list --service-account-name sa-storage-access | awk 'NR == 4 {print $6}')
aws_secret_access_key = <SECRET>
EOF

cat ~/.sa_storage.key

chmod -v 600 ~/.sa_storage.key
```

<details>
<summary>
Создание файла доступа
</summary>

```log
[default]
aws_access_key_id = YCAJEJyV6VU4oe14uT0xhP9s7
aws_secret_access_key = <!!!SECRET!!!>

права доступа '/home/shoel/.sa_storage.key' изменены с 0644 (rw-r--r--) на 0600 (rw-------)
```

</details>

```bash
terraform init --upgrade \
&& terraform validate \
&& terraform fmt \
&& terraform plan -out=tfplan
```

<details>
<summary>
вывод инициализации и проверки
</summary>

```log
Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.226.0...
- Installed yandex-cloud/yandex v0.226.0 (unauthenticated)

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
│ The current .terraform.lock.hcl file only includes checksums for linux_amd64, so Terraform running on another platform will fail to install
│ these providers.
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


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_iam_service_account.sa-storage-access will be created
  + resource "yandex_iam_service_account" "sa-storage-access" {
      + created_at         = (known after apply)
      + description        = "Service account для доступа к Object Storage"
      + expires_at         = (known after apply)
      + folder_id          = "b1g9l0vgsvf6cegkvj1c"
      + id                 = (known after apply)
      + labels             = (known after apply)
      + name               = "sa-storage-access"
      + service_account_id = (known after apply)
      + status             = (known after apply)
    }

  # yandex_iam_service_account_static_access_key.sa_static_key will be created
  + resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
      + access_key                   = (known after apply)
      + created_at                   = (known after apply)
      + description                  = "Static access key для доступа к Object Storage"
      + encrypted_secret_key         = (known after apply)
      + id                           = (known after apply)
      + key_fingerprint              = (known after apply)
      + output_to_lockbox_version_id = (known after apply)
      + pgp_key                      = (sensitive value)
      + secret_key                   = (sensitive value)
      + service_account_id           = (known after apply)
    }

  # yandex_kms_symmetric_key.sym-kms will be created
  + resource "yandex_kms_symmetric_key" "sym-kms" {
      + created_at          = (known after apply)
      + default_algorithm   = "AES_256"
      + deletion_protection = false
      + description         = "Создание симметричного ключа"
      + folder_id           = "b1g9l0vgsvf6cegkvj1c"
      + id                  = (known after apply)
      + labels              = (known after apply)
      + name                = "sym-kms-den-skv"
      + rotated_at          = (known after apply)
      + status              = (known after apply)
      + symmetric_key_id    = (known after apply)
        # (1 unchanged attribute hidden)
    }

  # yandex_resourcemanager_folder_iam_binding.images-puller will be created
  + resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
      + folder_id = "b1g9l0vgsvf6cegkvj1c"
      + id        = (known after apply)
      + members   = [
          + (known after apply),
        ]
      + role      = "container-registry.images.puller"
    }

  # yandex_resourcemanager_folder_iam_binding.vpc-public-admin will be created
  + resource "yandex_resourcemanager_folder_iam_binding" "vpc-public-admin" {
      + folder_id = "b1g9l0vgsvf6cegkvj1c"
      + id        = (known after apply)
      + members   = [
          + (known after apply),
        ]
      + role      = "vpc.publicAdmin"
    }

  # yandex_resourcemanager_folder_iam_member.sa_storage_editor will be created
  + resource "yandex_resourcemanager_folder_iam_member" "sa_storage_editor" {
      + folder_id = "b1g9l0vgsvf6cegkvj1c"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "storage.editor"
    }

  # yandex_storage_bucket.tfstate will be created
  + resource "yandex_storage_bucket" "tfstate" {
      + acl                     = (known after apply)
      + bucket                  = "tfstate-skv"
      + bucket_domain_name      = (known after apply)
      + default_storage_class   = "STANDARD"
      + disabled_statickey_auth = false
      + folder_id               = (known after apply)
      + force_destroy           = false
      + id                      = (known after apply)
      + max_size                = 1073741824
      + policy                  = (known after apply)
      + website_domain          = (known after apply)
      + website_endpoint        = (known after apply)

      + anonymous_access_flags {
          + config_read = false
          + list        = false
          + read        = false
        }

      + grant (known after apply)

      + server_side_encryption_configuration {
          + rule {
              + apply_server_side_encryption_by_default {
                  + kms_master_key_id = (known after apply)
                  + sse_algorithm     = "aws:kms"
                }
            }
        }

      + versioning {
          + enabled = false
        }
    }

  # yandex_vpc_address.public_addr["ingress_lb_zone_ru_central1_a"] will be created
  + resource "yandex_vpc_address" "public_addr" {
      + created_at          = (known after apply)
      + deletion_protection = (known after apply)
      + folder_id           = (known after apply)
      + id                  = (known after apply)
      + labels              = (known after apply)
      + name                = "ingress_lb_zone_ru_central1_a"
      + reserved            = (known after apply)
      + used                = (known after apply)

      + external_ipv4_address {
          + address                  = (known after apply)
          + ddos_protection_provider = (known after apply)
          + outgoing_smtp_capability = (known after apply)
          + zone_id                  = "ru-central1-a"
        }
    }

  # yandex_vpc_network.skv-net will be created
  + resource "yandex_vpc_network" "skv-net" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "skv-net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_security_group.internal will be created
  + resource "yandex_vpc_security_group" "internal" {
      + created_at  = (known after apply)
      + description = "Доступность для внутренней сети"
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + labels      = {
          + "firewall" = "yc_internal"
        }
      + name        = "internal"
      + network_id  = (known after apply)
      + status      = (known after apply)

      + egress {
          + description       = "self"
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + predefined_target = "self_security_group"
          + protocol          = "ANY"
          + to_port           = 65535
          + v4_cidr_blocks    = []
          + v6_cidr_blocks    = []
            # (1 unchanged attribute hidden)
        }

      + ingress {
          + description       = "self"
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + predefined_target = "self_security_group"
          + protocol          = "ANY"
          + to_port           = 65535
          + v4_cidr_blocks    = []
          + v6_cidr_blocks    = []
            # (1 unchanged attribute hidden)
        }
    }

  # yandex_vpc_security_group.k8s_master will be created
  + resource "yandex_vpc_security_group" "k8s_master" {
      + created_at  = (known after apply)
      + description = "Доступность для мастера k8s"
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + labels      = {
          + "firewall" = "k8s-master"
        }
      + name        = "k8s-master"
      + network_id  = (known after apply)
      + status      = (known after apply)

      + egress (known after apply)

      + ingress {
          + description       = "доступ до api k8s из Yandex load balancer"
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + predefined_target = "loadbalancer_healthchecks"
          + protocol          = "TCP"
          + to_port           = 65535
          + v4_cidr_blocks    = []
          + v6_cidr_blocks    = []
            # (1 unchanged attribute hidden)
        }
      + ingress {
          + description       = "доступ до api k8s"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 443
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "127.0.0.1/32",
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
    }

  # yandex_vpc_security_group.k8s_worker will be created
  + resource "yandex_vpc_security_group" "k8s_worker" {
      + created_at  = (known after apply)
      + description = "Доступность для рабочих нод"
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + labels      = {
          + "firewall" = "k8s-worker"
        }
      + name        = "k8s-worker"
      + network_id  = (known after apply)
      + status      = (known after apply)

      + egress {
          + description       = "any connections"
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
          + description       = "any connections"
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
    }

  # yandex_vpc_subnet.subnet-main["k8s_master_zone_a"] will be created
  + resource "yandex_vpc_subnet" "subnet-main" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "k8s_master_zone_a"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.10.10.0/28",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-main["k8s_worker_zone_a"] will be created
  + resource "yandex_vpc_subnet" "subnet-main" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "k8s_worker_zone_a"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.10.10.16/28",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-main["k8s_worker_zone_b"] will be created
  + resource "yandex_vpc_subnet" "subnet-main" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "k8s_worker_zone_b"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.10.10.32/28",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # yandex_vpc_subnet.subnet-main["k8s_worker_zone_d"] will be created
  + resource "yandex_vpc_subnet" "subnet-main" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "k8s_worker_zone_d"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.10.10.48/28",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-d"
    }

Plan: 16 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + access_key_id        = (known after apply)
  + encrypted_secret_key = (known after apply)
  + key_fingerprint      = (known after apply)
  + service_account_id   = (known after apply)

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"
```

</details>

```bash
# Импорт существующего сервисного аккаунта (yc iam service-account list)
terraform import \
"yandex_iam_service_account.$(yc iam service-account list | awk '/sa-storage-access/ {print $4}')" \
$(yc iam service-account list | awk '/sa-storage-access/ {print $2}')
```

<details>
<summary>
лог импорта существующих ресурсов
</summary>

```log
yandex_iam_service_account.sa-storage-access: Importing from ID "ajeoimlfbtl0sab6ln8a"...
yandex_iam_service_account.sa-storage-access: Import prepared!
  Prepared yandex_iam_service_account for import
yandex_iam_service_account.sa-storage-access: Refreshing state...

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

</details>

```bash
# Импорт существующего бакета (по имени бакета)
terraform import yandex_storage_bucket.tfstate \
$(yc storage bucket list | awk 'NR ==4  {print $2}')
```

<details>
<summary>
лог импорта существующих ресурсов
</summary>

```log
yandex_storage_bucket.tfstate: Importing from ID "tfstate-skv"...
yandex_storage_bucket.tfstate: Import prepared!
  Prepared yandex_storage_bucket for import
yandex_storage_bucket.tfstate: Refreshing state... [id=tfstate-skv]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

</details>

```bash
# Обновление plan
terraform plan -out=tfplan
```

<details>
<summary>
Обновления Plan
</summary>

```log
yandex_iam_service_account.sa-storage-access: Refreshing state... [id=ajevuvi14s54jikil9m0]
yandex_storage_bucket.tfstate: Refreshing state... [id=tfstate-skv]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create
  ~ update in-place

Terraform will perform the following actions:

  # yandex_iam_service_account.sa-storage-access will be updated in-place
  ~ resource "yandex_iam_service_account" "sa-storage-access" {
      ~ created_at         = "2026-09-12T21:00:43Z" -> (known after apply)
      + description        = "Service account для доступа к Object Storage"
        id                 = "ajevuvi14s54jikil9m0"
      + labels             = (known after apply)
        name               = "sa-storage-access"
      ~ status             = "ACTIVE" -> (known after apply)
        # (3 unchanged attributes hidden)
    }

  # yandex_iam_service_account_static_access_key.sa_static_key will be created
  + resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
      + access_key                   = (known after apply)
      + created_at                   = (known after apply)
      + description                  = "Static access key для доступа к Object Storage"
      + encrypted_secret_key         = (known after apply)
      + id                           = (known after apply)
      + key_fingerprint              = (known after apply)
      + output_to_lockbox_version_id = (known after apply)
      + pgp_key                      = (sensitive value)
      + secret_key                   = (sensitive value)
      + service_account_id           = "ajevuvi14s54jikil9m0"
    }

  # yandex_kms_symmetric_key.sym-kms will be created
  + resource "yandex_kms_symmetric_key" "sym-kms" {
      + created_at          = (known after apply)
      + default_algorithm   = "AES_256"
      + deletion_protection = false
      + description         = "Создание симметричного ключа"
      + folder_id           = "b1g9l0vgsvf6cegkvj1c"
      + id                  = (known after apply)
      + labels              = (known after apply)
      + name                = "sym-kms-den-skv"
      + rotated_at          = (known after apply)
      + status              = (known after apply)
      + symmetric_key_id    = (known after apply)
        # (1 unchanged attribute hidden)
    }

  # yandex_resourcemanager_folder_iam_binding.images-puller will be created
  + resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
      + folder_id = "b1g9l0vgsvf6cegkvj1c"
      + id        = (known after apply)
      + members   = [
          + "serviceAccount:ajevuvi14s54jikil9m0",
        ]
      + role      = "container-registry.images.puller"
    }

  # yandex_resourcemanager_folder_iam_binding.vpc-public-admin will be created
  + resource "yandex_resourcemanager_folder_iam_binding" "vpc-public-admin" {
      + folder_id = "b1g9l0vgsvf6cegkvj1c"
      + id        = (known after apply)
      + members   = [
          + "serviceAccount:ajevuvi14s54jikil9m0",
        ]
      + role      = "vpc.publicAdmin"
    }

  # yandex_resourcemanager_folder_iam_member.sa_storage_editor will be created
  + resource "yandex_resourcemanager_folder_iam_member" "sa_storage_editor" {
      + folder_id = "b1g9l0vgsvf6cegkvj1c"
      + id        = (known after apply)
      + member    = "serviceAccount:ajevuvi14s54jikil9m0"
      + role      = "storage.editor"
    }

  # yandex_storage_bucket.tfstate will be updated in-place
  ~ resource "yandex_storage_bucket" "tfstate" {
      + force_destroy           = false
        id                      = "tfstate-skv"
      ~ max_size                = 0 -> 1073741824
        tags                    = {}
        # (6 unchanged attributes hidden)

      + server_side_encryption_configuration {
          + rule {
              + apply_server_side_encryption_by_default {
                  + kms_master_key_id = (known after apply)
                  + sse_algorithm     = "aws:kms"
                }
            }
        }

        # (2 unchanged blocks hidden)
    }

  # yandex_vpc_address.public_addr["ingress_lb_zone_ru_central1_a"] will be created
  + resource "yandex_vpc_address" "public_addr" {
      + created_at          = (known after apply)
      + deletion_protection = (known after apply)
      + folder_id           = (known after apply)
      + id                  = (known after apply)
      + labels              = (known after apply)
      + name                = "ingress_lb_zone_ru_central1_a"
      + reserved            = (known after apply)
      + used                = (known after apply)

      + external_ipv4_address {
          + address                  = (known after apply)
          + ddos_protection_provider = (known after apply)
          + outgoing_smtp_capability = (known after apply)
          + zone_id                  = "ru-central1-a"
        }
    }

  # yandex_vpc_network.skv-net will be created
  + resource "yandex_vpc_network" "skv-net" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "skv-net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_security_group.internal will be created
  + resource "yandex_vpc_security_group" "internal" {
      + created_at  = (known after apply)
      + description = "Доступность для внутренней сети"
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + labels      = {
          + "firewall" = "yc_internal"
        }
      + name        = "internal"
      + network_id  = (known after apply)
      + status      = (known after apply)

      + egress {
          + description       = "self"
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + predefined_target = "self_security_group"
          + protocol          = "ANY"
          + to_port           = 65535
          + v4_cidr_blocks    = []
          + v6_cidr_blocks    = []
            # (1 unchanged attribute hidden)
        }

      + ingress {
          + description       = "self"
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + predefined_target = "self_security_group"
          + protocol          = "ANY"
          + to_port           = 65535
          + v4_cidr_blocks    = []
          + v6_cidr_blocks    = []
            # (1 unchanged attribute hidden)
        }
    }

  # yandex_vpc_security_group.k8s_master will be created
  + resource "yandex_vpc_security_group" "k8s_master" {
      + created_at  = (known after apply)
      + description = "Доступность для мастера k8s"
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + labels      = {
          + "firewall" = "k8s-master"
        }
      + name        = "k8s-master"
      + network_id  = (known after apply)
      + status      = (known after apply)

      + egress (known after apply)

      + ingress {
          + description       = "доступ до api k8s из Yandex load balancer"
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + predefined_target = "loadbalancer_healthchecks"
          + protocol          = "TCP"
          + to_port           = 65535
          + v4_cidr_blocks    = []
          + v6_cidr_blocks    = []
            # (1 unchanged attribute hidden)
        }
      + ingress {
          + description       = "доступ до api k8s"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 443
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "127.0.0.1/32",
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
    }

  # yandex_vpc_security_group.k8s_worker will be created
  + resource "yandex_vpc_security_group" "k8s_worker" {
      + created_at  = (known after apply)
      + description = "Доступность для рабочих нод"
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + labels      = {
          + "firewall" = "k8s-worker"
        }
      + name        = "k8s-worker"
      + network_id  = (known after apply)
      + status      = (known after apply)

      + egress {
          + description       = "any connections"
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
          + description       = "any connections"
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
    }

  # yandex_vpc_subnet.subnet-main["k8s_master_zone_a"] will be created
  + resource "yandex_vpc_subnet" "subnet-main" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "k8s_master_zone_a"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.10.10.0/28",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-main["k8s_worker_zone_a"] will be created
  + resource "yandex_vpc_subnet" "subnet-main" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "k8s_worker_zone_a"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.10.10.16/28",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-main["k8s_worker_zone_b"] will be created
  + resource "yandex_vpc_subnet" "subnet-main" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "k8s_worker_zone_b"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.10.10.32/28",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # yandex_vpc_subnet.subnet-main["k8s_worker_zone_d"] will be created
  + resource "yandex_vpc_subnet" "subnet-main" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "k8s_worker_zone_d"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.10.10.48/28",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-d"
    }

Plan: 14 to add, 2 to change, 0 to destroy.

Changes to Outputs:
  + access_key_id        = (known after apply)
  + encrypted_secret_key = (known after apply)
  + key_fingerprint      = (known after apply)

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"
```

</details>

```bash
# Создание ресурсов
terraform apply "tfplan"
```

<details>
<summary>
Лог Создания ресурсов
</summary>

```log
yandex_vpc_network.skv-net: Creating...
yandex_vpc_address.public_addr["ingress_lb_zone_ru_central1_a"]: Creating...
yandex_kms_symmetric_key.sym-kms: Creating...
yandex_iam_service_account.sa-storage-access: Modifying... [id=ajevuvi14s54jikil9m0]
yandex_kms_symmetric_key.sym-kms: Creation complete after 0s [id=abjbpu5tk0dfbcfceku2]
yandex_storage_bucket.tfstate: Modifying... [id=tfstate-skv]
yandex_vpc_address.public_addr["ingress_lb_zone_ru_central1_a"]: Creation complete after 1s [id=e9bac3283b88mk7aio1q]
yandex_storage_bucket.tfstate: Modifications complete after 1s [id=tfstate-skv]
yandex_iam_service_account.sa-storage-access: Modifications complete after 2s [id=ajevuvi14s54jikil9m0]
yandex_resourcemanager_folder_iam_binding.vpc-public-admin: Creating...
yandex_resourcemanager_folder_iam_member.sa_storage_editor: Creating...
yandex_resourcemanager_folder_iam_binding.images-puller: Creating...
yandex_iam_service_account_static_access_key.sa_static_key: Creating...
yandex_vpc_network.skv-net: Creation complete after 2s [id=enpet221hvbndeo89itn]
yandex_vpc_subnet.subnet-main["k8s_worker_zone_d"]: Creating...
yandex_vpc_subnet.subnet-main["k8s_master_zone_a"]: Creating...
yandex_vpc_security_group.internal: Creating...
yandex_vpc_subnet.subnet-main["k8s_worker_zone_b"]: Creating...
yandex_vpc_security_group.k8s_master: Creating...
yandex_vpc_security_group.k8s_worker: Creating...
yandex_vpc_subnet.subnet-main["k8s_worker_zone_d"]: Creation complete after 0s [id=fl82knu8pvd3dn0g3eu3]
yandex_vpc_subnet.subnet-main["k8s_worker_zone_a"]: Creating...
yandex_vpc_subnet.subnet-main["k8s_worker_zone_a"]: Creation complete after 1s [id=e9b8rf88ci7qgodsrct7]
yandex_vpc_security_group.k8s_master: Creation complete after 1s [id=enpcae5stgt33eejn07u]
yandex_iam_service_account_static_access_key.sa_static_key: Creation complete after 1s [id=aje0g7a5d2oqkcq9sjs3]
yandex_vpc_subnet.subnet-main["k8s_master_zone_a"]: Creation complete after 1s [id=e9bftt165f7is440d0l4]
yandex_vpc_subnet.subnet-main["k8s_worker_zone_b"]: Creation complete after 1s [id=e2lsf0nmgc0g7992tc1j]
yandex_vpc_security_group.internal: Creation complete after 2s [id=enprr82lvjj1e7grmet7]
yandex_resourcemanager_folder_iam_member.sa_storage_editor: Creation complete after 2s [id=b1g9l0vgsvf6cegkvj1c/storage.editor/serviceAccount:ajevuvi14s54jikil9m0]
yandex_resourcemanager_folder_iam_binding.vpc-public-admin: Creation complete after 2s [id=b1g9l0vgsvf6cegkvj1c/vpc.publicAdmin]
yandex_vpc_security_group.k8s_worker: Creation complete after 4s [id=enpn8bp7qm5c215u43ha]
yandex_resourcemanager_folder_iam_binding.images-puller: Creation complete after 5s [id=b1g9l0vgsvf6cegkvj1c/container-registry.images.puller]

Apply complete! Resources: 14 added, 2 changed, 0 destroyed.
```

</details>

```bash
terraform output encrypted_secret_key \
| xargs -I{} echo {} \
| base64 -d \
| gpg2 --list-secret-keys
```

<details>
<summary>
Лог Создания ресурсов
</summary>

```log
[keyboxd]
---------
sec   ed25519 2026-09-12 [SC]
      CC1A1DA66D05E943B17BDB820186BF84DFD06287
uid         [  абсолютно ] denskv (denskv) <shoelacevip12@gmail.com>
ssb   cv25519 2026-09-12 [E]
```

</details>
