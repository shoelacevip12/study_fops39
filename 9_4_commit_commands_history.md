# Для домашнего задания 9.4
### commit_9, master
```bash
git checkout master

git branch -v

cp -r 9_{3,4}

git clone https://github.com/netology-code/smon-homeworks.git

mv -p smon-homeworks/hw-04.md 9_4/README.md

rm -rf smon-homeworks \
9_4/img/* 

cd 9_4

ssh-keygen -f ~/.ssh/id_09-4_ed25519 -t ed25519 -C "9-04"

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

sed -i "8s|.*|      - $(cat ~/.ssh/id_09-3_ed25519.pub)|" cloud-init.yml

rm -rf ANS* \
templates \
tfplan

ansible-galaxy collection install prometheus.prometheus

git clone https://github.com/prometheus-community/ansible.git

rm -rf ansible/.git

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_9, master' \
&& git push --set-upstream study_fops39 master

```

### commit_1, 9_4-prometheus
```bash
cd 9_4

git log --oneline

git checkout -b 9_4-prometheus

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 9_4-prometheus' \
&& git push --set-upstream study_fops39 9_4-prometheus
```

### commit_2, 9_4-prometheus
```bash

cd 9_4

terraform validate \
&& terraform fmt  \
&& terraform init --upgrade \
&& terraform plan -out=tfplan

terraform apply "tfplan"

mv ansible.cfg ansible/

cd ansible

rm ~/.ssh/known_hosts \
; eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_09-4_ed25519 \
&& for d in {120..1}; do \
echo -n "Лучше подождать чем получить ошибку =): $d сек." \
; sleep 1 \
; echo -ne "\r"; done \
&& ssh -o StrictHostKeyChecking=no -i \
~/.ssh/id_09-4_ed25519 -A skv@$(awk 'NR==5' hosts.ini | cut -d' ' -f1) hostnamectl \
&& yc compute instance list

sed -i 's/Description=Prometheus/Description=Prometheus Service Netology Lesson 9.4 — [Скворцов Д.В.]/g' \
"roles/prometheus/templates/prometheus.service.j2"

sed -i 's/Description=Prometheus Node Exporter/Description=Node Exporter Netology Lesson 9.4 — [Скворцов Д.В.]/g' \
"roles/node_exporter/templates/node_exporter.service.j2"

cat>prometheus_server.yaml<<'EOF'
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
EOF

ANSIBLE_ALLOW_BROKEN_CONDITIONALS=true ansible-playbook prometheus_server.yaml

&& yc compute instance list

git branch -v \
&& git remote -v

git status

git add . .. \
&& git status

git commit -am 'commit_2, 9_4-prometheus' \
&& git push --set-upstream study_fops39 9_4-prometheus
```