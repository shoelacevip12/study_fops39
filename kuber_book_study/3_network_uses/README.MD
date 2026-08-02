# Работа с сетью в Kubernetes

## Использование CNI Antrea

### Команда: клонирование репозитория Antrea

```bash
git clone https://github.com/antrea-io/antrea.git

find . -name ".git" -exec rm -vrf {} \;
```

<details>
<summary>
Вывод клонирования репозитория Antrea
</summary>

```log
Клонирование в «antrea»...
remote: Enumerating objects: 75331, done.
remote: Counting objects: 100% (476/476), done.
remote: Compressing objects: 100% (353/353), done.
remote: Total 75331 (delta 270), reused 124 (delta 123), pack-reused 74855 (from 4)
Получение объектов: 100% (75331/75331), 44.50 MiB | 10.48 MiB/s, готово.
Определение изменений: 100% (53739/53739), готово.
Updating files: 100% (2102/2102), готово.

удалён './antrea/.git/description'
удалён './antrea/.git/hooks/post-update.sample'
удалён './antrea/.git/hooks/pre-rebase.sample'
удалён './antrea/.git/hooks/pre-commit.sample'
удалён './antrea/.git/hooks/pre-receive.sample'
удалён './antrea/.git/hooks/commit-msg.sample'
удалён './antrea/.git/hooks/pre-push.sample'
удалён './antrea/.git/hooks/applypatch-msg.sample'
удалён './antrea/.git/hooks/pre-applypatch.sample'
удалён './antrea/.git/hooks/update.sample'
удалён './antrea/.git/hooks/fsmonitor-watchman.sample'
удалён './antrea/.git/hooks/push-to-checkout.sample'
удалён './antrea/.git/hooks/pre-merge-commit.sample'
удалён './antrea/.git/hooks/sendemail-validate.sample'
удалён './antrea/.git/hooks/prepare-commit-msg.sample'
удалён каталог './antrea/.git/hooks'
удалён './antrea/.git/info/exclude'
удалён каталог './antrea/.git/info'
удалён './antrea/.git/objects/pack/pack-c2c2310dc783ae5312fb56be48cbaf1485be40ef.pack'
удалён './antrea/.git/objects/pack/pack-c2c2310dc783ae5312fb56be48cbaf1485be40ef.rev'
удалён './antrea/.git/objects/pack/pack-c2c2310dc783ae5312fb56be48cbaf1485be40ef.idx'
удалён каталог './antrea/.git/objects/pack'
удалён каталог './antrea/.git/objects/info'
удалён каталог './antrea/.git/objects'
удалён './antrea/.git/refs/heads/main'
удалён каталог './antrea/.git/refs/heads'
удалён каталог './antrea/.git/refs/tags'
удалён './antrea/.git/refs/remotes/origin/HEAD'
удалён каталог './antrea/.git/refs/remotes/origin'
удалён каталог './antrea/.git/refs/remotes'
удалён каталог './antrea/.git/refs'
удалён './antrea/.git/packed-refs'
удалён './antrea/.git/logs/refs/remotes/origin/HEAD'
удалён каталог './antrea/.git/logs/refs/remotes/origin'
удалён каталог './antrea/.git/logs/refs/remotes'
удалён './antrea/.git/logs/refs/heads/main'
удалён каталог './antrea/.git/logs/refs/heads'
удалён каталог './antrea/.git/logs/refs'
удалён './antrea/.git/logs/HEAD'
удалён каталог './antrea/.git/logs'
удалён './antrea/.git/HEAD'
удалён './antrea/.git/config'
удалён './antrea/.git/index'
удалён каталог './antrea/.git'
find: «./antrea/.git»: Нет такого файла или каталога
```

</details>

### Команда: развертывание кластера с CNI Antrea

```bash
cd ./antrea/ci/kind

./kind-setup.sh create antrea

kubectl apply -f ../../build/yamls/antrea.yml

cd -
```

<details>
<summary>
Вывод развертывания на CNI Antrea
</summary>

```log
[shoel@shoellin kind]$ ./kind-setup.sh create antrea
Creating docker network antrea with args: -d bridge -o com.docker.network.bridge.enable_ip_masquerade=true -o com.docker.network.driver.mtu=1500 -o com.docker.network.bridge.gateway_mode_ipv4=nat-unprotected
fbdbb6f31989ccd725e6e45d6c276644b3d1a455af7f3350e20b9668141a15e4
Creating cluster "antrea" ...
 ✓ Ensuring node image (kindest/node:v1.36.1) 🖼
 ✓ Preparing nodes 📦 📦 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing StorageClass 💾 
 ✓ Joining worker nodes 🚜 
Set kubectl context to "kind-antrea"
You can now use your cluster with:

kubectl cluster-info --context kind-antrea

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
deployment.apps/coredns patched
Configuring networks
removing worker nodes antrea-worker2 antrea-worker from networks antrea antrea
template parsing error: template: :1:35: executing "" at <"antrea">: nil data; no entry for key "IPAddress"
template parsing error: template: :1:35: executing "" at <"antrea">: nil data; no entry for key "GlobalIPv6Address"
connected worker antrea-worker2 to network antrea
RTNETLINK answers: File exists

[shoel@shoellin kind]$ kubectl apply -f ../../antrea/build/yamls/antrea.yml
customresourcedefinition.apiextensions.k8s.io/antreaagentinfos.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/antreacontrollerinfos.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/antreanodeconfigs.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/bgppolicies.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/clustergroups.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/clusternetworkpolicies.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/egresses.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/externalentities.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/externalippools.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/externalnodes.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/flowexporterdestinations.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/groups.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/nodelatencymonitors.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/packetcaptures.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/supportbundlecollections.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/tiers.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/traceflows.crd.antrea.io created
customresourcedefinition.apiextensions.k8s.io/trafficcontrols.crd.antrea.io created
serviceaccount/antrea-agent created
serviceaccount/antctl created
serviceaccount/antrea-controller created
secret/antrea-agent-service-account-token created
secret/antctl-service-account-token created
configmap/antrea-config created
clusterrole.rbac.authorization.k8s.io/antrea-agent created
clusterrole.rbac.authorization.k8s.io/antctl created
clusterrole.rbac.authorization.k8s.io/antrea-cluster-identity-reader created
clusterrole.rbac.authorization.k8s.io/antrea-controller created
clusterrole.rbac.authorization.k8s.io/aggregate-antrea-policies-edit created
clusterrole.rbac.authorization.k8s.io/aggregate-antrea-policies-view created
clusterrole.rbac.authorization.k8s.io/aggregate-traceflows-edit created
clusterrole.rbac.authorization.k8s.io/aggregate-traceflows-view created
clusterrole.rbac.authorization.k8s.io/aggregate-antrea-clustergroups-edit created
clusterrole.rbac.authorization.k8s.io/aggregate-antrea-clustergroups-view created
clusterrolebinding.rbac.authorization.k8s.io/antrea-agent created
clusterrolebinding.rbac.authorization.k8s.io/antctl created
clusterrolebinding.rbac.authorization.k8s.io/antrea-controller created
service/antrea created
daemonset.apps/antrea-agent created
deployment.apps/antrea-controller created
apiservice.apiregistration.k8s.io/v1beta2.controlplane.antrea.io created
apiservice.apiregistration.k8s.io/v1beta1.system.antrea.io created
apiservice.apiregistration.k8s.io/v1alpha1.stats.antrea.io created
mutatingwebhookconfiguration.admissionregistration.k8s.io/crdmutator.antrea.io created
validatingwebhookconfiguration.admissionregistration.k8s.io/crdvalidator.antrea.io created

[shoel@shoellin kind]$ cd -
/home/shoel/nfs_git/gited/kuber_book_study/3_network_uses
```

</details>

### Команда: получение списка всех подов кластера

```bash
kubectl get pods -A -o wide
```

<details>
<summary>
Получение списка всех модулей Pod в кластере
</summary>

```log
NAMESPACE            NAME                                           READY   STATUS    RESTARTS   AGE    IP           NODE                   NOMINATED NODE   READINESS GATES
kube-system          antrea-agent-fv7nb                             2/2     Running   0          105s   172.18.0.2   antrea-worker2         <none>           <none>
kube-system          antrea-agent-j2594                             2/2     Running   0          105s   172.18.0.3   antrea-control-plane   <none>           <none>
kube-system          antrea-agent-m7w9b                             2/2     Running   0          105s   172.18.0.4   antrea-worker          <none>           <none>
kube-system          antrea-controller-775fcbdf8f-kv5tm             1/1     Running   0          105s   172.18.0.2   antrea-worker2         <none>           <none>
kube-system          coredns-8495bdd5c6-d2gvl                       1/1     Running   0          119s   10.244.0.3   antrea-control-plane   <none>           <none>
kube-system          coredns-8495bdd5c6-g6zkb                       1/1     Running   0          119s   10.244.0.2   antrea-control-plane   <none>           <none>
kube-system          etcd-antrea-control-plane                      1/1     Running   0          2m9s   172.18.0.3   antrea-control-plane   <none>           <none>
kube-system          kube-apiserver-antrea-control-plane            1/1     Running   0          2m8s   172.18.0.3   antrea-control-plane   <none>           <none>
kube-system          kube-controller-manager-antrea-control-plane   1/1     Running   0          2m8s   172.18.0.3   antrea-control-plane   <none>           <none>
kube-system          kube-proxy-cj8v8                               1/1     Running   0          119s   172.18.0.2   antrea-worker2         <none>           <none>
kube-system          kube-proxy-pbbbk                               1/1     Running   0          2m2s   172.18.0.3   antrea-control-plane   <none>           <none>
kube-system          kube-proxy-zk42c                               1/1     Running   0          119s   172.18.0.4   antrea-worker          <none>           <none>
kube-system          kube-scheduler-antrea-control-plane            1/1     Running   0          2m9s   172.18.0.3   antrea-control-plane   <none>           <none>
local-path-storage   local-path-provisioner-855c7b7774-9crt9        1/1     Running   0          2m2s   10.244.2.3   antrea-worker2         <none>           <none>
```

</details>

### Команда: загрузка и установка sonobuoy

```bash
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.5/sonobuoy_0.57.5_linux_amd64.tar.gz

tar -xfv sonobuoy_0.57.5_linux_amd64.tar.gz

chmod -v +x sonobuoy

sudo mv -v sonobuoy /usr/local/bin

sonobuoy version

rm -vrf sonobuoy_0.57.5_linux_amd64.tar.gz LICENSE
```

<details>
<summary>
Вывод команд
</summary>

```log
sonobuoy_0.57.5_linux_amd64.tar.gz                  100%[=================================================================================================================>]  24,25M  11,0MB/s    за 2,2s    

2026-08-01 17:46:48 (11,0 MB/s) - ‘sonobuoy_0.57.5_linux_amd64.tar.gz’ сохранён [25428672/25428672]

LICENSE
sonobuoy

права доступа 'sonobuoy' оставлены в виде 0777 (rwxrwxrwx)

[sudo] пароль для shoel: 
copied 'sonobuoy' -> '/usr/local/bin/sonobuoy'
удалён 'sonobuoy'

Sonobuoy Version: v0.57.5
MinimumKubeVersion: 1.17.0
MaximumKubeVersion: 1.99.99
GitSHA: 310c51d9874a4d10d021ec8a19f8b42292ec0bfc
GoVersion: go1.26.4
Platform: linux/amd64
API Version check skipped due to missing `--kubeconfig` or other error

удалён 'sonobuoy_0.57.5_linux_amd64.tar.gz'
удалён 'LICENSE'
```

</details>

### Команда: запуск quick conformance тестов

```bash
sonobuoy run --mode quick
```

### Команда: проверка подов в namespace sonobuoy

```bash
kubectl get pods -n sonobuoy -o wide
```

<details>
<summary>
Вывод команды спика подов в namespace sonobuoy
</summary>

```log
NAME                                                      READY   STATUS              RESTARTS   AGE   IP           NODE                   NOMINATED NODE   READINESS GATES
sonobuoy                                                  1/1     Running             0          35s   10.244.1.2   antrea-worker          <none>           <none>
sonobuoy-e2e-job-6c28295b24014d43                         0/2     ContainerCreating   0          28s   <none>       antrea-worker          <none>           <none>
sonobuoy-systemd-logs-daemon-set-2d909ee39aca430b-qdps9   0/2     ContainerCreating   0          28s   172.18.0.4   antrea-worker          <none>           <none>
sonobuoy-systemd-logs-daemon-set-2d909ee39aca430b-skbzl   0/2     ContainerCreating   0          28s   172.18.0.3   antrea-control-plane   <none>           <none>
sonobuoy-systemd-logs-daemon-set-2d909ee39aca430b-x8bwd   0/2     ContainerCreating   0          28s   172.18.0.2   antrea-worker2         <none>           <none>
```

```log
NAME                                                      READY   STATUS        RESTARTS   AGE    IP           NODE                   NOMINATED NODE   READINESS GATES
sonobuoy                                                  1/1     Running       0          2m1s   10.244.1.2   antrea-worker          <none>           <none>
sonobuoy-systemd-logs-daemon-set-2d909ee39aca430b-qdps9   2/2     Terminating   0          114s   172.18.0.4   antrea-worker          <none>           <none>
sonobuoy-systemd-logs-daemon-set-2d909ee39aca430b-skbzl   2/2     Terminating   0          114s   172.18.0.3   antrea-control-plane   <none>           <none>
sonobuoy-systemd-logs-daemon-set-2d909ee39aca430b-x8bwd   2/2     Terminating   0          114s   172.18.0.2   antrea-worker2         <none>           <none>
```

```log
NAME       READY   STATUS    RESTARTS   AGE     IP           NODE            NOMINATED NODE   READINESS GATES
sonobuoy   1/1     Running   0          2m18s   10.244.1.2   antrea-worker   <none>           <none>
```

</details>

```bash
export results="$(sonobuoy retrieve)"

sonobuoy results $results
```

<details>
<summary>
Вывод результатов
</summary>

```log
sonobuoy results $results
Plugin: e2e
Status: passed
Total: 7586
Passed: 8
Failed: 0
Skipped: 7578

Plugin: systemd-logs
Status: passed
Total: 3
Passed: 3
Failed: 0
Skipped: 0

Run Details:
API Server version: v1.36.1
Node health: 3/3 (100%)
Pods health: 19/19 (100%)
Errors detected in files:
Errors:
152 podlogs/kube-system/kube-apiserver-antrea-control-plane/logs/kube-apiserver.txt
 22 podlogs/kube-system/antrea-agent-m7w9b/logs/antrea-agent.txt
 22 podlogs/kube-system/antrea-agent-fv7nb/logs/antrea-agent.txt
 21 podlogs/kube-system/kube-scheduler-antrea-control-plane/logs/kube-scheduler.txt
 21 podlogs/kube-system/antrea-agent-j2594/logs/antrea-agent.txt
 14 podlogs/kube-system/kube-controller-manager-antrea-control-plane/logs/kube-controller-manager.txt
  4 podlogs/kube-system/antrea-controller-775fcbdf8f-kv5tm/logs/antrea-controller.txt
  1 podlogs/kube-system/kube-proxy-cj8v8/logs/kube-proxy.txt
  1 podlogs/kube-system/kube-proxy-zk42c/logs/kube-proxy.txt
  1 podlogs/kube-system/kube-proxy-pbbbk/logs/kube-proxy.txt
  1 podlogs/sonobuoy/sonobuoy-e2e-job-6c28295b24014d43/logs/e2e.txt
Warnings:
149 podlogs/kube-system/kube-apiserver-antrea-control-plane/logs/kube-apiserver.txt
 85 podlogs/kube-system/etcd-antrea-control-plane/logs/etcd.txt
 11 podlogs/kube-system/kube-controller-manager-antrea-control-plane/logs/kube-controller-manager.txt
  7 podlogs/sonobuoy/sonobuoy/logs/kube-sonobuoy.txt
  3 podlogs/kube-system/kube-scheduler-antrea-control-plane/logs/kube-scheduler.txt
  2 podlogs/kube-system/antrea-agent-j2594/logs/antrea-agent.txt
  2 podlogs/kube-system/antrea-agent-m7w9b/logs/antrea-agent.txt
  2 podlogs/kube-system/antrea-agent-fv7nb/logs/antrea-agent.txt
  1 podlogs/sonobuoy/sonobuoy-e2e-job-6c28295b24014d43/logs/e2e.txt
```

</details>

### Команда: вход в контейнер antrea-worker2

```bash
docker exec -it antrea-worker2 bash
```

### Команда: установка net-tools в контейнере antrea-worker2

```bash
apt-get update \
; apt-get install -y net-tools
```

### Команда: просмотр сетевого окружения на antrea-worker2

```bash
ip -br a

ip route

arp

arp -na
```

<details>
<summary>
Просмотр сетевого окружения на одно из nod Antrea
</summary>

```log
lo               UNKNOWN        127.0.0.1/8 ::1/128 
tunl0@NONE       DOWN           
eth0@if88        UP             172.18.0.2/16 fc00:f853:ccd:e793::2/64 fe80::14cf:a8ff:fee5:53f0/64 
eth1@if91        DOWN           172.21.0.2/16 
ovs-system       DOWN           
genev_sys_6081   UNKNOWN        fe80::78ff:79ff:fe7c:cb18/64 
antrea-gw0       UNKNOWN        10.244.2.1/24 fe80::42:efff:fe6e:a64d/64 
antrea-egress0   DOWN           
local-pa-b7d8e5@if3 UP             fe80::849c:7ff:fef4:a80d/64

default via 172.18.0.1 dev eth0 
10.244.0.0/24 via 10.244.0.1 dev antrea-gw0 onlink 
10.244.1.0/24 via 10.244.1.1 dev antrea-gw0 onlink 
10.244.2.0/24 dev antrea-gw0 scope link src 10.244.2.1 
172.18.0.0/16 dev eth0 proto kernel scope link src 172.18.0.2

Address                  HWtype  HWaddress           Flags Mask            Iface
10.244.1.1               ether   aa:bb:cc:dd:ee:ff   C                     antrea-gw0
10.244.2.3               ether   32:26:66:f8:d3:59   C                     antrea-gw0
antrea-worker.kind       ether   ee:c0:52:3f:06:6b   C                     eth0
10.244.2.2               ether   0e:ec:44:17:0d:4f   C                     antrea-gw0
shoellin                 ether   f6:10:7c:88:65:c3   C                     eth0
antrea-control-plane.ki  ether   fe:dc:a0:5c:c0:f7   C                     eth0

? (10.244.1.1) at aa:bb:cc:dd:ee:ff [ether] on antrea-gw0
? (10.244.2.3) at 32:26:66:f8:d3:59 [ether] on antrea-gw0
? (172.18.0.4) at ee:c0:52:3f:06:6b [ether] on eth0
? (10.244.2.2) at 0e:ec:44:17:0d:4f [ether] on antrea-gw0
? (172.18.0.1) at f6:10:7c:88:65:c3 [ether] on eth0
? (172.18.0.3) at fe:dc:a0:5c:c0:f7 [ether] on eth0
```

</details>

### Команда: масштабирование CoreDNS и проверка подов

```bash
root@antrea-worker2:/# exit

kubectl get pods -n kube-system -o wide \
; kubectl get pods -n kube-system \
| wc -l

kubectl scale deployment coredns \
-n kube-system \
--replicas=10

kubectl get pods -n kube-system -o wide \
; kubectl get pods -n kube-system \
| wc -l

docker exec -it antrea-control-plane bash
```

<details>
<summary>
Вывод проверки подов и масштабирования CoreDNS
</summary>

```log
NAME                                           READY   STATUS    RESTARTS   AGE   IP           NODE                   NOMINATED NODE   READINESS GATES
antrea-agent-fv7nb                             2/2     Running   0          20m   172.18.0.2   antrea-worker2         <none>           <none>
antrea-agent-j2594                             2/2     Running   0          20m   172.18.0.3   antrea-control-plane   <none>           <none>
antrea-agent-m7w9b                             2/2     Running   0          20m   172.18.0.4   antrea-worker          <none>           <none>
antrea-controller-775fcbdf8f-kv5tm             1/1     Running   0          20m   172.18.0.2   antrea-worker2         <none>           <none>
coredns-8495bdd5c6-d2gvl                       1/1     Running   0          20m   10.244.0.3   antrea-control-plane   <none>           <none>
coredns-8495bdd5c6-g6zkb                       1/1     Running   0          20m   10.244.0.2   antrea-control-plane   <none>           <none>
etcd-antrea-control-plane                      1/1     Running   0          20m   172.18.0.3   antrea-control-plane   <none>           <none>
kube-apiserver-antrea-control-plane            1/1     Running   0          20m   172.18.0.3   antrea-control-plane   <none>           <none>
kube-controller-manager-antrea-control-plane   1/1     Running   0          20m   172.18.0.3   antrea-control-plane   <none>           <none>
kube-proxy-cj8v8                               1/1     Running   0          20m   172.18.0.2   antrea-worker2         <none>           <none>
kube-proxy-pbbbk                               1/1     Running   0          20m   172.18.0.3   antrea-control-plane   <none>           <none>
kube-proxy-zk42c                               1/1     Running   0          20m   172.18.0.4   antrea-worker          <none>           <none>
kube-scheduler-antrea-control-plane            1/1     Running   0          20m   172.18.0.3   antrea-control-plane   <none>           <none>
```

```log
14
```

```log
deployment.apps/coredns scaled
```

```log
NAME                                           READY   STATUS    RESTARTS   AGE   IP            NODE                   NOMINATED NODE   READINESS GATES
antrea-agent-fv7nb                             2/2     Running   0          21m   172.18.0.2    antrea-worker2         <none>           <none>
antrea-agent-j2594                             2/2     Running   0          21m   172.18.0.3    antrea-control-plane   <none>           <none>
antrea-agent-m7w9b                             2/2     Running   0          21m   172.18.0.4    antrea-worker          <none>           <none>
antrea-controller-775fcbdf8f-kv5tm             1/1     Running   0          21m   172.18.0.2    antrea-worker2         <none>           <none>
coredns-8495bdd5c6-5jnrj                       1/1     Running   0          23s   10.244.0.10   antrea-control-plane   <none>           <none>
coredns-8495bdd5c6-8h2rd                       1/1     Running   0          23s   10.244.0.7    antrea-control-plane   <none>           <none>
coredns-8495bdd5c6-bw9kd                       1/1     Running   0          23s   10.244.0.4    antrea-control-plane   <none>           <none>
coredns-8495bdd5c6-d2gvl                       1/1     Running   0          21m   10.244.0.3    antrea-control-plane   <none>           <none>
coredns-8495bdd5c6-g6zkb                       1/1     Running   0          21m   10.244.0.2    antrea-control-plane   <none>           <none>
coredns-8495bdd5c6-htggh                       1/1     Running   0          23s   10.244.0.6    antrea-control-plane   <none>           <none>
coredns-8495bdd5c6-sksdh                       1/1     Running   0          23s   10.244.0.11   antrea-control-plane   <none>           <none>
coredns-8495bdd5c6-wxg4z                       1/1     Running   0          23s   10.244.0.5    antrea-control-plane   <none>           <none>
coredns-8495bdd5c6-xq6hk                       1/1     Running   0          23s   10.244.0.8    antrea-control-plane   <none>           <none>
coredns-8495bdd5c6-zrbdm                       1/1     Running   0          23s   10.244.0.9    antrea-control-plane   <none>           <none>
etcd-antrea-control-plane                      1/1     Running   0          21m   172.18.0.3    antrea-control-plane   <none>           <none>
kube-apiserver-antrea-control-plane            1/1     Running   0          21m   172.18.0.3    antrea-control-plane   <none>           <none>
kube-controller-manager-antrea-control-plane   1/1     Running   0          21m   172.18.0.3    antrea-control-plane   <none>           <none>
kube-proxy-cj8v8                               1/1     Running   0          21m   172.18.0.2    antrea-worker2         <none>           <none>
kube-proxy-pbbbk                               1/1     Running   0          21m   172.18.0.3    antrea-control-plane   <none>           <none>
kube-proxy-zk42c                               1/1     Running   0          21m   172.18.0.4    antrea-worker          <none>           <none>
kube-scheduler-antrea-control-plane            1/1     Running   0          21m   172.18.0.3    antrea-control-plane   <none>           <none>
```

```log
22
```

</details>

### Команда: установка net-tools в контейнере control-plane

```bash
apt-get update \
; apt-get install -y net-tools
```

```bash
ip -br a

ip route

arp

arp -na
```

<details>
<summary>
Просмотр сетевого окружения на одно из nodы control-plane с CNI Antrea
</summary>

```log
lo               UNKNOWN        127.0.0.1/8 ::1/128 
tunl0@NONE       DOWN           
eth0@if89        UP             172.18.0.3/16 fc00:f853:ccd:e793::3/64 fe80::fcdc:a0ff:fe5c:c0f7/64 
ovs-system       DOWN           
genev_sys_6081   UNKNOWN        fe80::fce5:c6ff:fe3c:4a4c/64 
antrea-gw0       UNKNOWN        10.244.0.1/24 fe80::60b4:1bff:feee:a8e5/64 
antrea-egress0   DOWN           
coredns--90ea33@if3 UP             fe80::6041:46ff:fed8:3bcd/64 
coredns--3e4ff4@if3 UP             fe80::cced:49ff:fe9b:f15d/64 
coredns--a5ecd0@if3 UP             fe80::dc04:f2ff:fee6:fb50/64 
coredns--8455fe@if3 UP             fe80::2852:e6ff:febc:8273/64 
coredns--98f03c@if3 UP             fe80::240f:ceff:fe7e:7401/64 
coredns--c2cf2e@if3 UP             fe80::c8a1:fbff:feac:650a/64 
coredns--06ffe8@if3 UP             fe80::44ea:b4ff:feca:4674/64 
coredns--94dfbf@if3 UP             fe80::90c7:3aff:fe7d:bc12/64 
coredns--f8ef8b@if3 UP             fe80::a873:f4ff:fe40:d0a0/64 
coredns--91f0fb@if3 UP             fe80::3094:1fff:fe64:e93d/64

default via 172.18.0.1 dev eth0 
10.244.0.0/24 dev antrea-gw0 scope link src 10.244.0.1 
10.244.1.0/24 via 10.244.1.1 dev antrea-gw0 onlink 
10.244.2.0/24 via 10.244.2.1 dev antrea-gw0 onlink 
172.18.0.0/16 dev eth0 proto kernel scope link src 172.18.0.3

Address                  HWtype  HWaddress           Flags Mask            Iface
10.244.0.8               ether   52:6f:95:3f:05:94   C                     antrea-gw0
10.244.0.10              ether   e2:58:bb:26:0a:3d   C                     antrea-gw0
10.244.0.5               ether   46:61:f2:7a:db:18   C                     antrea-gw0
10.244.0.7               ether   32:c4:8f:9b:c7:6a   C                     antrea-gw0
shoellin                 ether   f6:10:7c:88:65:c3   C                     eth0
10.244.0.3               ether   02:09:af:02:8a:a1   C                     antrea-gw0
10.244.0.9               ether   66:5b:ee:60:53:00   C                     antrea-gw0
10.244.1.1               ether   aa:bb:cc:dd:ee:ff   C                     antrea-gw0
10.244.0.11              ether   3a:df:da:e1:23:e0   C                     antrea-gw0
antrea-worker.kind       ether   ee:c0:52:3f:06:6b   C                     eth0
10.244.0.4               ether   ca:9f:fa:52:d6:3c   C                     antrea-gw0
10.244.0.6               ether   8e:88:ca:03:6b:5b   C                     antrea-gw0
antrea-worker2.kind      ether   16:cf:a8:e5:53:f0   C                     eth0
10.244.0.2               ether   f2:6d:c1:d3:d3:76   C                     antrea-gw0

? (10.244.0.8) at 52:6f:95:3f:05:94 [ether] on antrea-gw0
? (10.244.0.10) at e2:58:bb:26:0a:3d [ether] on antrea-gw0
? (10.244.0.5) at 46:61:f2:7a:db:18 [ether] on antrea-gw0
? (10.244.0.7) at 32:c4:8f:9b:c7:6a [ether] on antrea-gw0
? (172.18.0.1) at f6:10:7c:88:65:c3 [ether] on eth0
? (10.244.0.3) at 02:09:af:02:8a:a1 [ether] on antrea-gw0
? (10.244.0.9) at 66:5b:ee:60:53:00 [ether] on antrea-gw0
? (10.244.1.1) at aa:bb:cc:dd:ee:ff [ether] on antrea-gw0
? (10.244.0.11) at 3a:df:da:e1:23:e0 [ether] on antrea-gw0
? (172.18.0.4) at ee:c0:52:3f:06:6b [ether] on eth0
? (10.244.0.4) at ca:9f:fa:52:d6:3c [ether] on antrea-gw0
? (10.244.0.6) at 8e:88:ca:03:6b:5b [ether] on antrea-gw0
? (172.18.0.2) at 16:cf:a8:e5:53:f0 [ether] on eth0
? (10.244.0.2) at f2:6d:c1:d3:d3:76 [ether] on antrea-gw0
```

</details>

### Команда: просмотр статистики сетевых интерфейсов

```bash
ip -s a
```

<details>
<summary>
Вывод статистики для всех сетевых интерфейсов
</summary>

```log
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host proto kernel_lo 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
     110340030  435234      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
     110340030  435234      0       0       0       0 
2: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
    RX:  bytes packets errors dropped  missed   mcast           
             0       0      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
             0       0      0       0       0       0 
3: eth0@if89: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether fe:dc:a0:5c:c0:f7 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.18.0.3/16 brd 172.18.255.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fc00:f853:ccd:e793::3/64 scope global nodad 
       valid_lft forever preferred_lft forever
    inet6 fe80::fcdc:a0ff:fe5c:c0f7/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
     331352904  237548      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
      27633524  142645      0       0       0       0 
4: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether c6:bb:f3:40:38:f6 brd ff:ff:ff:ff:ff:ff
    RX:  bytes packets errors dropped  missed   mcast           
             0       0      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
             0       0      0       0       0       0 
5: genev_sys_6081: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 65000 qdisc noqueue master ovs-system state UNKNOWN group default qlen 1000
    link/ether fe:e5:c6:3c:4a:4c brd ff:ff:ff:ff:ff:ff
    inet6 fe80::fce5:c6ff:fe3c:4a4c/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
          3961      25      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
        870405      38      0      14       0       0 
6: antrea-gw0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 62:b4:1b:ee:a8:e5 brd ff:ff:ff:ff:ff:ff
    inet 10.244.0.1/24 brd 10.244.0.255 scope global antrea-gw0
       valid_lft forever preferred_lft forever
    inet6 fe80::60b4:1bff:feee:a8e5/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
        714272    8302      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
       2189600    9368      0       0       0       0 
7: antrea-egress0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default 
    link/ether f2:7c:fe:c4:be:f0 brd ff:ff:ff:ff:ff:ff
    RX:  bytes packets errors dropped  missed   mcast           
             0       0      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
             0       0      0       0       0       0 
8: coredns--90ea33@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master ovs-system state UP group default 
    link/ether 62:41:46:d8:3b:cd brd ff:ff:ff:ff:ff:ff link-netns cni-00c7899e-257c-99b9-6194-6e1390529fb4
    inet6 fe80::6041:46ff:fed8:3bcd/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
        182279    1893      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
        262395    2197      0       0       0       0 
9: coredns--3e4ff4@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master ovs-system state UP group default 
    link/ether ce:ed:49:9b:f1:5d brd ff:ff:ff:ff:ff:ff link-netns cni-9f6d5013-8bee-260c-a0a4-e84618a1ad18
    inet6 fe80::cced:49ff:fe9b:f15d/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
        183516    1910      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
        263835    2205      0       0       0       0 
10: coredns--a5ecd0@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master ovs-system state UP group default 
    link/ether de:04:f2:e6:fb:50 brd ff:ff:ff:ff:ff:ff link-netns cni-70e52773-c3c5-29d0-1539-a33530b2ae04
    inet6 fe80::dc04:f2ff:fee6:fb50/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
         58878     577      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
        109263     662      0       0       0       0 
11: coredns--8455fe@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master ovs-system state UP group default 
    link/ether 2a:52:e6:bc:82:73 brd ff:ff:ff:ff:ff:ff link-netns cni-3854b2f7-aea1-3462-cbd1-d5498cd79475
    inet6 fe80::2852:e6ff:febc:8273/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
         60019     590      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
        106604     661      0       0       0       0 
12: coredns--98f03c@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master ovs-system state UP group default 
    link/ether 26:0f:ce:7e:74:01 brd ff:ff:ff:ff:ff:ff link-netns cni-abf1f509-0b8f-a026-6495-580fe7660f1f
    inet6 fe80::240f:ceff:fe7e:7401/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
         58799     576      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
        105748     653      0       0       0       0 
13: coredns--c2cf2e@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master ovs-system state UP group default 
    link/ether ca:a1:fb:ac:65:0a brd ff:ff:ff:ff:ff:ff link-netns cni-fdd2f546-f280-d391-96ee-1928714ceea7
    inet6 fe80::c8a1:fbff:feac:650a/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
         59614     584      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
        103363     657      0       0       0       0 
14: coredns--06ffe8@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master ovs-system state UP group default 
    link/ether 46:ea:b4:ca:46:74 brd ff:ff:ff:ff:ff:ff link-netns cni-27f2a823-4e56-18cf-b2ff-9be10bcddda6
    inet6 fe80::44ea:b4ff:feca:4674/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
         58968     577      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
        102571     647      0       0       0       0 
15: coredns--94dfbf@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master ovs-system state UP group default 
    link/ether 92:c7:3a:7d:bc:12 brd ff:ff:ff:ff:ff:ff link-netns cni-981b8d5b-326d-de64-0c5e-ba612aca804b
    inet6 fe80::90c7:3aff:fe7d:bc12/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
         57623     562      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
         92641     644      0       0       0       0 
16: coredns--f8ef8b@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master ovs-system state UP group default 
    link/ether aa:73:f4:40:d0:a0 brd ff:ff:ff:ff:ff:ff link-netns cni-993bd1a7-310f-7aca-88a9-b4125d3d80c5
    inet6 fe80::a873:f4ff:fe40:d0a0/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
         58273     568      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
         93214     645      0       0       0       0 
17: coredns--91f0fb@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master ovs-system state UP group default 
    link/ether 32:94:1f:64:e9:3d brd ff:ff:ff:ff:ff:ff link-netns cni-80a67889-bebe-f0b0-af03-f9e46b3a83bf
    inet6 fe80::3094:1fff:fe64:e93d/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
         57958     565      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
         92643     638      0       0       0       0
```

</details>

### Команда: просмотр таблицы маршрутизации

```bash
route -n
```

<details>
<summary>
Вывод маршрутов со стороны ноды contol-plane с CNI antrea
</summary>

```log
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         172.18.0.1      0.0.0.0         UG    0      0        0 eth0
10.244.0.0      0.0.0.0         255.255.255.0   U     0      0        0 antrea-gw0
10.244.1.0      10.244.1.1      255.255.255.0   UG    0      0        0 antrea-gw0
10.244.2.0      10.244.2.1      255.255.255.0   UG    0      0        0 antrea-gw0
172.18.0.0      0.0.0.0         255.255.0.0     U     0      0        0 eth0
```

</details>

### Команда: получение имени пода antrea-agent

```bash
kubectl get pods -n kube-system \
| grep agent \
| tail -1
```

```log
antrea-agent-m7w9b                             2/2     Running   0          46m
```

```bash
kubectl exec antrea-agent-m7w9b -n kube-system -- ovs-vsctl list interface
```

<details>
<summary>
Вывод информации об интерфейсах IPVS(OVS) antrea
</summary>

```log
_uuid               : 68437fa1-474e-4a31-8955-9c8ab440aea6
admin_state         : up
bfd                 : {}
bfd_status          : {}
cfm_fault           : []
cfm_fault_status    : []
cfm_flap_count      : []
cfm_health          : []
cfm_mpid            : []
cfm_remote_mpids    : []
cfm_remote_opstate  : []
duplex              : []
error               : []
external_ids        : {}
ifindex             : 6
ingress_policing_burst: 0
ingress_policing_kpkts_burst: 0
ingress_policing_kpkts_rate: 0
ingress_policing_rate: 0
lacp_current        : []
link_resets         : 1
link_speed          : []
link_state          : up
lldp                : {}
mac                 : "02:60:ef:e6:1d:57"
mac_in_use          : "02:60:ef:e6:1d:57"
mtu                 : 1450
mtu_request         : 1450
name                : antrea-gw0
ofport              : 32769
ofport_request      : 32769
options             : {}
other_config        : {}
statistics          : {collisions=0, rx_bytes=183114, rx_crc_err=0, rx_dropped=0, rx_errors=0, rx_frame_err=0, rx_missed_errors=0, rx_multicast_packets=0, rx_over_err=0, rx_packets=1588, tx_bytes=2999124, tx_dropped=0, tx_errors=0, tx_packets=1495, upcall_errors=0, upcall_packets=29}
status              : {driver_name=openvswitch}
type                : internal

_uuid               : d328191e-e286-4b3a-ba2f-aa887b426cd4
admin_state         : up
bfd                 : {}
bfd_status          : {}
cfm_fault           : []
cfm_fault_status    : []
cfm_flap_count      : []
cfm_health          : []
cfm_mpid            : []
cfm_remote_mpids    : []
cfm_remote_opstate  : []
duplex              : []
error               : []
external_ids        : {}
ifindex             : 5
ingress_policing_burst: 0
ingress_policing_kpkts_burst: 0
ingress_policing_kpkts_rate: 0
ingress_policing_rate: 0
lacp_current        : []
link_resets         : 0
link_speed          : []
link_state          : up
lldp                : {}
mac                 : []
mac_in_use          : "ae:f2:60:5e:34:44"
mtu                 : []
mtu_request         : []
name                : antrea-tun0
ofport              : 32768
ofport_request      : 32768
options             : {key=flow, remote_ip=flow}
other_config        : {}
statistics          : {rx_bytes=1482139, rx_packets=72, tx_bytes=8479, tx_packets=48}
status              : {tunnel_egress_iface=eth0, tunnel_egress_iface_carrier=up}
type                : geneve

_uuid               : c6e9a0f2-3866-451c-94e1-a951268fe18a
admin_state         : up
bfd                 : {}
bfd_status          : {}
cfm_fault           : []
cfm_fault_status    : []
cfm_flap_count      : []
cfm_health          : []
cfm_mpid            : []
cfm_remote_mpids    : []
cfm_remote_opstate  : []
duplex              : full
error               : []
external_ids        : {}
ifindex             : 8
ingress_policing_burst: 0
ingress_policing_kpkts_burst: 0
ingress_policing_kpkts_rate: 0
ingress_policing_rate: 0
lacp_current        : []
link_resets         : 0
link_speed          : 10000000000
link_state          : up
lldp                : {}
mac                 : []
mac_in_use          : "66:15:82:a1:f3:fd"
mtu                 : 1450
mtu_request         : []
name                : sonobuoy-19e293
ofport              : 1
ofport_request      : []
options             : {}
other_config        : {}
statistics          : {collisions=0, rx_bytes=200454, rx_crc_err=0, rx_dropped=0, rx_errors=0, rx_frame_err=0, rx_missed_errors=0, rx_multicast_packets=0, rx_over_err=0, rx_packets=1539, tx_bytes=4339151, tx_dropped=0, tx_errors=0, tx_packets=1470, upcall_errors=0, upcall_packets=55}
status              : {driver_name=veth, driver_version="1.0", firmware_version=""}
type                : ""
```

