# Домашнее задание к занятию «`Безопасность в облачных провайдерах`» `Скворцов`  

Используя конфигурации, выполненные в рамках предыдущих домашних заданий, нужно добавить возможность шифрования бакета.

---

## Задание 1. Yandex Cloud

1. С помощью ключа в KMS необходимо зашифровать содержимое бакета:

    - создать ключ в KMS;
    - с помощью ключа зашифровать содержимое бакета, созданного ранее.

2. (Выполняется не в Terraform)* Создать статический сайт в Object Storage c собственным публичным адресом и сделать доступным по HTTPS:

    - создать сертификат;
    - создать статическую страницу в Object Storage и применить сертификат HTTPS;
    - в качестве результата предоставить скриншот на страницу с сертификатом в заголовке (замочек).

Полезные документы:

- [Настройка HTTPS статичного сайта](https://cloud.yandex.ru/docs/storage/operations/hosting/certificate).
- [Object Storage bucket](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket).
- [KMS key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key).

---

Пример bootstrap-скрипта:

```bash
#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>My cool web-server</h1></html>" > index.html
aws s3 mb s3://mysuperbacketname2021
aws s3 cp index.html s3://mysuperbacketname2021
```

### Записи на DNS домен `den-skv.ru`

![](./img/0.dns.png)
![](./img/0.1.dns.png)

### Ссылки на файл в S3 хранилище и сайт

- [файл на S3 с шифрованием](https://storage.yandexcloud.net/den-skv-chiphers/files/share_shdevops.png)
- [файл на S3 с расшифровкой(expired)](https://storage.yandexcloud.net/den-skv-chiphers/files/share_shdevops.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=YCAJEOKgkAxIoaoWIrkyJ-O3a%2F20260830%2Fru-central1%2Fs3%2Faws4_request&X-Amz-Date=20260830T210118Z&X-Amz-Expires=60&X-Amz-Signature=3cb435bf70444cc80d7ae3dcc99222ec0baf3d0007fda13f2d0ffd025d613fa5&X-Amz-SignedHeaders=host)

- [файл html страницы в S3 баките без шифрования](https://storage.yandexcloud.net/den-skv.ru/index.html)
- [ссылка на сайт *.website.yandexcloud.net](https://den-skv.ru.website.yandexcloud.net)
- [ссылка на сайт с зарегистрированным доменом](https://den-skv.ru)

### `TF-манифесты работы`

- [провайдера YC](./tf/providers.tf)
- [переменных](./tf/variables.tf)
- [симметричный ключ для шифрования хранилища](./tf/kms.tf)
- [создание сертификата с DNS_CNAME валидацией](./tf/certificate.tf)
- [Создание зоны DNS и записей в YC](./tf/dns.tf)
- [Создание S3 бакетов с шифрованием и для сайта](./tf/s3.tf)


### Скриншоты тестов

![](./img/1.gif)

---

![](./img/2.gif)

---

### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
