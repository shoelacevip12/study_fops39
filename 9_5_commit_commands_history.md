# Для домашнего задания 9.5
### commit_10, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sflt-homeworks.git

rm -rf sflt-homeworks/{.git,2,2.md,3.md,4.md,README.md}

mv sflt-homeworks 9_5

cd 9_5

mv 1/hsrp_advanced.pkt .

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_10, master' \
&& git push --set-upstream study_fops39 master

```

### commit_1, 9_5-FHRP_VRRP
```bash
git log --oneline

git checkout -b 9_5-FHRP_VRRP

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 9_5-FHRP_VRRP' \
&& git push --set-upstream study_fops39 9_5-FHRP_VRRP
```

### commit_2, 9_5-FHRP_VRRP
```Pug
#Router 1
en
sh run


^C
conf t
int gi0/1
standby 1 preempt
standby 1 tr gi0/0
sh
no sh
end

wr

cop run st

sh run | in standby

sh stan br
````

```Pug
#Router 2
en
sh run


^C
conf t
int gi0/1
standby 1 pri 55
standby 1 tr gi0/0
sh
no sh
end

wr

cop run st

sh run | in standby

sh stan br
```
```bash
git branch -v

git remote -v

git status

git add . ..

git commit -am 'commit_2, 9_5-FHRP_VRRP' \
&& git push --set-upstream study_fops39 9_5-FHRP_VRRP
```