</details>

### Команда: вход в контейнер control-plane

```bash
docker exec -it antrea-control-plane bash
```

### Команда: установка tcpdump в контейнере control-plane

```bash
apt-get update \
; apt-get install -y tcpdump
```

```bash
ip -br a | grep core | tail -1
```

```log
coredns--91f0fb@if3 UP             fe80::3094:1fff:fe64:e93d/64 
```

### Команда: захват трафика tcpdump

```bash
tcpdump -i coredns--91f0fb -n
```

<details>
<summary>
Вывод tcpdump с control-plane Ноды
</summary>

```log
listening on coredns--91f0fb, link-type EN10MB (Ethernet), snapshot length 262144 bytes
18:07:34.737829 IP 10.244.0.1.49786 > 10.244.0.11.8080: Flags [S], seq 1364560534, win 64860, options [mss 1410,sackOK,TS val 2866724996 ecr 0,nop,wscale 10], length 0
18:07:34.737863 IP 10.244.0.11.8080 > 10.244.0.1.49786: Flags [S.], seq 265679686, ack 1364560535, win 64308, options [mss 1410,sackOK,TS val 4003716828 ecr 2866724996,nop,wscale 10], length 0
18:07:34.737910 IP 10.244.0.1.49786 > 10.244.0.11.8080: Flags [.], ack 1, win 64, options [nop,nop,TS val 2866724996 ecr 4003716828], length 0
18:07:34.738096 IP 10.244.0.1.49786 > 10.244.0.11.8080: Flags [P.], seq 1:110, ack 1, win 64, options [nop,nop,TS val 2866724996 ecr 4003716828], length 109: HTTP: GET /health HTTP/1.1
18:07:34.738120 IP 10.244.0.11.8080 > 10.244.0.1.49786: Flags [.], ack 110, win 63, options [nop,nop,TS val 4003716829 ecr 2866724996], length 0
18:07:34.738211 IP 10.244.0.11.8080 > 10.244.0.1.49786: Flags [P.], seq 1:138, ack 110, win 63, options [nop,nop,TS val 4003716829 ecr 2866724996], length 137: HTTP: HTTP/1.1 200 OK
18:07:34.738272 IP 10.244.0.1.49786 > 10.244.0.11.8080: Flags [.], ack 138, win 64, options [nop,nop,TS val 2866724997 ecr 4003716829], length 0
18:07:34.738348 IP 10.244.0.11.8080 > 10.244.0.1.49786: Flags [F.], seq 138, ack 110, win 63, options [nop,nop,TS val 4003716829 ecr 2866724997], length 0
18:07:34.738352 IP 10.244.0.1.49786 > 10.244.0.11.8080: Flags [F.], seq 110, ack 138, win 64, options [nop,nop,TS val 2866724997 ecr 4003716829], length 0
18:07:34.738403 IP 10.244.0.1.49786 > 10.244.0.11.8080: Flags [.], ack 139, win 64, options [nop,nop,TS val 2866724997 ecr 4003716829], length 0
18:07:34.738424 IP 10.244.0.11.8080 > 10.244.0.1.49786: Flags [.], ack 111, win 63, options [nop,nop,TS val 4003716829 ecr 2866724997], length 0
18:07:35.917146 IP 10.96.0.1.443 > 10.244.0.11.48196: Flags [P.], seq 355278999:355279117, ack 450367614, win 77, options [nop,nop,TS val 3264900505 ecr 2514862782], length 118
18:07:35.917191 IP 10.244.0.11.48196 > 10.96.0.1.443: Flags [.], ack 118, win 94, options [nop,nop,TS val 2514864874 ecr 3264900505], length 0
18:07:36.492855 IP 10.244.0.1.50462 > 10.244.0.11.8181: Flags [S], seq 3929064436, win 64860, options [mss 1410,sackOK,TS val 2961515256 ecr 0,nop,wscale 10], length 0
18:07:36.492893 IP 10.244.0.11.8181 > 10.244.0.1.50462: Flags [S.], seq 194830172, ack 3929064437, win 64308, options [mss 1410,sackOK,TS val 2562167197 ecr 2961515256,nop,wscale 10], length 0
18:07:36.492949 IP 10.244.0.1.50462 > 10.244.0.11.8181: Flags [.], ack 1, win 64, options [nop,nop,TS val 2961515256 ecr 2562167197], length 0
18:07:36.493228 IP 10.244.0.1.50462 > 10.244.0.11.8181: Flags [P.], seq 1:109, ack 1, win 64, options [nop,nop,TS val 2961515257 ecr 2562167197], length 108
18:07:36.493272 IP 10.244.0.11.8181 > 10.244.0.1.50462: Flags [.], ack 109, win 63, options [nop,nop,TS val 2562167198 ecr 2961515257], length 0
18:07:36.493448 IP 10.244.0.11.8181 > 10.244.0.1.50462: Flags [P.], seq 1:138, ack 109, win 63, options [nop,nop,TS val 2562167198 ecr 2961515257], length 137
18:07:36.493504 IP 10.244.0.1.50462 > 10.244.0.11.8181: Flags [.], ack 138, win 64, options [nop,nop,TS val 2961515257 ecr 2562167198], length 0
18:07:36.493578 IP 10.244.0.11.8181 > 10.244.0.1.50462: Flags [F.], seq 138, ack 109, win 63, options [nop,nop,TS val 2562167198 ecr 2961515257], length 0
18:07:36.493606 IP 10.244.0.1.50462 > 10.244.0.11.8181: Flags [F.], seq 109, ack 138, win 64, options [nop,nop,TS val 2961515257 ecr 2562167198], length 0
18:07:36.493626 IP 10.244.0.11.8181 > 10.244.0.1.50462: Flags [.], ack 110, win 63, options [nop,nop,TS val 2562167198 ecr 2961515257], length 0
18:07:36.493671 IP 10.244.0.1.50462 > 10.244.0.11.8181: Flags [.], ack 139, win 64, options [nop,nop,TS val 2961515257 ecr 2562167198], length 0
^C
24 packets captured
24 packets received by filter
0 packets dropped by kernel
```

</details>

### Команда: захват трафика tcpdump с фильтром по хосту

```bash
tcpdump host 10.244.0.11 -i coredns--91f0fb
```

<details>
<summary>
Вывод tcpdump с control-plane Ноды
</summary>

```log
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on coredns--91f0fb, link-type EN10MB (Ethernet), snapshot length 262144 bytes
18:10:24.737431 IP 10.244.0.1.45538 > 10.244.0.11.http-alt: Flags [S], seq 4235295302, win 64860, options [mss 1410,sackOK,TS val 3646397330 ecr 0,nop,wscale 10], length 0
18:10:24.737473 IP 10.244.0.11.http-alt > 10.244.0.1.45538: Flags [S.], seq 3735419364, ack 4235295303, win 64308, options [mss 1410,sackOK,TS val 459308740 ecr 3646397330,nop,wscale 10], length 0
18:10:24.737524 IP 10.244.0.1.45538 > 10.244.0.11.http-alt: Flags [.], ack 1, win 64, options [nop,nop,TS val 3646397330 ecr 459308740], length 0
18:10:24.737709 IP 10.244.0.1.45538 > 10.244.0.11.http-alt: Flags [P.], seq 1:110, ack 1, win 64, options [nop,nop,TS val 3646397330 ecr 459308740], length 109: HTTP: GET /health HTTP/1.1
18:10:24.737733 IP 10.244.0.11.http-alt > 10.244.0.1.45538: Flags [.], ack 110, win 63, options [nop,nop,TS val 459308740 ecr 3646397330], length 0
18:10:24.737823 IP 10.244.0.11.http-alt > 10.244.0.1.45538: Flags [P.], seq 1:138, ack 110, win 63, options [nop,nop,TS val 459308740 ecr 3646397330], length 137: HTTP: HTTP/1.1 200 OK
18:10:24.737892 IP 10.244.0.1.45538 > 10.244.0.11.http-alt: Flags [.], ack 138, win 64, options [nop,nop,TS val 3646397330 ecr 459308740], length 0
18:10:24.737964 IP 10.244.0.11.http-alt > 10.244.0.1.45538: Flags [F.], seq 138, ack 110, win 63, options [nop,nop,TS val 459308740 ecr 3646397330], length 0
18:10:24.737998 IP 10.244.0.1.45538 > 10.244.0.11.http-alt: Flags [F.], seq 110, ack 138, win 64, options [nop,nop,TS val 3646397330 ecr 459308740], length 0
18:10:24.738018 IP 10.244.0.11.http-alt > 10.244.0.1.45538: Flags [.], ack 111, win 63, options [nop,nop,TS val 459308740 ecr 3646397330], length 0
18:10:24.738096 IP 10.244.0.1.45538 > 10.244.0.11.http-alt: Flags [.], ack 139, win 64, options [nop,nop,TS val 3646397330 ecr 459308740], length 0
18:10:26.492642 IP 10.244.0.1.40912 > 10.244.0.11.8181: Flags [S], seq 995959551, win 64860, options [mss 1410,sackOK,TS val 3429707030 ecr 0,nop,wscale 10], length 0
18:10:26.492675 IP 10.244.0.11.8181 > 10.244.0.1.40912: Flags [S.], seq 2777625988, ack 995959552, win 64308, options [mss 1410,sackOK,TS val 2921767007 ecr 3429707030,nop,wscale 10], length 0
18:10:26.492723 IP 10.244.0.1.40912 > 10.244.0.11.8181: Flags [.], ack 1, win 64, options [nop,nop,TS val 3429707030 ecr 2921767007], length 0
18:10:26.492871 IP 10.244.0.1.40912 > 10.244.0.11.8181: Flags [P.], seq 1:109, ack 1, win 64, options [nop,nop,TS val 3429707030 ecr 2921767007], length 108
18:10:26.492887 IP 10.244.0.11.8181 > 10.244.0.1.40912: Flags [.], ack 109, win 63, options [nop,nop,TS val 2921767007 ecr 3429707030], length 0
18:10:26.493113 IP 10.244.0.11.8181 > 10.244.0.1.40912: Flags [P.], seq 1:138, ack 109, win 63, options [nop,nop,TS val 2921767008 ecr 3429707030], length 137
18:10:26.493178 IP 10.244.0.1.40912 > 10.244.0.11.8181: Flags [.], ack 138, win 64, options [nop,nop,TS val 3429707031 ecr 2921767008], length 0
18:10:26.493270 IP 10.244.0.11.8181 > 10.244.0.1.40912: Flags [F.], seq 138, ack 109, win 63, options [nop,nop,TS val 2921767008 ecr 3429707031], length 0
18:10:26.493270 IP 10.244.0.1.40912 > 10.244.0.11.8181: Flags [F.], seq 109, ack 138, win 64, options [nop,nop,TS val 3429707031 ecr 2921767008], length 0
18:10:26.493325 IP 10.244.0.1.40912 > 10.244.0.11.8181: Flags [.], ack 139, win 64, options [nop,nop,TS val 3429707031 ecr 2921767008], length 0
18:10:26.493346 IP 10.244.0.11.8181 > 10.244.0.1.40912: Flags [.], ack 110, win 63, options [nop,nop,TS val 2921767008 ecr 3429707031], length 0
^C
22 packets captured
22 packets received by filter
0 packets dropped by kernel
```

</details>

### Команда: просмотр правил iptables

```bash
iptables-save
```

<details>
<summary>
Вывод правил iptables с CNI Antrea
</summary>

```log
# Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:12:47 2026
*mangle
:PREROUTING ACCEPT [946566:350891893]
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [889984:175137449]
:POSTROUTING ACCEPT [0:0]
:ANTREA-OUTPUT - [0:0]
:ANTREA-PREROUTING - [0:0]
:KUBE-IPTABLES-HINT - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-PROXY-CANARY - [0:0]
-A PREROUTING -m comment --comment "Antrea: jump to Antrea prerouting rules" -j ANTREA-PREROUTING
-A OUTPUT -m comment --comment "Antrea: jump to Antrea output rules" -j ANTREA-OUTPUT
-A ANTREA-OUTPUT -o antrea-gw0 -m comment --comment "Antrea: mark LOCAL output packets" -m addrtype --src-type LOCAL -j MARK --set-xmark 0x80000000/0x80000000
COMMIT
# Completed on Sat Aug  1 18:12:47 2026
# Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:12:47 2026
*raw
:PREROUTING ACCEPT [946566:350891893]
:OUTPUT ACCEPT [890001:175143091]
:ANTREA-OUTPUT - [0:0]
:ANTREA-PREROUTING - [0:0]
-A PREROUTING -m comment --comment "Antrea: jump to Antrea prerouting rules" -j ANTREA-PREROUTING
-A OUTPUT -m comment --comment "Antrea: jump to Antrea output rules" -j ANTREA-OUTPUT
-A ANTREA-OUTPUT -p udp -m comment --comment "Antrea: do not track outgoing encapsulation packets" -m udp --dport 6081 -m addrtype --src-type LOCAL -j NOTRACK
-A ANTREA-PREROUTING -p udp -m comment --comment "Antrea: do not track incoming encapsulation packets" -m udp --dport 6081 -m addrtype --dst-type LOCAL -j NOTRACK
COMMIT
# Completed on Sat Aug  1 18:12:47 2026
# Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:12:47 2026
*filter
:INPUT ACCEPT [1087662:522298697]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [990672:203077782]
:ANTREA-FORWARD - [0:0]
:KUBE-EXTERNAL-SERVICES - [0:0]
:KUBE-FIREWALL - [0:0]
:KUBE-FORWARD - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-NODEPORTS - [0:0]
:KUBE-PROXY-CANARY - [0:0]
:KUBE-PROXY-FIREWALL - [0:0]
:KUBE-SERVICES - [0:0]
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A INPUT -m comment --comment "kubernetes health check service ports" -j KUBE-NODEPORTS
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A INPUT -j KUBE-FIREWALL
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A FORWARD -m comment --comment "kubernetes forwarding rules" -j KUBE-FORWARD
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A FORWARD -m comment --comment "Antrea: jump to Antrea forwarding rules" -j ANTREA-FORWARD
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -j KUBE-FIREWALL
-A ANTREA-FORWARD -i antrea-gw0 -m comment --comment "Antrea: accept packets from local Pods" -j ACCEPT
-A ANTREA-FORWARD -o antrea-gw0 -m comment --comment "Antrea: accept packets to local Pods" -j ACCEPT
-A KUBE-FIREWALL ! -s 127.0.0.0/8 -d 127.0.0.0/8 -m comment --comment "block incoming localnet connections" -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT -j DROP
-A KUBE-FORWARD -m conntrack --ctstate INVALID -m nfacct --nfacct-name  ct_state_invalid_dropped_pkts -j DROP
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding conntrack rule" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
COMMIT
# Completed on Sat Aug  1 18:12:47 2026
# Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:12:47 2026
*nat
:PREROUTING ACCEPT [371:22692]
:INPUT ACCEPT [374:23013]
:OUTPUT ACCEPT [17943:1076580]
:POSTROUTING ACCEPT [17994:1081486]
:ANTREA-POSTROUTING - [0:0]
:DOCKER_OUTPUT - [0:0]
:DOCKER_POSTROUTING - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-MARK-MASQ - [0:0]
:KUBE-NODEPORTS - [0:0]
:KUBE-POSTROUTING - [0:0]
:KUBE-PROXY-CANARY - [0:0]
:KUBE-SEP-232DQYSHL5HNRYWJ - [0:0]
:KUBE-SEP-275NWNNANOEIGYHG - [0:0]
:KUBE-SEP-2Z3537XSN3RJRU3M - [0:0]
:KUBE-SEP-47Y74YAUKL3G2JYG - [0:0]
:KUBE-SEP-6E7XQMQ4RAYOWTTM - [0:0]
:KUBE-SEP-A4UL7OUXQPUR7Y7Q - [0:0]
:KUBE-SEP-A7YQ4MY4TZII3JTK - [0:0]
:KUBE-SEP-CEWR77HQLZDHWWAJ - [0:0]
:KUBE-SEP-CPH3WXMLRJ2BZFXW - [0:0]
:KUBE-SEP-FVQSBIWR5JTECIVC - [0:0]
:KUBE-SEP-HJ7EWOW62IX6GL6R - [0:0]
:KUBE-SEP-IRMT6RY5EEEBXDAY - [0:0]
:KUBE-SEP-IT2ZTR26TO4XFPTO - [0:0]
:KUBE-SEP-LASJGFFJP3UOS6RQ - [0:0]
:KUBE-SEP-LBMQNJ35ID4UIQ2A - [0:0]
:KUBE-SEP-LPGSDLJ3FDW46N4W - [0:0]
:KUBE-SEP-N4G2XR5TDX7PQE7P - [0:0]
:KUBE-SEP-OP4AXEAS4OXHBEQX - [0:0]
:KUBE-SEP-PUHFDAMRBZWCPADU - [0:0]
:KUBE-SEP-QKX4QX54UKWK6JIY - [0:0]
:KUBE-SEP-R7EMXN5TTQQVP4UW - [0:0]
:KUBE-SEP-RSRPD4CCUGBDDTH6 - [0:0]
:KUBE-SEP-S7MPVVC7MGYVFSF3 - [0:0]
:KUBE-SEP-SF3LG62VAE5ALYDV - [0:0]
:KUBE-SEP-SISP6ORRA37L3ZYK - [0:0]
:KUBE-SEP-VR6VIIG2A6524KLY - [0:0]
:KUBE-SEP-WXWGHGKZOCNYRYI7 - [0:0]
:KUBE-SEP-XNZERJBNXRGRQGMS - [0:0]
:KUBE-SEP-XRFUWCXKVCLGWYQC - [0:0]
:KUBE-SEP-YIL6JZP7A3QYXJU2 - [0:0]
:KUBE-SEP-ZJHOSXJEKQGYJUBC - [0:0]
:KUBE-SEP-ZP3FB6NMPNCO4VBJ - [0:0]
:KUBE-SEP-ZXMNUKOKXUTL2MK2 - [0:0]
:KUBE-SERVICES - [0:0]
:KUBE-SVC-EOJDDEN7FILLJEVG - [0:0]
:KUBE-SVC-ERIFXISQEP7F7OF4 - [0:0]
:KUBE-SVC-JD5MR3NA4I4DYORP - [0:0]
:KUBE-SVC-NPX46M4PTMTKRN6Y - [0:0]
:KUBE-SVC-QDWG4LJGNBTOT5ED - [0:0]
:KUBE-SVC-TCOU7JCQXEZGVUNU - [0:0]
-A PREROUTING -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A PREROUTING -d 172.18.0.1/32 -j DOCKER_OUTPUT
-A OUTPUT -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -d 172.18.0.1/32 -j DOCKER_OUTPUT
-A POSTROUTING -m comment --comment "kubernetes postrouting rules" -j KUBE-POSTROUTING
-A POSTROUTING -d 172.18.0.1/32 -j DOCKER_POSTROUTING
-A POSTROUTING -m comment --comment "Antrea: jump to Antrea postrouting rules" -j ANTREA-POSTROUTING
-A ANTREA-POSTROUTING -s 10.244.0.0/24 ! -o antrea-gw0 -m comment --comment "Antrea: masquerade Pod to external packets" -m set ! --match-set ANTREA-POD-IP dst -j MASQUERADE
-A ANTREA-POSTROUTING -o antrea-gw0 -m comment --comment "Antrea: masquerade LOCAL traffic" -m addrtype ! --src-type LOCAL --limit-iface-out -m addrtype --src-type LOCAL -j MASQUERADE --random-fully
-A DOCKER_OUTPUT -d 172.18.0.1/32 -p tcp -m tcp --dport 53 -j DNAT --to-destination 127.0.0.11:42351
-A DOCKER_OUTPUT -d 172.18.0.1/32 -p udp -m udp --dport 53 -j DNAT --to-destination 127.0.0.11:46614
-A DOCKER_POSTROUTING -s 127.0.0.11/32 -p tcp -m tcp --sport 42351 -j SNAT --to-source 172.18.0.1:53
-A DOCKER_POSTROUTING -s 127.0.0.11/32 -p udp -m udp --sport 46614 -j SNAT --to-source 172.18.0.1:53
-A KUBE-MARK-MASQ -j MARK --set-xmark 0x4000/0x4000
-A KUBE-POSTROUTING -m mark ! --mark 0x4000/0x4000 -j RETURN
-A KUBE-POSTROUTING -j MARK --set-xmark 0x4000/0x0
-A KUBE-POSTROUTING -m comment --comment "kubernetes service traffic requiring SNAT" -j MASQUERADE --random-fully
-A KUBE-SEP-232DQYSHL5HNRYWJ -s 10.244.0.7/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-232DQYSHL5HNRYWJ -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.244.0.7:53
-A KUBE-SEP-275NWNNANOEIGYHG -s 10.244.0.6/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-275NWNNANOEIGYHG -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.244.0.6:9153
-A KUBE-SEP-2Z3537XSN3RJRU3M -s 10.244.0.6/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-2Z3537XSN3RJRU3M -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.244.0.6:53
-A KUBE-SEP-47Y74YAUKL3G2JYG -s 172.18.0.2/32 -m comment --comment "kube-system/antrea" -j KUBE-MARK-MASQ
-A KUBE-SEP-47Y74YAUKL3G2JYG -p tcp -m comment --comment "kube-system/antrea" -m tcp -j DNAT --to-destination 172.18.0.2:10349
-A KUBE-SEP-6E7XQMQ4RAYOWTTM -s 10.244.0.3/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-6E7XQMQ4RAYOWTTM -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.244.0.3:53
-A KUBE-SEP-A4UL7OUXQPUR7Y7Q -s 10.244.0.7/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-A4UL7OUXQPUR7Y7Q -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.244.0.7:53
-A KUBE-SEP-A7YQ4MY4TZII3JTK -s 10.244.0.11/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-A7YQ4MY4TZII3JTK -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.244.0.11:53
-A KUBE-SEP-CEWR77HQLZDHWWAJ -s 10.244.0.9/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-CEWR77HQLZDHWWAJ -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.244.0.9:9153
-A KUBE-SEP-CPH3WXMLRJ2BZFXW -s 10.244.0.7/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-CPH3WXMLRJ2BZFXW -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.244.0.7:9153
-A KUBE-SEP-FVQSBIWR5JTECIVC -s 10.244.0.5/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-FVQSBIWR5JTECIVC -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.244.0.5:9153
-A KUBE-SEP-HJ7EWOW62IX6GL6R -s 10.244.0.10/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-HJ7EWOW62IX6GL6R -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.244.0.10:9153
-A KUBE-SEP-IRMT6RY5EEEBXDAY -s 10.244.0.6/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-IRMT6RY5EEEBXDAY -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.244.0.6:53
-A KUBE-SEP-IT2ZTR26TO4XFPTO -s 10.244.0.2/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-IT2ZTR26TO4XFPTO -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.244.0.2:53
-A KUBE-SEP-LASJGFFJP3UOS6RQ -s 10.244.0.5/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-LASJGFFJP3UOS6RQ -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.244.0.5:53
-A KUBE-SEP-LBMQNJ35ID4UIQ2A -s 10.244.0.9/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-LBMQNJ35ID4UIQ2A -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.244.0.9:53
-A KUBE-SEP-LPGSDLJ3FDW46N4W -s 10.244.0.5/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-LPGSDLJ3FDW46N4W -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.244.0.5:53
-A KUBE-SEP-N4G2XR5TDX7PQE7P -s 10.244.0.2/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-N4G2XR5TDX7PQE7P -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.244.0.2:9153
-A KUBE-SEP-OP4AXEAS4OXHBEQX -s 10.244.0.10/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-OP4AXEAS4OXHBEQX -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.244.0.10:53
-A KUBE-SEP-PUHFDAMRBZWCPADU -s 10.244.0.4/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-PUHFDAMRBZWCPADU -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.244.0.4:9153
-A KUBE-SEP-QKX4QX54UKWK6JIY -s 172.18.0.3/32 -m comment --comment "default/kubernetes:https" -j KUBE-MARK-MASQ
-A KUBE-SEP-QKX4QX54UKWK6JIY -p tcp -m comment --comment "default/kubernetes:https" -m tcp -j DNAT --to-destination 172.18.0.3:6443
-A KUBE-SEP-R7EMXN5TTQQVP4UW -s 10.244.0.10/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-R7EMXN5TTQQVP4UW -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.244.0.10:53
-A KUBE-SEP-RSRPD4CCUGBDDTH6 -s 10.244.1.2/32 -m comment --comment "sonobuoy/sonobuoy-aggregator" -j KUBE-MARK-MASQ
-A KUBE-SEP-RSRPD4CCUGBDDTH6 -p tcp -m comment --comment "sonobuoy/sonobuoy-aggregator" -m tcp -j DNAT --to-destination 10.244.1.2:8080
-A KUBE-SEP-S7MPVVC7MGYVFSF3 -s 10.244.0.9/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-S7MPVVC7MGYVFSF3 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.244.0.9:53
-A KUBE-SEP-SF3LG62VAE5ALYDV -s 10.244.0.4/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-SF3LG62VAE5ALYDV -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.244.0.4:53
-A KUBE-SEP-SISP6ORRA37L3ZYK -s 10.244.0.8/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-SISP6ORRA37L3ZYK -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.244.0.8:53
-A KUBE-SEP-VR6VIIG2A6524KLY -s 10.244.0.11/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-VR6VIIG2A6524KLY -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.244.0.11:53
-A KUBE-SEP-WXWGHGKZOCNYRYI7 -s 10.244.0.4/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-WXWGHGKZOCNYRYI7 -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.244.0.4:53
-A KUBE-SEP-XNZERJBNXRGRQGMS -s 10.244.0.8/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-XNZERJBNXRGRQGMS -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.244.0.8:9153
-A KUBE-SEP-XRFUWCXKVCLGWYQC -s 10.244.0.8/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-XRFUWCXKVCLGWYQC -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.244.0.8:53
-A KUBE-SEP-YIL6JZP7A3QYXJU2 -s 10.244.0.2/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-YIL6JZP7A3QYXJU2 -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.244.0.2:53
-A KUBE-SEP-ZJHOSXJEKQGYJUBC -s 10.244.0.11/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-ZJHOSXJEKQGYJUBC -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.244.0.11:9153
-A KUBE-SEP-ZP3FB6NMPNCO4VBJ -s 10.244.0.3/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-ZP3FB6NMPNCO4VBJ -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.244.0.3:9153
-A KUBE-SEP-ZXMNUKOKXUTL2MK2 -s 10.244.0.3/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-ZXMNUKOKXUTL2MK2 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.244.0.3:53
-A KUBE-SERVICES -d 10.96.225.231/32 -p tcp -m comment --comment "kube-system/antrea cluster IP" -m tcp --dport 443 -j KUBE-SVC-QDWG4LJGNBTOT5ED
-A KUBE-SERVICES -d 10.96.181.73/32 -p tcp -m comment --comment "sonobuoy/sonobuoy-aggregator cluster IP" -m tcp --dport 8080 -j KUBE-SVC-EOJDDEN7FILLJEVG
-A KUBE-SERVICES -d 10.96.0.1/32 -p tcp -m comment --comment "default/kubernetes:https cluster IP" -m tcp --dport 443 -j KUBE-SVC-NPX46M4PTMTKRN6Y
-A KUBE-SERVICES -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp cluster IP" -m tcp --dport 53 -j KUBE-SVC-ERIFXISQEP7F7OF4
-A KUBE-SERVICES -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:metrics cluster IP" -m tcp --dport 9153 -j KUBE-SVC-JD5MR3NA4I4DYORP
-A KUBE-SERVICES -d 10.96.0.10/32 -p udp -m comment --comment "kube-system/kube-dns:dns cluster IP" -m udp --dport 53 -j KUBE-SVC-TCOU7JCQXEZGVUNU
-A KUBE-SERVICES -m comment --comment "kubernetes service nodeports; NOTE: this must be the last rule in this chain" -m addrtype --dst-type LOCAL -j KUBE-NODEPORTS
-A KUBE-SVC-EOJDDEN7FILLJEVG ! -s 10.244.0.0/16 -d 10.96.181.73/32 -p tcp -m comment --comment "sonobuoy/sonobuoy-aggregator cluster IP" -m tcp --dport 8080 -j KUBE-MARK-MASQ
-A KUBE-SVC-EOJDDEN7FILLJEVG -m comment --comment "sonobuoy/sonobuoy-aggregator -> 10.244.1.2:8080" -j KUBE-SEP-RSRPD4CCUGBDDTH6
-A KUBE-SVC-ERIFXISQEP7F7OF4 ! -s 10.244.0.0/16 -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp cluster IP" -m tcp --dport 53 -j KUBE-MARK-MASQ
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.244.0.10:53" -m statistic --mode random --probability 0.10000000009 -j KUBE-SEP-OP4AXEAS4OXHBEQX
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.244.0.11:53" -m statistic --mode random --probability 0.11111111101 -j KUBE-SEP-A7YQ4MY4TZII3JTK
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.244.0.2:53" -m statistic --mode random --probability 0.12500000000 -j KUBE-SEP-IT2ZTR26TO4XFPTO
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.244.0.3:53" -m statistic --mode random --probability 0.14285714272 -j KUBE-SEP-ZXMNUKOKXUTL2MK2
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.244.0.4:53" -m statistic --mode random --probability 0.16666666651 -j KUBE-SEP-SF3LG62VAE5ALYDV
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.244.0.5:53" -m statistic --mode random --probability 0.20000000019 -j KUBE-SEP-LASJGFFJP3UOS6RQ
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.244.0.6:53" -m statistic --mode random --probability 0.25000000000 -j KUBE-SEP-2Z3537XSN3RJRU3M
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.244.0.7:53" -m statistic --mode random --probability 0.33333333349 -j KUBE-SEP-A4UL7OUXQPUR7Y7Q
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.244.0.8:53" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-XRFUWCXKVCLGWYQC
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.244.0.9:53" -j KUBE-SEP-S7MPVVC7MGYVFSF3
-A KUBE-SVC-JD5MR3NA4I4DYORP ! -s 10.244.0.0/16 -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:metrics cluster IP" -m tcp --dport 9153 -j KUBE-MARK-MASQ
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.244.0.10:9153" -m statistic --mode random --probability 0.10000000009 -j KUBE-SEP-HJ7EWOW62IX6GL6R
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.244.0.11:9153" -m statistic --mode random --probability 0.11111111101 -j KUBE-SEP-ZJHOSXJEKQGYJUBC
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.244.0.2:9153" -m statistic --mode random --probability 0.12500000000 -j KUBE-SEP-N4G2XR5TDX7PQE7P
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.244.0.3:9153" -m statistic --mode random --probability 0.14285714272 -j KUBE-SEP-ZP3FB6NMPNCO4VBJ
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.244.0.4:9153" -m statistic --mode random --probability 0.16666666651 -j KUBE-SEP-PUHFDAMRBZWCPADU
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.244.0.5:9153" -m statistic --mode random --probability 0.20000000019 -j KUBE-SEP-FVQSBIWR5JTECIVC
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.244.0.6:9153" -m statistic --mode random --probability 0.25000000000 -j KUBE-SEP-275NWNNANOEIGYHG
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.244.0.7:9153" -m statistic --mode random --probability 0.33333333349 -j KUBE-SEP-CPH3WXMLRJ2BZFXW
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.244.0.8:9153" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-XNZERJBNXRGRQGMS
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.244.0.9:9153" -j KUBE-SEP-CEWR77HQLZDHWWAJ
-A KUBE-SVC-NPX46M4PTMTKRN6Y ! -s 10.244.0.0/16 -d 10.96.0.1/32 -p tcp -m comment --comment "default/kubernetes:https cluster IP" -m tcp --dport 443 -j KUBE-MARK-MASQ
-A KUBE-SVC-NPX46M4PTMTKRN6Y -m comment --comment "default/kubernetes:https -> 172.18.0.3:6443" -j KUBE-SEP-QKX4QX54UKWK6JIY
-A KUBE-SVC-QDWG4LJGNBTOT5ED ! -s 10.244.0.0/16 -d 10.96.225.231/32 -p tcp -m comment --comment "kube-system/antrea cluster IP" -m tcp --dport 443 -j KUBE-MARK-MASQ
-A KUBE-SVC-QDWG4LJGNBTOT5ED -m comment --comment "kube-system/antrea -> 172.18.0.2:10349" -j KUBE-SEP-47Y74YAUKL3G2JYG
-A KUBE-SVC-TCOU7JCQXEZGVUNU ! -s 10.244.0.0/16 -d 10.96.0.10/32 -p udp -m comment --comment "kube-system/kube-dns:dns cluster IP" -m udp --dport 53 -j KUBE-MARK-MASQ
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.10:53" -m statistic --mode random --probability 0.10000000009 -j KUBE-SEP-R7EMXN5TTQQVP4UW
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.11:53" -m statistic --mode random --probability 0.11111111101 -j KUBE-SEP-VR6VIIG2A6524KLY
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.2:53" -m statistic --mode random --probability 0.12500000000 -j KUBE-SEP-YIL6JZP7A3QYXJU2
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.3:53" -m statistic --mode random --probability 0.14285714272 -j KUBE-SEP-6E7XQMQ4RAYOWTTM
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.4:53" -m statistic --mode random --probability 0.16666666651 -j KUBE-SEP-WXWGHGKZOCNYRYI7
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.5:53" -m statistic --mode random --probability 0.20000000019 -j KUBE-SEP-LPGSDLJ3FDW46N4W
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.6:53" -m statistic --mode random --probability 0.25000000000 -j KUBE-SEP-IRMT6RY5EEEBXDAY
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.7:53" -m statistic --mode random --probability 0.33333333349 -j KUBE-SEP-232DQYSHL5HNRYWJ
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.8:53" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-SISP6ORRA37L3ZYK
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.9:53" -j KUBE-SEP-LBMQNJ35ID4UIQ2A
COMMIT
# Completed on Sat Aug  1 18:12:47 2026
```

</details>

```bash
iptables-save \
| grep SEP-Q 
```

<details>
<summary>
Вывод фильтрации правил iptables по SEP-Q
</summary>

```log
:KUBE-SEP-QKX4QX54UKWK6JIY - [0:0]
-A KUBE-SEP-QKX4QX54UKWK6JIY -s 172.18.0.3/32 -m comment --comment "default/kubernetes:https" -j KUBE-MARK-MASQ
-A KUBE-SEP-QKX4QX54UKWK6JIY -p tcp -m comment --comment "default/kubernetes:https" -m tcp -j DNAT --to-destination 172.18.0.3:6443
-A KUBE-SVC-NPX46M4PTMTKRN6Y -m comment --comment "default/kubernetes:https -> 172.18.0.3:6443" -j KUBE-SEP-QKX4QX54UKWK6JIY
```

</details>

<details>
<summary>
Создание политики для блокировки доступа для модуля web
</summary>

```bash
cat > web-deny_all.yaml <<'EOF'
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: web-deny-all
spec:
  podSelector:
    matchLabels:
      app: web
  ingress: []
EOF
```

</details>

<details>
<summary>
Создание политики для разрешения доступа к порту 80 из модуля web2
</summary>

```bash
cat > web-web2-80-alllow.yaml <<'EOF'
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: web
spec:
  podSelector:
    matchLabels:
      app: web
  ingress:
    - ports:
      - port: 80
    - from:
      - podSelector:
          matchLabels:
            app: web2
EOF
```

</details>

<details>
<summary>
Создание создани службы nginx
</summary>

```bash
cat > nginx-pod.yaml <<'EOF'
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: nginx-ds
spec:
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx
EOF
```

</details>

### Команда: применение манифеста nginx

```bash
kubectl apply -f nginx-pod.yaml
```

<details>
<summary>
Применение манифеста службы nginx
</summary>

```log
daemonset.apps/nginx-ds created
```

</details>

### Команда: просмотр созданных pods

```bash
kubectl get pods -n default -o wide
```

<details>
<summary>
Просмотр созданных pods
</summary>

```log
NAME             READY   STATUS    RESTARTS   AGE    IP           NODE             NOMINATED NODE   READINESS GATES
nginx-ds-dc2bj   1/1     Running   0          2m9s   10.244.2.5   antrea-worker2   <none>           <none>
nginx-ds-pddvd   1/1     Running   0          2m9s   10.244.1.4   antrea-worker    <none>           <none>
```

</details>

### Команда: сохранение правил iptables до применения политик

```bash
docker exec -it antrea-control-plane bash

root@antrea-control-plane:/# iptables-save > a1

exit
```

### Команда: применение политики блокировки доступа

```bash
kubectl apply -f web-deny_all.yaml
```

```log
networkpolicy.networking.k8s.io/web-deny-all created
```

