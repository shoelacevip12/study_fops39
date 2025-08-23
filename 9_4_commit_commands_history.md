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

sed -i "8s|.*|      - $(cat ~/.ssh/id_09-4_ed25519.pub)|" cloud-init.yml

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

cp ansible.cfg ansible/

sed -i "2s|./h|../h|" ansible/ansible.cfg

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
"ansible/roles/prometheus/templates/prometheus.service.j2"

sed -i 's/Description=Prometheus Node Exporter/Description=Node Exporter Netology Lesson 9.4 — [Скворцов Д.В.]/g' \
"ansible/roles/node_exporter/templates/node_exporter.service.j2"

cat>./ansible/prometheus_server.yaml<<'EOF'
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

ANSIBLE_ALLOW_BROKEN_CONDITIONALS=true ansible-playbook ansible/prometheus_server.yaml

&& yc compute instance list

git branch -v \
&& git remote -v

git status

git add . .. \
&& git status

git commit -am 'commit_2, 9_4-prometheus' \
&& git push --set-upstream study_fops39 9_4-prometheus
```

### commit_3, 9_4-prometheus
```bash

cd ..

terraform destroy

ansible-galaxy collection install grafana.grafana

git clone https://github.com/grafana/grafana-ansible-collection.git

mv grafana-ansible-collection ansible_gr

rm -rf ansible_gr/.git

cp ansible.cfg  ansible_gr/

sed -i "2s|./h|../h|" ansible_gr/ansible.cfg

cat >ansible_gr/Grafana_server.yaml<<'EOF'
---
- hosts: prom-core[0]
  become: yes
  vars:
    grafana_ini:
      security:
        admin_user: admin
        admin_password: test@skv
    grafana_datasources:
      - name: "Prometheus"
        type: "prometheus"
        url: 'http://localhost:9090'
    grafana_deb_url: "https://drive.usercontent.google.com/download?id=1qyOyfimxPCxaLlpFG9qUa-yI333UmDur&export=download&authuser=0&confirm=t&uuid=cf3de615-55ca-4548-8d74-2b0d677da23a&at=AN8xHopbt9iylbD94PD-GhQSIIxV%3A1755950320616"
    grafana_deb_file: "grafana_12.1.1_16903967602_linux_amd64.deb"

  pre_tasks:
    - name: Download Grafana DEB package
      get_url:
        url: "{{ grafana_deb_url }}"
        dest: "/tmp/{{ grafana_deb_file }}"
        mode: '0644'
        timeout: 300
        headers:
          Content-Disposition: "attachment"

    - name: Install Grafana from DEB package
      apt:
        deb: "/tmp/{{ grafana_deb_file }}"
        state: present
  roles:
    - grafana
EOF

terraform validate \
&& terraform fmt  \
&& terraform init --upgrade \
&& terraform plan -out=tfplan

terraform apply "tfplan"

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

ANSIBLE_ALLOW_BROKEN_CONDITIONALS=true ansible-playbook ansible/prometheus_server.yaml

ssh -i ~/.ssh/id_09-4_ed25519 -A \
skv@$(awk 'NR==5' hosts.ini | cut -d' ' -f1) \
sudo bash -c "echo -e \n && hostnamectl | grep hostname: \
&& systemctl status \
prometheus \
| grep -e Netology -e Active"

ssh -i ~/.ssh/id_09-4_ed25519 -A \
skv@$(awk 'NR==5' hosts.ini | cut -d' ' -f1) \
sudo bash -c "echo -e \n && hostnamectl | grep hostname: \
&& systemctl status \
node_exporter \
| grep -e Netology -e Active"

ssh -J skv@$(awk 'NR==5' hosts.ini | cut -d' ' -f1) \
-i ~/.ssh/id_09-4_ed25519 skv@$(awk 'NR==9' hosts.ini | cut -d' ' -f1) \
sudo bash -c "echo -e \n && hostnamectl | grep hostname: \
&& systemctl status node_exporter.service \
| grep -e Netology -e Active"

ANSIBLE_ALLOW_BROKEN_CONDITIONALS=true ansible-playbook ansible_gr/Grafana_server.yaml

ssh -i ~/.ssh/id_09-4_ed25519 -A \
skv@$(awk 'NR==5' hosts.ini | cut -d' ' -f1) \
sudo bash -c "echo -e \n && hostnamectl | grep hostname: \
&& systemctl status \
{prometheus,node_exporter,grafana-server} \
| grep -e Netology -e Active"

git branch -v \
&& git remote -v

git status

git add . .. \
&& git status

git commit -am 'commit_3, 9_4-prometheus' \
&& git push --set-upstream study_fops39 9_4-prometheus

```

### commit_10, master
```bash
terraform destroy

git branch -v

git log --oneline

git status

git diff && git diff --staged

git add . .. \
&& git commit --amend --no-edit \
&& git push --set-upstream study_fops39 9_4-prometheus --force

git checkout master

git branch -v

git merge 9_4-prometheus

git add . .. \
&& git status

git commit -am 'commit_10, master & 9_4-prometheus' && git push study_fops39 master
```