# Домашнее задание к занятию 14 «`Средство визуализации Grafana`» `Скворцов Денис`

## Задание повышенной сложности

**При решении задания 1** не используйте директорию [help](./help) для сборки проекта. Самостоятельно разверните grafana, где в роли источника данных будет выступать prometheus, а сборщиком данных будет node-exporter:

- grafana;
- prometheus-server;
- prometheus node-exporter.

За дополнительными материалами можете обратиться в официальную документацию grafana и prometheus.

В решении к домашнему заданию также приведите все конфигурации, скрипты, манифесты, которые вы 
использовали в процессе решения задания.

**При решении задания 3** вы должны самостоятельно завести удобный для вас канал нотификации, например, Telegram или email, и отправить туда тестовые события.

В решении приведите скриншоты тестовых событий из каналов нотификаций.

## Обязательные задания

### Задание 1

1. Используя директорию [help](./help) внутри этого домашнего задания, запустите связку prometheus-grafana.
1. Зайдите в веб-интерфейс grafana, используя авторизационные данные, указанные в манифесте docker-compose.
1. Подключите поднятый вами prometheus, как источник данных.
1. Решение домашнего задания — скриншот веб-интерфейса grafana со списком подключенных Datasource.

![](./img/0.png)
![](./img/1.png)
![](./img/2.png)
![](./img/3.png)


## Задание 2

Изучите самостоятельно ресурсы:

1. [PromQL tutorial for beginners and humans](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085).
1. [Understanding Machine CPU usage](https://www.robustperception.io/understanding-machine-cpu-usage).
1. [Introduction to PromQL, the Prometheus query language](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/).

Создайте Dashboard и в ней создайте Panels:

#

- утилизация CPU для nodeexporter (в процентах, 100-idle);

```promql
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

![](./img/4.1.png)

#

- CPULA 1/5/15;

```promql
node_load1
```

```promql
node_load5
```

```promql
node_load15
```

![](./img/4.2.png)

#

- количество свободной оперативной памяти;

```promql
node_memory_MemAvailable_bytes / 1024 / 1024 /1024
```

![](./img/4.3.png)

#
- количество места на файловой системе.

```promql
100 - ((node_filesystem_avail_bytes{mountpoint="/",fstype!="tmpfs"} * 100) / node_filesystem_size_bytes{mountpoint="/",fstype!="tmpfs"})
```

![](./img/4.4.png)

#

Для решения этого задания приведите promql-запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

![](./img/4.png)

## Задание 3

1. Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».
1. В качестве решения задания приведите скриншот вашей итоговой Dashboard.

![](./img/5.0.png)
![](./img/5.1.png)
![](./img/5.2.png)
![](./img/5.3.png)
![](./img/5.4.png)

## Задание 4

1. Сохраните ваш Dashboard.Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
1. В качестве решения задания приведите листинг этого файла.

[Dashboard JSON MODEL](./dashboard-skv_den.json)

[Dashboard YAML MODEL](./dashboard-skv_den.yaml)

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