### Команда: сохранение правил iptables после применения политики

```bash
docker exec -it antrea-control-plane bash

root@antrea-control-plane:/# iptables-save > a2
```

### Команда: установка git в контейнере control-plane

```bash
apt-get update \
; apt-get install -y git
```

### Команда: просмотр изменений в iptables

```bash
git diff a1 a2
```

<details>
<summary>
Просмотр изменений в iptables
</summary>

```log
index 1f75a6e..a9dba08 100644
--- a/a1
+++ b/a2
@@ -1,9 +1,9 @@
-# Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:49:36 2026
+# Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:52:10 2026
 *mangle
-:PREROUTING ACCEPT [1451474:443108483]
+:PREROUTING ACCEPT [1486871:449737822]
 :INPUT ACCEPT [0:0]
 :FORWARD ACCEPT [0:0]
-:OUTPUT ACCEPT [1398907:268669421]
+:OUTPUT ACCEPT [1434575:275794742]
 :POSTROUTING ACCEPT [0:0]
 :ANTREA-OUTPUT - [0:0]
 :ANTREA-PREROUTING - [0:0]
@@ -14,11 +14,11 @@
 -A OUTPUT -m comment --comment "Antrea: jump to Antrea output rules" -j ANTREA-OUTPUT
 -A ANTREA-OUTPUT -o antrea-gw0 -m comment --comment "Antrea: mark LOCAL output packets" -m addrtype --src-type LOCAL -j MARK --set-xmark 0x80000000/0x80000000
 COMMIT
-# Completed on Sat Aug  1 18:49:36 2026
-# Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:49:36 2026
+# Completed on Sat Aug  1 18:52:10 2026
+# Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:52:10 2026
 *raw
-:PREROUTING ACCEPT [1451474:443108483]
-:OUTPUT ACCEPT [1398924:268675063]
+:PREROUTING ACCEPT [1486871:449737822]
+:OUTPUT ACCEPT [1434592:275800384]
 :ANTREA-OUTPUT - [0:0]
 :ANTREA-PREROUTING - [0:0]
 -A PREROUTING -m comment --comment "Antrea: jump to Antrea prerouting rules" -j ANTREA-PREROUTING
@@ -26,12 +26,12 @@ COMMIT
 -A ANTREA-OUTPUT -p udp -m comment --comment "Antrea: do not track outgoing encapsulation packets" -m udp --dport 6081 -m addrtype --src-type LOCAL -j NOTRACK
 -A ANTREA-PREROUTING -p udp -m comment --comment "Antrea: do not track incoming encapsulation packets" -m udp --dport 6081 -m addrtype --dst-type LOCAL -j NOTRACK
 COMMIT
-# Completed on Sat Aug  1 18:49:36 2026
-# Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:49:36 2026
+# Completed on Sat Aug  1 18:52:10 2026
+# Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:52:10 2026
 *filter
-:INPUT ACCEPT [1592570:614515287]
+:INPUT ACCEPT [1627967:621144626]
 :FORWARD ACCEPT [0:0]
-:OUTPUT ACCEPT [1499595:296609754]
+:OUTPUT ACCEPT [1535263:303735075]
 :ANTREA-FORWARD - [0:0]
 :KUBE-EXTERNAL-SERVICES - [0:0]
 :KUBE-FIREWALL - [0:0]
@@ -60,13 +60,13 @@ COMMIT
 -A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT
 -A KUBE-FORWARD -m comment --comment "kubernetes forwarding conntrack rule" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
 COMMIT
-# Completed on Sat Aug  1 18:49:36 2026
-# Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:49:36 2026
+# Completed on Sat Aug  1 18:52:10 2026
+# Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:52:10 2026
 *nat
-:PREROUTING ACCEPT [527:32052]
-:INPUT ACCEPT [530:32373]
-:OUTPUT ACCEPT [30082:1804920]
-:POSTROUTING ACCEPT [30133:1809826]
+:PREROUTING ACCEPT [537:32652]
+:INPUT ACCEPT [540:32973]
+:OUTPUT ACCEPT [30924:1855440]
+:POSTROUTING ACCEPT [30975:1860346]
 :ANTREA-POSTROUTING - [0:0]
 :DOCKER_OUTPUT - [0:0]
 :DOCKER_POSTROUTING - [0:0]
@@ -245,4 +245,4 @@ COMMIT
 -A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.8:53" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-SISP6ORRA37L3ZYK
 -A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.9:53" -j KUBE-SEP-LBMQNJ35ID4UIQ2A
 COMMIT
-# Completed on Sat Aug  1 18:49:36 2026
+# Completed on Sat Aug  1 18:52:10 2026
```

</details>

### Команда: смена политик и проверка

```bash
root@antrea-control-plane:/# exit

kubectl delete -f web-deny_all.yaml

kubectl apply -f web-web2-80-alllow.yaml
```

<details>
<summary>
смена примененных политик
</summary>

```log
networkpolicy.networking.k8s.io "web-deny-all" deleted from default namespace

networkpolicy.networking.k8s.io/web created
```

</details>

### Команда: сравнение трех снимков iptables

```bash
docker exec -it antrea-control-plane bash

root@antrea-control-plane:/# iptables-save > a3

diff3 a{1..3}
```

<details>
<summary>
Просмотр текущих удаленных репозиториев
</summary>

```log
====
1:1c
  # Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:49:36 2026
2:1c
  # Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:52:10 2026
3:1c
  # Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:59:10 2026
====
1:3c
  :PREROUTING ACCEPT [1451474:443108483]
2:3c
  :PREROUTING ACCEPT [1486871:449737822]
3:3c
  :PREROUTING ACCEPT [1598490:490938744]
====
1:6c
  :OUTPUT ACCEPT [1398907:268669421]
2:6c
  :OUTPUT ACCEPT [1434575:275794742]
3:6c
  :OUTPUT ACCEPT [1541895:294174947]
====
1:17,18c
  # Completed on Sat Aug  1 18:49:36 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:49:36 2026
2:17,18c
  # Completed on Sat Aug  1 18:52:10 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:52:10 2026
3:17,18c
  # Completed on Sat Aug  1 18:59:10 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:59:10 2026
====
1:20,21c
  :PREROUTING ACCEPT [1451474:443108483]
  :OUTPUT ACCEPT [1398924:268675063]
2:20,21c
  :PREROUTING ACCEPT [1486871:449737822]
  :OUTPUT ACCEPT [1434592:275800384]
3:20,21c
  :PREROUTING ACCEPT [1598490:490938744]
  :OUTPUT ACCEPT [1541912:294180589]
====
1:29,30c
  # Completed on Sat Aug  1 18:49:36 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:49:36 2026
2:29,30c
  # Completed on Sat Aug  1 18:52:10 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:52:10 2026
3:29,30c
  # Completed on Sat Aug  1 18:59:10 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:59:10 2026
====
1:32c
  :INPUT ACCEPT [1592570:614515287]
2:32c
  :INPUT ACCEPT [1627967:621144626]
3:32c
  :INPUT ACCEPT [1739586:662345548]
====
1:34c
  :OUTPUT ACCEPT [1499595:296609754]
2:34c
  :OUTPUT ACCEPT [1535263:303735075]
3:34c
  :OUTPUT ACCEPT [1642583:322115280]
====
1:63,64c
  # Completed on Sat Aug  1 18:49:36 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:49:36 2026
2:63,64c
  # Completed on Sat Aug  1 18:52:10 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:52:10 2026
3:63,64c
  # Completed on Sat Aug  1 18:59:10 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sat Aug  1 18:59:10 2026
====
1:66,69c
  :PREROUTING ACCEPT [527:32052]
  :INPUT ACCEPT [530:32373]
  :OUTPUT ACCEPT [30082:1804920]
  :POSTROUTING ACCEPT [30133:1809826]
2:66,69c
  :PREROUTING ACCEPT [537:32652]
  :INPUT ACCEPT [540:32973]
  :OUTPUT ACCEPT [30924:1855440]
  :POSTROUTING ACCEPT [30975:1860346]
3:66,69c
  :PREROUTING ACCEPT [566:34392]
  :INPUT ACCEPT [569:34713]
  :OUTPUT ACCEPT [33232:1993920]
  :POSTROUTING ACCEPT [33287:1999152]
====
1:248c
  # Completed on Sat Aug  1 18:49:36 2026
2:248c
  # Completed on Sat Aug  1 18:52:10 2026
3:248c
  # Completed on Sat Aug  1 18:59:10 2026
```

</details>

### Команда: удаление политик разрешения доступа

```bash
root@antrea-control-plane:/# exit

kubectl delete -f web-web2-80-alllow.yaml
```

<details>
<summary>
Удаление политик
</summary>

```log
networkpolicy.networking.k8s.io "web" deleted from default namespace
```

</details>

### Команда: получение имени пода antrea-agent

```bash
kubectl get pods -n kube-system \
| grep agent \
| tail -1
```

```log
antrea-agent-m7w9b                             2/2     Running   0          46m
```

```bash
kubectl exec antrea-agent-m7w9b -n kube-system -- bash -c "ovs-ofctl dump-flows br-int | grep table > a1"

kubectl apply -f web-deny_all.yaml

kubectl exec antrea-agent-m7w9b -n kube-system -- bash -c "ovs-ofctl dump-flows br-int | grep table > a2"

kubectl exec antrea-agent-m7w9b -n kube-system -- diff a1 a2
```

<details>
<summary>
Вывод внесенных изменений на уровне OVS
</summary>

```log
1,143c1,148
<  cookie=0x1000000000000, duration=7076.361s, table=0, n_packets=21, n_bytes=882, idle_age=1844, priority=200,arp actions=resubmit(,1)
<  cookie=0x1000000000000, duration=7076.360s, table=0, n_packets=3229, n_bytes=4802555, idle_age=6769, priority=200,ip actions=resubmit(,3)
<  cookie=0x1000000000000, duration=7076.361s, table=0, n_packets=46, n_bytes=3448, idle_age=731, priority=0 actions=drop
<  cookie=0x1010000000000, duration=7076.350s, table=1, n_packets=4, n_bytes=168, idle_age=6794, priority=200,arp,in_port=32769,arp_spa=10.244.1.1,arp_sha=02:60:ef:e6:1d:57 actions=resubmit(,2)
<  cookie=0x1010000000000, duration=6955.265s, table=1, n_packets=8, n_bytes=336, idle_age=6794, priority=200,arp,in_port=1,arp_spa=10.244.1.2,arp_sha=9a:84:26:63:6f:97 actions=resubmit(,2)
<  cookie=0x1010000000000, duration=1845.102s, table=1, n_packets=3, n_bytes=126, idle_age=1844, priority=200,arp,in_port=3,arp_spa=10.244.1.4,arp_sha=9e:f4:19:16:ce:0b actions=resubmit(,2)
<  cookie=0x1000000000000, duration=7076.361s, table=1, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=drop
<  cookie=0x1010000000000, duration=7076.120s, table=2, n_packets=0, n_bytes=0, idle_age=7076, priority=200,arp,arp_tpa=10.244.2.1,arp_op=1 actions=move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[],mod_dl_src:aa:bb:cc:dd:ee:ff,load:0x2->NXM_OF_ARP_OP[],move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[],load:0xaabbccddeeff->NXM_NX_ARP_SHA[],move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[],load:0xaf40201->NXM_OF_ARP_SPA[],IN_PORT
<  cookie=0x1010000000000, duration=7076.121s, table=2, n_packets=0, n_bytes=0, idle_age=7076, priority=200,arp,arp_tpa=10.244.0.1,arp_op=1 actions=move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[],mod_dl_src:aa:bb:cc:dd:ee:ff,load:0x2->NXM_OF_ARP_OP[],move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[],load:0xaabbccddeeff->NXM_NX_ARP_SHA[],move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[],load:0xaf40001->NXM_OF_ARP_SPA[],IN_PORT
<  cookie=0x1010000000000, duration=7076.351s, table=2, n_packets=21, n_bytes=882, idle_age=1845, priority=190,arp actions=NORMAL
<  cookie=0x1000000000000, duration=7076.362s, table=2, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=drop
<  cookie=0x1010000000000, duration=7076.351s, table=3, n_packets=32, n_bytes=501096, idle_age=6868, priority=210,ip,in_port=32769,nw_src=10.244.1.1 actions=load:0x2->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
<  cookie=0x1010000000000, duration=7076.351s, table=3, n_packets=1444, n_bytes=2496714, idle_age=6769, priority=200,in_port=32769 actions=load:0x2->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[27],resubmit(,4)
<  cookie=0x1010000000000, duration=7076.350s, table=3, n_packets=72, n_bytes=1482139, idle_age=6868, priority=200,in_port=32768 actions=load:0x1->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG0[9],resubmit(,5)
<  cookie=0x1010000000000, duration=6955.266s, table=3, n_packets=1516, n_bytes=198972, idle_age=6769, priority=190,in_port=1 actions=load:0x3->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
<  cookie=0x1010000000000, duration=1845.103s, table=3, n_packets=0, n_bytes=0, idle_age=1845, priority=190,in_port=3 actions=load:0x3->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
<  cookie=0x1000000000000, duration=7076.362s, table=3, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=drop
<  cookie=0x1010000000000, duration=7076.350s, table=4, n_packets=1476, n_bytes=2997810, idle_age=6769, priority=200,ip,in_port=32769 actions=resubmit(,5)
<  cookie=0x1010000000000, duration=6955.266s, table=4, n_packets=1516, n_bytes=198972, idle_age=6769, priority=200,ip,in_port=1,dl_src=9a:84:26:63:6f:97,nw_src=10.244.1.2 actions=resubmit(,5)
<  cookie=0x1010000000000, duration=1845.103s, table=4, n_packets=0, n_bytes=0, idle_age=1845, priority=200,ip,in_port=3,dl_src=9e:f4:19:16:ce:0b,nw_src=10.244.1.4 actions=resubmit(,5)
<  cookie=0x1000000000000, duration=7076.362s, table=4, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=drop
<  cookie=0x1030000000000, duration=7076.347s, table=5, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ip,nw_dst=169.254.0.253 actions=ct(table=6,zone=65521,nat)
<  cookie=0x1030000000000, duration=7076.347s, table=5, n_packets=25, n_bytes=4312, idle_age=6868, priority=200,ip,nw_dst=10.244.1.1 actions=ct(table=6,zone=65521,nat)
<  cookie=0x1000000000000, duration=7076.362s, table=5, n_packets=3204, n_bytes=4798243, idle_age=6769, priority=0 actions=resubmit(,6)
<  cookie=0x1010000000000, duration=7076.351s, table=6, n_packets=3229, n_bytes=4802555, idle_age=6769, priority=200,ip actions=ct(table=7,zone=65520,nat)
<  cookie=0x1000000000000, duration=7076.362s, table=6, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=resubmit(,7)
<  cookie=0x1010000000000, duration=7076.351s, table=7, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ct_state=+inv+trk,ip actions=drop
<  cookie=0x1010000000000, duration=7076.351s, table=7, n_packets=228, n_bytes=2104899, idle_age=6868, priority=190,ct_state=-new+trk,ct_mark=0/0x10,ip actions=resubmit(,12)
<  cookie=0x1030000000000, duration=7076.347s, table=7, n_packets=2992, n_bytes=2696990, idle_age=6769, priority=190,ct_state=-new+trk,ct_mark=0x10/0x10,ip actions=load:0x1->NXM_NX_REG0[9],resubmit(,12)
<  cookie=0x1010000000000, duration=7076.351s, table=7, n_packets=9, n_bytes=666, idle_age=6883, priority=0 actions=resubmit(,8)
<  cookie=0x1030000000000, duration=7076.347s, table=8, n_packets=9, n_bytes=666, idle_age=6883, priority=200,ip actions=resubmit(,9),resubmit(,10)
<  cookie=0x1000000000000, duration=7076.362s, table=8, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=resubmit(,9)
<  cookie=0x1030000000000, duration=7076.347s, table=9, n_packets=9, n_bytes=666, idle_age=6883, priority=0 actions=load:0x1->NXM_NX_REG4[16..18]
<  cookie=0x1030000000000, duration=7076.121s, table=10, n_packets=0, n_bytes=0, idle_age=7076, priority=200,udp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=53 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x5->NXM_NX_REG7[],group:5
<  cookie=0x1030000000000, duration=7076.111s, table=10, n_packets=0, n_bytes=0, idle_age=7076, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=53 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x6->NXM_NX_REG7[],group:6
<  cookie=0x1030000000000, duration=7076.104s, table=10, n_packets=0, n_bytes=0, idle_age=7076, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=9153 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x7->NXM_NX_REG7[],group:7
<  cookie=0x1030000000000, duration=7076.094s, table=10, n_packets=4, n_bytes=296, idle_age=6883, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.1,tp_dst=443 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x8->NXM_NX_REG7[],group:8
<  cookie=0x1030000000000, duration=7076.088s, table=10, n_packets=0, n_bytes=0, idle_age=7076, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.225.231,tp_dst=443 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x9->NXM_NX_REG7[],group:9
<  cookie=0x1030000000000, duration=6955.603s, table=10, n_packets=0, n_bytes=0, idle_age=6955, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.181.73,tp_dst=8080 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0xa->NXM_NX_REG7[],group:10
<  cookie=0x1000000000000, duration=7076.362s, table=10, n_packets=5, n_bytes=370, idle_age=6887, priority=0 actions=resubmit(,11)
<  cookie=0x1030000000000, duration=7076.347s, table=11, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0x4000/0x4000 actions=controller(reason=no_match,id=3452,userdata=04)
<  cookie=0x1030000000000, duration=7076.102s, table=11, n_packets=4, n_bytes=296, idle_age=6883, priority=200,tcp,reg3=0xac120003,reg4=0x2192b/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=172.18.0.3:6443),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=7064.736s, table=11, n_packets=0, n_bytes=0, idle_age=7064, priority=200,udp,reg3=0xaf40003,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=7064.736s, table=11, n_packets=0, n_bytes=0, idle_age=7064, priority=200,udp,reg3=0xaf40002,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=7064.711s, table=11, n_packets=0, n_bytes=0, idle_age=7064, priority=200,tcp,reg3=0xaf40003,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=7064.711s, table=11, n_packets=0, n_bytes=0, idle_age=7064, priority=200,tcp,reg3=0xaf40002,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=7064.700s, table=11, n_packets=0, n_bytes=0, idle_age=7064, priority=200,tcp,reg3=0xaf40003,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=7064.700s, table=11, n_packets=0, n_bytes=0, idle_age=7064, priority=200,tcp,reg3=0xaf40002,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=7062.810s, table=11, n_packets=0, n_bytes=0, idle_age=7062, priority=200,tcp,reg3=0xac120002,reg4=0x2286d/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=172.18.0.2:10349),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=6948.387s, table=11, n_packets=0, n_bytes=0, idle_age=6948, priority=200,tcp,reg3=0xaf40102,reg4=0x21f90/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.1.2:8080),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5869.783s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,udp,reg3=0xaf40005,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5869.783s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,udp,reg3=0xaf40006,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5869.783s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,udp,reg3=0xaf40004,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5869.773s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,tcp,reg3=0xaf40005,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5869.773s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,tcp,reg3=0xaf40006,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5869.773s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,tcp,reg3=0xaf40004,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5869.764s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,tcp,reg3=0xaf40004,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5869.764s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,tcp,reg3=0xaf40006,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5869.764s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,tcp,reg3=0xaf40005,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.758s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf40007,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.758s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf40009,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.758s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf4000a,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.758s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf4000b,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.758s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf40008,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.748s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,udp,reg3=0xaf4000a,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.748s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,udp,reg3=0xaf40008,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.748s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,udp,reg3=0xaf4000b,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.748s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,udp,reg3=0xaf40007,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.748s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,udp,reg3=0xaf40009,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.739s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf40008,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.738s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf40007,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.738s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf4000b,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.738s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf4000a,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=5868.738s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf40009,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
<  cookie=0x1030000000000, duration=7076.347s, table=11, n_packets=0, n_bytes=0, idle_age=7076, priority=190,reg4=0x20000/0x70000 actions=load:0x1->NXM_NX_REG4[16..18],resubmit(,10)
<  cookie=0x1000000000000, duration=7076.361s, table=11, n_packets=5, n_bytes=370, idle_age=6887, priority=0 actions=resubmit(,12)
<  cookie=0x1020000000000, duration=7076.342s, table=12, n_packets=3220, n_bytes=4801889, idle_age=6769, priority=64990,ct_state=-new+est,ip actions=resubmit(,15)
<  cookie=0x1020000000000, duration=7076.342s, table=12, n_packets=0, n_bytes=0, idle_age=7076, priority=64990,ct_state=-new+rel,ip actions=resubmit(,15)
<  cookie=0x1000000000000, duration=7076.361s, table=12, n_packets=9, n_bytes=666, idle_age=6883, priority=0 actions=resubmit(,13)
<  cookie=0x1000000000000, duration=7076.361s, table=13, n_packets=9, n_bytes=666, idle_age=6883, priority=0 actions=resubmit(,14)
<  cookie=0x1000000000000, duration=7076.361s, table=14, n_packets=9, n_bytes=666, idle_age=6883, priority=0 actions=resubmit(,15)
<  cookie=0x1000000000000, duration=7076.361s, table=15, n_packets=3229, n_bytes=4802555, idle_age=6769, priority=0 actions=resubmit(,16)
<  cookie=0x1010000000000, duration=7076.350s, table=16, n_packets=25, n_bytes=4312, idle_age=6868, priority=210,ip,nw_dst=10.244.1.1 actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
<  cookie=0x1010000000000, duration=7076.350s, table=16, n_packets=0, n_bytes=0, idle_age=7076, priority=210,ct_state=+rpl+trk,ct_mark=0x2/0xf,ip actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
<  cookie=0x1010000000000, duration=7076.350s, table=16, n_packets=88, n_bytes=610339, idle_age=6868, priority=200,ip,reg0=0/0x200,nw_dst=10.244.1.0/24 actions=resubmit(,21)
<  cookie=0x1010000000000, duration=7076.121s, table=16, n_packets=23, n_bytes=4168, idle_age=6868, priority=200,ip,nw_dst=10.244.2.0/24 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:aa:bb:cc:dd:ee:ff,load:0xac120002->NXM_NX_TUN_IPV4_DST[],load:0x1->NXM_NX_REG0[4..7],resubmit(,18)
<  cookie=0x1010000000000, duration=7076.120s, table=16, n_packets=25, n_bytes=4311, idle_age=6868, priority=200,ip,nw_dst=10.244.0.0/24 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:aa:bb:cc:dd:ee:ff,load:0xac120003->NXM_NX_TUN_IPV4_DST[],load:0x1->NXM_NX_REG0[4..7],resubmit(,18)
<  cookie=0x1010000000000, duration=6955.266s, table=16, n_packets=1389, n_bytes=3734917, idle_age=6769, priority=200,ip,reg0=0x200/0x200,nw_dst=10.244.1.2 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:9a:84:26:63:6f:97,resubmit(,18)
<  cookie=0x1010000000000, duration=1845.103s, table=16, n_packets=0, n_bytes=0, idle_age=1845, priority=200,ip,reg0=0x200/0x200,nw_dst=10.244.1.4 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:9e:f4:19:16:ce:0b,resubmit(,18)
<  cookie=0x1030000000000, duration=7076.347s, table=16, n_packets=0, n_bytes=0, idle_age=7076, priority=190,ct_mark=0x10/0x10,reg0=0x202/0x20f actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
<  cookie=0x1040000000000, duration=7076.340s, table=16, n_packets=1552, n_bytes=200572, idle_age=6769, priority=190,ct_state=-rpl+trk,ip,reg0=0x3/0xf,reg4=0/0x100000 actions=resubmit(,17)
<  cookie=0x1040000000000, duration=7076.340s, table=16, n_packets=0, n_bytes=0, idle_age=7076, priority=190,ct_state=-rpl+trk,ip,reg0=0x1/0xf actions=mod_dl_dst:02:60:ef:e6:1d:57,resubmit(,17)
<  cookie=0x1010000000000, duration=7076.351s, table=16, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
<  cookie=0x1040000000000, duration=7076.340s, table=17, n_packets=0, n_bytes=0, idle_age=7076, priority=210,ip,nw_dst=172.18.0.4 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
<  cookie=0x1040000000000, duration=7076.121s, table=17, n_packets=0, n_bytes=0, idle_age=7076, priority=210,ip,nw_dst=172.18.0.2 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
<  cookie=0x1040000000000, duration=7076.120s, table=17, n_packets=1552, n_bytes=200572, idle_age=6769, priority=210,ip,nw_dst=172.18.0.3 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
<  cookie=0x1040000000000, duration=7076.022s, table=17, n_packets=0, n_bytes=0, idle_age=7076, priority=210,ip,nw_dst=10.96.0.0/16 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
<  cookie=0x1040000000000, duration=7076.340s, table=17, n_packets=0, n_bytes=0, idle_age=7076, priority=190,ct_state=+new+trk,ip,reg0=0x1/0xf actions=drop
<  cookie=0x1040000000000, duration=7076.340s, table=17, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
<  cookie=0x1010000000000, duration=7076.351s, table=18, n_packets=1444, n_bytes=2496714, idle_age=6769, priority=210,ip,reg0=0x2/0xf actions=resubmit(,19)
<  cookie=0x1010000000000, duration=7076.351s, table=18, n_packets=145, n_bytes=1494930, idle_age=6868, priority=200,ip actions=dec_ttl,resubmit(,19)
<  cookie=0x1000000000000, duration=7076.361s, table=18, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=resubmit(,19)
<  cookie=0x1030000000000, duration=7076.347s, table=19, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ct_state=+new+trk,ip,reg0=0x22/0xff actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
<  cookie=0x1030000000000, duration=7076.347s, table=19, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ct_state=+new+trk,ip,reg0=0x12/0xff,reg4=0x200000/0x2200000 actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
<  cookie=0x1030000000000, duration=6948.387s, table=19, n_packets=0, n_bytes=0, idle_age=6948, priority=190,ct_state=+new+trk,ip,nw_src=10.244.1.2,nw_dst=10.244.1.2 actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
<  cookie=0x1000000000000, duration=7076.361s, table=19, n_packets=1589, n_bytes=3991644, idle_age=6769, priority=0 actions=resubmit(,20)
<  cookie=0x1030000000000, duration=7076.347s, table=20, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ct_state=+new+trk,ct_mark=0x40/0x40,ip,reg0=0x2/0xf actions=ct(commit,table=21,zone=65521,nat(src=169.254.0.253),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6]))
<  cookie=0x1030000000000, duration=7076.347s, table=20, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ct_state=+new+trk,ct_mark=0x40/0x40,ip,reg0=0x3/0xf actions=ct(commit,table=21,zone=65521,nat(src=10.244.1.1),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6]))
<  cookie=0x1030000000000, duration=7076.347s, table=20, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ct_state=-new-rpl+trk,ct_mark=0x20/0x20,ip actions=ct(table=21,zone=65521,nat)
<  cookie=0x1030000000000, duration=7076.347s, table=20, n_packets=0, n_bytes=0, idle_age=7076, priority=190,ct_state=+new+trk,ct_mark=0x20/0x20,ip,reg0=0x2/0xf actions=ct(commit,table=21,zone=65521,nat(src=10.244.1.1),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5]))
<  cookie=0x1000000000000, duration=7076.361s, table=20, n_packets=1589, n_bytes=3991644, idle_age=6769, priority=0 actions=resubmit(,21)
<  cookie=0x1010000000000, duration=7076.350s, table=21, n_packets=1577, n_bytes=204884, idle_age=6769, priority=200,dl_dst=02:60:ef:e6:1d:57 actions=load:0x8001->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
<  cookie=0x1010000000000, duration=7076.350s, table=21, n_packets=48, n_bytes=8479, idle_age=6868, priority=200,dl_dst=aa:bb:cc:dd:ee:ff actions=load:0x8000->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
<  cookie=0x1010000000000, duration=6955.266s, table=21, n_packets=1456, n_bytes=4338327, idle_age=6769, priority=200,dl_dst=9a:84:26:63:6f:97 actions=load:0x1->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
<  cookie=0x1010000000000, duration=1845.103s, table=21, n_packets=0, n_bytes=0, idle_age=1845, priority=200,dl_dst=9e:f4:19:16:ce:0b actions=load:0x3->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
<  cookie=0x1000000000000, duration=7076.361s, table=21, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=resubmit(,22)
<  cookie=0x1010000000000, duration=7076.350s, table=22, n_packets=32, n_bytes=501096, idle_age=6868, priority=210,pkt_mark=0x80000000/0x80000000,ct_state=-rpl+trk,ip actions=resubmit(,27)
<  cookie=0x1020000000000, duration=7076.342s, table=22, n_packets=1577, n_bytes=204884, idle_age=6769, priority=200,reg0=0x20/0xf0 actions=resubmit(,26)
<  cookie=0x1020000000000, duration=7076.342s, table=22, n_packets=48, n_bytes=8479, idle_age=6868, priority=200,reg0=0x10/0xf0 actions=resubmit(,26)
<  cookie=0x1020000000000, duration=7076.342s, table=22, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0x40/0xf0 actions=resubmit(,26)
<  cookie=0x1020000000000, duration=7076.342s, table=22, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ct_mark=0x40/0x40 actions=resubmit(,27)
<  cookie=0x1000000000000, duration=7076.361s, table=22, n_packets=1572, n_bytes=4088096, idle_age=6769, priority=0 actions=resubmit(,23)
<  cookie=0x1020000000000, duration=7076.236s, table=23, n_packets=0, n_bytes=0, idle_age=7076, priority=64991,conj_id=1 actions=controller(reason=no_match,id=3452,userdata=02,pause),resubmit(,26)
<  cookie=0x1020000000000, duration=7071.224s, table=23, n_packets=0, n_bytes=0, idle_age=7076, priority=64991,ct_state=+rpl+trk,udp,tp_src=53 actions=conjunction(1,1/2)
<  cookie=0x1020000000000, duration=7071.224s, table=23, n_packets=0, n_bytes=0, idle_age=7076, priority=64991,ct_state=+rpl+trk,tcp,tp_src=53 actions=conjunction(1,1/2)
<  cookie=0x1020000000000, duration=7076.342s, table=23, n_packets=1568, n_bytes=4087800, idle_age=6769, priority=64990,ct_state=-new+est,ip actions=resubmit(,26)
<  cookie=0x1020000000000, duration=7076.342s, table=23, n_packets=0, n_bytes=0, idle_age=7076, priority=64990,ct_state=-new+rel,ip actions=resubmit(,26)
<  cookie=0x1000000000000, duration=7076.361s, table=23, n_packets=4, n_bytes=296, idle_age=6887, priority=0 actions=resubmit(,24)
<  cookie=0x1000000000000, duration=7076.361s, table=24, n_packets=4, n_bytes=296, idle_age=6887, priority=0 actions=resubmit(,25)
<  cookie=0x1000000000000, duration=7076.361s, table=25, n_packets=4, n_bytes=296, idle_age=6887, priority=0 actions=resubmit(,26)
<  cookie=0x1000000000000, duration=7076.361s, table=26, n_packets=3197, n_bytes=4301459, idle_age=6769, priority=0 actions=resubmit(,27)
<  cookie=0x1010000000000, duration=7076.351s, table=27, n_packets=9, n_bytes=666, idle_age=6883, priority=200,ct_state=+new+trk,ct_mark=0/0x20,ip actions=ct(commit,table=28,zone=65520,exec(move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
<  cookie=0x1000000000000, duration=7076.361s, table=27, n_packets=3220, n_bytes=4801889, idle_age=6769, priority=0 actions=resubmit(,28)
<  cookie=0x1030000000000, duration=7076.347s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=210,ct_mark=0x40/0x40,reg0=0x200000/0x600000 actions=IN_PORT
<  cookie=0x1010000000000, duration=7076.351s, table=28, n_packets=3229, n_bytes=4802555, idle_age=6769, priority=200,reg0=0x200000/0x600000 actions=output:NXM_NX_REG1[]
<  cookie=0x1020000000000, duration=7076.342s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0x2400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.01)
<  cookie=0x1020000000000, duration=7076.342s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0x4400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.02)
<  cookie=0x1020000000000, duration=7076.342s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0x6400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.03)
<  cookie=0x1020000000000, duration=7076.342s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0x8400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.04)
<  cookie=0x1020000000000, duration=7076.342s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0xa400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.05)
<  cookie=0x1020000000000, duration=7076.342s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0xc400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.06)
<  cookie=0x1020000000000, duration=7076.342s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0xe400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.07)
<  cookie=0x1000000000000, duration=7076.361s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=drop
---
>  cookie=0x1000000000000, duration=7135.827s, table=0, n_packets=21, n_bytes=882, idle_age=1904, priority=200,arp actions=resubmit(,1)
>  cookie=0x1000000000000, duration=7135.826s, table=0, n_packets=3229, n_bytes=4802555, idle_age=6829, priority=200,ip actions=resubmit(,3)
>  cookie=0x1000000000000, duration=7135.827s, table=0, n_packets=46, n_bytes=3448, idle_age=790, priority=0 actions=drop
>  cookie=0x1010000000000, duration=7135.816s, table=1, n_packets=4, n_bytes=168, idle_age=6853, priority=200,arp,in_port=32769,arp_spa=10.244.1.1,arp_sha=02:60:ef:e6:1d:57 actions=resubmit(,2)
>  cookie=0x1010000000000, duration=7014.731s, table=1, n_packets=8, n_bytes=336, idle_age=6853, priority=200,arp,in_port=1,arp_spa=10.244.1.2,arp_sha=9a:84:26:63:6f:97 actions=resubmit(,2)
>  cookie=0x1010000000000, duration=1904.568s, table=1, n_packets=3, n_bytes=126, idle_age=1904, priority=200,arp,in_port=3,arp_spa=10.244.1.4,arp_sha=9e:f4:19:16:ce:0b actions=resubmit(,2)
>  cookie=0x1000000000000, duration=7135.827s, table=1, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=drop
>  cookie=0x1010000000000, duration=7135.586s, table=2, n_packets=0, n_bytes=0, idle_age=7135, priority=200,arp,arp_tpa=10.244.2.1,arp_op=1 actions=move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[],mod_dl_src:aa:bb:cc:dd:ee:ff,load:0x2->NXM_OF_ARP_OP[],move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[],load:0xaabbccddeeff->NXM_NX_ARP_SHA[],move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[],load:0xaf40201->NXM_OF_ARP_SPA[],IN_PORT
>  cookie=0x1010000000000, duration=7135.586s, table=2, n_packets=0, n_bytes=0, idle_age=7135, priority=200,arp,arp_tpa=10.244.0.1,arp_op=1 actions=move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[],mod_dl_src:aa:bb:cc:dd:ee:ff,load:0x2->NXM_OF_ARP_OP[],move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[],load:0xaabbccddeeff->NXM_NX_ARP_SHA[],move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[],load:0xaf40001->NXM_OF_ARP_SPA[],IN_PORT
>  cookie=0x1010000000000, duration=7135.816s, table=2, n_packets=21, n_bytes=882, idle_age=1904, priority=190,arp actions=NORMAL
>  cookie=0x1000000000000, duration=7135.827s, table=2, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=drop
>  cookie=0x1010000000000, duration=7135.816s, table=3, n_packets=32, n_bytes=501096, idle_age=6927, priority=210,ip,in_port=32769,nw_src=10.244.1.1 actions=load:0x2->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
>  cookie=0x1010000000000, duration=7135.816s, table=3, n_packets=1444, n_bytes=2496714, idle_age=6829, priority=200,in_port=32769 actions=load:0x2->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[27],resubmit(,4)
>  cookie=0x1010000000000, duration=7135.815s, table=3, n_packets=72, n_bytes=1482139, idle_age=6927, priority=200,in_port=32768 actions=load:0x1->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG0[9],resubmit(,5)
>  cookie=0x1010000000000, duration=7014.731s, table=3, n_packets=1516, n_bytes=198972, idle_age=6829, priority=190,in_port=1 actions=load:0x3->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
>  cookie=0x1010000000000, duration=1904.568s, table=3, n_packets=0, n_bytes=0, idle_age=1904, priority=190,in_port=3 actions=load:0x3->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
>  cookie=0x1000000000000, duration=7135.827s, table=3, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=drop
>  cookie=0x1010000000000, duration=7135.815s, table=4, n_packets=1476, n_bytes=2997810, idle_age=6829, priority=200,ip,in_port=32769 actions=resubmit(,5)
>  cookie=0x1010000000000, duration=7014.731s, table=4, n_packets=1516, n_bytes=198972, idle_age=6829, priority=200,ip,in_port=1,dl_src=9a:84:26:63:6f:97,nw_src=10.244.1.2 actions=resubmit(,5)
>  cookie=0x1010000000000, duration=1904.568s, table=4, n_packets=0, n_bytes=0, idle_age=1904, priority=200,ip,in_port=3,dl_src=9e:f4:19:16:ce:0b,nw_src=10.244.1.4 actions=resubmit(,5)
>  cookie=0x1000000000000, duration=7135.827s, table=4, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=drop
>  cookie=0x1030000000000, duration=7135.812s, table=5, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ip,nw_dst=169.254.0.253 actions=ct(table=6,zone=65521,nat)
>  cookie=0x1030000000000, duration=7135.812s, table=5, n_packets=25, n_bytes=4312, idle_age=6927, priority=200,ip,nw_dst=10.244.1.1 actions=ct(table=6,zone=65521,nat)
>  cookie=0x1000000000000, duration=7135.827s, table=5, n_packets=3204, n_bytes=4798243, idle_age=6829, priority=0 actions=resubmit(,6)
>  cookie=0x1010000000000, duration=7135.816s, table=6, n_packets=3229, n_bytes=4802555, idle_age=6829, priority=200,ip actions=ct(table=7,zone=65520,nat)
>  cookie=0x1000000000000, duration=7135.827s, table=6, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=resubmit(,7)
>  cookie=0x1010000000000, duration=7135.816s, table=7, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ct_state=+inv+trk,ip actions=drop
>  cookie=0x1010000000000, duration=7135.816s, table=7, n_packets=228, n_bytes=2104899, idle_age=6927, priority=190,ct_state=-new+trk,ct_mark=0/0x10,ip actions=resubmit(,12)
>  cookie=0x1030000000000, duration=7135.812s, table=7, n_packets=2992, n_bytes=2696990, idle_age=6829, priority=190,ct_state=-new+trk,ct_mark=0x10/0x10,ip actions=load:0x1->NXM_NX_REG0[9],resubmit(,12)
>  cookie=0x1010000000000, duration=7135.816s, table=7, n_packets=9, n_bytes=666, idle_age=6942, priority=0 actions=resubmit(,8)
>  cookie=0x1030000000000, duration=7135.812s, table=8, n_packets=9, n_bytes=666, idle_age=6942, priority=200,ip actions=resubmit(,9),resubmit(,10)
>  cookie=0x1000000000000, duration=7135.827s, table=8, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=resubmit(,9)
>  cookie=0x1030000000000, duration=7135.812s, table=9, n_packets=9, n_bytes=666, idle_age=6942, priority=0 actions=load:0x1->NXM_NX_REG4[16..18]
>  cookie=0x1030000000000, duration=7135.586s, table=10, n_packets=0, n_bytes=0, idle_age=7135, priority=200,udp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=53 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x5->NXM_NX_REG7[],group:5
>  cookie=0x1030000000000, duration=7135.576s, table=10, n_packets=0, n_bytes=0, idle_age=7135, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=53 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x6->NXM_NX_REG7[],group:6
>  cookie=0x1030000000000, duration=7135.569s, table=10, n_packets=0, n_bytes=0, idle_age=7135, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=9153 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x7->NXM_NX_REG7[],group:7
>  cookie=0x1030000000000, duration=7135.559s, table=10, n_packets=4, n_bytes=296, idle_age=6942, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.1,tp_dst=443 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x8->NXM_NX_REG7[],group:8
>  cookie=0x1030000000000, duration=7135.553s, table=10, n_packets=0, n_bytes=0, idle_age=7135, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.225.231,tp_dst=443 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x9->NXM_NX_REG7[],group:9
>  cookie=0x1030000000000, duration=7015.068s, table=10, n_packets=0, n_bytes=0, idle_age=7015, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.181.73,tp_dst=8080 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0xa->NXM_NX_REG7[],group:10
>  cookie=0x1000000000000, duration=7135.827s, table=10, n_packets=5, n_bytes=370, idle_age=6946, priority=0 actions=resubmit(,11)
>  cookie=0x1030000000000, duration=7135.812s, table=11, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0x4000/0x4000 actions=controller(reason=no_match,id=3452,userdata=04)
>  cookie=0x1030000000000, duration=7135.567s, table=11, n_packets=4, n_bytes=296, idle_age=6942, priority=200,tcp,reg3=0xac120003,reg4=0x2192b/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=172.18.0.3:6443),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=7124.201s, table=11, n_packets=0, n_bytes=0, idle_age=7124, priority=200,udp,reg3=0xaf40003,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=7124.201s, table=11, n_packets=0, n_bytes=0, idle_age=7124, priority=200,udp,reg3=0xaf40002,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=7124.176s, table=11, n_packets=0, n_bytes=0, idle_age=7124, priority=200,tcp,reg3=0xaf40003,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=7124.176s, table=11, n_packets=0, n_bytes=0, idle_age=7124, priority=200,tcp,reg3=0xaf40002,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=7124.165s, table=11, n_packets=0, n_bytes=0, idle_age=7124, priority=200,tcp,reg3=0xaf40003,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=7124.165s, table=11, n_packets=0, n_bytes=0, idle_age=7124, priority=200,tcp,reg3=0xaf40002,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=7122.275s, table=11, n_packets=0, n_bytes=0, idle_age=7122, priority=200,tcp,reg3=0xac120002,reg4=0x2286d/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=172.18.0.2:10349),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=7007.852s, table=11, n_packets=0, n_bytes=0, idle_age=7007, priority=200,tcp,reg3=0xaf40102,reg4=0x21f90/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.1.2:8080),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5929.248s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,udp,reg3=0xaf40005,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5929.248s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,udp,reg3=0xaf40006,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5929.248s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,udp,reg3=0xaf40004,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5929.238s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,tcp,reg3=0xaf40005,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5929.238s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,tcp,reg3=0xaf40006,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5929.238s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,tcp,reg3=0xaf40004,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5929.229s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,tcp,reg3=0xaf40004,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5929.229s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,tcp,reg3=0xaf40006,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5929.229s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,tcp,reg3=0xaf40005,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.223s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf40007,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.223s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf40009,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.223s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf4000a,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.223s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf4000b,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.223s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf40008,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.213s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,udp,reg3=0xaf4000a,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.213s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,udp,reg3=0xaf40008,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.213s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,udp,reg3=0xaf4000b,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.213s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,udp,reg3=0xaf40007,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.213s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,udp,reg3=0xaf40009,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.204s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf40008,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.203s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf40007,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.203s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf4000b,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.203s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf4000a,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=5928.203s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf40009,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
>  cookie=0x1030000000000, duration=7135.812s, table=11, n_packets=0, n_bytes=0, idle_age=7135, priority=190,reg4=0x20000/0x70000 actions=load:0x1->NXM_NX_REG4[16..18],resubmit(,10)
>  cookie=0x1000000000000, duration=7135.826s, table=11, n_packets=5, n_bytes=370, idle_age=6946, priority=0 actions=resubmit(,12)
>  cookie=0x1020000000000, duration=7135.807s, table=12, n_packets=3220, n_bytes=4801889, idle_age=6829, priority=64990,ct_state=-new+est,ip actions=resubmit(,15)
>  cookie=0x1020000000000, duration=7135.807s, table=12, n_packets=0, n_bytes=0, idle_age=7135, priority=64990,ct_state=-new+rel,ip actions=resubmit(,15)
>  cookie=0x1000000000000, duration=7135.826s, table=12, n_packets=9, n_bytes=666, idle_age=6942, priority=0 actions=resubmit(,13)
>  cookie=0x1000000000000, duration=7135.826s, table=13, n_packets=9, n_bytes=666, idle_age=6942, priority=0 actions=resubmit(,14)
>  cookie=0x1000000000000, duration=7135.826s, table=14, n_packets=9, n_bytes=666, idle_age=6942, priority=0 actions=resubmit(,15)
>  cookie=0x1000000000000, duration=7135.826s, table=15, n_packets=3229, n_bytes=4802555, idle_age=6829, priority=0 actions=resubmit(,16)
>  cookie=0x1010000000000, duration=7135.815s, table=16, n_packets=25, n_bytes=4312, idle_age=6927, priority=210,ip,nw_dst=10.244.1.1 actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
>  cookie=0x1010000000000, duration=7135.815s, table=16, n_packets=0, n_bytes=0, idle_age=7135, priority=210,ct_state=+rpl+trk,ct_mark=0x2/0xf,ip actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
>  cookie=0x1010000000000, duration=7135.815s, table=16, n_packets=88, n_bytes=610339, idle_age=6927, priority=200,ip,reg0=0/0x200,nw_dst=10.244.1.0/24 actions=resubmit(,21)
>  cookie=0x1010000000000, duration=7135.586s, table=16, n_packets=23, n_bytes=4168, idle_age=6927, priority=200,ip,nw_dst=10.244.2.0/24 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:aa:bb:cc:dd:ee:ff,load:0xac120002->NXM_NX_TUN_IPV4_DST[],load:0x1->NXM_NX_REG0[4..7],resubmit(,18)
>  cookie=0x1010000000000, duration=7135.585s, table=16, n_packets=25, n_bytes=4311, idle_age=6927, priority=200,ip,nw_dst=10.244.0.0/24 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:aa:bb:cc:dd:ee:ff,load:0xac120003->NXM_NX_TUN_IPV4_DST[],load:0x1->NXM_NX_REG0[4..7],resubmit(,18)
>  cookie=0x1010000000000, duration=7014.731s, table=16, n_packets=1389, n_bytes=3734917, idle_age=6829, priority=200,ip,reg0=0x200/0x200,nw_dst=10.244.1.2 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:9a:84:26:63:6f:97,resubmit(,18)
>  cookie=0x1010000000000, duration=1904.568s, table=16, n_packets=0, n_bytes=0, idle_age=1904, priority=200,ip,reg0=0x200/0x200,nw_dst=10.244.1.4 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:9e:f4:19:16:ce:0b,resubmit(,18)
>  cookie=0x1030000000000, duration=7135.812s, table=16, n_packets=0, n_bytes=0, idle_age=7135, priority=190,ct_mark=0x10/0x10,reg0=0x202/0x20f actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
>  cookie=0x1040000000000, duration=7135.805s, table=16, n_packets=1552, n_bytes=200572, idle_age=6829, priority=190,ct_state=-rpl+trk,ip,reg0=0x3/0xf,reg4=0/0x100000 actions=resubmit(,17)
>  cookie=0x1040000000000, duration=7135.805s, table=16, n_packets=0, n_bytes=0, idle_age=7135, priority=190,ct_state=-rpl+trk,ip,reg0=0x1/0xf actions=mod_dl_dst:02:60:ef:e6:1d:57,resubmit(,17)
>  cookie=0x1010000000000, duration=7135.816s, table=16, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
>  cookie=0x1040000000000, duration=7135.805s, table=17, n_packets=0, n_bytes=0, idle_age=7135, priority=210,ip,nw_dst=172.18.0.4 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
>  cookie=0x1040000000000, duration=7135.586s, table=17, n_packets=0, n_bytes=0, idle_age=7135, priority=210,ip,nw_dst=172.18.0.2 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
>  cookie=0x1040000000000, duration=7135.585s, table=17, n_packets=1552, n_bytes=200572, idle_age=6829, priority=210,ip,nw_dst=172.18.0.3 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
>  cookie=0x1040000000000, duration=7135.487s, table=17, n_packets=0, n_bytes=0, idle_age=7135, priority=210,ip,nw_dst=10.96.0.0/16 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
>  cookie=0x1040000000000, duration=7135.805s, table=17, n_packets=0, n_bytes=0, idle_age=7135, priority=190,ct_state=+new+trk,ip,reg0=0x1/0xf actions=drop
>  cookie=0x1040000000000, duration=7135.805s, table=17, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
>  cookie=0x1010000000000, duration=7135.816s, table=18, n_packets=1444, n_bytes=2496714, idle_age=6829, priority=210,ip,reg0=0x2/0xf actions=resubmit(,19)
>  cookie=0x1010000000000, duration=7135.816s, table=18, n_packets=145, n_bytes=1494930, idle_age=6927, priority=200,ip actions=dec_ttl,resubmit(,19)
>  cookie=0x1000000000000, duration=7135.826s, table=18, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=resubmit(,19)
>  cookie=0x1030000000000, duration=7135.812s, table=19, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ct_state=+new+trk,ip,reg0=0x22/0xff actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
>  cookie=0x1030000000000, duration=7135.812s, table=19, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ct_state=+new+trk,ip,reg0=0x12/0xff,reg4=0x200000/0x2200000 actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
>  cookie=0x1030000000000, duration=7007.852s, table=19, n_packets=0, n_bytes=0, idle_age=7007, priority=190,ct_state=+new+trk,ip,nw_src=10.244.1.2,nw_dst=10.244.1.2 actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
>  cookie=0x1000000000000, duration=7135.826s, table=19, n_packets=1589, n_bytes=3991644, idle_age=6829, priority=0 actions=resubmit(,20)
>  cookie=0x1030000000000, duration=7135.812s, table=20, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ct_state=+new+trk,ct_mark=0x40/0x40,ip,reg0=0x2/0xf actions=ct(commit,table=21,zone=65521,nat(src=169.254.0.253),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6]))
>  cookie=0x1030000000000, duration=7135.812s, table=20, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ct_state=+new+trk,ct_mark=0x40/0x40,ip,reg0=0x3/0xf actions=ct(commit,table=21,zone=65521,nat(src=10.244.1.1),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6]))
>  cookie=0x1030000000000, duration=7135.812s, table=20, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ct_state=-new-rpl+trk,ct_mark=0x20/0x20,ip actions=ct(table=21,zone=65521,nat)
>  cookie=0x1030000000000, duration=7135.812s, table=20, n_packets=0, n_bytes=0, idle_age=7135, priority=190,ct_state=+new+trk,ct_mark=0x20/0x20,ip,reg0=0x2/0xf actions=ct(commit,table=21,zone=65521,nat(src=10.244.1.1),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5]))
>  cookie=0x1000000000000, duration=7135.826s, table=20, n_packets=1589, n_bytes=3991644, idle_age=6829, priority=0 actions=resubmit(,21)
>  cookie=0x1010000000000, duration=7135.815s, table=21, n_packets=1577, n_bytes=204884, idle_age=6829, priority=200,dl_dst=02:60:ef:e6:1d:57 actions=load:0x8001->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
>  cookie=0x1010000000000, duration=7135.815s, table=21, n_packets=48, n_bytes=8479, idle_age=6927, priority=200,dl_dst=aa:bb:cc:dd:ee:ff actions=load:0x8000->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
>  cookie=0x1010000000000, duration=7014.731s, table=21, n_packets=1456, n_bytes=4338327, idle_age=6829, priority=200,dl_dst=9a:84:26:63:6f:97 actions=load:0x1->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
>  cookie=0x1010000000000, duration=1904.568s, table=21, n_packets=0, n_bytes=0, idle_age=1904, priority=200,dl_dst=9e:f4:19:16:ce:0b actions=load:0x3->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
>  cookie=0x1000000000000, duration=7135.826s, table=21, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=resubmit(,22)
>  cookie=0x1010000000000, duration=7135.815s, table=22, n_packets=32, n_bytes=501096, idle_age=6927, priority=210,pkt_mark=0x80000000/0x80000000,ct_state=-rpl+trk,ip actions=resubmit(,27)
>  cookie=0x1020000000000, duration=7135.807s, table=22, n_packets=1577, n_bytes=204884, idle_age=6829, priority=200,reg0=0x20/0xf0 actions=resubmit(,26)
>  cookie=0x1020000000000, duration=7135.807s, table=22, n_packets=48, n_bytes=8479, idle_age=6927, priority=200,reg0=0x10/0xf0 actions=resubmit(,26)
>  cookie=0x1020000000000, duration=7135.807s, table=22, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0x40/0xf0 actions=resubmit(,26)
>  cookie=0x1020000000000, duration=7135.807s, table=22, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ct_mark=0x40/0x40 actions=resubmit(,27)
>  cookie=0x1000000000000, duration=7135.826s, table=22, n_packets=1572, n_bytes=4088096, idle_age=6829, priority=0 actions=resubmit(,23)
>  cookie=0x1020000000000, duration=7135.701s, table=23, n_packets=0, n_bytes=0, idle_age=7135, priority=64991,conj_id=1 actions=controller(reason=no_match,id=3452,userdata=02,pause),resubmit(,26)
>  cookie=0x1020000000000, duration=7130.689s, table=23, n_packets=0, n_bytes=0, idle_age=7135, priority=64991,ct_state=+rpl+trk,udp,tp_src=53 actions=conjunction(1,1/2)
>  cookie=0x1020000000000, duration=7130.689s, table=23, n_packets=0, n_bytes=0, idle_age=7135, priority=64991,ct_state=+rpl+trk,tcp,tp_src=53 actions=conjunction(1,1/2)
>  cookie=0x1020000000000, duration=7135.807s, table=23, n_packets=1568, n_bytes=4087800, idle_age=6829, priority=64990,ct_state=-new+est,ip actions=resubmit(,26)
>  cookie=0x1020000000000, duration=7135.807s, table=23, n_packets=0, n_bytes=0, idle_age=7135, priority=64990,ct_state=-new+rel,ip actions=resubmit(,26)
>  cookie=0x1000000000000, duration=7135.826s, table=23, n_packets=4, n_bytes=296, idle_age=6946, priority=0 actions=resubmit(,24)
>  cookie=0x1020000000000, duration=19.034s, table=24, n_packets=0, n_bytes=0, idle_age=19, priority=200,reg1=0x3 actions=conjunction(2,2/2)
>  cookie=0x1020000000000, duration=19.040s, table=24, n_packets=0, n_bytes=0, idle_age=19, priority=190,conj_id=2,ip actions=load:0x2->NXM_NX_REG6[],ct(commit,table=26,zone=65520,exec(load:0x2->NXM_NX_CT_LABEL[0..31]))
>  cookie=0x1000000000000, duration=7135.826s, table=24, n_packets=4, n_bytes=296, idle_age=6946, priority=0 actions=resubmit(,25)
>  cookie=0x1020000000000, duration=19.034s, table=25, n_packets=0, n_bytes=0, idle_age=19, priority=200,reg1=0x3 actions=drop
>  cookie=0x1000000000000, duration=7135.826s, table=25, n_packets=4, n_bytes=296, idle_age=6946, priority=0 actions=resubmit(,26)
>  cookie=0x1020000000000, duration=19.040s, table=26, n_packets=0, n_bytes=0, idle_age=19, priority=200,ct_state=+new,ct_label=0x2/0xffffffff,ip actions=resubmit(,27)
>  cookie=0x1020000000000, duration=19.040s, table=26, n_packets=0, n_bytes=0, idle_age=19, priority=200,ct_state=-new,ct_label=0x2/0xffffffff,ip actions=resubmit(,27)
>  cookie=0x1000000000000, duration=7135.826s, table=26, n_packets=3197, n_bytes=4301459, idle_age=6829, priority=0 actions=resubmit(,27)
>  cookie=0x1010000000000, duration=7135.816s, table=27, n_packets=9, n_bytes=666, idle_age=6942, priority=200,ct_state=+new+trk,ct_mark=0/0x20,ip actions=ct(commit,table=28,zone=65520,exec(move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
>  cookie=0x1000000000000, duration=7135.826s, table=27, n_packets=3220, n_bytes=4801889, idle_age=6829, priority=0 actions=resubmit(,28)
>  cookie=0x1030000000000, duration=7135.812s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=210,ct_mark=0x40/0x40,reg0=0x200000/0x600000 actions=IN_PORT
>  cookie=0x1010000000000, duration=7135.816s, table=28, n_packets=3229, n_bytes=4802555, idle_age=6829, priority=200,reg0=0x200000/0x600000 actions=output:NXM_NX_REG1[]
>  cookie=0x1020000000000, duration=7135.807s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0x2400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.01)
>  cookie=0x1020000000000, duration=7135.807s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0x4400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.02)
>  cookie=0x1020000000000, duration=7135.807s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0x6400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.03)
>  cookie=0x1020000000000, duration=7135.807s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0x8400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.04)
>  cookie=0x1020000000000, duration=7135.807s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0xa400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.05)
>  cookie=0x1020000000000, duration=7135.807s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0xc400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.06)
>  cookie=0x1020000000000, duration=7135.807s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0xe400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.07)
>  cookie=0x1000000000000, duration=7135.826s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=drop
command terminated with exit code 1
```