### commit_3, 9_5-FHRP_VRRP
```bash
 cd gited/9_5/1

 vagrant plugin expunge --reinstall

cat >Vagrantfile<<'EOF'
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.insert_key = true

  # Общая конфигурация для обеих машин
  config.vm.box = "cloud-image/ubuntu-24.04"
  config.vm.box_version = "20250805.0.0"

  # Конфигурация для libvirt (общая)
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = "kvm"
    libvirt.uri = 'qemu:///system'
    libvirt.memory = 4096
    libvirt.cpus = 2
    libvirt.nested = true
    libvirt.disk_driver :cache => 'none'
    libvirt.disk_bus = "virtio"
    libvirt.default_prefix = "keepalived_"
    libvirt.nic_model_type = "virtio"
    libvirt.management_network_mode = "route"
  end

  # Определение первой машины
  config.vm.define "vrrp1" do |vrrp1|
    vrrp1.vm.hostname = "vrrp1"
    # vrrp1.vm.management_network_address = "192.168.121.3/24"

    vrrp1.vm.cloud_init do |cloud_init|
      cloud_init.content_type = "text/cloud-config"
      cloud_init.inline = <<-EOF
        package_update: true
        package_upgrade: true
      EOF
    end

    vrrp1.vm.synced_folder ".",  "/usr/local/bin",
      type: "rsync",
      rsync__args: ["--verbose", "--rsync-path='sudo rsync'", "--archive", "--delete", "--include=check_web_server.sh", "--exclude=*"],
      create: true

    vrrp1.vm.synced_folder ".",  "/etc/keepalived",
      type: "rsync",
      rsync__args: ["--verbose", "--rsync-path='sudo rsync'", "--archive", "--delete", "--include=keepalived-nginx.conf", "--exclude=*"],
      create: true

    vrrp1.vm.provision "shell", inline: <<-SHELL
      export DEBIAN_FRONTEND=noninteractive
      sudo systemctl enable --now cloud-init
      sudo cloud-init init
      sudo cloud-init clean
      sudo apt update -y
      sudo apt install -y \
      curl \
      openssh-server \
      libsnmp-base \
      ipvsadm \
      libsnmp40t64 \
      curl \
      ca-certificates \
      nginx \
      nano \
      apt-transport-https \
      gnupg \
      keepalived \
      ncat
      sudo chmod +x /usr/local/bin/check_web_server.sh
      ip_address=$(ip route get 77.88.8.8 2>/dev/null | awk '{print $7; exit}')
      sudo sed -i -e "12s/nginx\!/$ip_address/" /var/www/html/index.nginx-debian.html
      sudo systemctl enable --now nginx.service
      ip_int=$(ip a | grep "2: " | cut -c4-7)
      sudo mv /etc/keepalived/keepalived{-nginx,}.conf
      sudo sed -i -e "9s|ens33|$ip_int|" /etc/keepalived/keepalived.conf
      sudo systemctl enable --now keepalived.service
    SHELL
  end

  # Определение второй машины
  config.vm.define "vrrp2" do |vrrp2|
    vrrp2.vm.hostname = "vrrp2"
    # vrrp2.vm.management_network_address = "192.168.121.4/24"

    vrrp2.vm.cloud_init do |cloud_init|
      cloud_init.content_type = "text/cloud-config"
      cloud_init.inline = <<-EOF
        package_update: true
        package_upgrade: true
      EOF
    end

    vrrp2.vm.synced_folder ".",  "/usr/local/bin",
      type: "rsync",
      rsync__args: ["--verbose", "--rsync-path='sudo rsync'", "--archive", "--delete", "--include=check_web_server.sh", "--exclude=*"],
      create: true

    vrrp2.vm.synced_folder ".",  "/etc/keepalived",
      type: "rsync",
      rsync__args: ["--verbose", "--rsync-path='sudo rsync'", "--archive", "--delete", "--include=keepalived-nginx.conf", "--exclude=*"],
      create: true

    vrrp2.vm.provision "shell", inline: <<-SHELL
      export DEBIAN_FRONTEND=noninteractive
      sudo systemctl enable --now cloud-init
      sudo cloud-init init
      sudo cloud-init clean
      sudo apt update -y
      sudo apt install -y \
      curl \
      openssh-server \
      libsnmp-base \
      ipvsadm \
      libsnmp40t64 \
      curl \
      ca-certificates \
      nginx \
      nano \
      apt-transport-https \
      gnupg \
      keepalived \
      ncat
      sudo chmod +x /usr/local/bin/check_web_server.sh
      ip_address=$(ip route get 77.88.8.8 2>/dev/null | awk '{print $7; exit}')
      sudo sed -i -e "12s/nginx\!/$ip_address/" /var/www/html/index.nginx-debian.html
      sudo systemctl enable --now nginx.service
      ip_int=$(ip a | grep "2: " | cut -c4-7)
      sudo mv /etc/keepalived/keepalived{-nginx,}.conf
      sudo sed -i -e "8s|MASTER|BACKUP|" \
      -e "9s|ens33|$ip_int|" \
      -e "11s|255|200|" /etc/keepalived/keepalived.conf
      sudo systemctl enable --now keepalived.service
    SHELL
  end
end
EOF

cat >check_web_server.sh<<'EOF'
#!/bin/bash
# Параметры по умолчанию
HOST="127.0.0.1"
PORT="80"
FILE="/var/www/html/index.nginx-debian.html"
# Проверка доступности порта
if nc -z "$HOST" "$PORT" &>/dev/null; then
    echo "Порт $PORT на $HOST доступен"
else
    exit 1
fi
# Проверка существования файла
if [ -f "$FILE" ]; then
    echo "Файл $FILE существует"
else
    exit 2
fi
exit 0
EOF

vagrant up

vagrant ssh vrrp1 -- -t 'sudo systemctl stop keepalived'

vagrant ssh vrrp2 -- -t 'sudo journalctl -xefu keepalived'

vagrant ssh vrrp1 -- -t 'sudo systemctl start keepalived'

mv ../{1,README}.md

cd ..

git branch -v

git remote -v

git status

git add . ..

git commit -am 'commit_3, 9_5-FHRP_VRRP' \
&& git push --set-upstream study_fops39 9_5-FHRP_VRRP
```

### commit_12, master
```bash
(cd 1 && vagrant destroy)

git branch -v

git log --oneline

git status

git diff && git diff --staged

git add . .. \
&& git commit --amend --no-edit \
&& git push --set-upstream study_fops39 9_5-FHRP_VRRP --force

git checkout master

git branch -v

git merge 9_5-FHRP_VRRP

git add . .. \
&& git status

git commit -am 'commit_12, master & 9_5-FHRP_VRRP' && git push study_fops39 master
```