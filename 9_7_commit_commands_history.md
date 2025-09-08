# Для домашнего задания 9.7
### commit_15, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sflt-homeworks.git

rm -rf sflt-homeworks/{.git,1,1.md,2,2.md,4.md,README.md}

mv sflt-homeworks 9_7

cd 9_7

mv {3,README}.md

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_15, master' \
&& git push --set-upstream study_fops39 master

```

### commit_1, 9_7-Rsync
```bash
git log --oneline

git checkout -b 9_7-Rsync

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 9_7-Rsync' \
&& git push --set-upstream study_fops39 9_7-Rsync
```

### commit_2, 9_7-Rsync
```bash

rsync --archive \
--verbose \
--delete \
--checksum \
--exclude='/.*' \
--exclude='*.qcow2' \
--exclude='*.iso' \
-P \
~/ /tmp/backup/

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_2, 9_7-Rsync' \
&& git push --set-upstream study_fops39 9_7-Rsync

```

### commit_3, 9_7-Rsync
```bash

cat > backup_home.sh <<'EOF'
#!/bin/bash

Sou_dir="$HOME/"
D_dir="/tmp/backup/"

# Cоздание директории назначения
mkdir -p "$D_dir"

# Выполнение резервного копирования
logger -t "home_backup" "Запуск резервного копирования из $Sou_dir в $D_dir"

rsync --archive \
      --verbose \
      --delete \
      --checksum \
      --exclude='/.*' \
      --exclude='*.qcow2' \
      --exclude='*.iso' \
      -P \
      "$Sou_dir" "$D_dir" > /tmp/backup_output.tmp 2>&1

# Сохраняем код завершения rsync
RS_EX_code=$?

# Логирование результата
if [ $RS_EX_code -eq 0 ]; then
    # Если rsync завершился успешно
    logger -t "home_backup" "Резервное копирование успешно завершено."
else
    # Если rsync завершился с ошибкой
    logger -t "home_backup" "Ошибка резервного копирования. Код ошибки: $RS_EX_code. Подробности в /tmp/backup_output.tmp"
fi

exit $RS_EX_code
EOF

chmod +x ~/gited/9_7/backup_home.sh

sudo pacman -Syu cronie

EDITOR=nano crontab -e

0 1 * * * ~/gited/9_7/backup_home.sh

crontab -l

./backup_home.sh 

journalctl -fe | grep копир

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_3, 9_7-Rsync' \
&& git push --set-upstream study_fops39 9_7-Rsync
```

### commit_4, 9_7-Rsync
```bash
ssh-keygen -t ed25519 -C "rsync-test" -f /home/shoel/.ssh/id_ed25519

cat ~/.ssh/rsync_id_ed25519.pub

cat > Vagrantfile <<'EOF'
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
    hallltest.vm.cloud_init do |cloud_init|
      cloud_init.content_type = "text/cloud-config"
      cloud_init.inline = <<-EOF
        package_update: true
        package_upgrade: true
      EOF
    end

    hallltest.vm.provision "shell", inline: <<-SHELL
      export DEBIAN_FRONTEND=noninteractive
      sudo systemctl enable --now cloud-init
      sudo systemctl restart cloud-init
      sudo cloud-init init
      sudo cloud-init status --wait
      sudo cloud-init clean
    SHELL
  end
end
EOF

vagrant validate \
&& vagrant up

vagrant ssh -- -t 'echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK8bseyY1R1vCXjrqNUASbCR8ZWoG+Tx06SJ/UsaKAsO rsync-test' >> .ssh/authorized_keys'

vagrant ssh -- -t 'cat .ssh/authorized_keys'

rm ~/.ssh/known_hosts \
; eval $(ssh-agent) \
&& ssh-add  ~/.ssh/rsync_id_ed25519

ip neigh | head -1 | cut -d' ' -f1

sed -i 's|/tmp/backup/|agrant@192.168.121.31:/tmp/backup/|'

sed -i '/iso/a\      --bwlimit=123 \\' backup_home.sh

sed -i '/iso/a\      -e "ssh -i ~/.ssh/rsync_id_ed25519" \\' backup_home.sh

./backup_home.sh

vagrant ssh -- -t 'ls -hR /tmp/backup'

vagrant ssh -- -t 'du -h /tmp/backup'

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_4, 9_7-Rsync' \
&& git push --set-upstream study_fops39 9_7-Rsync
```

### commit_16, master
```bash
vagrant destroy

git branch -v

git log --oneline

git status

git diff && git diff --staged

git add . .. \
&& git commit --amend --no-edit \
&& git push --set-upstream study_fops39 9_7-Rsync --force

git checkout master

git branch -v

git merge 9_7-Rsync

git add . .. \
&& git status

git commit -am 'commit_14, master & 9_7-Rsync' && git push study_fops39 master
```