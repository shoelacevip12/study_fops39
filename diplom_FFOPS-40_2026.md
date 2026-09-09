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