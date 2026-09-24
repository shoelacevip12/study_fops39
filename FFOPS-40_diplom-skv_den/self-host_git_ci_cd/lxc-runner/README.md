# LXC-runner для Forgejo Actions (ci-runner)

Альтернативный раннер вместо `docker-compose-forgejo-runner`: **forgejo-runner внутри
LXC-контейнера** (libvirt). Джобы исполняются
ПРЯМО в контейнере (метки `ubuntu`, `self-hosted`) - без act/docker-прослойки,
без dind. Terraform, зеркала реестров и секреты джобы ставят/готовят сами workflow
( копии в [`workflows/`](workflows/)).

## Топология

| Элемент | Значение |
|---|---|
| Хост (libvirt) | br0=`192.168.89.193`, wg0=`10.8.0.1` (forgejo) |
| LXC ci-runner | `192.168.89.20/24`, default via `192.168.89.1` |
| Маршрут до forgejo | `10.8.0.0/24 via 192.168.89.193` |
| DNS | coredns `10.8.0.1` (зона `den-skv.ru`) + `77.88.8.8` |
| Forgejo URL runner'а | `http://10.8.0.1:3000/` |

## Состав каталога

- [`lxc-ci-runner.xml`](lxc-ci-runner.xml) - домен libvirt (type=lxc, rootfs `/disk/VMs/ci-runner/rootfs`, bridge br0, capabilities для будущего docker-in-LXC).
- [`prepare_runner_rootfs.sh`](prepare_runner_rootfs.sh) - **на хосте**: клонирует эталонный rootfs ALT p11, статическая сеть/маршруты/DNS/hosts, SSH-ключ, копирует `setup_runner_inside.sh` в `/root/`, define+start домена.
- [`setup_runner_inside.sh`](setup_runner_inside.sh) - **внутри LXC**: пакеты (git, curl, unzip, python3...), forgejo-runner, конфиг с прямыми метками, systemd-unit.
- [`workflows/`](workflows/) - копии рабочих workflow под LXC (`runs-on: ubuntu`, без `container:`):
  - `hello-lxc.yml` - проверочный echo;
  - `tf-k8s-terraform-lxc.yml`, `tf-net-s3-terraform-lxc.yml` - terraform-пайплайны.

## Запуск

```bash
# 1. НА ХОСТЕ: подготовить rootfs, сеть, скопировать setup-скрипт, стартовать домен
bash self-host_git_ci_cd/lxc-runner/prepare_runner_rootfs.sh

# 2. Получить пару uuid/token в forgejo:
#    Admin -> Actions -> Runners -> Create registration token

# 3. ВНУТРИ контейнера (ssh root@192.168.89.20 или sudo virsh console ci-runner):
RUNNER_UUID=<uuid> RUNNER_TOKEN=<token> bash /root/setup_runner_inside.sh

# 4. Проверки
curl -s http://10.8.0.1:3000/      # ответ forgejo
ip route                            # есть 10.8.0.0/24 via 192.168.89.193
systemctl status forgejo-runner     # active (running)
journalctl -u forgejo-runner -f     # 'declared successfully' = подключён
# в forgejo Admin -> Actions -> Runners появился runner с метками ubuntu/self-hosted
```

## Переключение tf-репозиториев на LXC-runner

1. Скопировать LXC-вариант в репозиторий (заменив docker-вариант):

```bash
# в репозитории tf-k8s
cp ../self-host_git_ci_cd/lxc-runner/workflows/tf-k8s-terraform-lxc.yml .forgejo/workflows/terraform.yml
# в репозитории tf-net-S3-store
cp ../self-host_git_ci_cd/lxc-runner/workflows/tf-net-s3-terraform-lxc.yml .forgejo/workflows/terraform.yml
```

2. **Важно:** активным должен быть ТОЛЬКО один workflow-файл на репозиторий.
   Если оставить одновременно docker-вариант и lxc-вариант - при push джоба
   запустится дважды (docker-runner + LXC-runner) и `terraform apply` пойдёт
   параллельно на одном state (конфликт блокировки/дублирование ресурсов).

3. Секреты/переменные не меняются: `TOKEN`, `SA_STORAGE_KEY`,
   `YC_AUTHORIZED_KEY`, `SSH_PUB_KEY`, `vars.SECRETS_REPO`, `vars.SECRETS_PATH`.

## Примечания

- Terraform/kubectl в LXC **не устанавливаются**: workflow ставит terraform сам
  (зеркало `hashicorp-releases.yandexcloud.net`), провайдеры качает через
  `terraform-mirror.yandexcloud.net` (шаг «Настройка зеркала реестра провайдеров»).
- Для работы шага «Подготовка секретов» в контейнере нужен `python3`
  (`python3 -m json.tool`) - он включён в пакеты `setup_runner_inside.sh`.
- Docker-вариант workflow остаётся рабочим на compose-runner'е - переключайтесь
  на LXC по готовности, заменив файл workflow.
- Capabilities в `lxc-ci-runner.xml` (sys_admin, net_admin и др.) оставлены на
  будущее: если понадобится docker-in-LXC (CI/CD приложения со сборкой образов).