</details>

### Команда: смена политик и сравнение OVS flows

```bash
kubectl delete -f web-deny_all.yaml

kubectl apply -f web-web2-80-alllow.yaml

kubectl exec antrea-agent-m7w9b -n kube-system -- bash -c "ovs-ofctl dump-flows br-int | grep table > a3"

kubectl exec antrea-agent-m7w9b -n kube-system -- diff3 a1 a2 a3
```

<details>
<summary>
Просмотр всех внесенных изменений в политиках на OVS
</summary>

```log
====
1:1,143c
   cookie=0x1000000000000, duration=7076.361s, table=0, n_packets=21, n_bytes=882, idle_age=1844, priority=200,arp actions=resubmit(,1)
   cookie=0x1000000000000, duration=7076.360s, table=0, n_packets=3229, n_bytes=4802555, idle_age=6769, priority=200,ip actions=resubmit(,3)
   cookie=0x1000000000000, duration=7076.361s, table=0, n_packets=46, n_bytes=3448, idle_age=731, priority=0 actions=drop
   cookie=0x1010000000000, duration=7076.350s, table=1, n_packets=4, n_bytes=168, idle_age=6794, priority=200,arp,in_port=32769,arp_spa=10.244.1.1,arp_sha=02:60:ef:e6:1d:57 actions=resubmit(,2)
   cookie=0x1010000000000, duration=6955.265s, table=1, n_packets=8, n_bytes=336, idle_age=6794, priority=200,arp,in_port=1,arp_spa=10.244.1.2,arp_sha=9a:84:26:63:6f:97 actions=resubmit(,2)
   cookie=0x1010000000000, duration=1845.102s, table=1, n_packets=3, n_bytes=126, idle_age=1844, priority=200,arp,in_port=3,arp_spa=10.244.1.4,arp_sha=9e:f4:19:16:ce:0b actions=resubmit(,2)
   cookie=0x1000000000000, duration=7076.361s, table=1, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=drop
   cookie=0x1010000000000, duration=7076.120s, table=2, n_packets=0, n_bytes=0, idle_age=7076, priority=200,arp,arp_tpa=10.244.2.1,arp_op=1 actions=move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[],mod_dl_src:aa:bb:cc:dd:ee:ff,load:0x2->NXM_OF_ARP_OP[],move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[],load:0xaabbccddeeff->NXM_NX_ARP_SHA[],move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[],load:0xaf40201->NXM_OF_ARP_SPA[],IN_PORT
   cookie=0x1010000000000, duration=7076.121s, table=2, n_packets=0, n_bytes=0, idle_age=7076, priority=200,arp,arp_tpa=10.244.0.1,arp_op=1 actions=move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[],mod_dl_src:aa:bb:cc:dd:ee:ff,load:0x2->NXM_OF_ARP_OP[],move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[],load:0xaabbccddeeff->NXM_NX_ARP_SHA[],move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[],load:0xaf40001->NXM_OF_ARP_SPA[],IN_PORT
   cookie=0x1010000000000, duration=7076.351s, table=2, n_packets=21, n_bytes=882, idle_age=1845, priority=190,arp actions=NORMAL
   cookie=0x1000000000000, duration=7076.362s, table=2, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=drop
   cookie=0x1010000000000, duration=7076.351s, table=3, n_packets=32, n_bytes=501096, idle_age=6868, priority=210,ip,in_port=32769,nw_src=10.244.1.1 actions=load:0x2->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
   cookie=0x1010000000000, duration=7076.351s, table=3, n_packets=1444, n_bytes=2496714, idle_age=6769, priority=200,in_port=32769 actions=load:0x2->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[27],resubmit(,4)
   cookie=0x1010000000000, duration=7076.350s, table=3, n_packets=72, n_bytes=1482139, idle_age=6868, priority=200,in_port=32768 actions=load:0x1->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG0[9],resubmit(,5)
   cookie=0x1010000000000, duration=6955.266s, table=3, n_packets=1516, n_bytes=198972, idle_age=6769, priority=190,in_port=1 actions=load:0x3->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
   cookie=0x1010000000000, duration=1845.103s, table=3, n_packets=0, n_bytes=0, idle_age=1845, priority=190,in_port=3 actions=load:0x3->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
   cookie=0x1000000000000, duration=7076.362s, table=3, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=drop
   cookie=0x1010000000000, duration=7076.350s, table=4, n_packets=1476, n_bytes=2997810, idle_age=6769, priority=200,ip,in_port=32769 actions=resubmit(,5)
   cookie=0x1010000000000, duration=6955.266s, table=4, n_packets=1516, n_bytes=198972, idle_age=6769, priority=200,ip,in_port=1,dl_src=9a:84:26:63:6f:97,nw_src=10.244.1.2 actions=resubmit(,5)
   cookie=0x1010000000000, duration=1845.103s, table=4, n_packets=0, n_bytes=0, idle_age=1845, priority=200,ip,in_port=3,dl_src=9e:f4:19:16:ce:0b,nw_src=10.244.1.4 actions=resubmit(,5)
   cookie=0x1000000000000, duration=7076.362s, table=4, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=drop
   cookie=0x1030000000000, duration=7076.347s, table=5, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ip,nw_dst=169.254.0.253 actions=ct(table=6,zone=65521,nat)
   cookie=0x1030000000000, duration=7076.347s, table=5, n_packets=25, n_bytes=4312, idle_age=6868, priority=200,ip,nw_dst=10.244.1.1 actions=ct(table=6,zone=65521,nat)
   cookie=0x1000000000000, duration=7076.362s, table=5, n_packets=3204, n_bytes=4798243, idle_age=6769, priority=0 actions=resubmit(,6)
   cookie=0x1010000000000, duration=7076.351s, table=6, n_packets=3229, n_bytes=4802555, idle_age=6769, priority=200,ip actions=ct(table=7,zone=65520,nat)
   cookie=0x1000000000000, duration=7076.362s, table=6, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=resubmit(,7)
   cookie=0x1010000000000, duration=7076.351s, table=7, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ct_state=+inv+trk,ip actions=drop
   cookie=0x1010000000000, duration=7076.351s, table=7, n_packets=228, n_bytes=2104899, idle_age=6868, priority=190,ct_state=-new+trk,ct_mark=0/0x10,ip actions=resubmit(,12)
   cookie=0x1030000000000, duration=7076.347s, table=7, n_packets=2992, n_bytes=2696990, idle_age=6769, priority=190,ct_state=-new+trk,ct_mark=0x10/0x10,ip actions=load:0x1->NXM_NX_REG0[9],resubmit(,12)
   cookie=0x1010000000000, duration=7076.351s, table=7, n_packets=9, n_bytes=666, idle_age=6883, priority=0 actions=resubmit(,8)
   cookie=0x1030000000000, duration=7076.347s, table=8, n_packets=9, n_bytes=666, idle_age=6883, priority=200,ip actions=resubmit(,9),resubmit(,10)
   cookie=0x1000000000000, duration=7076.362s, table=8, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=resubmit(,9)
   cookie=0x1030000000000, duration=7076.347s, table=9, n_packets=9, n_bytes=666, idle_age=6883, priority=0 actions=load:0x1->NXM_NX_REG4[16..18]
   cookie=0x1030000000000, duration=7076.121s, table=10, n_packets=0, n_bytes=0, idle_age=7076, priority=200,udp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=53 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x5->NXM_NX_REG7[],group:5
   cookie=0x1030000000000, duration=7076.111s, table=10, n_packets=0, n_bytes=0, idle_age=7076, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=53 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x6->NXM_NX_REG7[],group:6
   cookie=0x1030000000000, duration=7076.104s, table=10, n_packets=0, n_bytes=0, idle_age=7076, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=9153 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x7->NXM_NX_REG7[],group:7
   cookie=0x1030000000000, duration=7076.094s, table=10, n_packets=4, n_bytes=296, idle_age=6883, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.1,tp_dst=443 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x8->NXM_NX_REG7[],group:8
   cookie=0x1030000000000, duration=7076.088s, table=10, n_packets=0, n_bytes=0, idle_age=7076, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.225.231,tp_dst=443 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x9->NXM_NX_REG7[],group:9
   cookie=0x1030000000000, duration=6955.603s, table=10, n_packets=0, n_bytes=0, idle_age=6955, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.181.73,tp_dst=8080 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0xa->NXM_NX_REG7[],group:10
   cookie=0x1000000000000, duration=7076.362s, table=10, n_packets=5, n_bytes=370, idle_age=6887, priority=0 actions=resubmit(,11)
   cookie=0x1030000000000, duration=7076.347s, table=11, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0x4000/0x4000 actions=controller(reason=no_match,id=3452,userdata=04)
   cookie=0x1030000000000, duration=7076.102s, table=11, n_packets=4, n_bytes=296, idle_age=6883, priority=200,tcp,reg3=0xac120003,reg4=0x2192b/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=172.18.0.3:6443),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7064.736s, table=11, n_packets=0, n_bytes=0, idle_age=7064, priority=200,udp,reg3=0xaf40003,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7064.736s, table=11, n_packets=0, n_bytes=0, idle_age=7064, priority=200,udp,reg3=0xaf40002,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7064.711s, table=11, n_packets=0, n_bytes=0, idle_age=7064, priority=200,tcp,reg3=0xaf40003,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7064.711s, table=11, n_packets=0, n_bytes=0, idle_age=7064, priority=200,tcp,reg3=0xaf40002,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7064.700s, table=11, n_packets=0, n_bytes=0, idle_age=7064, priority=200,tcp,reg3=0xaf40003,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7064.700s, table=11, n_packets=0, n_bytes=0, idle_age=7064, priority=200,tcp,reg3=0xaf40002,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7062.810s, table=11, n_packets=0, n_bytes=0, idle_age=7062, priority=200,tcp,reg3=0xac120002,reg4=0x2286d/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=172.18.0.2:10349),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6948.387s, table=11, n_packets=0, n_bytes=0, idle_age=6948, priority=200,tcp,reg3=0xaf40102,reg4=0x21f90/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.1.2:8080),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5869.783s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,udp,reg3=0xaf40005,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5869.783s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,udp,reg3=0xaf40006,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5869.783s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,udp,reg3=0xaf40004,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5869.773s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,tcp,reg3=0xaf40005,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5869.773s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,tcp,reg3=0xaf40006,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5869.773s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,tcp,reg3=0xaf40004,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5869.764s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,tcp,reg3=0xaf40004,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5869.764s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,tcp,reg3=0xaf40006,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5869.764s, table=11, n_packets=0, n_bytes=0, idle_age=5869, priority=200,tcp,reg3=0xaf40005,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.758s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf40007,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.758s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf40009,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.758s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf4000a,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.758s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf4000b,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.758s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf40008,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.748s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,udp,reg3=0xaf4000a,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.748s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,udp,reg3=0xaf40008,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.748s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,udp,reg3=0xaf4000b,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.748s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,udp,reg3=0xaf40007,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.748s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,udp,reg3=0xaf40009,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.739s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf40008,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.738s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf40007,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.738s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf4000b,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.738s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf4000a,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5868.738s, table=11, n_packets=0, n_bytes=0, idle_age=5868, priority=200,tcp,reg3=0xaf40009,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7076.347s, table=11, n_packets=0, n_bytes=0, idle_age=7076, priority=190,reg4=0x20000/0x70000 actions=load:0x1->NXM_NX_REG4[16..18],resubmit(,10)
   cookie=0x1000000000000, duration=7076.361s, table=11, n_packets=5, n_bytes=370, idle_age=6887, priority=0 actions=resubmit(,12)
   cookie=0x1020000000000, duration=7076.342s, table=12, n_packets=3220, n_bytes=4801889, idle_age=6769, priority=64990,ct_state=-new+est,ip actions=resubmit(,15)
   cookie=0x1020000000000, duration=7076.342s, table=12, n_packets=0, n_bytes=0, idle_age=7076, priority=64990,ct_state=-new+rel,ip actions=resubmit(,15)
   cookie=0x1000000000000, duration=7076.361s, table=12, n_packets=9, n_bytes=666, idle_age=6883, priority=0 actions=resubmit(,13)
   cookie=0x1000000000000, duration=7076.361s, table=13, n_packets=9, n_bytes=666, idle_age=6883, priority=0 actions=resubmit(,14)
   cookie=0x1000000000000, duration=7076.361s, table=14, n_packets=9, n_bytes=666, idle_age=6883, priority=0 actions=resubmit(,15)
   cookie=0x1000000000000, duration=7076.361s, table=15, n_packets=3229, n_bytes=4802555, idle_age=6769, priority=0 actions=resubmit(,16)
   cookie=0x1010000000000, duration=7076.350s, table=16, n_packets=25, n_bytes=4312, idle_age=6868, priority=210,ip,nw_dst=10.244.1.1 actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1010000000000, duration=7076.350s, table=16, n_packets=0, n_bytes=0, idle_age=7076, priority=210,ct_state=+rpl+trk,ct_mark=0x2/0xf,ip actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1010000000000, duration=7076.350s, table=16, n_packets=88, n_bytes=610339, idle_age=6868, priority=200,ip,reg0=0/0x200,nw_dst=10.244.1.0/24 actions=resubmit(,21)
   cookie=0x1010000000000, duration=7076.121s, table=16, n_packets=23, n_bytes=4168, idle_age=6868, priority=200,ip,nw_dst=10.244.2.0/24 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:aa:bb:cc:dd:ee:ff,load:0xac120002->NXM_NX_TUN_IPV4_DST[],load:0x1->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1010000000000, duration=7076.120s, table=16, n_packets=25, n_bytes=4311, idle_age=6868, priority=200,ip,nw_dst=10.244.0.0/24 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:aa:bb:cc:dd:ee:ff,load:0xac120003->NXM_NX_TUN_IPV4_DST[],load:0x1->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1010000000000, duration=6955.266s, table=16, n_packets=1389, n_bytes=3734917, idle_age=6769, priority=200,ip,reg0=0x200/0x200,nw_dst=10.244.1.2 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:9a:84:26:63:6f:97,resubmit(,18)
   cookie=0x1010000000000, duration=1845.103s, table=16, n_packets=0, n_bytes=0, idle_age=1845, priority=200,ip,reg0=0x200/0x200,nw_dst=10.244.1.4 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:9e:f4:19:16:ce:0b,resubmit(,18)
   cookie=0x1030000000000, duration=7076.347s, table=16, n_packets=0, n_bytes=0, idle_age=7076, priority=190,ct_mark=0x10/0x10,reg0=0x202/0x20f actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1040000000000, duration=7076.340s, table=16, n_packets=1552, n_bytes=200572, idle_age=6769, priority=190,ct_state=-rpl+trk,ip,reg0=0x3/0xf,reg4=0/0x100000 actions=resubmit(,17)
   cookie=0x1040000000000, duration=7076.340s, table=16, n_packets=0, n_bytes=0, idle_age=7076, priority=190,ct_state=-rpl+trk,ip,reg0=0x1/0xf actions=mod_dl_dst:02:60:ef:e6:1d:57,resubmit(,17)
   cookie=0x1010000000000, duration=7076.351s, table=16, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7076.340s, table=17, n_packets=0, n_bytes=0, idle_age=7076, priority=210,ip,nw_dst=172.18.0.4 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7076.121s, table=17, n_packets=0, n_bytes=0, idle_age=7076, priority=210,ip,nw_dst=172.18.0.2 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7076.120s, table=17, n_packets=1552, n_bytes=200572, idle_age=6769, priority=210,ip,nw_dst=172.18.0.3 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7076.022s, table=17, n_packets=0, n_bytes=0, idle_age=7076, priority=210,ip,nw_dst=10.96.0.0/16 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7076.340s, table=17, n_packets=0, n_bytes=0, idle_age=7076, priority=190,ct_state=+new+trk,ip,reg0=0x1/0xf actions=drop
   cookie=0x1040000000000, duration=7076.340s, table=17, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1010000000000, duration=7076.351s, table=18, n_packets=1444, n_bytes=2496714, idle_age=6769, priority=210,ip,reg0=0x2/0xf actions=resubmit(,19)
   cookie=0x1010000000000, duration=7076.351s, table=18, n_packets=145, n_bytes=1494930, idle_age=6868, priority=200,ip actions=dec_ttl,resubmit(,19)
   cookie=0x1000000000000, duration=7076.361s, table=18, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=resubmit(,19)
   cookie=0x1030000000000, duration=7076.347s, table=19, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ct_state=+new+trk,ip,reg0=0x22/0xff actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
   cookie=0x1030000000000, duration=7076.347s, table=19, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ct_state=+new+trk,ip,reg0=0x12/0xff,reg4=0x200000/0x2200000 actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
   cookie=0x1030000000000, duration=6948.387s, table=19, n_packets=0, n_bytes=0, idle_age=6948, priority=190,ct_state=+new+trk,ip,nw_src=10.244.1.2,nw_dst=10.244.1.2 actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
   cookie=0x1000000000000, duration=7076.361s, table=19, n_packets=1589, n_bytes=3991644, idle_age=6769, priority=0 actions=resubmit(,20)
   cookie=0x1030000000000, duration=7076.347s, table=20, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ct_state=+new+trk,ct_mark=0x40/0x40,ip,reg0=0x2/0xf actions=ct(commit,table=21,zone=65521,nat(src=169.254.0.253),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6]))
   cookie=0x1030000000000, duration=7076.347s, table=20, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ct_state=+new+trk,ct_mark=0x40/0x40,ip,reg0=0x3/0xf actions=ct(commit,table=21,zone=65521,nat(src=10.244.1.1),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6]))
   cookie=0x1030000000000, duration=7076.347s, table=20, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ct_state=-new-rpl+trk,ct_mark=0x20/0x20,ip actions=ct(table=21,zone=65521,nat)
   cookie=0x1030000000000, duration=7076.347s, table=20, n_packets=0, n_bytes=0, idle_age=7076, priority=190,ct_state=+new+trk,ct_mark=0x20/0x20,ip,reg0=0x2/0xf actions=ct(commit,table=21,zone=65521,nat(src=10.244.1.1),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5]))
   cookie=0x1000000000000, duration=7076.361s, table=20, n_packets=1589, n_bytes=3991644, idle_age=6769, priority=0 actions=resubmit(,21)
   cookie=0x1010000000000, duration=7076.350s, table=21, n_packets=1577, n_bytes=204884, idle_age=6769, priority=200,dl_dst=02:60:ef:e6:1d:57 actions=load:0x8001->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
   cookie=0x1010000000000, duration=7076.350s, table=21, n_packets=48, n_bytes=8479, idle_age=6868, priority=200,dl_dst=aa:bb:cc:dd:ee:ff actions=load:0x8000->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
   cookie=0x1010000000000, duration=6955.266s, table=21, n_packets=1456, n_bytes=4338327, idle_age=6769, priority=200,dl_dst=9a:84:26:63:6f:97 actions=load:0x1->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
   cookie=0x1010000000000, duration=1845.103s, table=21, n_packets=0, n_bytes=0, idle_age=1845, priority=200,dl_dst=9e:f4:19:16:ce:0b actions=load:0x3->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
   cookie=0x1000000000000, duration=7076.361s, table=21, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=resubmit(,22)
   cookie=0x1010000000000, duration=7076.350s, table=22, n_packets=32, n_bytes=501096, idle_age=6868, priority=210,pkt_mark=0x80000000/0x80000000,ct_state=-rpl+trk,ip actions=resubmit(,27)
   cookie=0x1020000000000, duration=7076.342s, table=22, n_packets=1577, n_bytes=204884, idle_age=6769, priority=200,reg0=0x20/0xf0 actions=resubmit(,26)
   cookie=0x1020000000000, duration=7076.342s, table=22, n_packets=48, n_bytes=8479, idle_age=6868, priority=200,reg0=0x10/0xf0 actions=resubmit(,26)
   cookie=0x1020000000000, duration=7076.342s, table=22, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0x40/0xf0 actions=resubmit(,26)
   cookie=0x1020000000000, duration=7076.342s, table=22, n_packets=0, n_bytes=0, idle_age=7076, priority=200,ct_mark=0x40/0x40 actions=resubmit(,27)
   cookie=0x1000000000000, duration=7076.361s, table=22, n_packets=1572, n_bytes=4088096, idle_age=6769, priority=0 actions=resubmit(,23)
   cookie=0x1020000000000, duration=7076.236s, table=23, n_packets=0, n_bytes=0, idle_age=7076, priority=64991,conj_id=1 actions=controller(reason=no_match,id=3452,userdata=02,pause),resubmit(,26)
   cookie=0x1020000000000, duration=7071.224s, table=23, n_packets=0, n_bytes=0, idle_age=7076, priority=64991,ct_state=+rpl+trk,udp,tp_src=53 actions=conjunction(1,1/2)
   cookie=0x1020000000000, duration=7071.224s, table=23, n_packets=0, n_bytes=0, idle_age=7076, priority=64991,ct_state=+rpl+trk,tcp,tp_src=53 actions=conjunction(1,1/2)
   cookie=0x1020000000000, duration=7076.342s, table=23, n_packets=1568, n_bytes=4087800, idle_age=6769, priority=64990,ct_state=-new+est,ip actions=resubmit(,26)
   cookie=0x1020000000000, duration=7076.342s, table=23, n_packets=0, n_bytes=0, idle_age=7076, priority=64990,ct_state=-new+rel,ip actions=resubmit(,26)
   cookie=0x1000000000000, duration=7076.361s, table=23, n_packets=4, n_bytes=296, idle_age=6887, priority=0 actions=resubmit(,24)
   cookie=0x1000000000000, duration=7076.361s, table=24, n_packets=4, n_bytes=296, idle_age=6887, priority=0 actions=resubmit(,25)
   cookie=0x1000000000000, duration=7076.361s, table=25, n_packets=4, n_bytes=296, idle_age=6887, priority=0 actions=resubmit(,26)
   cookie=0x1000000000000, duration=7076.361s, table=26, n_packets=3197, n_bytes=4301459, idle_age=6769, priority=0 actions=resubmit(,27)
   cookie=0x1010000000000, duration=7076.351s, table=27, n_packets=9, n_bytes=666, idle_age=6883, priority=200,ct_state=+new+trk,ct_mark=0/0x20,ip actions=ct(commit,table=28,zone=65520,exec(move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
   cookie=0x1000000000000, duration=7076.361s, table=27, n_packets=3220, n_bytes=4801889, idle_age=6769, priority=0 actions=resubmit(,28)
   cookie=0x1030000000000, duration=7076.347s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=210,ct_mark=0x40/0x40,reg0=0x200000/0x600000 actions=IN_PORT
   cookie=0x1010000000000, duration=7076.351s, table=28, n_packets=3229, n_bytes=4802555, idle_age=6769, priority=200,reg0=0x200000/0x600000 actions=output:NXM_NX_REG1[]
   cookie=0x1020000000000, duration=7076.342s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0x2400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.01)
   cookie=0x1020000000000, duration=7076.342s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0x4400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.02)
   cookie=0x1020000000000, duration=7076.342s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0x6400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.03)
   cookie=0x1020000000000, duration=7076.342s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0x8400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.04)
   cookie=0x1020000000000, duration=7076.342s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0xa400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.05)
   cookie=0x1020000000000, duration=7076.342s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0xc400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.06)
   cookie=0x1020000000000, duration=7076.342s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=200,reg0=0xe400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.07)
   cookie=0x1000000000000, duration=7076.361s, table=28, n_packets=0, n_bytes=0, idle_age=7076, priority=0 actions=drop
2:1,148c
   cookie=0x1000000000000, duration=7135.827s, table=0, n_packets=21, n_bytes=882, idle_age=1904, priority=200,arp actions=resubmit(,1)
   cookie=0x1000000000000, duration=7135.826s, table=0, n_packets=3229, n_bytes=4802555, idle_age=6829, priority=200,ip actions=resubmit(,3)
   cookie=0x1000000000000, duration=7135.827s, table=0, n_packets=46, n_bytes=3448, idle_age=790, priority=0 actions=drop
   cookie=0x1010000000000, duration=7135.816s, table=1, n_packets=4, n_bytes=168, idle_age=6853, priority=200,arp,in_port=32769,arp_spa=10.244.1.1,arp_sha=02:60:ef:e6:1d:57 actions=resubmit(,2)
   cookie=0x1010000000000, duration=7014.731s, table=1, n_packets=8, n_bytes=336, idle_age=6853, priority=200,arp,in_port=1,arp_spa=10.244.1.2,arp_sha=9a:84:26:63:6f:97 actions=resubmit(,2)
   cookie=0x1010000000000, duration=1904.568s, table=1, n_packets=3, n_bytes=126, idle_age=1904, priority=200,arp,in_port=3,arp_spa=10.244.1.4,arp_sha=9e:f4:19:16:ce:0b actions=resubmit(,2)
   cookie=0x1000000000000, duration=7135.827s, table=1, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=drop
   cookie=0x1010000000000, duration=7135.586s, table=2, n_packets=0, n_bytes=0, idle_age=7135, priority=200,arp,arp_tpa=10.244.2.1,arp_op=1 actions=move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[],mod_dl_src:aa:bb:cc:dd:ee:ff,load:0x2->NXM_OF_ARP_OP[],move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[],load:0xaabbccddeeff->NXM_NX_ARP_SHA[],move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[],load:0xaf40201->NXM_OF_ARP_SPA[],IN_PORT
   cookie=0x1010000000000, duration=7135.586s, table=2, n_packets=0, n_bytes=0, idle_age=7135, priority=200,arp,arp_tpa=10.244.0.1,arp_op=1 actions=move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[],mod_dl_src:aa:bb:cc:dd:ee:ff,load:0x2->NXM_OF_ARP_OP[],move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[],load:0xaabbccddeeff->NXM_NX_ARP_SHA[],move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[],load:0xaf40001->NXM_OF_ARP_SPA[],IN_PORT
   cookie=0x1010000000000, duration=7135.816s, table=2, n_packets=21, n_bytes=882, idle_age=1904, priority=190,arp actions=NORMAL
   cookie=0x1000000000000, duration=7135.827s, table=2, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=drop
   cookie=0x1010000000000, duration=7135.816s, table=3, n_packets=32, n_bytes=501096, idle_age=6927, priority=210,ip,in_port=32769,nw_src=10.244.1.1 actions=load:0x2->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
   cookie=0x1010000000000, duration=7135.816s, table=3, n_packets=1444, n_bytes=2496714, idle_age=6829, priority=200,in_port=32769 actions=load:0x2->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[27],resubmit(,4)
   cookie=0x1010000000000, duration=7135.815s, table=3, n_packets=72, n_bytes=1482139, idle_age=6927, priority=200,in_port=32768 actions=load:0x1->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG0[9],resubmit(,5)
   cookie=0x1010000000000, duration=7014.731s, table=3, n_packets=1516, n_bytes=198972, idle_age=6829, priority=190,in_port=1 actions=load:0x3->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
   cookie=0x1010000000000, duration=1904.568s, table=3, n_packets=0, n_bytes=0, idle_age=1904, priority=190,in_port=3 actions=load:0x3->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
   cookie=0x1000000000000, duration=7135.827s, table=3, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=drop
   cookie=0x1010000000000, duration=7135.815s, table=4, n_packets=1476, n_bytes=2997810, idle_age=6829, priority=200,ip,in_port=32769 actions=resubmit(,5)
   cookie=0x1010000000000, duration=7014.731s, table=4, n_packets=1516, n_bytes=198972, idle_age=6829, priority=200,ip,in_port=1,dl_src=9a:84:26:63:6f:97,nw_src=10.244.1.2 actions=resubmit(,5)
   cookie=0x1010000000000, duration=1904.568s, table=4, n_packets=0, n_bytes=0, idle_age=1904, priority=200,ip,in_port=3,dl_src=9e:f4:19:16:ce:0b,nw_src=10.244.1.4 actions=resubmit(,5)
   cookie=0x1000000000000, duration=7135.827s, table=4, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=drop
   cookie=0x1030000000000, duration=7135.812s, table=5, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ip,nw_dst=169.254.0.253 actions=ct(table=6,zone=65521,nat)
   cookie=0x1030000000000, duration=7135.812s, table=5, n_packets=25, n_bytes=4312, idle_age=6927, priority=200,ip,nw_dst=10.244.1.1 actions=ct(table=6,zone=65521,nat)
   cookie=0x1000000000000, duration=7135.827s, table=5, n_packets=3204, n_bytes=4798243, idle_age=6829, priority=0 actions=resubmit(,6)
   cookie=0x1010000000000, duration=7135.816s, table=6, n_packets=3229, n_bytes=4802555, idle_age=6829, priority=200,ip actions=ct(table=7,zone=65520,nat)
   cookie=0x1000000000000, duration=7135.827s, table=6, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=resubmit(,7)
   cookie=0x1010000000000, duration=7135.816s, table=7, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ct_state=+inv+trk,ip actions=drop
   cookie=0x1010000000000, duration=7135.816s, table=7, n_packets=228, n_bytes=2104899, idle_age=6927, priority=190,ct_state=-new+trk,ct_mark=0/0x10,ip actions=resubmit(,12)
   cookie=0x1030000000000, duration=7135.812s, table=7, n_packets=2992, n_bytes=2696990, idle_age=6829, priority=190,ct_state=-new+trk,ct_mark=0x10/0x10,ip actions=load:0x1->NXM_NX_REG0[9],resubmit(,12)
   cookie=0x1010000000000, duration=7135.816s, table=7, n_packets=9, n_bytes=666, idle_age=6942, priority=0 actions=resubmit(,8)
   cookie=0x1030000000000, duration=7135.812s, table=8, n_packets=9, n_bytes=666, idle_age=6942, priority=200,ip actions=resubmit(,9),resubmit(,10)
   cookie=0x1000000000000, duration=7135.827s, table=8, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=resubmit(,9)
   cookie=0x1030000000000, duration=7135.812s, table=9, n_packets=9, n_bytes=666, idle_age=6942, priority=0 actions=load:0x1->NXM_NX_REG4[16..18]
   cookie=0x1030000000000, duration=7135.586s, table=10, n_packets=0, n_bytes=0, idle_age=7135, priority=200,udp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=53 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x5->NXM_NX_REG7[],group:5
   cookie=0x1030000000000, duration=7135.576s, table=10, n_packets=0, n_bytes=0, idle_age=7135, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=53 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x6->NXM_NX_REG7[],group:6
   cookie=0x1030000000000, duration=7135.569s, table=10, n_packets=0, n_bytes=0, idle_age=7135, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=9153 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x7->NXM_NX_REG7[],group:7
   cookie=0x1030000000000, duration=7135.559s, table=10, n_packets=4, n_bytes=296, idle_age=6942, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.1,tp_dst=443 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x8->NXM_NX_REG7[],group:8
   cookie=0x1030000000000, duration=7135.553s, table=10, n_packets=0, n_bytes=0, idle_age=7135, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.225.231,tp_dst=443 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x9->NXM_NX_REG7[],group:9
   cookie=0x1030000000000, duration=7015.068s, table=10, n_packets=0, n_bytes=0, idle_age=7015, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.181.73,tp_dst=8080 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0xa->NXM_NX_REG7[],group:10
   cookie=0x1000000000000, duration=7135.827s, table=10, n_packets=5, n_bytes=370, idle_age=6946, priority=0 actions=resubmit(,11)
   cookie=0x1030000000000, duration=7135.812s, table=11, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0x4000/0x4000 actions=controller(reason=no_match,id=3452,userdata=04)
   cookie=0x1030000000000, duration=7135.567s, table=11, n_packets=4, n_bytes=296, idle_age=6942, priority=200,tcp,reg3=0xac120003,reg4=0x2192b/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=172.18.0.3:6443),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7124.201s, table=11, n_packets=0, n_bytes=0, idle_age=7124, priority=200,udp,reg3=0xaf40003,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7124.201s, table=11, n_packets=0, n_bytes=0, idle_age=7124, priority=200,udp,reg3=0xaf40002,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7124.176s, table=11, n_packets=0, n_bytes=0, idle_age=7124, priority=200,tcp,reg3=0xaf40003,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7124.176s, table=11, n_packets=0, n_bytes=0, idle_age=7124, priority=200,tcp,reg3=0xaf40002,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7124.165s, table=11, n_packets=0, n_bytes=0, idle_age=7124, priority=200,tcp,reg3=0xaf40003,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7124.165s, table=11, n_packets=0, n_bytes=0, idle_age=7124, priority=200,tcp,reg3=0xaf40002,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7122.275s, table=11, n_packets=0, n_bytes=0, idle_age=7122, priority=200,tcp,reg3=0xac120002,reg4=0x2286d/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=172.18.0.2:10349),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7007.852s, table=11, n_packets=0, n_bytes=0, idle_age=7007, priority=200,tcp,reg3=0xaf40102,reg4=0x21f90/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.1.2:8080),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5929.248s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,udp,reg3=0xaf40005,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5929.248s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,udp,reg3=0xaf40006,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5929.248s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,udp,reg3=0xaf40004,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5929.238s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,tcp,reg3=0xaf40005,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5929.238s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,tcp,reg3=0xaf40006,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5929.238s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,tcp,reg3=0xaf40004,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5929.229s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,tcp,reg3=0xaf40004,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5929.229s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,tcp,reg3=0xaf40006,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5929.229s, table=11, n_packets=0, n_bytes=0, idle_age=5929, priority=200,tcp,reg3=0xaf40005,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.223s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf40007,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.223s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf40009,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.223s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf4000a,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.223s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf4000b,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.223s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf40008,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.213s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,udp,reg3=0xaf4000a,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.213s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,udp,reg3=0xaf40008,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.213s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,udp,reg3=0xaf4000b,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.213s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,udp,reg3=0xaf40007,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.213s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,udp,reg3=0xaf40009,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.204s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf40008,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.203s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf40007,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.203s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf4000b,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.203s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf4000a,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=5928.203s, table=11, n_packets=0, n_bytes=0, idle_age=5928, priority=200,tcp,reg3=0xaf40009,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7135.812s, table=11, n_packets=0, n_bytes=0, idle_age=7135, priority=190,reg4=0x20000/0x70000 actions=load:0x1->NXM_NX_REG4[16..18],resubmit(,10)
   cookie=0x1000000000000, duration=7135.826s, table=11, n_packets=5, n_bytes=370, idle_age=6946, priority=0 actions=resubmit(,12)
   cookie=0x1020000000000, duration=7135.807s, table=12, n_packets=3220, n_bytes=4801889, idle_age=6829, priority=64990,ct_state=-new+est,ip actions=resubmit(,15)
   cookie=0x1020000000000, duration=7135.807s, table=12, n_packets=0, n_bytes=0, idle_age=7135, priority=64990,ct_state=-new+rel,ip actions=resubmit(,15)
   cookie=0x1000000000000, duration=7135.826s, table=12, n_packets=9, n_bytes=666, idle_age=6942, priority=0 actions=resubmit(,13)
   cookie=0x1000000000000, duration=7135.826s, table=13, n_packets=9, n_bytes=666, idle_age=6942, priority=0 actions=resubmit(,14)
   cookie=0x1000000000000, duration=7135.826s, table=14, n_packets=9, n_bytes=666, idle_age=6942, priority=0 actions=resubmit(,15)
   cookie=0x1000000000000, duration=7135.826s, table=15, n_packets=3229, n_bytes=4802555, idle_age=6829, priority=0 actions=resubmit(,16)
   cookie=0x1010000000000, duration=7135.815s, table=16, n_packets=25, n_bytes=4312, idle_age=6927, priority=210,ip,nw_dst=10.244.1.1 actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1010000000000, duration=7135.815s, table=16, n_packets=0, n_bytes=0, idle_age=7135, priority=210,ct_state=+rpl+trk,ct_mark=0x2/0xf,ip actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1010000000000, duration=7135.815s, table=16, n_packets=88, n_bytes=610339, idle_age=6927, priority=200,ip,reg0=0/0x200,nw_dst=10.244.1.0/24 actions=resubmit(,21)
   cookie=0x1010000000000, duration=7135.586s, table=16, n_packets=23, n_bytes=4168, idle_age=6927, priority=200,ip,nw_dst=10.244.2.0/24 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:aa:bb:cc:dd:ee:ff,load:0xac120002->NXM_NX_TUN_IPV4_DST[],load:0x1->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1010000000000, duration=7135.585s, table=16, n_packets=25, n_bytes=4311, idle_age=6927, priority=200,ip,nw_dst=10.244.0.0/24 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:aa:bb:cc:dd:ee:ff,load:0xac120003->NXM_NX_TUN_IPV4_DST[],load:0x1->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1010000000000, duration=7014.731s, table=16, n_packets=1389, n_bytes=3734917, idle_age=6829, priority=200,ip,reg0=0x200/0x200,nw_dst=10.244.1.2 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:9a:84:26:63:6f:97,resubmit(,18)
   cookie=0x1010000000000, duration=1904.568s, table=16, n_packets=0, n_bytes=0, idle_age=1904, priority=200,ip,reg0=0x200/0x200,nw_dst=10.244.1.4 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:9e:f4:19:16:ce:0b,resubmit(,18)
   cookie=0x1030000000000, duration=7135.812s, table=16, n_packets=0, n_bytes=0, idle_age=7135, priority=190,ct_mark=0x10/0x10,reg0=0x202/0x20f actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1040000000000, duration=7135.805s, table=16, n_packets=1552, n_bytes=200572, idle_age=6829, priority=190,ct_state=-rpl+trk,ip,reg0=0x3/0xf,reg4=0/0x100000 actions=resubmit(,17)
   cookie=0x1040000000000, duration=7135.805s, table=16, n_packets=0, n_bytes=0, idle_age=7135, priority=190,ct_state=-rpl+trk,ip,reg0=0x1/0xf actions=mod_dl_dst:02:60:ef:e6:1d:57,resubmit(,17)
   cookie=0x1010000000000, duration=7135.816s, table=16, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7135.805s, table=17, n_packets=0, n_bytes=0, idle_age=7135, priority=210,ip,nw_dst=172.18.0.4 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7135.586s, table=17, n_packets=0, n_bytes=0, idle_age=7135, priority=210,ip,nw_dst=172.18.0.2 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7135.585s, table=17, n_packets=1552, n_bytes=200572, idle_age=6829, priority=210,ip,nw_dst=172.18.0.3 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7135.487s, table=17, n_packets=0, n_bytes=0, idle_age=7135, priority=210,ip,nw_dst=10.96.0.0/16 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7135.805s, table=17, n_packets=0, n_bytes=0, idle_age=7135, priority=190,ct_state=+new+trk,ip,reg0=0x1/0xf actions=drop
   cookie=0x1040000000000, duration=7135.805s, table=17, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1010000000000, duration=7135.816s, table=18, n_packets=1444, n_bytes=2496714, idle_age=6829, priority=210,ip,reg0=0x2/0xf actions=resubmit(,19)
   cookie=0x1010000000000, duration=7135.816s, table=18, n_packets=145, n_bytes=1494930, idle_age=6927, priority=200,ip actions=dec_ttl,resubmit(,19)
   cookie=0x1000000000000, duration=7135.826s, table=18, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=resubmit(,19)
   cookie=0x1030000000000, duration=7135.812s, table=19, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ct_state=+new+trk,ip,reg0=0x22/0xff actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
   cookie=0x1030000000000, duration=7135.812s, table=19, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ct_state=+new+trk,ip,reg0=0x12/0xff,reg4=0x200000/0x2200000 actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
   cookie=0x1030000000000, duration=7007.852s, table=19, n_packets=0, n_bytes=0, idle_age=7007, priority=190,ct_state=+new+trk,ip,nw_src=10.244.1.2,nw_dst=10.244.1.2 actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
   cookie=0x1000000000000, duration=7135.826s, table=19, n_packets=1589, n_bytes=3991644, idle_age=6829, priority=0 actions=resubmit(,20)
   cookie=0x1030000000000, duration=7135.812s, table=20, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ct_state=+new+trk,ct_mark=0x40/0x40,ip,reg0=0x2/0xf actions=ct(commit,table=21,zone=65521,nat(src=169.254.0.253),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6]))
   cookie=0x1030000000000, duration=7135.812s, table=20, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ct_state=+new+trk,ct_mark=0x40/0x40,ip,reg0=0x3/0xf actions=ct(commit,table=21,zone=65521,nat(src=10.244.1.1),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6]))
   cookie=0x1030000000000, duration=7135.812s, table=20, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ct_state=-new-rpl+trk,ct_mark=0x20/0x20,ip actions=ct(table=21,zone=65521,nat)
   cookie=0x1030000000000, duration=7135.812s, table=20, n_packets=0, n_bytes=0, idle_age=7135, priority=190,ct_state=+new+trk,ct_mark=0x20/0x20,ip,reg0=0x2/0xf actions=ct(commit,table=21,zone=65521,nat(src=10.244.1.1),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5]))
   cookie=0x1000000000000, duration=7135.826s, table=20, n_packets=1589, n_bytes=3991644, idle_age=6829, priority=0 actions=resubmit(,21)
   cookie=0x1010000000000, duration=7135.815s, table=21, n_packets=1577, n_bytes=204884, idle_age=6829, priority=200,dl_dst=02:60:ef:e6:1d:57 actions=load:0x8001->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
   cookie=0x1010000000000, duration=7135.815s, table=21, n_packets=48, n_bytes=8479, idle_age=6927, priority=200,dl_dst=aa:bb:cc:dd:ee:ff actions=load:0x8000->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
   cookie=0x1010000000000, duration=7014.731s, table=21, n_packets=1456, n_bytes=4338327, idle_age=6829, priority=200,dl_dst=9a:84:26:63:6f:97 actions=load:0x1->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
   cookie=0x1010000000000, duration=1904.568s, table=21, n_packets=0, n_bytes=0, idle_age=1904, priority=200,dl_dst=9e:f4:19:16:ce:0b actions=load:0x3->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
   cookie=0x1000000000000, duration=7135.826s, table=21, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=resubmit(,22)
   cookie=0x1010000000000, duration=7135.815s, table=22, n_packets=32, n_bytes=501096, idle_age=6927, priority=210,pkt_mark=0x80000000/0x80000000,ct_state=-rpl+trk,ip actions=resubmit(,27)
   cookie=0x1020000000000, duration=7135.807s, table=22, n_packets=1577, n_bytes=204884, idle_age=6829, priority=200,reg0=0x20/0xf0 actions=resubmit(,26)
   cookie=0x1020000000000, duration=7135.807s, table=22, n_packets=48, n_bytes=8479, idle_age=6927, priority=200,reg0=0x10/0xf0 actions=resubmit(,26)
   cookie=0x1020000000000, duration=7135.807s, table=22, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0x40/0xf0 actions=resubmit(,26)
   cookie=0x1020000000000, duration=7135.807s, table=22, n_packets=0, n_bytes=0, idle_age=7135, priority=200,ct_mark=0x40/0x40 actions=resubmit(,27)
   cookie=0x1000000000000, duration=7135.826s, table=22, n_packets=1572, n_bytes=4088096, idle_age=6829, priority=0 actions=resubmit(,23)
   cookie=0x1020000000000, duration=7135.701s, table=23, n_packets=0, n_bytes=0, idle_age=7135, priority=64991,conj_id=1 actions=controller(reason=no_match,id=3452,userdata=02,pause),resubmit(,26)
   cookie=0x1020000000000, duration=7130.689s, table=23, n_packets=0, n_bytes=0, idle_age=7135, priority=64991,ct_state=+rpl+trk,udp,tp_src=53 actions=conjunction(1,1/2)
   cookie=0x1020000000000, duration=7130.689s, table=23, n_packets=0, n_bytes=0, idle_age=7135, priority=64991,ct_state=+rpl+trk,tcp,tp_src=53 actions=conjunction(1,1/2)
   cookie=0x1020000000000, duration=7135.807s, table=23, n_packets=1568, n_bytes=4087800, idle_age=6829, priority=64990,ct_state=-new+est,ip actions=resubmit(,26)
   cookie=0x1020000000000, duration=7135.807s, table=23, n_packets=0, n_bytes=0, idle_age=7135, priority=64990,ct_state=-new+rel,ip actions=resubmit(,26)
   cookie=0x1000000000000, duration=7135.826s, table=23, n_packets=4, n_bytes=296, idle_age=6946, priority=0 actions=resubmit(,24)
   cookie=0x1020000000000, duration=19.034s, table=24, n_packets=0, n_bytes=0, idle_age=19, priority=200,reg1=0x3 actions=conjunction(2,2/2)
   cookie=0x1020000000000, duration=19.040s, table=24, n_packets=0, n_bytes=0, idle_age=19, priority=190,conj_id=2,ip actions=load:0x2->NXM_NX_REG6[],ct(commit,table=26,zone=65520,exec(load:0x2->NXM_NX_CT_LABEL[0..31]))
   cookie=0x1000000000000, duration=7135.826s, table=24, n_packets=4, n_bytes=296, idle_age=6946, priority=0 actions=resubmit(,25)
   cookie=0x1020000000000, duration=19.034s, table=25, n_packets=0, n_bytes=0, idle_age=19, priority=200,reg1=0x3 actions=drop
   cookie=0x1000000000000, duration=7135.826s, table=25, n_packets=4, n_bytes=296, idle_age=6946, priority=0 actions=resubmit(,26)
   cookie=0x1020000000000, duration=19.040s, table=26, n_packets=0, n_bytes=0, idle_age=19, priority=200,ct_state=+new,ct_label=0x2/0xffffffff,ip actions=resubmit(,27)
   cookie=0x1020000000000, duration=19.040s, table=26, n_packets=0, n_bytes=0, idle_age=19, priority=200,ct_state=-new,ct_label=0x2/0xffffffff,ip actions=resubmit(,27)
   cookie=0x1000000000000, duration=7135.826s, table=26, n_packets=3197, n_bytes=4301459, idle_age=6829, priority=0 actions=resubmit(,27)
   cookie=0x1010000000000, duration=7135.816s, table=27, n_packets=9, n_bytes=666, idle_age=6942, priority=200,ct_state=+new+trk,ct_mark=0/0x20,ip actions=ct(commit,table=28,zone=65520,exec(move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
   cookie=0x1000000000000, duration=7135.826s, table=27, n_packets=3220, n_bytes=4801889, idle_age=6829, priority=0 actions=resubmit(,28)
   cookie=0x1030000000000, duration=7135.812s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=210,ct_mark=0x40/0x40,reg0=0x200000/0x600000 actions=IN_PORT
   cookie=0x1010000000000, duration=7135.816s, table=28, n_packets=3229, n_bytes=4802555, idle_age=6829, priority=200,reg0=0x200000/0x600000 actions=output:NXM_NX_REG1[]
   cookie=0x1020000000000, duration=7135.807s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0x2400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.01)
   cookie=0x1020000000000, duration=7135.807s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0x4400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.02)
   cookie=0x1020000000000, duration=7135.807s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0x6400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.03)
   cookie=0x1020000000000, duration=7135.807s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0x8400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.04)
   cookie=0x1020000000000, duration=7135.807s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0xa400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.05)
   cookie=0x1020000000000, duration=7135.807s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0xc400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.06)
   cookie=0x1020000000000, duration=7135.807s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=200,reg0=0xe400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.07)
   cookie=0x1000000000000, duration=7135.826s, table=28, n_packets=0, n_bytes=0, idle_age=7135, priority=0 actions=drop
3:1,153c
   cookie=0x1000000000000, duration=7433.036s, table=0, n_packets=21, n_bytes=882, idle_age=2201, priority=200,arp actions=resubmit(,1)
   cookie=0x1000000000000, duration=7433.035s, table=0, n_packets=3229, n_bytes=4802555, idle_age=7126, priority=200,ip actions=resubmit(,3)
   cookie=0x1000000000000, duration=7433.036s, table=0, n_packets=46, n_bytes=3448, idle_age=1087, priority=0 actions=drop
   cookie=0x1010000000000, duration=7433.025s, table=1, n_packets=4, n_bytes=168, idle_age=7150, priority=200,arp,in_port=32769,arp_spa=10.244.1.1,arp_sha=02:60:ef:e6:1d:57 actions=resubmit(,2)
   cookie=0x1010000000000, duration=7311.940s, table=1, n_packets=8, n_bytes=336, idle_age=7150, priority=200,arp,in_port=1,arp_spa=10.244.1.2,arp_sha=9a:84:26:63:6f:97 actions=resubmit(,2)
   cookie=0x1010000000000, duration=2201.777s, table=1, n_packets=3, n_bytes=126, idle_age=2201, priority=200,arp,in_port=3,arp_spa=10.244.1.4,arp_sha=9e:f4:19:16:ce:0b actions=resubmit(,2)
   cookie=0x1000000000000, duration=7433.036s, table=1, n_packets=0, n_bytes=0, idle_age=7433, priority=0 actions=drop
   cookie=0x1010000000000, duration=7432.795s, table=2, n_packets=0, n_bytes=0, idle_age=7432, priority=200,arp,arp_tpa=10.244.2.1,arp_op=1 actions=move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[],mod_dl_src:aa:bb:cc:dd:ee:ff,load:0x2->NXM_OF_ARP_OP[],move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[],load:0xaabbccddeeff->NXM_NX_ARP_SHA[],move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[],load:0xaf40201->NXM_OF_ARP_SPA[],IN_PORT
   cookie=0x1010000000000, duration=7432.795s, table=2, n_packets=0, n_bytes=0, idle_age=7432, priority=200,arp,arp_tpa=10.244.0.1,arp_op=1 actions=move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[],mod_dl_src:aa:bb:cc:dd:ee:ff,load:0x2->NXM_OF_ARP_OP[],move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[],load:0xaabbccddeeff->NXM_NX_ARP_SHA[],move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[],load:0xaf40001->NXM_OF_ARP_SPA[],IN_PORT
   cookie=0x1010000000000, duration=7433.025s, table=2, n_packets=21, n_bytes=882, idle_age=2201, priority=190,arp actions=NORMAL
   cookie=0x1000000000000, duration=7433.036s, table=2, n_packets=0, n_bytes=0, idle_age=7433, priority=0 actions=drop
   cookie=0x1010000000000, duration=7433.025s, table=3, n_packets=32, n_bytes=501096, idle_age=7225, priority=210,ip,in_port=32769,nw_src=10.244.1.1 actions=load:0x2->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
   cookie=0x1010000000000, duration=7433.025s, table=3, n_packets=1444, n_bytes=2496714, idle_age=7126, priority=200,in_port=32769 actions=load:0x2->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[27],resubmit(,4)
   cookie=0x1010000000000, duration=7433.024s, table=3, n_packets=72, n_bytes=1482139, idle_age=7225, priority=200,in_port=32768 actions=load:0x1->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG0[9],resubmit(,5)
   cookie=0x1010000000000, duration=7311.940s, table=3, n_packets=1516, n_bytes=198972, idle_age=7126, priority=190,in_port=1 actions=load:0x3->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
   cookie=0x1010000000000, duration=2201.777s, table=3, n_packets=0, n_bytes=0, idle_age=2201, priority=190,in_port=3 actions=load:0x3->NXM_NX_REG0[0..3],load:0x1->NXM_NX_REG4[28],resubmit(,4)
   cookie=0x1000000000000, duration=7433.036s, table=3, n_packets=0, n_bytes=0, idle_age=7433, priority=0 actions=drop
   cookie=0x1010000000000, duration=7433.024s, table=4, n_packets=1476, n_bytes=2997810, idle_age=7126, priority=200,ip,in_port=32769 actions=resubmit(,5)
   cookie=0x1010000000000, duration=7311.940s, table=4, n_packets=1516, n_bytes=198972, idle_age=7126, priority=200,ip,in_port=1,dl_src=9a:84:26:63:6f:97,nw_src=10.244.1.2 actions=resubmit(,5)
   cookie=0x1010000000000, duration=2201.777s, table=4, n_packets=0, n_bytes=0, idle_age=2201, priority=200,ip,in_port=3,dl_src=9e:f4:19:16:ce:0b,nw_src=10.244.1.4 actions=resubmit(,5)
   cookie=0x1000000000000, duration=7433.036s, table=4, n_packets=0, n_bytes=0, idle_age=7433, priority=0 actions=drop
   cookie=0x1030000000000, duration=7433.021s, table=5, n_packets=0, n_bytes=0, idle_age=7433, priority=200,ip,nw_dst=169.254.0.253 actions=ct(table=6,zone=65521,nat)
   cookie=0x1030000000000, duration=7433.021s, table=5, n_packets=25, n_bytes=4312, idle_age=7225, priority=200,ip,nw_dst=10.244.1.1 actions=ct(table=6,zone=65521,nat)
   cookie=0x1000000000000, duration=7433.036s, table=5, n_packets=3204, n_bytes=4798243, idle_age=7126, priority=0 actions=resubmit(,6)
   cookie=0x1010000000000, duration=7433.025s, table=6, n_packets=3229, n_bytes=4802555, idle_age=7126, priority=200,ip actions=ct(table=7,zone=65520,nat)
   cookie=0x1000000000000, duration=7433.036s, table=6, n_packets=0, n_bytes=0, idle_age=7433, priority=0 actions=resubmit(,7)
   cookie=0x1010000000000, duration=7433.025s, table=7, n_packets=0, n_bytes=0, idle_age=7433, priority=200,ct_state=+inv+trk,ip actions=drop
   cookie=0x1010000000000, duration=7433.025s, table=7, n_packets=228, n_bytes=2104899, idle_age=7225, priority=190,ct_state=-new+trk,ct_mark=0/0x10,ip actions=resubmit(,12)
   cookie=0x1030000000000, duration=7433.021s, table=7, n_packets=2992, n_bytes=2696990, idle_age=7126, priority=190,ct_state=-new+trk,ct_mark=0x10/0x10,ip actions=load:0x1->NXM_NX_REG0[9],resubmit(,12)
   cookie=0x1010000000000, duration=7433.025s, table=7, n_packets=9, n_bytes=666, idle_age=7239, priority=0 actions=resubmit(,8)
   cookie=0x1030000000000, duration=7433.021s, table=8, n_packets=9, n_bytes=666, idle_age=7239, priority=200,ip actions=resubmit(,9),resubmit(,10)
   cookie=0x1000000000000, duration=7433.036s, table=8, n_packets=0, n_bytes=0, idle_age=7433, priority=0 actions=resubmit(,9)
   cookie=0x1030000000000, duration=7433.021s, table=9, n_packets=9, n_bytes=666, idle_age=7239, priority=0 actions=load:0x1->NXM_NX_REG4[16..18]
   cookie=0x1030000000000, duration=7432.795s, table=10, n_packets=0, n_bytes=0, idle_age=7432, priority=200,udp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=53 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x5->NXM_NX_REG7[],group:5
   cookie=0x1030000000000, duration=7432.785s, table=10, n_packets=0, n_bytes=0, idle_age=7432, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=53 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x6->NXM_NX_REG7[],group:6
   cookie=0x1030000000000, duration=7432.778s, table=10, n_packets=0, n_bytes=0, idle_age=7432, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.10,tp_dst=9153 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x7->NXM_NX_REG7[],group:7
   cookie=0x1030000000000, duration=7432.768s, table=10, n_packets=4, n_bytes=296, idle_age=7239, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.0.1,tp_dst=443 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x8->NXM_NX_REG7[],group:8
   cookie=0x1030000000000, duration=7432.762s, table=10, n_packets=0, n_bytes=0, idle_age=7432, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.225.231,tp_dst=443 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0x9->NXM_NX_REG7[],group:9
   cookie=0x1030000000000, duration=7312.277s, table=10, n_packets=0, n_bytes=0, idle_age=7312, priority=200,tcp,reg4=0x10000/0x70000,nw_dst=10.96.181.73,tp_dst=8080 actions=load:0x1->NXM_NX_REG0[9],load:0x2->NXM_NX_REG4[16..18],load:0xa->NXM_NX_REG7[],group:10
   cookie=0x1000000000000, duration=7433.036s, table=10, n_packets=5, n_bytes=370, idle_age=7244, priority=0 actions=resubmit(,11)
   cookie=0x1030000000000, duration=7433.021s, table=11, n_packets=0, n_bytes=0, idle_age=7433, priority=200,reg0=0x4000/0x4000 actions=controller(reason=no_match,id=3452,userdata=04)
   cookie=0x1030000000000, duration=7432.776s, table=11, n_packets=4, n_bytes=296, idle_age=7239, priority=200,tcp,reg3=0xac120003,reg4=0x2192b/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=172.18.0.3:6443),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7421.410s, table=11, n_packets=0, n_bytes=0, idle_age=7421, priority=200,udp,reg3=0xaf40003,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7421.410s, table=11, n_packets=0, n_bytes=0, idle_age=7421, priority=200,udp,reg3=0xaf40002,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7421.385s, table=11, n_packets=0, n_bytes=0, idle_age=7421, priority=200,tcp,reg3=0xaf40003,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7421.385s, table=11, n_packets=0, n_bytes=0, idle_age=7421, priority=200,tcp,reg3=0xaf40002,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7421.374s, table=11, n_packets=0, n_bytes=0, idle_age=7421, priority=200,tcp,reg3=0xaf40003,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.3:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7421.374s, table=11, n_packets=0, n_bytes=0, idle_age=7421, priority=200,tcp,reg3=0xaf40002,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.2:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7419.484s, table=11, n_packets=0, n_bytes=0, idle_age=7419, priority=200,tcp,reg3=0xac120002,reg4=0x2286d/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=172.18.0.2:10349),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7305.061s, table=11, n_packets=0, n_bytes=0, idle_age=7305, priority=200,tcp,reg3=0xaf40102,reg4=0x21f90/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.1.2:8080),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6226.457s, table=11, n_packets=0, n_bytes=0, idle_age=6226, priority=200,udp,reg3=0xaf40005,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6226.457s, table=11, n_packets=0, n_bytes=0, idle_age=6226, priority=200,udp,reg3=0xaf40006,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6226.457s, table=11, n_packets=0, n_bytes=0, idle_age=6226, priority=200,udp,reg3=0xaf40004,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6226.447s, table=11, n_packets=0, n_bytes=0, idle_age=6226, priority=200,tcp,reg3=0xaf40005,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6226.447s, table=11, n_packets=0, n_bytes=0, idle_age=6226, priority=200,tcp,reg3=0xaf40006,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6226.447s, table=11, n_packets=0, n_bytes=0, idle_age=6226, priority=200,tcp,reg3=0xaf40004,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6226.438s, table=11, n_packets=0, n_bytes=0, idle_age=6226, priority=200,tcp,reg3=0xaf40004,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.4:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6226.438s, table=11, n_packets=0, n_bytes=0, idle_age=6226, priority=200,tcp,reg3=0xaf40006,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.6:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6226.438s, table=11, n_packets=0, n_bytes=0, idle_age=6226, priority=200,tcp,reg3=0xaf40005,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.5:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.432s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,tcp,reg3=0xaf40007,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.432s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,tcp,reg3=0xaf40009,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.432s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,tcp,reg3=0xaf4000a,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.432s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,tcp,reg3=0xaf4000b,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.432s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,tcp,reg3=0xaf40008,reg4=0x223c1/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:9153),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.422s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,udp,reg3=0xaf4000a,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.422s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,udp,reg3=0xaf40008,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.422s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,udp,reg3=0xaf4000b,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.422s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,udp,reg3=0xaf40007,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.422s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,udp,reg3=0xaf40009,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.413s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,tcp,reg3=0xaf40008,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.8:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.412s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,tcp,reg3=0xaf40007,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.7:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.412s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,tcp,reg3=0xaf4000b,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.11:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.412s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,tcp,reg3=0xaf4000a,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.10:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=6225.412s, table=11, n_packets=0, n_bytes=0, idle_age=6225, priority=200,tcp,reg3=0xaf40009,reg4=0x20035/0x7ffff actions=ct(commit,table=12,zone=65520,nat(dst=10.244.0.9:53),exec(load:0x1->NXM_NX_CT_MARK[4]))
   cookie=0x1030000000000, duration=7433.021s, table=11, n_packets=0, n_bytes=0, idle_age=7433, priority=190,reg4=0x20000/0x70000 actions=load:0x1->NXM_NX_REG4[16..18],resubmit(,10)
   cookie=0x1000000000000, duration=7433.035s, table=11, n_packets=5, n_bytes=370, idle_age=7244, priority=0 actions=resubmit(,12)
   cookie=0x1020000000000, duration=7433.016s, table=12, n_packets=3220, n_bytes=4801889, idle_age=7126, priority=64990,ct_state=-new+est,ip actions=resubmit(,15)
   cookie=0x1020000000000, duration=7433.016s, table=12, n_packets=0, n_bytes=0, idle_age=7433, priority=64990,ct_state=-new+rel,ip actions=resubmit(,15)
   cookie=0x1000000000000, duration=7433.035s, table=12, n_packets=9, n_bytes=666, idle_age=7239, priority=0 actions=resubmit(,13)
   cookie=0x1000000000000, duration=7433.035s, table=13, n_packets=9, n_bytes=666, idle_age=7239, priority=0 actions=resubmit(,14)
   cookie=0x1000000000000, duration=7433.035s, table=14, n_packets=9, n_bytes=666, idle_age=7239, priority=0 actions=resubmit(,15)
   cookie=0x1000000000000, duration=7433.035s, table=15, n_packets=3229, n_bytes=4802555, idle_age=7126, priority=0 actions=resubmit(,16)
   cookie=0x1010000000000, duration=7433.024s, table=16, n_packets=25, n_bytes=4312, idle_age=7225, priority=210,ip,nw_dst=10.244.1.1 actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1010000000000, duration=7433.024s, table=16, n_packets=0, n_bytes=0, idle_age=7433, priority=210,ct_state=+rpl+trk,ct_mark=0x2/0xf,ip actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1010000000000, duration=7433.024s, table=16, n_packets=88, n_bytes=610339, idle_age=7225, priority=200,ip,reg0=0/0x200,nw_dst=10.244.1.0/24 actions=resubmit(,21)
   cookie=0x1010000000000, duration=7432.795s, table=16, n_packets=23, n_bytes=4168, idle_age=7225, priority=200,ip,nw_dst=10.244.2.0/24 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:aa:bb:cc:dd:ee:ff,load:0xac120002->NXM_NX_TUN_IPV4_DST[],load:0x1->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1010000000000, duration=7432.794s, table=16, n_packets=25, n_bytes=4311, idle_age=7225, priority=200,ip,nw_dst=10.244.0.0/24 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:aa:bb:cc:dd:ee:ff,load:0xac120003->NXM_NX_TUN_IPV4_DST[],load:0x1->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1010000000000, duration=7311.940s, table=16, n_packets=1389, n_bytes=3734917, idle_age=7126, priority=200,ip,reg0=0x200/0x200,nw_dst=10.244.1.2 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:9a:84:26:63:6f:97,resubmit(,18)
   cookie=0x1010000000000, duration=2201.777s, table=16, n_packets=0, n_bytes=0, idle_age=2201, priority=200,ip,reg0=0x200/0x200,nw_dst=10.244.1.4 actions=mod_dl_src:02:60:ef:e6:1d:57,mod_dl_dst:9e:f4:19:16:ce:0b,resubmit(,18)
   cookie=0x1030000000000, duration=7433.021s, table=16, n_packets=0, n_bytes=0, idle_age=7433, priority=190,ct_mark=0x10/0x10,reg0=0x202/0x20f actions=mod_dl_dst:02:60:ef:e6:1d:57,load:0x2->NXM_NX_REG0[4..7],resubmit(,18)
   cookie=0x1040000000000, duration=7433.014s, table=16, n_packets=1552, n_bytes=200572, idle_age=7126, priority=190,ct_state=-rpl+trk,ip,reg0=0x3/0xf,reg4=0/0x100000 actions=resubmit(,17)
   cookie=0x1040000000000, duration=7433.014s, table=16, n_packets=0, n_bytes=0, idle_age=7433, priority=190,ct_state=-rpl+trk,ip,reg0=0x1/0xf actions=mod_dl_dst:02:60:ef:e6:1d:57,resubmit(,17)
   cookie=0x1010000000000, duration=7433.025s, table=16, n_packets=0, n_bytes=0, idle_age=7433, priority=0 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7433.014s, table=17, n_packets=0, n_bytes=0, idle_age=7433, priority=210,ip,nw_dst=172.18.0.4 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7432.795s, table=17, n_packets=0, n_bytes=0, idle_age=7432, priority=210,ip,nw_dst=172.18.0.2 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7432.794s, table=17, n_packets=1552, n_bytes=200572, idle_age=7126, priority=210,ip,nw_dst=172.18.0.3 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7432.696s, table=17, n_packets=0, n_bytes=0, idle_age=7432, priority=210,ip,nw_dst=10.96.0.0/16 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1040000000000, duration=7433.014s, table=17, n_packets=0, n_bytes=0, idle_age=7433, priority=190,ct_state=+new+trk,ip,reg0=0x1/0xf actions=drop
   cookie=0x1040000000000, duration=7433.014s, table=17, n_packets=0, n_bytes=0, idle_age=7433, priority=0 actions=load:0x2->NXM_NX_REG0[4..7],resubmit(,21)
   cookie=0x1010000000000, duration=7433.025s, table=18, n_packets=1444, n_bytes=2496714, idle_age=7126, priority=210,ip,reg0=0x2/0xf actions=resubmit(,19)
   cookie=0x1010000000000, duration=7433.025s, table=18, n_packets=145, n_bytes=1494930, idle_age=7225, priority=200,ip actions=dec_ttl,resubmit(,19)
   cookie=0x1000000000000, duration=7433.035s, table=18, n_packets=0, n_bytes=0, idle_age=7433, priority=0 actions=resubmit(,19)
   cookie=0x1030000000000, duration=7433.021s, table=19, n_packets=0, n_bytes=0, idle_age=7433, priority=200,ct_state=+new+trk,ip,reg0=0x22/0xff actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
   cookie=0x1030000000000, duration=7433.021s, table=19, n_packets=0, n_bytes=0, idle_age=7433, priority=200,ct_state=+new+trk,ip,reg0=0x12/0xff,reg4=0x200000/0x2200000 actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
   cookie=0x1030000000000, duration=7305.061s, table=19, n_packets=0, n_bytes=0, idle_age=7305, priority=190,ct_state=+new+trk,ip,nw_src=10.244.1.2,nw_dst=10.244.1.2 actions=ct(commit,table=20,zone=65520,exec(load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6],move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
   cookie=0x1000000000000, duration=7433.035s, table=19, n_packets=1589, n_bytes=3991644, idle_age=7126, priority=0 actions=resubmit(,20)
   cookie=0x1030000000000, duration=7433.021s, table=20, n_packets=0, n_bytes=0, idle_age=7433, priority=200,ct_state=+new+trk,ct_mark=0x40/0x40,ip,reg0=0x2/0xf actions=ct(commit,table=21,zone=65521,nat(src=169.254.0.253),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6]))
   cookie=0x1030000000000, duration=7433.021s, table=20, n_packets=0, n_bytes=0, idle_age=7433, priority=200,ct_state=+new+trk,ct_mark=0x40/0x40,ip,reg0=0x3/0xf actions=ct(commit,table=21,zone=65521,nat(src=10.244.1.1),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5],load:0x1->NXM_NX_CT_MARK[6]))
   cookie=0x1030000000000, duration=7433.021s, table=20, n_packets=0, n_bytes=0, idle_age=7433, priority=200,ct_state=-new-rpl+trk,ct_mark=0x20/0x20,ip actions=ct(table=21,zone=65521,nat)
   cookie=0x1030000000000, duration=7433.021s, table=20, n_packets=0, n_bytes=0, idle_age=7433, priority=190,ct_state=+new+trk,ct_mark=0x20/0x20,ip,reg0=0x2/0xf actions=ct(commit,table=21,zone=65521,nat(src=10.244.1.1),exec(load:0x1->NXM_NX_CT_MARK[4],load:0x1->NXM_NX_CT_MARK[5]))
   cookie=0x1000000000000, duration=7433.035s, table=20, n_packets=1589, n_bytes=3991644, idle_age=7126, priority=0 actions=resubmit(,21)
   cookie=0x1010000000000, duration=7433.024s, table=21, n_packets=1577, n_bytes=204884, idle_age=7126, priority=200,dl_dst=02:60:ef:e6:1d:57 actions=load:0x8001->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
   cookie=0x1010000000000, duration=7433.024s, table=21, n_packets=48, n_bytes=8479, idle_age=7225, priority=200,dl_dst=aa:bb:cc:dd:ee:ff actions=load:0x8000->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
   cookie=0x1010000000000, duration=7311.940s, table=21, n_packets=1456, n_bytes=4338327, idle_age=7126, priority=200,dl_dst=9a:84:26:63:6f:97 actions=load:0x1->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
   cookie=0x1010000000000, duration=2201.777s, table=21, n_packets=0, n_bytes=0, idle_age=2201, priority=200,dl_dst=9e:f4:19:16:ce:0b actions=load:0x3->NXM_NX_REG1[],load:0x1->NXM_NX_REG0[21..22],resubmit(,22)
   cookie=0x1000000000000, duration=7433.035s, table=21, n_packets=0, n_bytes=0, idle_age=7433, priority=0 actions=resubmit(,22)
   cookie=0x1010000000000, duration=7433.024s, table=22, n_packets=32, n_bytes=501096, idle_age=7225, priority=210,pkt_mark=0x80000000/0x80000000,ct_state=-rpl+trk,ip actions=resubmit(,27)
   cookie=0x1020000000000, duration=7433.016s, table=22, n_packets=1577, n_bytes=204884, idle_age=7126, priority=200,reg0=0x20/0xf0 actions=resubmit(,26)
   cookie=0x1020000000000, duration=7433.016s, table=22, n_packets=48, n_bytes=8479, idle_age=7225, priority=200,reg0=0x10/0xf0 actions=resubmit(,26)
   cookie=0x1020000000000, duration=7433.016s, table=22, n_packets=0, n_bytes=0, idle_age=7433, priority=200,reg0=0x40/0xf0 actions=resubmit(,26)
   cookie=0x1020000000000, duration=7433.016s, table=22, n_packets=0, n_bytes=0, idle_age=7433, priority=200,ct_mark=0x40/0x40 actions=resubmit(,27)
   cookie=0x1000000000000, duration=7433.035s, table=22, n_packets=1572, n_bytes=4088096, idle_age=7126, priority=0 actions=resubmit(,23)
   cookie=0x1020000000000, duration=7432.910s, table=23, n_packets=0, n_bytes=0, idle_age=7432, priority=64991,conj_id=1 actions=controller(reason=no_match,id=3452,userdata=02,pause),resubmit(,26)
   cookie=0x1020000000000, duration=7427.898s, table=23, n_packets=0, n_bytes=0, idle_age=7432, priority=64991,ct_state=+rpl+trk,udp,tp_src=53 actions=conjunction(1,1/2)
   cookie=0x1020000000000, duration=7427.898s, table=23, n_packets=0, n_bytes=0, idle_age=7432, priority=64991,ct_state=+rpl+trk,tcp,tp_src=53 actions=conjunction(1,1/2)
   cookie=0x1020000000000, duration=7433.016s, table=23, n_packets=1568, n_bytes=4087800, idle_age=7126, priority=64990,ct_state=-new+est,ip actions=resubmit(,26)
   cookie=0x1020000000000, duration=7433.016s, table=23, n_packets=0, n_bytes=0, idle_age=7433, priority=64990,ct_state=-new+rel,ip actions=resubmit(,26)
   cookie=0x1000000000000, duration=7433.035s, table=23, n_packets=4, n_bytes=296, idle_age=7244, priority=0 actions=resubmit(,24)
   cookie=0x1020000000000, duration=7.760s, table=24, n_packets=0, n_bytes=0, idle_age=7, priority=200,ip actions=conjunction(3,1/3)
   cookie=0x1020000000000, duration=7.760s, table=24, n_packets=0, n_bytes=0, idle_age=7, priority=200,reg1=0x3 actions=conjunction(2,2/2),conjunction(3,2/3)
   cookie=0x1020000000000, duration=7.760s, table=24, n_packets=0, n_bytes=0, idle_age=7, priority=200,tcp,tp_dst=80 actions=conjunction(3,3/3)
   cookie=0x1020000000000, duration=7.765s, table=24, n_packets=0, n_bytes=0, idle_age=7, priority=190,conj_id=3,ip actions=load:0x3->NXM_NX_REG6[],ct(commit,table=26,zone=65520,exec(load:0x3->NXM_NX_CT_LABEL[0..31]))
   cookie=0x1020000000000, duration=7.755s, table=24, n_packets=0, n_bytes=0, idle_age=7, priority=190,conj_id=2,ip actions=load:0x2->NXM_NX_REG6[],ct(commit,table=26,zone=65520,exec(load:0x2->NXM_NX_CT_LABEL[0..31]))
   cookie=0x1000000000000, duration=7433.035s, table=24, n_packets=4, n_bytes=296, idle_age=7244, priority=0 actions=resubmit(,25)
   cookie=0x1020000000000, duration=7.760s, table=25, n_packets=0, n_bytes=0, idle_age=7, priority=200,reg1=0x3 actions=drop
   cookie=0x1000000000000, duration=7433.035s, table=25, n_packets=4, n_bytes=296, idle_age=7244, priority=0 actions=resubmit(,26)
   cookie=0x1020000000000, duration=7.765s, table=26, n_packets=0, n_bytes=0, idle_age=7, priority=200,ct_state=+new,ct_label=0x3/0xffffffff,ip actions=resubmit(,27)
   cookie=0x1020000000000, duration=7.765s, table=26, n_packets=0, n_bytes=0, idle_age=7, priority=200,ct_state=-new,ct_label=0x3/0xffffffff,ip actions=resubmit(,27)
   cookie=0x1020000000000, duration=7.755s, table=26, n_packets=0, n_bytes=0, idle_age=7, priority=200,ct_state=+new,ct_label=0x2/0xffffffff,ip actions=resubmit(,27)
   cookie=0x1020000000000, duration=7.755s, table=26, n_packets=0, n_bytes=0, idle_age=7, priority=200,ct_state=-new,ct_label=0x2/0xffffffff,ip actions=resubmit(,27)
   cookie=0x1000000000000, duration=7433.035s, table=26, n_packets=3197, n_bytes=4301459, idle_age=7126, priority=0 actions=resubmit(,27)
   cookie=0x1010000000000, duration=7433.025s, table=27, n_packets=9, n_bytes=666, idle_age=7239, priority=200,ct_state=+new+trk,ct_mark=0/0x20,ip actions=ct(commit,table=28,zone=65520,exec(move:NXM_NX_REG0[0..3]->NXM_NX_CT_MARK[0..3]))
   cookie=0x1000000000000, duration=7433.035s, table=27, n_packets=3220, n_bytes=4801889, idle_age=7126, priority=0 actions=resubmit(,28)
   cookie=0x1030000000000, duration=7433.021s, table=28, n_packets=0, n_bytes=0, idle_age=7433, priority=210,ct_mark=0x40/0x40,reg0=0x200000/0x600000 actions=IN_PORT
   cookie=0x1010000000000, duration=7433.025s, table=28, n_packets=3229, n_bytes=4802555, idle_age=7126, priority=200,reg0=0x200000/0x600000 actions=output:NXM_NX_REG1[]
   cookie=0x1020000000000, duration=7433.016s, table=28, n_packets=0, n_bytes=0, idle_age=7433, priority=200,reg0=0x2400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.01)
   cookie=0x1020000000000, duration=7433.016s, table=28, n_packets=0, n_bytes=0, idle_age=7433, priority=200,reg0=0x4400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.02)
   cookie=0x1020000000000, duration=7433.016s, table=28, n_packets=0, n_bytes=0, idle_age=7433, priority=200,reg0=0x6400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.03)
   cookie=0x1020000000000, duration=7433.016s, table=28, n_packets=0, n_bytes=0, idle_age=7433, priority=200,reg0=0x8400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.04)
   cookie=0x1020000000000, duration=7433.016s, table=28, n_packets=0, n_bytes=0, idle_age=7433, priority=200,reg0=0xa400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.05)
   cookie=0x1020000000000, duration=7433.016s, table=28, n_packets=0, n_bytes=0, idle_age=7433, priority=200,reg0=0xc400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.06)
   cookie=0x1020000000000, duration=7433.016s, table=28, n_packets=0, n_bytes=0, idle_age=7433, priority=200,reg0=0xe400000/0xfe600000 actions=controller(reason=no_match,id=3452,userdata=01.07)
   cookie=0x1000000000000, duration=7433.035s, table=28, n_packets=0, n_bytes=0, idle_age=7433, priority=0 actions=drop
```

