# Для домашнего задания 9.6
### commit_13, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sflt-homeworks.git

rm -rf sflt-homeworks/{.git,1,1.md,3.md,4.md,README.md}

mv sflt-homeworks 9_6

cd 9_6

mv {2,README}.md

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_13, master' \
&& git push --set-upstream study_fops39 master

```

### commit_1, 9_6-HA
```bash
git log --oneline

git checkout -b 9_6-HA

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 9_6-HA' \
&& git push --set-upstream study_fops39 9_6-HA
```

### commit_2, 9_6-HA
```bash
cd 9_6

mkdir service

rm -rf 2/nginx/nginx.cfg

rm -rf 2/haproxy

cat>Vagrantfile<<'EOF'
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.insert_key = true

  # Общая конфигурация
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
  config.vm.define "hallltest" do |hallltest|
    hallltest.vm.hostname = "hallltest"
    hallltest.vm.network "forwarded_port", guest: 8888, host: 8888
    hallltest.vm.network "forwarded_port", guest: 9999, host: 9999
    hallltest.vm.network "forwarded_port", guest: 80, host: 8081
    hallltest.vm.network "forwarded_port", guest: 8080, host: 8082
    hallltest.vm.network "forwarded_port", guest: 888, host: 8083
    hallltest.vm.network "forwarded_port", guest: 1325, host: 8084
    hallltest.vm.network "forwarded_port", guest: 8088, host: 8088
    hallltest.vm.cloud_init do |cloud_init|
      cloud_init.content_type = "text/cloud-config"
      cloud_init.inline = <<-EOF
        package_update: true
        package_upgrade: true
      EOF
    end

    hallltest.vm.synced_folder "2",  "/vagrant",
      type: "rsync",
      rsync__args: ["--verbose", "--archive", "--delete"],
      rsync__exclude: ["nginx", "haproxy"],
      create: true

    hallltest.vm.synced_folder "./2/nginx",  "/etc/nginx/conf.d/",
      type: "rsync",
      rsync__args: ["--verbose", "--archive", "--delete", "--rsync-path='sudo rsync'"],
      rsync__exclude: ["upstream.inc"],
      create: true

    hallltest.vm.synced_folder "./2/nginx",  "/etc/nginx/include/",
      type: "rsync",
      rsync__args: ["--verbose", "--archive", "--delete", "--rsync-path='sudo rsync'"],
      rsync__exclude: ["example-http.conf"],
      create: true

    hallltest.vm.synced_folder "service",  "/usr/lib/systemd/system/",
      type: "rsync",
      rsync__args: ["--verbose", "--archive", "--rsync-path='sudo rsync'"],
      create: true

    hallltest.vm.provision "shell", inline: <<-SHELL
      export DEBIAN_FRONTEND=noninteractive
      sudo systemctl enable --now cloud-init
      sudo cloud-init init
      sudo cloud-init clean
      sudo apt update -y
      sudo apt install -y \
      openssh-server \
      curl \
      ca-certificates \
      nginx \
      libnginx-mod-stream \
      haproxy \
      nano \
      apt-transport-https \
      gnupg
      
      sudo bash -c "cat >> /etc/nginx/nginx.conf <<'EOF'
stream {
    include /etc/nginx/include/upstream.inc;
    server {
        listen 8080;
        error_log /var/log/nginx/example-tcp-error.log;
        proxy_pass example_app;
    }
}
EOF"
    
      sudo bash -c "cat >> /etc/haproxy/haproxy.cfg <<'EOF'

listen stats  # веб-страница со статистикой
        bind                    :888
        mode                    http
        stats                   enable
        stats uri               /stats
        stats refresh           5s
        stats realm             Haproxy\ Statistics

frontend example  # секция фронтенд
        mode http
        bind :8088
        default_backend web_servers

backend web_servers    # секция бэкенд
        mode http
        balance roundrobin
        option httpchk
        http-check send meth GET uri /index.html
        server s1 127.0.0.1:8888 check
        server s2 127.0.0.1:9999 check

listen web_tcp

        bind :1325
        mode tcp
        balance roundrobin
        server s1 127.0.0.1:8888 check inter 3s
        server s2 127.0.0.1:9999 check inter 3s
EOF"
      sudo sed -i "3s| weight=3||" /etc/nginx/include/upstream.inc

      sudo systemctl enable --now python-http1.service
      sudo systemctl enable --now python-http2.service
      sudo systemctl enable --now nginx.service
      sudo systemctl reload nginx.service
      sudo systemctl enable haproxy.service
      sudo systemctl restart haproxy.service
    SHELL
  end
end
EOF

cat >service/python-http1.service<<'EOF'
[Unit]
Description=HTTP1
After=network.target
Wants=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 -m http.server --directory /vagrant/http1/ 8888 --bind 0.0.0.0
WorkingDirectory=/vagrant/http1/
Restart=always
RestartSec=5
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF

cat >service/python-http2.service<<'EOF'
[Unit]
Description=HTTP2
After=network.target
Wants=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 -m http.server --directory /vagrant/http2/ 9999 --bind 0.0.0.0
WorkingDirectory=/vagrant/http2/
Restart=always
RestartSec=5
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF

vagrant up

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_2, 9_6-HA' \
&& git push --set-upstream study_fops39 9_6-HA

```

### commit_3, 9_6-HA
```bash
vagrant destroy

mkdir 2/http3 \
&& echo 'Server 3 Port 7777' > \
2/http3/index.html

cat >service/python-http3.service<<'EOF'
[Unit]
Description=HTTP3
After=network.target
Wants=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 -m http.server --directory /vagrant/http3/ 7777 --bind 0.0.0.0
WorkingDirectory=/vagrant/http3/
Restart=always
RestartSec=5
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF

sed -i '/host: 9999/a\    hallltest.vm.network "forwarded_port", guest: 7777, host: 7777' \
Vagrantfile

sed -i -e '/default_backend web_servers/ {
    s//# default_backend web_servers/
    a\
\        acl ACL_example.local hdr(host) -i example.local\
\        use_backend web_servers if ACL_example.local
}' Vagrantfile

sed -i '117s/88 check/88 check weight 2/' \
Vagrantfile

sed -i '118s/99 check/99 check weight 3/' \
Vagrantfile

sed -i '118a\        server s3 127.0.0.1:7777 check weight 4' \
Vagrantfile

sed -i 's/88 check inter 3s/88 check inter 3s weight 2/' \
Vagrantfile

sed -i 's/99 check inter 3s/99 check inter 3s weight 3/' \
Vagrantfile

sed -i '/9999 check inter 3s/a\        server s3 127.0.0.1:7777 check inter 3s weight 4' \
Vagrantfile

sed -i "s/ght=3||/ght=3| weight=2|/" \
Vagrantfile

sed -i '130a\      sudo sed -i "s|99;|99 weight=3;|" /etc/nginx/include/upstream.inc' \
Vagrantfile

sed -i '131a\      sudo sed -i "4a\\\\        server 127.0.0.1:7777 weight=4;" /etc/nginx/include/upstream.inc' \
Vagrantfile

sed -i '132a\      sudo sed -i "s/p.com;/p.local;/" /etc/nginx/conf.d/example-http.conf' \
Vagrantfile

sed -i '/--now python-http2.service/a\      sudo systemctl enable --now python-http3.service' \
Vagrantfile

vagrant up

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_3, 9_6-HA' \
&& git push --set-upstream study_fops39 9_6-HA

```
