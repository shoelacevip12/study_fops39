# Работа с сетью в Kubernetes

## Использование CNI calico

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
17:59:44             e2e                 global    running            Passed:  0, Failed:  0, Remaining:444
17:59:44    systemd-logs   calico-control-plane   complete                                                 
17:59:44    systemd-logs          calico-worker   complete                                                 
17:59:44    systemd-logs         calico-worker2   complete
...
...

```

</details>









## Использование CNI Antrea

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