</details>

### Команда: удаление политик разрешения доступа

```bash
kubectl delete -f web-web2-80-alllow.yaml
```

---

## Использование CNI calico

### Удаление кластера kubernets kind

```bash
kind delete cluster \
--name="$(kind get clusters |head -n1)"
```

<details>
<summary>
Вывод команды удаления кластера
</summary>

```log
Deleting cluster "antrea" ...
Deleted nodes: ["antrea-control-plane" "antrea-worker2" "antrea-worker"]
```

</details>

### Команда: клонирование репозитория k8sprototypes

```bash
git clone https://github.com/jayunit100/k8sprototypes.git

find . -name ".git" -exec rm -vrf {} \;
```

<details>
<summary>
Вывод команды
</summary>

```log
Клонирование в «k8sprototypes»...
remote: Enumerating objects: 5716, done.
remote: Counting objects: 100% (2468/2468), done.
remote: Compressing objects: 100% (1433/1433), done.
remote: Total 5716 (delta 1212), reused 1735 (delta 902), pack-reused 3248 (from 1)
Получение объектов: 100% (5716/5716), 45.82 MiB | 10.23 MiB/s, готово.
Определение изменений: 100% (2730/2730), готово.
Updating files: 100% (1847/1847), готово.

удалён './k8sprototypes/.git/description'
удалён './k8sprototypes/.git/hooks/post-update.sample'
удалён './k8sprototypes/.git/hooks/pre-rebase.sample'
удалён './k8sprototypes/.git/hooks/pre-commit.sample'
удалён './k8sprototypes/.git/hooks/pre-receive.sample'
удалён './k8sprototypes/.git/hooks/commit-msg.sample'
удалён './k8sprototypes/.git/hooks/pre-push.sample'
удалён './k8sprototypes/.git/hooks/applypatch-msg.sample'
удалён './k8sprototypes/.git/hooks/pre-applypatch.sample'
удалён './k8sprototypes/.git/hooks/update.sample'
удалён './k8sprototypes/.git/hooks/fsmonitor-watchman.sample'
удалён './k8sprototypes/.git/hooks/push-to-checkout.sample'
удалён './k8sprototypes/.git/hooks/pre-merge-commit.sample'
удалён './k8sprototypes/.git/hooks/sendemail-validate.sample'
удалён './k8sprototypes/.git/hooks/prepare-commit-msg.sample'
удалён каталог './k8sprototypes/.git/hooks'
удалён './k8sprototypes/.git/info/exclude'
удалён каталог './k8sprototypes/.git/info'
удалён './k8sprototypes/.git/objects/pack/pack-0f20c902bfbbfa40b4aa748fd3d17cfb48b8c596.pack'
удалён './k8sprototypes/.git/objects/pack/pack-0f20c902bfbbfa40b4aa748fd3d17cfb48b8c596.rev'
удалён './k8sprototypes/.git/objects/pack/pack-0f20c902bfbbfa40b4aa748fd3d17cfb48b8c596.idx'
удалён каталог './k8sprototypes/.git/objects/pack'
удалён каталог './k8sprototypes/.git/objects/info'
удалён каталог './k8sprototypes/.git/objects'
удалён './k8sprototypes/.git/refs/heads/master'
удалён каталог './k8sprototypes/.git/refs/heads'
удалён каталог './k8sprototypes/.git/refs/tags'
удалён './k8sprototypes/.git/refs/remotes/origin/HEAD'
удалён каталог './k8sprototypes/.git/refs/remotes/origin'
удалён каталог './k8sprototypes/.git/refs/remotes'
удалён каталог './k8sprototypes/.git/refs'
удалён './k8sprototypes/.git/packed-refs'
удалён './k8sprototypes/.git/logs/refs/remotes/origin/HEAD'
удалён каталог './k8sprototypes/.git/logs/refs/remotes/origin'
удалён каталог './k8sprototypes/.git/logs/refs/remotes'
удалён './k8sprototypes/.git/logs/refs/heads/master'
удалён каталог './k8sprototypes/.git/logs/refs/heads'
удалён каталог './k8sprototypes/.git/logs/refs'
удалён './k8sprototypes/.git/logs/HEAD'
удалён каталог './k8sprototypes/.git/logs'
удалён './k8sprototypes/.git/HEAD'
удалён './k8sprototypes/.git/config'
удалён './k8sprototypes/.git/index'
удалён каталог './k8sprototypes/.git'
find: «./k8sprototypes/.git»: Нет такого файла или каталога
```

