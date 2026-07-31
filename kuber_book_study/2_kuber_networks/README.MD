# Практический разбор работ с SDN сетями в kubernetes

## О Nodeports

### Запуск Docker

```bash
sudo systemctl start docker.service
```

### Проверка подов кластера

```bash
kubectl get pods --all-namespaces
```

<details>
<summary>
Вывод о готовности учебного кластера
</summary>
```log
NAMESPACE            NAME                                         READY   STATUS    RESTARTS      AGE
default              core-k8s                                     1/1     Running   2 (68s ago)   2d23h
kube-system          coredns-589f44dc88-bfc7d                     1/1     Running   2 (68s ago)   5d1h
kube-system          coredns-589f44dc88-f7tlh                     1/1     Running   2 (68s ago)   5d1h
kube-system          etcd-kind-control-plane                      1/1     Running   2 (68s ago)   5d1h
kube-system          kindnet-lmmwq                                1/1     Running   2 (68s ago)   5d1h
kube-system          kube-apiserver-kind-control-plane            1/1     Running   2 (68s ago)   5d1h
kube-system          kube-controller-manager-kind-control-plane   1/1     Running   2 (68s ago)   5d1h
kube-system          kube-proxy-2j6zm                             1/1     Running   2 (68s ago)   5d1h
kube-system          kube-scheduler-kind-control-plane            1/1     Running   2 (68s ago)   5d1h
local-path-storage   local-path-provisioner-855c7b7774-r2vjt      1/1     Running   4 (33s ago)   5d1h
```
</details>

### Удаление пода

```bash
kubectl delete -f ../1_modules_pods/busybox.yaml
```

<details>
<summary>
Вывод о удалении учебного кластера
</summary>
```log
pod "core-k8s" deleted from default namespace
```
</details>

### Получение учебной конфигурации сервиса типа NodePort из развернутого конфигурации сервиса `CoreDNS`

```bash
kubectl get svc -o yaml kube-dns -n kube-system
```

<details>
<summary>
Конфиг учебного сервиса типа NodePort
</summary>
```bash
cat > my-nodeport.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  annotations:
    prometheus.io/port: "9153"
    prometheus.io/scrape: "true"
  labels:
    k8s-app: kube-dns
    kubernetes.io/cluster-service: "true"
    kubernetes.io/name: CoreDNS
  name: kube-dns-2
  namespace: kube-system
spec:
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - name: dns
    port: 53
    protocol: UDP
    targetPort: 53
  - name: dns-tcp
    port: 53
    protocol: TCP
    targetPort: 53
  - name: metrics
    port: 9153
    protocol: TCP
    targetPort: 9153
  selector:
    k8s-app: kube-dns
  sessionAffinity: None
  type: NodePort
status:
  loadBalancer: {}
EOF
```

</details>

#### Применение манифеста

```bash
kubectl create -f my-nodeport.yaml
```

<details>
<summary>
Вывод о создании учебного сервиса типа NodePort
</summary>
**Лог: результат создания сервиса**
```log
service/kube-dns-2 created
```
</details>

### Проверка созданного учебного сервиса типа NodePort

```bash
kubectl get services -o wide -A
```

<details>
<summary>
Вывод о создании учебного сервиса типа NodePort
</summary>
```log
NAMESPACE     NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                                    AGE    SELECTOR
default       kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP                                    5d2h   <none>
kube-system   kube-dns     ClusterIP   10.96.0.10     <none>        53/UDP,53/TCP,9153/TCP                     5d2h   k8s-app=kube-dns
kube-system   kube-dns-2   NodePort    10.96.71.107   <none>        53:30435/UDP,53:30435/TCP,9153:32415/TCP   16s    k8s-app=kube-dns
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
&& git commit -am 'some_word_add_module_1' \
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