</details>

### Команда: создание кластера Calico через kind-local-up.sh

```bash
cd ./k8sprototypes/kind

CLUSTER=calico CONFIG=calico-conf.yaml ./kind-local-up.sh

cd -
```

<details>
<summary>
Вывод создания кластера проекта jayunit100/k8sprototypes под kind
</summary>

```log
Using Calico CNI.
Deleting cluster "calico" ...
deleted old kind cluster, creating a new one...
Creating cluster "calico" ...
 ✓ Ensuring node image (kindest/node:v1.36.1) 🖼
 ✓ Preparing nodes 📦 📦 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing StorageClass 💾 
 ✓ Joining worker nodes 🚜 
Set kubectl context to "kind-calico"
You can now use your cluster with:

kubectl cluster-info --context kind-calico

Have a nice day! 👋
Kubernetes control plane is running at https://127.0.0.1:36745
CoreDNS is running at https://127.0.0.1:36745/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
No resources found in default namespace.
poddisruptionbudget.policy/calico-kube-controllers created
serviceaccount/calico-kube-controllers created
serviceaccount/calico-node created
configmap/calico-config created
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/caliconodestatuses.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipreservations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
clusterrole.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrole.rbac.authorization.k8s.io/calico-node created
clusterrolebinding.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrolebinding.rbac.authorization.k8s.io/calico-node created
daemonset.apps/calico-node created
deployment.apps/calico-kube-controllers created
NAME                                           READY   STATUS              RESTARTS   AGE
calico-kube-controllers-6ddb98b4d6-k8xvn       0/1     Pending             0          0s
calico-node-2vw75                              0/1     Init:0/3            0          0s
calico-node-55ms6                              0/1     Init:0/3            0          0s
calico-node-5cxw9                              0/1     Init:0/3            0          0s
coredns-589f44dc88-p5lwn                       0/1     Pending             0          3s
coredns-589f44dc88-xr9q6                       0/1     Pending             0          3s
etcd-calico-control-plane                      0/1     Running             0          10s
kube-apiserver-calico-control-plane            0/1     Running             0          10s
kube-controller-manager-calico-control-plane   0/1     Running             0          10s
kube-proxy-j6sc6                               0/1     ContainerCreating   0          2s
kube-proxy-szgn7                               1/1     Running             0          3s
kube-proxy-z7rlp                               0/1     ContainerCreating   0          2s
kube-scheduler-calico-control-plane            0/1     Running             0          10s
daemonset.apps/calico-node env updated
daemonset.apps/calico-node env updated

/home/shoel/nfs_git/gited/kuber_book_study/3_network_uses
```

</details>

### Команда: проверка подов кластера

```bash
kubectl get pods \
-A -o wide
```

<details>
<summary>
Вывод проверки подов кластера
</summary>

```log
NAMESPACE            NAME                                           READY   STATUS    RESTARTS   AGE     IP              NODE                   NOMINATED NODE   READINESS GATES
kube-system          calico-kube-controllers-6ddb98b4d6-k8xvn       1/1     Running   0          2m3s    192.168.9.132   calico-worker          <none>           <none>
kube-system          calico-node-5ljx2                              1/1     Running   0          2m3s    172.18.0.3      calico-control-plane   <none>           <none>
kube-system          calico-node-czddm                              1/1     Running   0          2m3s    172.18.0.4      calico-worker          <none>           <none>
kube-system          calico-node-pfp4g                              1/1     Running   0          2m3s    172.18.0.2      calico-worker2         <none>           <none>
kube-system          coredns-589f44dc88-p5lwn                       1/1     Running   0          2m6s    192.168.9.129   calico-worker          <none>           <none>
kube-system          coredns-589f44dc88-xr9q6                       1/1     Running   0          2m6s    192.168.9.131   calico-worker          <none>           <none>
kube-system          etcd-calico-control-plane                      1/1     Running   0          2m13s   172.18.0.3      calico-control-plane   <none>           <none>
kube-system          kube-apiserver-calico-control-plane            1/1     Running   0          2m13s   172.18.0.3      calico-control-plane   <none>           <none>
kube-system          kube-controller-manager-calico-control-plane   1/1     Running   0          2m13s   172.18.0.3      calico-control-plane   <none>           <none>
kube-system          kube-proxy-j6sc6                               1/1     Running   0          2m5s    172.18.0.4      calico-worker          <none>           <none>
kube-system          kube-proxy-szgn7                               1/1     Running   0          2m6s    172.18.0.3      calico-control-plane   <none>           <none>
kube-system          kube-proxy-z7rlp                               1/1     Running   0          2m5s    172.18.0.2      calico-worker2         <none>           <none>
kube-system          kube-scheduler-calico-control-plane            1/1     Running   0          2m13s   172.18.0.3      calico-control-plane   <none>           <none>
local-path-storage   local-path-provisioner-855c7b7774-zbz9w        1/1     Running   0          2m6s    192.168.9.130   calico-worker          <none>           <none>
```

</details>

### Команда: загрузка и установка sonobuoy

```bash
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.5/sonobuoy_0.57.5_linux_amd64.tar.gz

tar -xfv sonobuoy_0.57.5_linux_amd64.tar.gz

chmod -v +x sonobuoy

sudo mv -v sonobuoy /usr/local/bin

sonobuoy version

rm -vrf sonobuoy_0.57.5_linux_amd64.tar.gz LICENSE
```

<details>
<summary>
Вывод команд
</summary>

```log
sonobuoy_0.57.5_linux_amd64.tar.gz                  100%[=================================================================================================================>]  24,25M  11,0MB/s    за 2,2s    

2026-08-01 17:46:48 (11,0 MB/s) - ‘sonobuoy_0.57.5_linux_amd64.tar.gz’ сохранён [25428672/25428672]

LICENSE
sonobuoy

права доступа 'sonobuoy' оставлены в виде 0777 (rwxrwxrwx)

[sudo] пароль для shoel: 
copied 'sonobuoy' -> '/usr/local/bin/sonobuoy'
удалён 'sonobuoy'

Sonobuoy Version: v0.57.5
MinimumKubeVersion: 1.17.0
MaximumKubeVersion: 1.99.99
GitSHA: 310c51d9874a4d10d021ec8a19f8b42292ec0bfc
GoVersion: go1.26.4
Platform: linux/amd64
API Version check skipped due to missing `--kubeconfig` or other error

удалён 'sonobuoy_0.57.5_linux_amd64.tar.gz'
удалён 'LICENSE'
```

</details>

### Команда: запуск conformance тестов

```bash
sonobuoy run --wait
```

<details>
<summary>
Вывод зыпуска conformance тестов
</summary>

```log
INFO[0000] create request issued                         name=sonobuoy namespace= resource=namespaces
INFO[0000] create request issued                         name=sonobuoy-serviceaccount namespace=sonobuoy resource=serviceaccounts
INFO[0000] create request issued                         name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterrolebindings
INFO[0000] create request issued                         name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterroles
INFO[0000] create request issued                         name=sonobuoy-config-cm namespace=sonobuoy resource=configmaps
INFO[0000] create request issued                         name=sonobuoy-plugins-cm namespace=sonobuoy resource=configmaps
INFO[0000] create request issued                         name=sonobuoy namespace=sonobuoy resource=pods
INFO[0000] create request issued                         name=sonobuoy-aggregator namespace=sonobuoy resource=services


17:58:44          PLUGIN                   NODE    STATUS   RESULT   PROGRESS
17:58:44             e2e                 global   running                    
17:58:44    systemd-logs   calico-control-plane   running                    
17:58:44    systemd-logs          calico-worker   running                    
17:58:44    systemd-logs         calico-worker2   running                    
17:58:44 
17:58:44 Sonobuoy is still running. Runs can take 60 minutes or more depending on cluster and plugin configuration.
...
...
19:51:04             e2e                 global   complete   passed   Passed:  0, Failed:  0, Remaining:444
19:51:04    systemd-logs   calico-control-plane   complete   passed                                        
19:51:04    systemd-logs          calico-worker   complete   passed                                        
19:51:04    systemd-logs         calico-worker2   complete   passed                                        
19:51:04 Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

</details>

### Команда: получение результатов conformance тестов

```bash
export results="$(sonobuoy retrieve)"

sonobuoy results $results
```

<details>
<summary>
Вывод результатов
</summary>

```log
sonobuoy results $results
Plugin: e2e
Status: passed
Total: 7586
Passed: 451
Failed: 0
Skipped: 7135

Plugin: systemd-logs
Status: passed
Total: 3
Passed: 3
Failed: 0
Skipped: 0

Run Details:
API Server version: v1.36.1
Node health: 3/3 (100%)
Pods health: 19/19 (100%)
Errors detected in files:
Errors:
1210 podlogs/kube-system/kube-controller-manager-calico-control-plane/logs/kube-controller-manager.txt
1157 podlogs/kube-system/calico-node-czddm/logs/calico-node.txt
 908 podlogs/kube-system/calico-node-pfp4g/logs/calico-node.txt
 446 podlogs/kube-system/kube-apiserver-calico-control-plane/logs/kube-apiserver.txt
  51 podlogs/kube-system/kube-scheduler-calico-control-plane/logs/kube-scheduler.txt
   9 podlogs/kube-system/kube-proxy-z7rlp/logs/kube-proxy.txt
   9 podlogs/kube-system/kube-proxy-j6sc6/logs/kube-proxy.txt
   9 podlogs/kube-system/kube-proxy-szgn7/logs/kube-proxy.txt
   3 podlogs/kube-system/calico-node-5ljx2/logs/calico-node.txt
   2 podlogs/kube-system/calico-kube-controllers-6ddb98b4d6-k8xvn/logs/calico-kube-controllers.txt
   1 podlogs/sonobuoy/sonobuoy-e2e-job-21ca370429bc42b0/logs/e2e.txt
Warnings:
1499 podlogs/kube-system/calico-node-5ljx2/logs/calico-node.txt
 544 podlogs/kube-system/calico-node-pfp4g/logs/calico-node.txt
 538 podlogs/kube-system/calico-node-czddm/logs/calico-node.txt
 338 podlogs/kube-system/kube-apiserver-calico-control-plane/logs/kube-apiserver.txt
 305 podlogs/kube-system/etcd-calico-control-plane/logs/etcd.txt
  22 podlogs/kube-system/kube-controller-manager-calico-control-plane/logs/kube-controller-manager.txt
   7 podlogs/sonobuoy/sonobuoy/logs/kube-sonobuoy.txt
   4 podlogs/kube-system/kube-scheduler-calico-control-plane/logs/kube-scheduler.txt
   1 podlogs/sonobuoy/sonobuoy-e2e-job-21ca370429bc42b0/logs/e2e.txt
   1 podlogs/kube-system/calico-kube-controllers-6ddb98b4d6-k8xvn/logs/calico-kube-controllers.txt
```

</details>

### Команда: вход в контейнер calico-control-plane

```bash
docker exec -it calico-control-plane bash
```

### Команда: установка net-tools в контейнере calico-control-plane

```bash
apt-get update \
; apt-get install -y net-tools
```

### Команда: просмотр сетевого окружения на на ноде calico-control-plane

```bash
ip -br a

ip route

arp

arp -na
```

<details>
<summary>
Просмотр сетевого окружения на одно из nod Calico
</summary>

```log
lo               UNKNOWN        127.0.0.1/8 ::1/128 
eth0@if18        UP             172.18.0.2/16 fc00:f853:ccd:e793::2/64 fe80::d830:3aff:fe64:9b09/64 
tunl0@NONE       UNKNOWN        192.168.71.0/32 
cali3d40f5871ce@if4 UP             fe80::ecee:eeff:feee:eeee/64 
cali5958a8fd1b3@if4 UP             fe80::ecee:eeff:feee:eeee/64 
cali1b9ad3fa474@if4 UP             fe80::ecee:eeff:feee:eeee/64 
cali2e3c11611ea@if4 UP             fe80::ecee:eeff:feee:eeee/64 
root@calico-control-plane:/# ip route
default via 172.18.0.1 dev eth0 
172.18.0.0/16 dev eth0 proto kernel scope link src 172.18.0.2 
192.168.9.128/26 via 172.18.0.4 dev tunl0 proto bird onlink 
blackhole 192.168.71.0/26 proto bird 
192.168.71.1 dev cali3d40f5871ce scope link 
192.168.71.2 dev cali5958a8fd1b3 scope link 
192.168.71.3 dev cali1b9ad3fa474 scope link 
192.168.71.4 dev cali2e3c11611ea scope link 
192.168.88.0/26 via 172.18.0.3 dev tunl0 proto bird onlink 
root@calico-control-plane:/# arp
Address                  HWtype  HWaddress           Flags Mask            Iface
192.168.71.4             ether   9a:c0:cf:39:4b:ef   C                     cali2e3c11611ea
192.168.71.2             ether   56:3e:78:5a:7a:77   C                     cali5958a8fd1b3
calico-worker.kind       ether   fe:fe:38:dc:6f:b7   C                     eth0
192.168.71.3             ether   06:10:0a:c5:17:44   C                     cali1b9ad3fa474
192.168.71.1             ether   92:35:33:f6:02:8e   C                     cali3d40f5871ce
calico-worker2.kind      ether   ea:0c:fc:c0:a1:01   C                     eth0
shoellin                 ether   1a:8d:e6:34:5c:d9   C                     eth0
root@calico-control-plane:/# arp -na
? (192.168.71.4) at 9a:c0:cf:39:4b:ef [ether] on cali2e3c11611ea
? (192.168.71.2) at 56:3e:78:5a:7a:77 [ether] on cali5958a8fd1b3
? (172.18.0.4) at fe:fe:38:dc:6f:b7 [ether] on eth0
? (192.168.71.3) at 06:10:0a:c5:17:44 [ether] on cali1b9ad3fa474
? (192.168.71.1) at 92:35:33:f6:02:8e [ether] on cali3d40f5871ce
? (172.18.0.3) at ea:0c:fc:c0:a1:01 [ether] on eth0
? (172.18.0.1) at 1a:8d:e6:34:5c:d9 [ether] on eth0
```

</details>

### Команда: масштабирование CoreDNS и проверка подов

```bash
root@calico-control-plane:/# exit

kubectl get pods -n kube-system -o wide \
; kubectl get pods -n kube-system \
| wc -l

kubectl scale deployment coredns \
-n kube-system \
--replicas=10

kubectl get pods -n kube-system -o wide \
; kubectl get pods -n kube-system \
| wc -l

docker exec -it calico-control-plane bash
```

<details>
<summary>
Вывод проверки подов и масштабирования CoreDNS
</summary>

```log
calico-kube-controllers-6ddb98b4d6-m8fl9       1/1     Running   0          5m26s   192.168.71.3   calico-control-plane   <none>           <none>
calico-node-44jdt                              1/1     Running   0          5m26s   172.18.0.3     calico-worker2         <none>           <none>
calico-node-tztsh                              1/1     Running   0          5m26s   172.18.0.4     calico-worker          <none>           <none>
calico-node-w5slq                              1/1     Running   0          5m26s   172.18.0.2     calico-control-plane   <none>           <none>
coredns-589f44dc88-m2kdc                       1/1     Running   0          5m31s   192.168.71.4   calico-control-plane   <none>           <none>
coredns-589f44dc88-p4k8r                       1/1     Running   0          5m31s   192.168.71.2   calico-control-plane   <none>           <none>
etcd-calico-control-plane                      1/1     Running   0          5m39s   172.18.0.2     calico-control-plane   <none>           <none>
kube-apiserver-calico-control-plane            1/1     Running   0          5m36s   172.18.0.2     calico-control-plane   <none>           <none>
kube-controller-manager-calico-control-plane   1/1     Running   0          5m36s   172.18.0.2     calico-control-plane   <none>           <none>
kube-proxy-fcvkr                               1/1     Running   0          5m28s   172.18.0.3     calico-worker2         <none>           <none>
kube-proxy-q7fbl                               1/1     Running   0          5m28s   172.18.0.4     calico-worker          <none>           <none>
kube-proxy-qp788                               1/1     Running   0          5m31s   172.18.0.2     calico-control-plane   <none>           <none>
kube-scheduler-calico-control-plane            1/1     Running   0          5m38s   172.18.0.2     calico-control-plane   <none>           <none>
```

```log
14
```

```log
deployment.apps/coredns scaled
```

```log
NAME                                           READY   STATUS    RESTARTS   AGE     IP              NODE                   NOMINATED NODE   READINESS GATES
calico-kube-controllers-6ddb98b4d6-m8fl9       1/1     Running   0          5m40s   192.168.71.3    calico-control-plane   <none>           <none>
calico-node-44jdt                              1/1     Running   0          5m40s   172.18.0.3      calico-worker2         <none>           <none>
calico-node-tztsh                              1/1     Running   0          5m40s   172.18.0.4      calico-worker          <none>           <none>
calico-node-w5slq                              1/1     Running   0          5m40s   172.18.0.2      calico-control-plane   <none>           <none>
coredns-589f44dc88-297wb                       1/1     Running   0          10s     192.168.71.5    calico-control-plane   <none>           <none>
coredns-589f44dc88-52qp9                       1/1     Running   0          10s     192.168.9.130   calico-worker          <none>           <none>
coredns-589f44dc88-8dwdr                       1/1     Running   0          10s     192.168.88.1    calico-worker2         <none>           <none>
coredns-589f44dc88-c29rd                       1/1     Running   0          10s     192.168.88.3    calico-worker2         <none>           <none>
coredns-589f44dc88-cbb2q                       1/1     Running   0          10s     192.168.9.129   calico-worker          <none>           <none>
coredns-589f44dc88-kgrjp                       1/1     Running   0          10s     192.168.9.131   calico-worker          <none>           <none>
coredns-589f44dc88-kxjs4                       1/1     Running   0          10s     192.168.9.132   calico-worker          <none>           <none>
coredns-589f44dc88-m2kdc                       1/1     Running   0          5m45s   192.168.71.4    calico-control-plane   <none>           <none>
coredns-589f44dc88-p4k8r                       1/1     Running   0          5m45s   192.168.71.2    calico-control-plane   <none>           <none>
coredns-589f44dc88-xq2j2                       1/1     Running   0          10s     192.168.88.2    calico-worker2         <none>           <none>
etcd-calico-control-plane                      1/1     Running   0          5m53s   172.18.0.2      calico-control-plane   <none>           <none>
kube-apiserver-calico-control-plane            1/1     Running   0          5m50s   172.18.0.2      calico-control-plane   <none>           <none>
kube-controller-manager-calico-control-plane   1/1     Running   0          5m50s   172.18.0.2      calico-control-plane   <none>           <none>
kube-proxy-fcvkr                               1/1     Running   0          5m42s   172.18.0.3      calico-worker2         <none>           <none>
kube-proxy-q7fbl                               1/1     Running   0          5m42s   172.18.0.4      calico-worker          <none>           <none>
kube-proxy-qp788                               1/1     Running   0          5m45s   172.18.0.2      calico-control-plane   <none>           <none>
kube-scheduler-calico-control-plane            1/1     Running   0          5m52s   172.18.0.2      calico-control-plane   <none>           <none>
```

```log
22
```

</details>

```bash
ip -br a

ip route

arp

arp -na
```

<details>
<summary>
Просмотр сетевого окружения на одно из nodы control-plane с CNI Calico
</summary>

```log
lo               UNKNOWN        127.0.0.1/8 ::1/128 
eth0@if18        UP             172.18.0.2/16 fc00:f853:ccd:e793::2/64 fe80::d830:3aff:fe64:9b09/64 
tunl0@NONE       UNKNOWN        192.168.71.0/32 
cali3d40f5871ce@if4 UP             fe80::ecee:eeff:feee:eeee/64 
cali5958a8fd1b3@if4 UP             fe80::ecee:eeff:feee:eeee/64 
cali1b9ad3fa474@if4 UP             fe80::ecee:eeff:feee:eeee/64 
cali2e3c11611ea@if4 UP             fe80::ecee:eeff:feee:eeee/64 
calie07670134c6@if4 UP             fe80::ecee:eeff:feee:eeee/64 

default via 172.18.0.1 dev eth0 
172.18.0.0/16 dev eth0 proto kernel scope link src 172.18.0.2 
192.168.9.128/26 via 172.18.0.4 dev tunl0 proto bird onlink 
blackhole 192.168.71.0/26 proto bird 
192.168.71.1 dev cali3d40f5871ce scope link 
192.168.71.2 dev cali5958a8fd1b3 scope link 
192.168.71.3 dev cali1b9ad3fa474 scope link 
192.168.71.4 dev cali2e3c11611ea scope link 
192.168.71.5 dev calie07670134c6 scope link 
192.168.88.0/26 via 172.18.0.3 dev tunl0 proto bird onlink

Address                  HWtype  HWaddress           Flags Mask            Iface
calico-worker2.kind      ether   ea:0c:fc:c0:a1:01   C                     eth0
192.168.71.3             ether   06:10:0a:c5:17:44   C                     cali1b9ad3fa474
shoellin                 ether   1a:8d:e6:34:5c:d9   C                     eth0
192.168.71.2             ether   56:3e:78:5a:7a:77   C                     cali5958a8fd1b3
192.168.71.4             ether   9a:c0:cf:39:4b:ef   C                     cali2e3c11611ea
calico-worker.kind       ether   fe:fe:38:dc:6f:b7   C                     eth0
192.168.71.5             ether   8a:56:10:06:48:ca   C                     calie07670134c6
192.168.71.1             ether   92:35:33:f6:02:8e   C                     cali3d40f5871ce

? (172.18.0.3) at ea:0c:fc:c0:a1:01 [ether] on eth0
? (192.168.71.3) at 06:10:0a:c5:17:44 [ether] on cali1b9ad3fa474
? (172.18.0.1) at 1a:8d:e6:34:5c:d9 [ether] on eth0
? (192.168.71.2) at 56:3e:78:5a:7a:77 [ether] on cali5958a8fd1b3
? (192.168.71.4) at 9a:c0:cf:39:4b:ef [ether] on cali2e3c11611ea
? (172.18.0.4) at fe:fe:38:dc:6f:b7 [ether] on eth0
? (192.168.71.5) at 8a:56:10:06:48:ca [ether] on calie07670134c6
? (192.168.71.1) at 92:35:33:f6:02:8e [ether] on cali3d40f5871ce
```

</details>

### Команда: просмотр статистики сетевых интерфейсов

```bash
ip -s a
```

<details>
<summary>
Вывод статистики для всех сетевых интерфейсов
</summary>

```log
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host proto kernel_lo 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
      61885919  184461      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
      61885919  184461      0       0       0       0 
2: eth0@if18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether da:30:3a:64:9b:09 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.18.0.2/16 brd 172.18.255.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fc00:f853:ccd:e793::2/64 scope global nodad 
       valid_lft forever preferred_lft forever
    inet6 fe80::d830:3aff:fe64:9b09/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
     220699806  153212      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
      16382024   83349      0       0       0       0 
3: tunl0@NONE: <NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
    inet 192.168.71.0/32 scope global tunl0
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
             0       0      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
             0       0      0       0       0       0 
6: cali3d40f5871ce@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1480 qdisc noqueue state UP group default 
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-8cf635bd-e390-5cea-1e7a-0c1d7a491146
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
         10898     102      0       1       0       0 
    TX:  bytes packets errors dropped carrier collsns           
         16164      83      0       0       0       0 
7: cali5958a8fd1b3@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1480 qdisc noqueue state UP group default 
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-3ea146dd-7135-4405-5ec6-f8644a451f7d
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
         71154     705      0       1       0       0 
    TX:  bytes packets errors dropped carrier collsns           
        119936     756      0       0       0       0 
8: cali1b9ad3fa474@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1480 qdisc noqueue state UP group default 
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-cc1c2635-50fd-b86f-e203-ec886695bffe
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
         59945     646      0       1       0       0 
    TX:  bytes packets errors dropped carrier collsns           
       1093771     611      0       0       0       0 
9: cali2e3c11611ea@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1480 qdisc noqueue state UP group default 
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-5628540e-1cf2-7668-9468-79d61782de3b
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
         70052     694      0       1       0       0 
    TX:  bytes packets errors dropped carrier collsns           
        116880     749      0       0       0       0 
10: calie07670134c6@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1480 qdisc noqueue state UP group default 
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-62567ead-aab2-ec47-b991-65e22681137f
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
    RX:  bytes packets errors dropped  missed   mcast           
         43869     415      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
         86367     430      0       0       0       0
```

</details>

### Команда: просмотр таблицы маршрутизации

```bash
route -n
```

<details>
<summary>
Вывод маршрутов со стороны ноды contol-plane с CNI calico
</summary>

```log
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         172.18.0.1      0.0.0.0         UG    0      0        0 eth0
172.18.0.0      0.0.0.0         255.255.0.0     U     0      0        0 eth0
192.168.9.128   172.18.0.4      255.255.255.192 UG    0      0        0 tunl0
192.168.71.0    0.0.0.0         255.255.255.192 U     0      0        0 *
192.168.71.1    0.0.0.0         255.255.255.255 UH    0      0        0 cali3d40f5871ce
192.168.71.2    0.0.0.0         255.255.255.255 UH    0      0        0 cali5958a8fd1b3
192.168.71.3    0.0.0.0         255.255.255.255 UH    0      0        0 cali1b9ad3fa474
192.168.71.4    0.0.0.0         255.255.255.255 UH    0      0        0 cali2e3c11611ea
192.168.71.5    0.0.0.0         255.255.255.255 UH    0      0        0 calie07670134c6
192.168.88.0    172.18.0.3      255.255.255.192 UG    0      0        0 tunl0
```

</details>

### Команда: установка tcpdump в контейнере control-plane

```bash
apt-get update \
; apt-get install -y tcpdump
```

```bash
kubectl get pods -n kube-system -o wide | grep 71.2
```

```log
coredns-589f44dc88-p4k8r                       1/1     Running   0          23m   192.168.71.2    calico-control-plane   <none>           <none>
```

```bash
docker exec -it calico-control-plane bash
```

```bash
arp  | grep 71.2
```

```log
192.168.71.2  ether  56:3e:78:5a:7a:77  C  cali5958a8fd1b3 
```

### Команда: захват трафика tcpdump

```bash
tcpdump -i cali5958a8fd1b3 -n
```

<details>
<summary>
Вывод tcpdump с control-plane Ноды
</summary>

```log
listening on cali5958a8fd1b3, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:11:41.593376 IP 10.96.0.1.443 > 192.168.71.2.42782: Flags [P.], seq 4195941954:4195942072, ack 695528995, win 77, options [nop,nop,TS val 2139649379 ecr 270858628], length 118
17:11:41.593410 IP 192.168.71.2.42782 > 10.96.0.1.443: Flags [.], ack 118, win 93, options [nop,nop,TS val 270887232 ecr 2139649379], length 0
17:11:42.431035 IP 172.18.0.2.44222 > 192.168.71.2.8080: Flags [S], seq 660560293, win 64800, options [mss 1440,sackOK,TS val 3881069198 ecr 0,nop,wscale 10], length 0
17:11:42.431071 IP 192.168.71.2.8080 > 172.18.0.2.44222: Flags [S.], seq 2205280232, ack 660560294, win 64260, options [mss 1440,sackOK,TS val 763945097 ecr 3881069198,nop,wscale 10], length 0
17:11:42.431116 IP 172.18.0.2.44222 > 192.168.71.2.8080: Flags [.], ack 1, win 64, options [nop,nop,TS val 3881069198 ecr 763945097], length 0
17:11:42.431290 IP 172.18.0.2.44222 > 192.168.71.2.8080: Flags [P.], seq 1:111, ack 1, win 64, options [nop,nop,TS val 3881069198 ecr 763945097], length 110: HTTP: GET /health HTTP/1.1
17:11:42.431312 IP 192.168.71.2.8080 > 172.18.0.2.44222: Flags [.], ack 111, win 63, options [nop,nop,TS val 763945097 ecr 3881069198], length 0
17:11:42.431445 IP 192.168.71.2.8080 > 172.18.0.2.44222: Flags [P.], seq 1:138, ack 111, win 63, options [nop,nop,TS val 763945097 ecr 3881069198], length 137: HTTP: HTTP/1.1 200 OK
17:11:42.431492 IP 172.18.0.2.44222 > 192.168.71.2.8080: Flags [.], ack 138, win 64, options [nop,nop,TS val 3881069198 ecr 763945097], length 0
17:11:42.431563 IP 192.168.71.2.8080 > 172.18.0.2.44222: Flags [F.], seq 138, ack 111, win 63, options [nop,nop,TS val 763945097 ecr 3881069198], length 0
17:11:42.431616 IP 172.18.0.2.44222 > 192.168.71.2.8080: Flags [F.], seq 111, ack 139, win 64, options [nop,nop,TS val 3881069198 ecr 763945097], length 0
17:11:42.431671 IP 192.168.71.2.8080 > 172.18.0.2.44222: Flags [.], ack 112, win 63, options [nop,nop,TS val 763945097 ecr 3881069198], length 0
^C
12 packets captured
23 packets received by filter
0 packets dropped by kernel
```

</details>

### Команда: захват трафика tcpdump с фильтром по хосту

```bash
tcpdump host 172.18.0.2 -i cali5958a8fd1b3
```

<details>
<summary>
Вывод tcpdump с control-plane Ноды
</summary>

```log
listening on cali5958a8fd1b3, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:12:42.431219 IP calico-control-plane.49732 > 192.168.71.2.http-alt: Flags [S], seq 540310610, win 64800, options [mss 1440,sackOK,TS val 2551670269 ecr 0,nop,wscale 10], length 0
17:12:42.431262 IP 192.168.71.2.http-alt > calico-control-plane.49732: Flags [S.], seq 403996289, ack 540310611, win 64260, options [mss 1440,sackOK,TS val 4084053615 ecr 2551670269,nop,wscale 10], length 0
17:12:42.431311 IP calico-control-plane.49732 > 192.168.71.2.http-alt: Flags [.], ack 1, win 64, options [nop,nop,TS val 2551670269 ecr 4084053615], length 0
17:12:42.431501 IP calico-control-plane.49732 > 192.168.71.2.http-alt: Flags [P.], seq 1:111, ack 1, win 64, options [nop,nop,TS val 2551670269 ecr 4084053615], length 110: HTTP: GET /health HTTP/1.1
17:12:42.431534 IP 192.168.71.2.http-alt > calico-control-plane.49732: Flags [.], ack 111, win 63, options [nop,nop,TS val 4084053615 ecr 2551670269], length 0
17:12:42.431671 IP 192.168.71.2.http-alt > calico-control-plane.49732: Flags [P.], seq 1:138, ack 111, win 63, options [nop,nop,TS val 4084053616 ecr 2551670269], length 137: HTTP: HTTP/1.1 200 OK
17:12:42.431722 IP calico-control-plane.49732 > 192.168.71.2.http-alt: Flags [.], ack 138, win 64, options [nop,nop,TS val 2551670270 ecr 4084053616], length 0
17:12:42.431823 IP 192.168.71.2.http-alt > calico-control-plane.49732: Flags [F.], seq 138, ack 111, win 63, options [nop,nop,TS val 4084053616 ecr 2551670270], length 0
17:12:42.431870 IP calico-control-plane.49732 > 192.168.71.2.http-alt: Flags [F.], seq 111, ack 138, win 64, options [nop,nop,TS val 2551670270 ecr 4084053616], length 0
17:12:42.431894 IP 192.168.71.2.http-alt > calico-control-plane.49732: Flags [.], ack 112, win 63, options [nop,nop,TS val 4084053616 ecr 2551670270], length 0
17:12:42.431931 IP calico-control-plane.49732 > 192.168.71.2.http-alt: Flags [.], ack 139, win 64, options [nop,nop,TS val 2551670270 ecr 4084053616], length 0
17:12:43.239191 IP calico-control-plane.37458 > 192.168.71.2.8181: Flags [S], seq 2544782503, win 64800, options [mss 1440,sackOK,TS val 690650298 ecr 0,nop,wscale 10], length 0
17:12:43.239228 IP 192.168.71.2.8181 > calico-control-plane.37458: Flags [S.], seq 2799811788, ack 2544782504, win 64260, options [mss 1440,sackOK,TS val 3192595189 ecr 690650298,nop,wscale 10], length 0
17:12:43.239268 IP calico-control-plane.37458 > 192.168.71.2.8181: Flags [.], ack 1, win 64, options [nop,nop,TS val 690650298 ecr 3192595189], length 0
17:12:43.239421 IP calico-control-plane.37458 > 192.168.71.2.8181: Flags [P.], seq 1:110, ack 1, win 64, options [nop,nop,TS val 690650298 ecr 3192595189], length 109
17:12:43.239441 IP 192.168.71.2.8181 > calico-control-plane.37458: Flags [.], ack 110, win 63, options [nop,nop,TS val 3192595189 ecr 690650298], length 0
17:12:43.239521 IP 192.168.71.2.8181 > calico-control-plane.37458: Flags [P.], seq 1:138, ack 110, win 63, options [nop,nop,TS val 3192595189 ecr 690650298], length 137
17:12:43.239540 IP calico-control-plane.37458 > 192.168.71.2.8181: Flags [.], ack 138, win 64, options [nop,nop,TS val 690650298 ecr 3192595189], length 0
17:12:43.239570 IP 192.168.71.2.8181 > calico-control-plane.37458: Flags [F.], seq 138, ack 110, win 63, options [nop,nop,TS val 3192595189 ecr 690650298], length 0
17:12:43.239617 IP calico-control-plane.37458 > 192.168.71.2.8181: Flags [F.], seq 110, ack 139, win 64, options [nop,nop,TS val 690650298 ecr 3192595189], length 0
17:12:43.239664 IP 192.168.71.2.8181 > calico-control-plane.37458: Flags [.], ack 111, win 63, options [nop,nop,TS val 3192595189 ecr 690650298], length 0
^C
21 packets captured
21 packets received by filter
0 packets dropped by kernel
```

</details>

### Команда: просмотр правил iptables

```bash
iptables-save
```

<details>
<summary>
Вывод правил iptables с CNI Antrea
</summary>

```log
# Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:14:09 2026
*mangle
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
:KUBE-IPTABLES-HINT - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-PROXY-CANARY - [0:0]
:cali-POSTROUTING - [0:0]
:cali-PREROUTING - [0:0]
:cali-from-host-endpoint - [0:0]
:cali-to-host-endpoint - [0:0]
-A PREROUTING -m comment --comment "cali:6gwbT8clXdHdC1b1" -j cali-PREROUTING
-A POSTROUTING -m comment --comment "cali:O3lYWMrLQYEMJtB5" -j cali-POSTROUTING
-A cali-POSTROUTING -m comment --comment "cali:NX-7roTexQ3fGRfU" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-POSTROUTING -m comment --comment "cali:nnqPh8lh2VOogSzX" -j MARK --set-xmark 0x0/0xf0000
-A cali-POSTROUTING -m comment --comment "cali:nquN8Jw8Tz72pcBW" -m conntrack --ctstate DNAT -j cali-to-host-endpoint
-A cali-POSTROUTING -m comment --comment "cali:jWrgvDQ0xEZHmta3" -m comment --comment "Host endpoint policy accepted packet." -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-PREROUTING -m comment --comment "cali:6BJqBjBC7crtA-7-" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-PREROUTING -m comment --comment "cali:KX7AGNd6rMcDUai6" -m mark --mark 0x10000/0x10000 -j ACCEPT
-A cali-PREROUTING -m comment --comment "cali:wNH7KsA3ILKJBsY9" -j cali-from-host-endpoint
-A cali-PREROUTING -m comment --comment "cali:Cg96MgVuoPm7UMRo" -m comment --comment "Host endpoint policy accepted packet." -m mark --mark 0x10000/0x10000 -j ACCEPT
COMMIT
# Completed on Sun Aug  2 17:14:09 2026
# Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:14:09 2026
*raw
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:cali-OUTPUT - [0:0]
:cali-PREROUTING - [0:0]
:cali-from-host-endpoint - [0:0]
:cali-rpf-skip - [0:0]
:cali-to-host-endpoint - [0:0]
-A PREROUTING -m comment --comment "cali:6gwbT8clXdHdC1b1" -j cali-PREROUTING
-A OUTPUT -m comment --comment "cali:tVnHkvAo15HuiPy0" -j cali-OUTPUT
-A cali-OUTPUT -m comment --comment "cali:njdnLwYeGqBJyMxW" -j MARK --set-xmark 0x0/0xf0000
-A cali-OUTPUT -m comment --comment "cali:rz86uTUcEZAfFsh7" -j cali-to-host-endpoint
-A cali-OUTPUT -m comment --comment "cali:pN0F5zD0b8yf9W1Z" -m mark --mark 0x10000/0x10000 -j ACCEPT
-A cali-PREROUTING -m comment --comment "cali:XFX5xbM8B9qR10JG" -j MARK --set-xmark 0x0/0xf0000
-A cali-PREROUTING -i cali+ -m comment --comment "cali:EWMPb0zVROM-woQp" -j MARK --set-xmark 0x40000/0x40000
-A cali-PREROUTING -m comment --comment "cali:PWuxTAIaFCtsg5Qa" -m mark --mark 0x40000/0x40000 -j cali-rpf-skip
-A cali-PREROUTING -m comment --comment "cali:fSSbGND7dgyemWU7" -m mark --mark 0x40000/0x40000 -m rpfilter --validmark --invert -j DROP
-A cali-PREROUTING -m comment --comment "cali:ImU0-4Rl2WoOI9Ou" -m mark --mark 0x0/0x40000 -j cali-from-host-endpoint
-A cali-PREROUTING -m comment --comment "cali:lV4V2MPoMBf0hl9T" -m mark --mark 0x10000/0x10000 -j ACCEPT
COMMIT
# Completed on Sun Aug  2 17:14:09 2026
# Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:14:09 2026
*filter
:INPUT ACCEPT [547825:313958228]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [484267:112709574]
:KUBE-EXTERNAL-SERVICES - [0:0]
:KUBE-FIREWALL - [0:0]
:KUBE-FORWARD - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-NODEPORTS - [0:0]
:KUBE-PROXY-CANARY - [0:0]
:KUBE-PROXY-FIREWALL - [0:0]
:KUBE-SERVICES - [0:0]
:cali-FORWARD - [0:0]
:cali-INPUT - [0:0]
:cali-OUTPUT - [0:0]
:cali-cidr-block - [0:0]
:cali-from-hep-forward - [0:0]
:cali-from-host-endpoint - [0:0]
:cali-from-wl-dispatch - [0:0]
:cali-fw-cali1b9ad3fa474 - [0:0]
:cali-fw-cali2e3c11611ea - [0:0]
:cali-fw-cali3d40f5871ce - [0:0]
:cali-fw-cali5958a8fd1b3 - [0:0]
:cali-fw-calie07670134c6 - [0:0]
:cali-pri-_Fbc9Uzqla4kSgumjTb - [0:0]
:cali-pri-_NB9zZ6CLqAwN85RObG - [0:0]
:cali-pri-_PTRGc0U-L5Kz7V6ERW - [0:0]
:cali-pri-_u2Tn2rSoAPffvE7JO6 - [0:0]
:cali-pri-kns.kube-system - [0:0]
:cali-pro-_Fbc9Uzqla4kSgumjTb - [0:0]
:cali-pro-_NB9zZ6CLqAwN85RObG - [0:0]
:cali-pro-_PTRGc0U-L5Kz7V6ERW - [0:0]
:cali-pro-_u2Tn2rSoAPffvE7JO6 - [0:0]
:cali-pro-kns.kube-system - [0:0]
:cali-to-hep-forward - [0:0]
:cali-to-host-endpoint - [0:0]
:cali-to-wl-dispatch - [0:0]
:cali-tw-cali1b9ad3fa474 - [0:0]
:cali-tw-cali2e3c11611ea - [0:0]
:cali-tw-cali3d40f5871ce - [0:0]
:cali-tw-cali5958a8fd1b3 - [0:0]
:cali-tw-calie07670134c6 - [0:0]
:cali-wl-to-host - [0:0]
-A INPUT -m comment --comment "cali:Cz_u1IQiXIMmKD4c" -j cali-INPUT
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A INPUT -m comment --comment "kubernetes health check service ports" -j KUBE-NODEPORTS
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A INPUT -j KUBE-FIREWALL
-A FORWARD -m comment --comment "cali:wUHhoiAYhphO9Mso" -j cali-FORWARD
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A FORWARD -m comment --comment "kubernetes forwarding rules" -j KUBE-FORWARD
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A FORWARD -m comment --comment "cali:S93hcgKJrXEqnTfs" -m comment --comment "Policy explicitly accepted packet." -m mark --mark 0x10000/0x10000 -j ACCEPT
-A FORWARD -m comment --comment "cali:mp77cMpurHhyjLrM" -j MARK --set-xmark 0x10000/0x10000
-A OUTPUT -m comment --comment "cali:tVnHkvAo15HuiPy0" -j cali-OUTPUT
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -j KUBE-FIREWALL
-A KUBE-FIREWALL ! -s 127.0.0.0/8 -d 127.0.0.0/8 -m comment --comment "block incoming localnet connections" -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT -j DROP
-A KUBE-FORWARD -m conntrack --ctstate INVALID -m nfacct --nfacct-name  ct_state_invalid_dropped_pkts -j DROP
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding conntrack rule" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-FORWARD -m comment --comment "cali:vjrMJCRpqwy5oRoX" -j MARK --set-xmark 0x0/0xe0000
-A cali-FORWARD -m comment --comment "cali:A_sPAO0mcxbT9mOV" -m mark --mark 0x0/0x10000 -j cali-from-hep-forward
-A cali-FORWARD -i cali+ -m comment --comment "cali:8ZoYfO5HKXWbB3pk" -j cali-from-wl-dispatch
-A cali-FORWARD -o cali+ -m comment --comment "cali:jdEuaPBe14V2hutn" -j cali-to-wl-dispatch
-A cali-FORWARD -m comment --comment "cali:12bc6HljsMKsmfr-" -j cali-to-hep-forward
-A cali-FORWARD -m comment --comment "cali:NOSxoaGx8OIstr1z" -j cali-cidr-block
-A cali-INPUT -p 4 -m comment --comment "cali:PajejrV4aFdkZojI" -m comment --comment "Allow IPIP packets from Calico hosts" -m set --match-set cali40all-hosts-net src -m addrtype --dst-type LOCAL -j ACCEPT
-A cali-INPUT -p 4 -m comment --comment "cali:_wjq-Yrma8Ly1Svo" -m comment --comment "Drop IPIP packets from non-Calico hosts" -j DROP
-A cali-INPUT -i cali+ -m comment --comment "cali:8TZGxLWh_Eiz66wc" -g cali-wl-to-host
-A cali-INPUT -m comment --comment "cali:6McIeIDvPdL6PE1T" -m mark --mark 0x10000/0x10000 -j ACCEPT
-A cali-INPUT -m comment --comment "cali:YGPbrUms7NId8xVa" -j MARK --set-xmark 0x0/0xf0000
-A cali-INPUT -m comment --comment "cali:2gmY7Bg2i0i84Wk_" -j cali-from-host-endpoint
-A cali-INPUT -m comment --comment "cali:q-Vz2ZT9iGE331LL" -m comment --comment "Host endpoint policy accepted packet." -m mark --mark 0x10000/0x10000 -j ACCEPT
-A cali-OUTPUT -m comment --comment "cali:Mq1_rAdXXH3YkrzW" -m mark --mark 0x10000/0x10000 -j ACCEPT
-A cali-OUTPUT -o cali+ -m comment --comment "cali:69FkRTJDvD5Vu6Vl" -j RETURN
-A cali-OUTPUT -p 4 -m comment --comment "cali:AnEsmO6bDZbQntWW" -m comment --comment "Allow IPIP packets to other Calico hosts" -m set --match-set cali40all-hosts-net dst -m addrtype --src-type LOCAL -j ACCEPT
-A cali-OUTPUT -m comment --comment "cali:9e9Uf3GU5tX--Lxy" -j MARK --set-xmark 0x0/0xf0000
-A cali-OUTPUT -m comment --comment "cali:0f3LDz_VKuHFaA2K" -m conntrack ! --ctstate DNAT -j cali-to-host-endpoint
-A cali-OUTPUT -m comment --comment "cali:OgU2f8BVEAZ_fwkq" -m comment --comment "Host endpoint policy accepted packet." -m mark --mark 0x10000/0x10000 -j ACCEPT
-A cali-from-wl-dispatch -i cali1b9ad3fa474 -m comment --comment "cali:nGyPEVRTuKXHOesV" -g cali-fw-cali1b9ad3fa474
-A cali-from-wl-dispatch -i cali2e3c11611ea -m comment --comment "cali:VR70cf1BGFuycwMr" -g cali-fw-cali2e3c11611ea
-A cali-from-wl-dispatch -i cali3d40f5871ce -m comment --comment "cali:f8D6fC8tWc2MiEwO" -g cali-fw-cali3d40f5871ce
-A cali-from-wl-dispatch -i cali5958a8fd1b3 -m comment --comment "cali:PNO91lP-vqjdU1yX" -g cali-fw-cali5958a8fd1b3
-A cali-from-wl-dispatch -i calie07670134c6 -m comment --comment "cali:Mb8DAcL2RKWIMM2A" -g cali-fw-calie07670134c6
-A cali-from-wl-dispatch -m comment --comment "cali:Q3SGiVN-LahyeY_I" -m comment --comment "Unknown interface" -j DROP
-A cali-fw-cali1b9ad3fa474 -m comment --comment "cali:PQlXp14cIaeVQ9uf" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-fw-cali1b9ad3fa474 -m comment --comment "cali:eoJwEbvyamQdFs_Z" -m conntrack --ctstate INVALID -j DROP
-A cali-fw-cali1b9ad3fa474 -m comment --comment "cali:jpy6xB7GF_PO67xj" -j MARK --set-xmark 0x0/0x10000
-A cali-fw-cali1b9ad3fa474 -p udp -m comment --comment "cali:OaZ4SoZuhH3iYqfY" -m comment --comment "Drop VXLAN encapped packets originating in workloads" -m multiport --dports 4789 -j DROP
-A cali-fw-cali1b9ad3fa474 -p 4 -m comment --comment "cali:JTdDoGG7xPjHLu05" -m comment --comment "Drop IPinIP encapped packets originating in workloads" -j DROP
-A cali-fw-cali1b9ad3fa474 -m comment --comment "cali:5spaVG7RdY1jyx1O" -j cali-pro-kns.kube-system
-A cali-fw-cali1b9ad3fa474 -m comment --comment "cali:ERRk3x1qshCisxOM" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali1b9ad3fa474 -m comment --comment "cali:LR_wNDukjMyIF9yx" -j cali-pro-_PTRGc0U-L5Kz7V6ERW
-A cali-fw-cali1b9ad3fa474 -m comment --comment "cali:0AI8Ho9U29C2svZt" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali1b9ad3fa474 -m comment --comment "cali:U0Ki9uHz_E8ZXLPl" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-fw-cali2e3c11611ea -m comment --comment "cali:vMXZmRVyCw9S0nYL" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-fw-cali2e3c11611ea -m comment --comment "cali:oLyVcNIgAEeSBct9" -m conntrack --ctstate INVALID -j DROP
-A cali-fw-cali2e3c11611ea -m comment --comment "cali:EsdJI9GrIPaizQbW" -j MARK --set-xmark 0x0/0x10000
-A cali-fw-cali2e3c11611ea -p udp -m comment --comment "cali:kfrtD2sLbzbJM4o0" -m comment --comment "Drop VXLAN encapped packets originating in workloads" -m multiport --dports 4789 -j DROP
-A cali-fw-cali2e3c11611ea -p 4 -m comment --comment "cali:wUwpUCg_5I-18Jqi" -m comment --comment "Drop IPinIP encapped packets originating in workloads" -j DROP
-A cali-fw-cali2e3c11611ea -m comment --comment "cali:6p5KT436HtCE-8Io" -j cali-pro-kns.kube-system
-A cali-fw-cali2e3c11611ea -m comment --comment "cali:jfDT7_49TJOWsLuE" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali2e3c11611ea -m comment --comment "cali:rw5K01O67XbNubED" -j cali-pro-_u2Tn2rSoAPffvE7JO6
-A cali-fw-cali2e3c11611ea -m comment --comment "cali:omdUaSEU-uFx8hv1" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali2e3c11611ea -m comment --comment "cali:vzBc4_S2AzW20aIW" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-fw-cali3d40f5871ce -m comment --comment "cali:agz4Pbhti4s-Vxbw" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-fw-cali3d40f5871ce -m comment --comment "cali:J0uHkMDTx1xHcsU5" -m conntrack --ctstate INVALID -j DROP
-A cali-fw-cali3d40f5871ce -m comment --comment "cali:gQjrV0-A54XVcxMy" -j MARK --set-xmark 0x0/0x10000
-A cali-fw-cali3d40f5871ce -p udp -m comment --comment "cali:_UJ34FTjPNlDRGwL" -m comment --comment "Drop VXLAN encapped packets originating in workloads" -m multiport --dports 4789 -j DROP
-A cali-fw-cali3d40f5871ce -p 4 -m comment --comment "cali:Wy0PLW1CEti4vwha" -m comment --comment "Drop IPinIP encapped packets originating in workloads" -j DROP
-A cali-fw-cali3d40f5871ce -m comment --comment "cali:AMPgminoyR7hkMro" -j cali-pro-_Fbc9Uzqla4kSgumjTb
-A cali-fw-cali3d40f5871ce -m comment --comment "cali:8hSwYwdZ2aoq0rV3" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali3d40f5871ce -m comment --comment "cali:4uy7X-n0Sq9PPDMW" -j cali-pro-_NB9zZ6CLqAwN85RObG
-A cali-fw-cali3d40f5871ce -m comment --comment "cali:JP2Yt4CXz_ofp-bo" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali3d40f5871ce -m comment --comment "cali:2awk69p7INwPNwzA" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-fw-cali5958a8fd1b3 -m comment --comment "cali:T99dt3YbWUJznMbC" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-fw-cali5958a8fd1b3 -m comment --comment "cali:zLwSLDZi5UwYRNSz" -m conntrack --ctstate INVALID -j DROP
-A cali-fw-cali5958a8fd1b3 -m comment --comment "cali:LUuWvaDqQR_Ijaj8" -j MARK --set-xmark 0x0/0x10000
-A cali-fw-cali5958a8fd1b3 -p udp -m comment --comment "cali:1RSIsELP8-mDU-H9" -m comment --comment "Drop VXLAN encapped packets originating in workloads" -m multiport --dports 4789 -j DROP
-A cali-fw-cali5958a8fd1b3 -p 4 -m comment --comment "cali:d4QBojY54v71mReH" -m comment --comment "Drop IPinIP encapped packets originating in workloads" -j DROP
-A cali-fw-cali5958a8fd1b3 -m comment --comment "cali:tZhkmPDTz68sfZS7" -j cali-pro-kns.kube-system
-A cali-fw-cali5958a8fd1b3 -m comment --comment "cali:g89GjB9CsT3g7Au4" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali5958a8fd1b3 -m comment --comment "cali:jbpl2IuVN7y-Wpur" -j cali-pro-_u2Tn2rSoAPffvE7JO6
-A cali-fw-cali5958a8fd1b3 -m comment --comment "cali:PLIXFDvca7PpIG90" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali5958a8fd1b3 -m comment --comment "cali:b6WhdlxTDkFIjCGX" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-fw-calie07670134c6 -m comment --comment "cali:6ZqD7ROe8ISC6S-S" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-fw-calie07670134c6 -m comment --comment "cali:mwzAGUOxXBJu22UJ" -m conntrack --ctstate INVALID -j DROP
-A cali-fw-calie07670134c6 -m comment --comment "cali:L9QOD4mf_398mdgE" -j MARK --set-xmark 0x0/0x10000
-A cali-fw-calie07670134c6 -p udp -m comment --comment "cali:a5ATvte1WYANxW0Y" -m comment --comment "Drop VXLAN encapped packets originating in workloads" -m multiport --dports 4789 -j DROP
-A cali-fw-calie07670134c6 -p 4 -m comment --comment "cali:hraeb4zmEJ3jTKVf" -m comment --comment "Drop IPinIP encapped packets originating in workloads" -j DROP
-A cali-fw-calie07670134c6 -m comment --comment "cali:acrxOLE5qJRElzwf" -j cali-pro-kns.kube-system
-A cali-fw-calie07670134c6 -m comment --comment "cali:MXouDTZMTVAYTlNb" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-calie07670134c6 -m comment --comment "cali:g2ufvSkCpRSa_Yir" -j cali-pro-_u2Tn2rSoAPffvE7JO6
-A cali-fw-calie07670134c6 -m comment --comment "cali:6YcaDoNG2coIes3X" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-calie07670134c6 -m comment --comment "cali:Fjxg3YUhGNi1Lmd9" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-pri-_Fbc9Uzqla4kSgumjTb -m comment --comment "cali:mhJJBkogVZsmcFYT" -m comment --comment "Profile kns.local-path-storage ingress" -j MARK --set-xmark 0x10000/0x10000
-A cali-pri-_Fbc9Uzqla4kSgumjTb -m comment --comment "cali:5dsuZCaL1po2QneY" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-pri-_NB9zZ6CLqAwN85RObG -m comment --comment "cali:ql_I1PveGKMGBb3y" -m comment --comment "Profile ksa.local-path-storage.local-path-provisioner-service-account ingress"
-A cali-pri-_PTRGc0U-L5Kz7V6ERW -m comment --comment "cali:g4z4yZxg6IEqYbOs" -m comment --comment "Profile ksa.kube-system.calico-kube-controllers ingress"
-A cali-pri-_u2Tn2rSoAPffvE7JO6 -m comment --comment "cali:WqgznqAQ-uYV0oBx" -m comment --comment "Profile ksa.kube-system.coredns ingress"
-A cali-pri-kns.kube-system -m comment --comment "cali:J1TyxtHWd0qaBGK-" -m comment --comment "Profile kns.kube-system ingress" -j MARK --set-xmark 0x10000/0x10000
-A cali-pri-kns.kube-system -m comment --comment "cali:QIB6k7eEKdIg73Jp" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-pro-_Fbc9Uzqla4kSgumjTb -m comment --comment "cali:_jJcYdM5caQ3bH9X" -m comment --comment "Profile kns.local-path-storage egress" -j MARK --set-xmark 0x10000/0x10000
-A cali-pro-_Fbc9Uzqla4kSgumjTb -m comment --comment "cali:DqonQV8pXLEY1pl3" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-pro-_NB9zZ6CLqAwN85RObG -m comment --comment "cali:7x9KFvwtPTTLg4p3" -m comment --comment "Profile ksa.local-path-storage.local-path-provisioner-service-account egress"
-A cali-pro-_PTRGc0U-L5Kz7V6ERW -m comment --comment "cali:DR9-t6YJRvFY-IdZ" -m comment --comment "Profile ksa.kube-system.calico-kube-controllers egress"
-A cali-pro-_u2Tn2rSoAPffvE7JO6 -m comment --comment "cali:0-_UPh39dt5XfhmJ" -m comment --comment "Profile ksa.kube-system.coredns egress"
-A cali-pro-kns.kube-system -m comment --comment "cali:tgOR2S8DVHZW3F1M" -m comment --comment "Profile kns.kube-system egress" -j MARK --set-xmark 0x10000/0x10000
-A cali-pro-kns.kube-system -m comment --comment "cali:HVEEtYPJsiGRXCIt" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-to-wl-dispatch -o cali1b9ad3fa474 -m comment --comment "cali:UDDkrNwazY2cKYA5" -g cali-tw-cali1b9ad3fa474
-A cali-to-wl-dispatch -o cali2e3c11611ea -m comment --comment "cali:TWCZ5CJhh_SOFQ-h" -g cali-tw-cali2e3c11611ea
-A cali-to-wl-dispatch -o cali3d40f5871ce -m comment --comment "cali:d_iNaxNsD7wP1_D2" -g cali-tw-cali3d40f5871ce
-A cali-to-wl-dispatch -o cali5958a8fd1b3 -m comment --comment "cali:WkIe8HXAQBNbxjDY" -g cali-tw-cali5958a8fd1b3
-A cali-to-wl-dispatch -o calie07670134c6 -m comment --comment "cali:VjOATyhOisAx1OD2" -g cali-tw-calie07670134c6
-A cali-to-wl-dispatch -m comment --comment "cali:HHT8uu99Kg9Wh6UN" -m comment --comment "Unknown interface" -j DROP
-A cali-tw-cali1b9ad3fa474 -m comment --comment "cali:WdhjCOXSTVfoEInD" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-tw-cali1b9ad3fa474 -m comment --comment "cali:L1MBZlV4LL5hlV2f" -m conntrack --ctstate INVALID -j DROP
-A cali-tw-cali1b9ad3fa474 -m comment --comment "cali:QFRI04qZTWTcymMu" -j MARK --set-xmark 0x0/0x10000
-A cali-tw-cali1b9ad3fa474 -m comment --comment "cali:B8K41I5aY-UiLs_o" -j cali-pri-kns.kube-system
-A cali-tw-cali1b9ad3fa474 -m comment --comment "cali:rL32-fNBxupBG138" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali1b9ad3fa474 -m comment --comment "cali:87CXyYnFV5MhY6v_" -j cali-pri-_PTRGc0U-L5Kz7V6ERW
-A cali-tw-cali1b9ad3fa474 -m comment --comment "cali:iZUadEx2qoC5rj7V" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali1b9ad3fa474 -m comment --comment "cali:y3A3S4OwnkGTEx0j" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-tw-cali2e3c11611ea -m comment --comment "cali:5PzOMHlMqNRaK6Xg" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-tw-cali2e3c11611ea -m comment --comment "cali:o1bWoqMShw_Z4D8d" -m conntrack --ctstate INVALID -j DROP
-A cali-tw-cali2e3c11611ea -m comment --comment "cali:CGqDHSG06y68Pprg" -j MARK --set-xmark 0x0/0x10000
-A cali-tw-cali2e3c11611ea -m comment --comment "cali:WYmy-uvWNiBeZKgn" -j cali-pri-kns.kube-system
-A cali-tw-cali2e3c11611ea -m comment --comment "cali:x2HPCSikKFDlXD8j" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali2e3c11611ea -m comment --comment "cali:lii4pScA-yZ-L1fF" -j cali-pri-_u2Tn2rSoAPffvE7JO6
-A cali-tw-cali2e3c11611ea -m comment --comment "cali:d_I2chdA3I9G73uA" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali2e3c11611ea -m comment --comment "cali:fxL-iMmcTnSuYnSo" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-tw-cali3d40f5871ce -m comment --comment "cali:xB1vKf2JnFNWr7Ml" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-tw-cali3d40f5871ce -m comment --comment "cali:rCyiRMzlHj-IrGGF" -m conntrack --ctstate INVALID -j DROP
-A cali-tw-cali3d40f5871ce -m comment --comment "cali:XDugmFBWvf4HolE2" -j MARK --set-xmark 0x0/0x10000
-A cali-tw-cali3d40f5871ce -m comment --comment "cali:ejsZ27Q9CHpoPUzI" -j cali-pri-_Fbc9Uzqla4kSgumjTb
-A cali-tw-cali3d40f5871ce -m comment --comment "cali:fiOzwN2GdV4gnC4H" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali3d40f5871ce -m comment --comment "cali:IncrUjUCCCQsXgs8" -j cali-pri-_NB9zZ6CLqAwN85RObG
-A cali-tw-cali3d40f5871ce -m comment --comment "cali:20LZOXiciz9mabwE" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali3d40f5871ce -m comment --comment "cali:RXRpiVZ49JJqxQTW" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-tw-cali5958a8fd1b3 -m comment --comment "cali:R3qfRzmOJ0Uknv3C" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-tw-cali5958a8fd1b3 -m comment --comment "cali:F9gzOY8QpjREWu_R" -m conntrack --ctstate INVALID -j DROP
-A cali-tw-cali5958a8fd1b3 -m comment --comment "cali:q5Ll0FtwcVx3308t" -j MARK --set-xmark 0x0/0x10000
-A cali-tw-cali5958a8fd1b3 -m comment --comment "cali:R9PjxhBP_oPgc1po" -j cali-pri-kns.kube-system
-A cali-tw-cali5958a8fd1b3 -m comment --comment "cali:YTYk7HQlYXHUrTGk" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali5958a8fd1b3 -m comment --comment "cali:H5PVLLCoG1iQa13o" -j cali-pri-_u2Tn2rSoAPffvE7JO6
-A cali-tw-cali5958a8fd1b3 -m comment --comment "cali:YSm7p9IrizvlzHMy" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali5958a8fd1b3 -m comment --comment "cali:vUXrzuF1wGH58-fV" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-tw-calie07670134c6 -m comment --comment "cali:QDJyKFrT3IPBpmvs" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-tw-calie07670134c6 -m comment --comment "cali:Rrr7JQ3zhTGHbcst" -m conntrack --ctstate INVALID -j DROP
-A cali-tw-calie07670134c6 -m comment --comment "cali:O1377EJ63WquzZ2j" -j MARK --set-xmark 0x0/0x10000
-A cali-tw-calie07670134c6 -m comment --comment "cali:NH3pFBrsPBsAtZKH" -j cali-pri-kns.kube-system
-A cali-tw-calie07670134c6 -m comment --comment "cali:bJWSqN8h3pCD6SGj" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-calie07670134c6 -m comment --comment "cali:UZoL47gHvCjoOymk" -j cali-pri-_u2Tn2rSoAPffvE7JO6
-A cali-tw-calie07670134c6 -m comment --comment "cali:yCJChdkfQux10mvJ" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-calie07670134c6 -m comment --comment "cali:_LfvCEr-SY41XNAM" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-wl-to-host -m comment --comment "cali:Ee9Sbo10IpVujdIY" -j cali-from-wl-dispatch
-A cali-wl-to-host -m comment --comment "cali:nSZbcOoG1xPONxb8" -m comment --comment "Configured DefaultEndpointToHostAction" -j ACCEPT
COMMIT
# Completed on Sun Aug  2 17:14:09 2026
# Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:14:09 2026
*nat
:PREROUTING ACCEPT [116:7062]
:INPUT ACCEPT [123:7453]
:OUTPUT ACCEPT [7391:443460]
:POSTROUTING ACCEPT [7496:451814]
:DOCKER_OUTPUT - [0:0]
:DOCKER_POSTROUTING - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-MARK-MASQ - [0:0]
:KUBE-NODEPORTS - [0:0]
:KUBE-POSTROUTING - [0:0]
:KUBE-PROXY-CANARY - [0:0]
:KUBE-SEP-3HNLM3OSNOIBNAOC - [0:0]
:KUBE-SEP-3PC2O67L6IMUQGMB - [0:0]
:KUBE-SEP-4UPIMWSXV2DOCUVP - [0:0]
:KUBE-SEP-565FQKNMQPWQHA67 - [0:0]
:KUBE-SEP-67U65MPDK2EF2T76 - [0:0]
:KUBE-SEP-6AZ2TPBXTOSKHW5N - [0:0]
:KUBE-SEP-6LGFVRTSRQTZ5JJY - [0:0]
:KUBE-SEP-BEFQHDDTQ3SZ7PYQ - [0:0]
:KUBE-SEP-BWDOFTKBPB6WEGFO - [0:0]
:KUBE-SEP-BX37LZFYWKO6VNLV - [0:0]
:KUBE-SEP-C32B2XKN4N57M3BD - [0:0]
:KUBE-SEP-DIEY7AEBLUF6EUOK - [0:0]
:KUBE-SEP-DSQFCUXGLTKU7XHC - [0:0]
:KUBE-SEP-EXY6NTATUESOFVUK - [0:0]
:KUBE-SEP-HVRFQXNELWMKM4Q7 - [0:0]
:KUBE-SEP-IFUIGKJEBQAMBLAI - [0:0]
:KUBE-SEP-LXLKXXZ7MEYEB64R - [0:0]
:KUBE-SEP-NAEMZFFBWZ6KLFN2 - [0:0]
:KUBE-SEP-O3NM4IX5EML5KWM4 - [0:0]
:KUBE-SEP-O6I2NC2I6ZKAHT7K - [0:0]
:KUBE-SEP-OHPN3PMBHBXRFTWL - [0:0]
:KUBE-SEP-QT22LOKHUJUMN6NN - [0:0]
:KUBE-SEP-REQTH7GWTT45FLSF - [0:0]
:KUBE-SEP-RMV4KTZEOBG32N4Z - [0:0]
:KUBE-SEP-S2ZUFSB55QEX7QTD - [0:0]
:KUBE-SEP-SRQRRFOORYGR2F2N - [0:0]
:KUBE-SEP-UCGPS22XINHAFAGV - [0:0]
:KUBE-SEP-UNIDWJ5FCY32UEUX - [0:0]
:KUBE-SEP-V2PECCYPB6X2GSCW - [0:0]
:KUBE-SEP-WUZEPNHQEWM22777 - [0:0]
:KUBE-SEP-X6WM23DNC2CHY7GL - [0:0]
:KUBE-SERVICES - [0:0]
:KUBE-SVC-ERIFXISQEP7F7OF4 - [0:0]
:KUBE-SVC-JD5MR3NA4I4DYORP - [0:0]
:KUBE-SVC-NPX46M4PTMTKRN6Y - [0:0]
:KUBE-SVC-TCOU7JCQXEZGVUNU - [0:0]
:cali-OUTPUT - [0:0]
:cali-POSTROUTING - [0:0]
:cali-PREROUTING - [0:0]
:cali-fip-dnat - [0:0]
:cali-fip-snat - [0:0]
:cali-nat-outgoing - [0:0]
-A PREROUTING -m comment --comment "cali:6gwbT8clXdHdC1b1" -j cali-PREROUTING
-A PREROUTING -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A PREROUTING -d 172.18.0.1/32 -j DOCKER_OUTPUT
-A OUTPUT -m comment --comment "cali:tVnHkvAo15HuiPy0" -j cali-OUTPUT
-A OUTPUT -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -d 172.18.0.1/32 -j DOCKER_OUTPUT
-A POSTROUTING -m comment --comment "cali:O3lYWMrLQYEMJtB5" -j cali-POSTROUTING
-A POSTROUTING -m comment --comment "kubernetes postrouting rules" -j KUBE-POSTROUTING
-A POSTROUTING -d 172.18.0.1/32 -j DOCKER_POSTROUTING
-A DOCKER_OUTPUT -d 172.18.0.1/32 -p tcp -m tcp --dport 53 -j DNAT --to-destination 127.0.0.11:36225
-A DOCKER_OUTPUT -d 172.18.0.1/32 -p udp -m udp --dport 53 -j DNAT --to-destination 127.0.0.11:37368
-A DOCKER_POSTROUTING -s 127.0.0.11/32 -p tcp -m tcp --sport 36225 -j SNAT --to-source 172.18.0.1:53
-A DOCKER_POSTROUTING -s 127.0.0.11/32 -p udp -m udp --sport 37368 -j SNAT --to-source 172.18.0.1:53
-A KUBE-MARK-MASQ -j MARK --set-xmark 0x4000/0x4000
-A KUBE-POSTROUTING -m mark ! --mark 0x4000/0x4000 -j RETURN
-A KUBE-POSTROUTING -j MARK --set-xmark 0x4000/0x0
-A KUBE-POSTROUTING -m comment --comment "kubernetes service traffic requiring SNAT" -j MASQUERADE --random-fully
-A KUBE-SEP-3HNLM3OSNOIBNAOC -s 192.168.88.2/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-3HNLM3OSNOIBNAOC -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 192.168.88.2:53
-A KUBE-SEP-3PC2O67L6IMUQGMB -s 192.168.71.4/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-3PC2O67L6IMUQGMB -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 192.168.71.4:53
-A KUBE-SEP-4UPIMWSXV2DOCUVP -s 192.168.71.2/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-4UPIMWSXV2DOCUVP -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 192.168.71.2:53
-A KUBE-SEP-565FQKNMQPWQHA67 -s 192.168.71.4/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-565FQKNMQPWQHA67 -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 192.168.71.4:9153
-A KUBE-SEP-67U65MPDK2EF2T76 -s 192.168.9.130/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-67U65MPDK2EF2T76 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 192.168.9.130:53
-A KUBE-SEP-6AZ2TPBXTOSKHW5N -s 192.168.9.129/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-6AZ2TPBXTOSKHW5N -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 192.168.9.129:53
-A KUBE-SEP-6LGFVRTSRQTZ5JJY -s 192.168.9.132/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-6LGFVRTSRQTZ5JJY -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 192.168.9.132:53
-A KUBE-SEP-BEFQHDDTQ3SZ7PYQ -s 192.168.9.130/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-BEFQHDDTQ3SZ7PYQ -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 192.168.9.130:9153
-A KUBE-SEP-BWDOFTKBPB6WEGFO -s 192.168.9.130/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-BWDOFTKBPB6WEGFO -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 192.168.9.130:53
-A KUBE-SEP-BX37LZFYWKO6VNLV -s 192.168.71.2/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-BX37LZFYWKO6VNLV -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 192.168.71.2:53
-A KUBE-SEP-C32B2XKN4N57M3BD -s 192.168.9.131/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-C32B2XKN4N57M3BD -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 192.168.9.131:53
-A KUBE-SEP-DIEY7AEBLUF6EUOK -s 192.168.88.2/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-DIEY7AEBLUF6EUOK -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 192.168.88.2:9153
-A KUBE-SEP-DSQFCUXGLTKU7XHC -s 192.168.9.131/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-DSQFCUXGLTKU7XHC -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 192.168.9.131:9153
-A KUBE-SEP-EXY6NTATUESOFVUK -s 192.168.88.1/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-EXY6NTATUESOFVUK -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 192.168.88.1:9153
-A KUBE-SEP-HVRFQXNELWMKM4Q7 -s 192.168.88.3/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-HVRFQXNELWMKM4Q7 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 192.168.88.3:53
-A KUBE-SEP-IFUIGKJEBQAMBLAI -s 192.168.9.132/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-IFUIGKJEBQAMBLAI -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 192.168.9.132:9153
-A KUBE-SEP-LXLKXXZ7MEYEB64R -s 192.168.71.5/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-LXLKXXZ7MEYEB64R -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 192.168.71.5:53
-A KUBE-SEP-NAEMZFFBWZ6KLFN2 -s 192.168.71.5/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-NAEMZFFBWZ6KLFN2 -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 192.168.71.5:9153
-A KUBE-SEP-O3NM4IX5EML5KWM4 -s 192.168.88.3/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-O3NM4IX5EML5KWM4 -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 192.168.88.3:53
-A KUBE-SEP-O6I2NC2I6ZKAHT7K -s 192.168.71.5/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-O6I2NC2I6ZKAHT7K -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 192.168.71.5:53
-A KUBE-SEP-OHPN3PMBHBXRFTWL -s 192.168.88.1/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-OHPN3PMBHBXRFTWL -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 192.168.88.1:53
-A KUBE-SEP-QT22LOKHUJUMN6NN -s 192.168.9.129/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-QT22LOKHUJUMN6NN -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 192.168.9.129:9153
-A KUBE-SEP-REQTH7GWTT45FLSF -s 192.168.9.131/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-REQTH7GWTT45FLSF -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 192.168.9.131:53
-A KUBE-SEP-RMV4KTZEOBG32N4Z -s 192.168.71.4/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-RMV4KTZEOBG32N4Z -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 192.168.71.4:53
-A KUBE-SEP-S2ZUFSB55QEX7QTD -s 192.168.88.1/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-S2ZUFSB55QEX7QTD -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 192.168.88.1:53
-A KUBE-SEP-SRQRRFOORYGR2F2N -s 192.168.9.129/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-SRQRRFOORYGR2F2N -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 192.168.9.129:53
-A KUBE-SEP-UCGPS22XINHAFAGV -s 192.168.88.2/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-UCGPS22XINHAFAGV -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 192.168.88.2:53
-A KUBE-SEP-UNIDWJ5FCY32UEUX -s 192.168.9.132/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-UNIDWJ5FCY32UEUX -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 192.168.9.132:53
-A KUBE-SEP-V2PECCYPB6X2GSCW -s 172.18.0.2/32 -m comment --comment "default/kubernetes:https" -j KUBE-MARK-MASQ
-A KUBE-SEP-V2PECCYPB6X2GSCW -p tcp -m comment --comment "default/kubernetes:https" -m tcp -j DNAT --to-destination 172.18.0.2:6443
-A KUBE-SEP-WUZEPNHQEWM22777 -s 192.168.88.3/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-WUZEPNHQEWM22777 -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 192.168.88.3:9153
-A KUBE-SEP-X6WM23DNC2CHY7GL -s 192.168.71.2/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-X6WM23DNC2CHY7GL -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 192.168.71.2:9153
-A KUBE-SERVICES -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp cluster IP" -m tcp --dport 53 -j KUBE-SVC-ERIFXISQEP7F7OF4
-A KUBE-SERVICES -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:metrics cluster IP" -m tcp --dport 9153 -j KUBE-SVC-JD5MR3NA4I4DYORP
-A KUBE-SERVICES -d 10.96.0.1/32 -p tcp -m comment --comment "default/kubernetes:https cluster IP" -m tcp --dport 443 -j KUBE-SVC-NPX46M4PTMTKRN6Y
-A KUBE-SERVICES -d 10.96.0.10/32 -p udp -m comment --comment "kube-system/kube-dns:dns cluster IP" -m udp --dport 53 -j KUBE-SVC-TCOU7JCQXEZGVUNU
-A KUBE-SERVICES -m comment --comment "kubernetes service nodeports; NOTE: this must be the last rule in this chain" -m addrtype --dst-type LOCAL -j KUBE-NODEPORTS
-A KUBE-SVC-ERIFXISQEP7F7OF4 ! -s 192.168.0.0/16 -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp cluster IP" -m tcp --dport 53 -j KUBE-MARK-MASQ
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 192.168.71.2:53" -m statistic --mode random --probability 0.10000000009 -j KUBE-SEP-4UPIMWSXV2DOCUVP
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 192.168.71.4:53" -m statistic --mode random --probability 0.11111111101 -j KUBE-SEP-3PC2O67L6IMUQGMB
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 192.168.71.5:53" -m statistic --mode random --probability 0.12500000000 -j KUBE-SEP-O6I2NC2I6ZKAHT7K
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 192.168.88.1:53" -m statistic --mode random --probability 0.14285714272 -j KUBE-SEP-S2ZUFSB55QEX7QTD
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 192.168.88.2:53" -m statistic --mode random --probability 0.16666666651 -j KUBE-SEP-3HNLM3OSNOIBNAOC
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 192.168.88.3:53" -m statistic --mode random --probability 0.20000000019 -j KUBE-SEP-HVRFQXNELWMKM4Q7
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 192.168.9.129:53" -m statistic --mode random --probability 0.25000000000 -j KUBE-SEP-SRQRRFOORYGR2F2N
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 192.168.9.130:53" -m statistic --mode random --probability 0.33333333349 -j KUBE-SEP-67U65MPDK2EF2T76
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 192.168.9.131:53" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-C32B2XKN4N57M3BD
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 192.168.9.132:53" -j KUBE-SEP-6LGFVRTSRQTZ5JJY
-A KUBE-SVC-JD5MR3NA4I4DYORP ! -s 192.168.0.0/16 -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:metrics cluster IP" -m tcp --dport 9153 -j KUBE-MARK-MASQ
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 192.168.71.2:9153" -m statistic --mode random --probability 0.10000000009 -j KUBE-SEP-X6WM23DNC2CHY7GL
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 192.168.71.4:9153" -m statistic --mode random --probability 0.11111111101 -j KUBE-SEP-565FQKNMQPWQHA67
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 192.168.71.5:9153" -m statistic --mode random --probability 0.12500000000 -j KUBE-SEP-NAEMZFFBWZ6KLFN2
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 192.168.88.1:9153" -m statistic --mode random --probability 0.14285714272 -j KUBE-SEP-EXY6NTATUESOFVUK
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 192.168.88.2:9153" -m statistic --mode random --probability 0.16666666651 -j KUBE-SEP-DIEY7AEBLUF6EUOK
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 192.168.88.3:9153" -m statistic --mode random --probability 0.20000000019 -j KUBE-SEP-WUZEPNHQEWM22777
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 192.168.9.129:9153" -m statistic --mode random --probability 0.25000000000 -j KUBE-SEP-QT22LOKHUJUMN6NN
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 192.168.9.130:9153" -m statistic --mode random --probability 0.33333333349 -j KUBE-SEP-BEFQHDDTQ3SZ7PYQ
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 192.168.9.131:9153" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-DSQFCUXGLTKU7XHC
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 192.168.9.132:9153" -j KUBE-SEP-IFUIGKJEBQAMBLAI
-A KUBE-SVC-NPX46M4PTMTKRN6Y ! -s 192.168.0.0/16 -d 10.96.0.1/32 -p tcp -m comment --comment "default/kubernetes:https cluster IP" -m tcp --dport 443 -j KUBE-MARK-MASQ
-A KUBE-SVC-NPX46M4PTMTKRN6Y -m comment --comment "default/kubernetes:https -> 172.18.0.2:6443" -j KUBE-SEP-V2PECCYPB6X2GSCW
-A KUBE-SVC-TCOU7JCQXEZGVUNU ! -s 192.168.0.0/16 -d 10.96.0.10/32 -p udp -m comment --comment "kube-system/kube-dns:dns cluster IP" -m udp --dport 53 -j KUBE-MARK-MASQ
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 192.168.71.2:53" -m statistic --mode random --probability 0.10000000009 -j KUBE-SEP-BX37LZFYWKO6VNLV
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 192.168.71.4:53" -m statistic --mode random --probability 0.11111111101 -j KUBE-SEP-RMV4KTZEOBG32N4Z
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 192.168.71.5:53" -m statistic --mode random --probability 0.12500000000 -j KUBE-SEP-LXLKXXZ7MEYEB64R
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 192.168.88.1:53" -m statistic --mode random --probability 0.14285714272 -j KUBE-SEP-OHPN3PMBHBXRFTWL
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 192.168.88.2:53" -m statistic --mode random --probability 0.16666666651 -j KUBE-SEP-UCGPS22XINHAFAGV
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 192.168.88.3:53" -m statistic --mode random --probability 0.20000000019 -j KUBE-SEP-O3NM4IX5EML5KWM4
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 192.168.9.129:53" -m statistic --mode random --probability 0.25000000000 -j KUBE-SEP-6AZ2TPBXTOSKHW5N
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 192.168.9.130:53" -m statistic --mode random --probability 0.33333333349 -j KUBE-SEP-BWDOFTKBPB6WEGFO
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 192.168.9.131:53" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-REQTH7GWTT45FLSF
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 192.168.9.132:53" -j KUBE-SEP-UNIDWJ5FCY32UEUX
-A cali-OUTPUT -m comment --comment "cali:GBTAv2p5CwevEyJm" -j cali-fip-dnat
-A cali-POSTROUTING -m comment --comment "cali:Z-c7XtVd2Bq7s_hA" -j cali-fip-snat
-A cali-POSTROUTING -m comment --comment "cali:nYKhEzDlr11Jccal" -j cali-nat-outgoing
-A cali-POSTROUTING -o tunl0 -m comment --comment "cali:SXWvdsbh4Mw7wOln" -m addrtype ! --src-type LOCAL --limit-iface-out -m addrtype --src-type LOCAL -j MASQUERADE --random-fully
-A cali-PREROUTING -m comment --comment "cali:r6XmIziWUJsdOK6Z" -j cali-fip-dnat
-A cali-nat-outgoing -m comment --comment "cali:flqWnvo8yq4ULQLa" -m set --match-set cali40masq-ipam-pools src -m set ! --match-set cali40all-ipam-pools dst -j MASQUERADE --random-fully
COMMIT
# Completed on Sun Aug  2 17:14:09 2026
```

</details>

```bash
iptables-save \
| grep SEP-Q 
```

<details>
<summary>
Вывод фильтрации правил NAT в iptables по SEP-Q
</summary>

```log
:KUBE-SEP-QT22LOKHUJUMN6NN - [0:0]
-A KUBE-SEP-QT22LOKHUJUMN6NN -s 192.168.9.129/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-QT22LOKHUJUMN6NN -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 192.168.9.129:9153
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 192.168.9.129:9153" -m statistic --mode random --probability 0.25000000000 -j KUBE-SEP-QT22LOKHUJUMN6NN
```

</details>

---

<details>
<summary>
Создание политики для блокировки доступа для модуля web
</summary>

```bash
cat > web-deny_all.yaml <<'EOF'
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: web-deny-all
spec:
  podSelector:
    matchLabels:
      app: web
  ingress: []
EOF
```

</details>

<details>
<summary>
Создание политики для разрешения доступа к порту 80 из модуля web2
</summary>

```bash
cat > web-web2-80-alllow.yaml <<'EOF'
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: web
spec:
  podSelector:
    matchLabels:
      app: web
  ingress:
    - ports:
      - port: 80
    - from:
      - podSelector:
          matchLabels:
            app: web2
EOF
```

</details>

<details>
<summary>
Создание создани службы nginx
</summary>

```bash
cat > nginx-pod.yaml <<'EOF'
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: nginx-ds
spec:
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx
EOF
```

</details>

### Команда: применение манифеста nginx

```bash
kubectl apply -f nginx-pod.yaml
```

<details>
<summary>
Применение манифеста службы nginx
</summary>

```log
daemonset.apps/nginx-ds created
```

</details>


### Команда: просмотр созданных pods

```bash
kubectl get pods -n default -o wide
```

<details>
<summary>
Просмотр созданных pods
</summary>

```log
NAME             READY   STATUS    RESTARTS   AGE   IP              NODE             NOMINATED NODE   READINESS GATES
nginx-ds-5qt2d   1/1     Running   0          74s   192.168.88.4    calico-worker2   <none>           <none>
nginx-ds-hsl4c   1/1     Running   0          74s   192.168.9.133   calico-worker    <none>           <none>
```

</details>

### Команда: сохранение правил iptables до применения политик

```bash
docker exec -it calico-control-plane bash

root@calico-control-plane:/# iptables-save > a1

exit
```

### Команда: применение политики блокировки доступа

```bash
kubectl apply -f web-deny_all.yaml
```

```log
networkpolicy.networking.k8s.io/web-deny-all created
```

### Команда: сохранение правил iptables после применения политики

```bash
docker exec -it calico-control-plane bash

root@calico-control-plane:/# iptables-save > a2
```

### Команда: установка git в контейнере control-plane

```bash
apt-get update \
; apt-get install -y git
```

### Команда: просмотр изменений в iptables

```bash
git diff a1 a2
```

<details>
<summary>
Просмотр изменений в iptables
</summary>

```log
diff --git a/a1 b/a2
index 9ffeb7f..8f0c2fa 100644
--- a/a1
+++ b/a2
@@ -1,4 +1,4 @@
-# Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:19:11 2026
+# Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:20:20 2026
 *mangle
 :PREROUTING ACCEPT [0:0]
 :INPUT ACCEPT [0:0]
@@ -23,8 +23,8 @@
 -A cali-PREROUTING -m comment --comment "cali:wNH7KsA3ILKJBsY9" -j cali-from-host-endpoint
 -A cali-PREROUTING -m comment --comment "cali:Cg96MgVuoPm7UMRo" -m comment --comment "Host endpoint policy accepted packet." -m mark --mark 0x10000/0x10000 -j ACCEPT
 COMMIT
-# Completed on Sun Aug  2 17:19:11 2026
-# Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:19:11 2026
+# Completed on Sun Aug  2 17:20:20 2026
+# Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:20:20 2026
 *raw
 :PREROUTING ACCEPT [0:0]
 :OUTPUT ACCEPT [0:0]
@@ -45,12 +45,12 @@ COMMIT
 -A cali-PREROUTING -m comment --comment "cali:ImU0-4Rl2WoOI9Ou" -m mark --mark 0x0/0x40000 -j cali-from-host-endpoint
 -A cali-PREROUTING -m comment --comment "cali:lV4V2MPoMBf0hl9T" -m mark --mark 0x10000/0x10000 -j ACCEPT
 COMMIT
-# Completed on Sun Aug  2 17:19:11 2026
-# Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:19:11 2026
+# Completed on Sun Aug  2 17:20:20 2026
+# Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:20:20 2026
 *filter
-:INPUT ACCEPT [612200:325674257]
+:INPUT ACCEPT [626616:328472840]
 :FORWARD ACCEPT [0:0]
-:OUTPUT ACCEPT [549802:125149972]
+:OUTPUT ACCEPT [564521:128457340]
 :KUBE-EXTERNAL-SERVICES - [0:0]
 :KUBE-FIREWALL - [0:0]
 :KUBE-FORWARD - [0:0]
@@ -248,13 +248,13 @@ COMMIT
 -A cali-wl-to-host -m comment --comment "cali:Ee9Sbo10IpVujdIY" -j cali-from-wl-dispatch
 -A cali-wl-to-host -m comment --comment "cali:nSZbcOoG1xPONxb8" -m comment --comment "Configured DefaultEndpointToHostAction" -j ACCEPT
 COMMIT
-# Completed on Sun Aug  2 17:19:11 2026
-# Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:19:11 2026
+# Completed on Sun Aug  2 17:20:20 2026
+# Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:20:20 2026
 *nat
-:PREROUTING ACCEPT [122:7422]
-:INPUT ACCEPT [129:7813]
-:OUTPUT ACCEPT [8664:519840]
-:POSTROUTING ACCEPT [8769:528194]
+:PREROUTING ACCEPT [123:7482]
+:INPUT ACCEPT [130:7873]
+:OUTPUT ACCEPT [8957:537420]
+:POSTROUTING ACCEPT [9062:545774]
 :DOCKER_OUTPUT - [0:0]
 :DOCKER_POSTROUTING - [0:0]
 :KUBE-KUBELET-CANARY - [0:0]
@@ -430,4 +430,4 @@ COMMIT
 -A cali-PREROUTING -m comment --comment "cali:r6XmIziWUJsdOK6Z" -j cali-fip-dnat
 -A cali-nat-outgoing -m comment --comment "cali:flqWnvo8yq4ULQLa" -m set --match-set cali40masq-ipam-pools src -m set ! --match-set cali40all-ipam-pools dst -j MASQUERADE --random-fully
 COMMIT
-# Completed on Sun Aug  2 17:19:11 2026
+# Completed on Sun Aug  2 17:20:20 2026
```

</details>

### Команда: смена политик и проверка

```bash
root@calico-control-plane:/# exit

kubectl delete -f web-deny_all.yaml

kubectl apply -f web-web2-80-alllow.yaml
```

<details>
<summary>
смена примененных политик
</summary>

```log
networkpolicy.networking.k8s.io "web-deny-all" deleted from default namespace

networkpolicy.networking.k8s.io/web created
```

</details>

```bash
docker exec -it calico-control-plane bash

root@calico-control-plane:/# iptables-save > a3

diff3 a{1..3}
```

details>
<summary>
Просмотр текущих удаленных репозиториев
</summary>

```log
====
1:1c
  # Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:19:11 2026
2:1c
  # Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:20:20 2026
3:1c
  # Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:22:17 2026
====
1:26,27c
  # Completed on Sun Aug  2 17:19:11 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:19:11 2026
2:26,27c
  # Completed on Sun Aug  2 17:20:20 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:20:20 2026
3:26,27c
  # Completed on Sun Aug  2 17:22:17 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:22:17 2026
====
1:48,49c
  # Completed on Sun Aug  2 17:19:11 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:19:11 2026
2:48,49c
  # Completed on Sun Aug  2 17:20:20 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:20:20 2026
3:48,49c
  # Completed on Sun Aug  2 17:22:17 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:22:17 2026
====
1:51c
  :INPUT ACCEPT [612200:325674257]
2:51c
  :INPUT ACCEPT [626616:328472840]
3:51c
  :INPUT ACCEPT [666911:356556440]
====
1:53c
  :OUTPUT ACCEPT [549802:125149972]
2:53c
  :OUTPUT ACCEPT [564521:128457340]
3:53c
  :OUTPUT ACCEPT [600061:133532142]
====
1:251,252c
  # Completed on Sun Aug  2 17:19:11 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:19:11 2026
2:251,252c
  # Completed on Sun Aug  2 17:20:20 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:20:20 2026
3:251,252c
  # Completed on Sun Aug  2 17:22:17 2026
  # Generated by iptables-save v1.8.11 (nf_tables) on Sun Aug  2 17:22:17 2026
====
1:254,257c
  :PREROUTING ACCEPT [122:7422]
  :INPUT ACCEPT [129:7813]
  :OUTPUT ACCEPT [8664:519840]
  :POSTROUTING ACCEPT [8769:528194]
2:254,257c
  :PREROUTING ACCEPT [123:7482]
  :INPUT ACCEPT [130:7873]
  :OUTPUT ACCEPT [8957:537420]
  :POSTROUTING ACCEPT [9062:545774]
3:254,257c
  :PREROUTING ACCEPT [125:7602]
  :INPUT ACCEPT [132:7993]
  :OUTPUT ACCEPT [9458:567480]
  :POSTROUTING ACCEPT [9567:576160]
====
1:433c
  # Completed on Sun Aug  2 17:19:11 2026
2:433c
  # Completed on Sun Aug  2 17:20:20 2026
3:433c
  # Completed on Sun Aug  2 17:22:17 2026
```

</details>


### Команда: удаление политик разрешения доступа

```bash
root@calico-control-plane:/# exit

kubectl delete -f web-web2-80-alllow.yaml
```

<details>
<summary>
Удаление политик
</summary>

```log
networkpolicy.networking.k8s.io "web" deleted from default namespace
```





```bash
# Просмотр текущих удаленных репозиториев
git remote -v

# Проверка текущего локального состояния репозитория
git status

git rm -r --cached \
../../

git remote -v

# Добавляем ключи агенту ssh от репозитория gitflic и github
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_gitflic_2026_ed25519 \
&& ssh-add ~/.ssh/id_github_2026_ed25519 \
&& ssh-agent -c

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. ../.. \
&& git status

git diff \
&& git diff --staged

# Просмотр истории коммитов в кратком формате
git log --oneline

git add . .. ../.. \
&& git status \
&& git commit -am 'some_word_add_module_3' \
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
