# Для домашнего задания 19.3 `Система сбора логов Elastic Stack`

## commit_67, master Предварительная подготовка

```bash
# Переключение на мастер-ветку на случай работы в соседней ветке репозитория
git checkout master
```

<details>
<summary>
переход на master
</summary>

```log
Уже на «master»
```

</details>

```bash
# Просмотр имеющихся веток
git branch -v

# Клонирование репозитория
git clone \
https://github.com/netology-code/mnt-homeworks.git

# Удаление всех файлов и каталогов кроме каталога 10-monitoring-04-elk
find mnt-homeworks/ \
-mindepth 1 \
-not -path "*10-monitoring-04-elk*" \
-delete

# Перемещение нужного каталога в корневую директорию с новым именем 19_3
mv mnt-homeworks/10-monitoring-04-elk \
19_3

# Переход в каталог по последней переменной вывода последней команды (19_3)
cd !$

rm -rfv help
```

<details>
<summary>
cd в рабочую директорию
</summary>

```log
cd 19_3
удалён 'help/configs/filebeat.yml'
удалён 'help/configs/logstash.conf'
удалён 'help/configs/logstash.yml'
удалён каталог 'help/configs'
удалён 'help/docker-compose.yml'
удалён 'help/pinger/run.py'
удалён каталог 'help/pinger'
удалён каталог 'help'
```

</details>

```bash
# создание каталогов под скриншоты
mkdir -v img
```

<details>
<summary>
Создание каталога для изображений
</summary>

```log
mkdir: создан каталог 'img'
```

</details>

```bash
# Удаление оставшейся оставшейся части клона репозитория
rm -rfv \
../mnt-homeworks
```

<details>
<summary>
Удаление лишнего для Задания
</summary>

```log
../mnt-homeworks
удалён каталог '../mnt-homeworks'
```

</details>

```bash
# Просмотр текущих удаленных репозиториев
git remote -v

# Проверка текущего локального состояния репозитория
git status

git rm -r --cached \
../

git remote -v

# Добавляем ключи агенту ssh от репозитория gitflic и github
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_gitflic_2026_ed25519 \
&& ssh-add ~/.ssh/id_github_2026_ed25519 \
&& ssh-agent -c

# Просмотр различий в рабочей директории и индексов
git diff \
&& git diff --staged

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& git status

git diff \
&& git diff --staged

# Просмотр истории коммитов в кратком формате
git log --oneline

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий
git commit -am 'commit_67_1, master' \
&& git push \
--set-upstream \
study_fops39 \
master \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
master
```

## commit_1, `19_3-elk`

```bash
# Просмотр истории коммитов в кратком формате
git log --oneline

# Переключение\формирование новой ветки git
git checkout -b 19_3-elk

# Вывод всех веток
git branch -v

# Вывод списка удаленных репозиториев
git remote -v

# вывод текущего состояния репозитория
git status

# Просмотр истории коммитов в кратком формате
git log --oneline

# Добавляем ключи агенту ssh от репозитория gitflic и github
eval $(ssh-agent) \
&& ssh-add ~/.ssh/id_gitflic_2026_ed25519 \
&& ssh-add ~/.ssh/id_github_2026_ed25519 \
&& ssh-agent -c

# Просмотр различий в рабочей директории и индексов
git diff \
&& git diff --staged

git rm -r --cached \
./ ../

# Добавление всех изменений из текущей и вывод текущего состояния репозитория
git add . .. \
&& 

# Создание коммита со всеми изменениями и отправка в удаленный репозиторий
git commit -am 'commit2, 19_3-elk' \
&& git push \
--set-upstream \
study_fops39 \
19_3-elk \
&& git push \
--set-upstream \
study_fops39_gitflic_ru \
19_3-elk
```

## commit_2, `19_3-elk`

```bash
mkdir -v elk

cd !$
```

<details>
<summary>
Переход в каталог с работой
</summary>

```log
mkdir: создан каталог 'elk'

cd elk
```

</details>

#

```bash
mkdir -vp \
data_logs \
configs/{filebeat,logstash} \
configs/logstash/pipelines \
pinger
```

<details>
<summary>
Создание структуры проброса конфигов для рыботы стека в docker
</summary>

```log
mkdir: создан каталог 'data_logs'
mkdir: создан каталог 'configs/filebeat'
mkdir: создан каталог 'configs/logstash'
mkdir: создан каталог 'configs/logstash/pipelines'
mkdir: создан каталог 'pinger'
```

</details>

#

<details>
<summary>
создание описания стека в docker-compose
</summary>

```bash
cat >docker-compose.yml <<'EOF'
version: "3.9"
services:
  es-hot:
    image: elasticsearch:9.4.2
    container_name: es-hot
    environment:
      - node.name=es-hot
      - discovery.seed_hosts=es-hot,es-warm
      - cluster.initial_master_nodes=es-hot,es-warm
      - cluster.name=es_SKV-DV
      - node.roles=master,data_content,data_hot
      - "ES_JAVA_OPTS=-Xms4G -Xmx4G"
      - "http.host=0.0.0.0"
      - xpack.security.enabled=false
    ports:
      - 9200:9200
    networks:
      - ELK-net

  es-warm:
    image: elasticsearch:9.4.2
    container_name: es-warm
    environment:
      - node.name=es-warm
      - discovery.seed_hosts=es-hot,es-warm
      - cluster.initial_master_nodes=es-hot,es-warm
      - cluster.name=es_SKV-DV
      - node.roles=master,data_warm
      - "ES_JAVA_OPTS=-Xms4G -Xmx4G"
      - "http.host=0.0.0.0"
      - xpack.security.enabled=false
    depends_on:
      - es-hot
    networks:
      - ELK-net

  kibana:
    image: kibana:9.4.2
    ports:
      - "5601:5601"
    depends_on:
      - es-hot
      - es-warm
    environment:
      ELASTICSEARCH_URL: http://es-hot:9200
      ELASTICSEARCH_HOSTS: '["http://es-hot:9200","http://es-warm:9200"]'
    networks:
      - ELK-net

  logstash:
    image: logstash:9.4.2
    environment:
      ES_HOST: "es-hot:9200"
    ports:
      - "5044:5044/udp" # Для Nginx
      - "5046:5046/udp" # Для Python pinger
    depends_on:
      - es-hot
      - es-warm
    volumes:
      - ./configs/logstash/pipelines.yml:/usr/share/logstash/config/pipelines.yml
      - ./configs/logstash/pipelines:/usr/share/logstash/config/pipelines
      - ./data_logs:/var/log/nginx
    networks:
      - ELK-net

  nginx:
    image: nginx:1.29.1-perl
    ports:
      - 8080:80
      - 8443:443
    depends_on:
      - logstash
    volumes:
      - ./data_logs/access.log:/var/log/nginx/access.log
    networks:
      - ELK-net

  filebeat:
    image: elastic/filebeat:9.4.2
    group_add:
      - 959
    volumes:
      - ./data_logs:/var/log/app/:ro
      - ./configs/filebeat/filebeat.yml:/usr/share/filebeat/filebeat.yml:Z
      - /var/run/docker.sock:/var/run/docker.sock:ro
    depends_on:
      - logstash
      - es-hot
      - es-warm
      - kibana
      - nginx
      - some_application
    networks:
      - ELK-net

  some_application:
    image: library/python:3.9-alpine
    container_name: some_app
    volumes:
      - ./pinger/:/opt
    entrypoint: python3 /opt/run.py

networks:
  ELK-net:
    driver: bridge
EOF
```

</details>

#

<details>
<summary>
Создание скрипта генератора событий
</summary>

```bash
cat >./pinger/run.py <<'EOF'
#!/usr/bin/env python3

import logging
import random
import time

while True:

    number = random.randrange(0, 4)

    if number == 0:
        logging.info('Hello there!!')
    elif number == 1:
        logging.warning('Hmmm....something strange')
    elif number == 2:
        logging.error('OH NO!!!!!!')
    elif number == 3:
        logging.exception(Exception('this is exception'))

    time.sleep(1)
EOF
```

</details>

#

<details>
<summary>
Настройка beat для отслеживания
</summary>

```bash
cat >./configs/filebeat/filebeat.yml <<'EOF'
filebeat.inputs:
  - type: filestream
    enabled: true
    paths:
      - /var/log/app/access.log

    fields:
      service: log_gen

output.logstash:
  enabled: true
  hosts: ["logstash:5044"] 
EOF
```

</details>

#


<details>
<summary>
Настройка pipeline logstash
</summary>

```bash
cat >./elk/configs/logstash/pipelines/nginx.conf<<'EOF'
input {
  beats {
    port => 5044
  }
}

filter {
  grok {
    match => { "message" => '%{IPORHOST:client_ip} - - \[%{HTTPDATE:timestamp}\] "%{WORD:http_method} %{URIPATHPARAM:request} HTTP/%{NUMBER:http_version}" %{NUMBER:response_code:int} %{NUMBER:bytes_sent:int} "%{GREEDYDATA:referrer}" "%{GREEDYDATA:user_agent}" "%{GREEDYDATA:other}"' }
  }
  
  date {
    match => ["timestamp", "dd/MMM/yyyy:HH:mm:ss Z"]
    target => "@timestamp"
  }
  
  useragent {
    source => "user_agent"
    target => "user_agent_details"
  }
}

output {
  stdout {
  }
  elasticsearch {
      hosts => [ "${ES_HOST}" ]
      index => "logs_app_gen%-%{+YYYY.MM.dd}"
  } 
} 
EOF
```

</details>

#


```bash
touch ./data_logs/access.log

sudo chmod 777 -Rv ./

sudo chown -v 1000:1000 -R ./

sudo chmod -v go-w -R ./configs/filebeat/filebeat.yml

tree .
```

<details>
<summary>
Лог структуры работы
</summary>

```log
Password:

mode of './' changed from 0775 (rwxrwxr-x) to 0777 (rwxrwxrwx)
mode of './docker-compose.yml' retained as 0777 (rwxrwxrwx)
mode of './data_logs' retained as 0777 (rwxrwxrwx)
mode of './data_logs/access.log' retained as 0777 (rwxrwxrwx)
mode of './configs' retained as 0777 (rwxrwxrwx)
mode of './configs/logstash' retained as 0777 (rwxrwxrwx)
mode of './configs/logstash/pipelines.yml' retained as 0777 (rwxrwxrwx)
mode of './configs/logstash/pipelines' retained as 0777 (rwxrwxrwx)
mode of './configs/logstash/pipelines/nginx.conf' retained as 0777 (rwxrwxrwx)
mode of './configs/filebeat' retained as 0777 (rwxrwxrwx)
mode of './configs/filebeat/filebeat.yml' retained as 0777 (rwxrwxrwx)
mode of './pinger' retained as 0777 (rwxrwxrwx)
mode of './pinger/run.py' retained as 0777 (rwxrwxrwx)
```

```log
ownership of './docker-compose.yml' retained as 1000:1000
ownership of './data_logs/access.log' retained as 1000:1000
ownership of './data_logs' retained as 1000:1000
ownership of './configs/logstash/pipelines.yml' retained as 1000:1000
ownership of './configs/logstash/pipelines/nginx.conf' retained as 1000:1000
ownership of './configs/logstash/pipelines' retained as 1000:1000
ownership of './configs/logstash' retained as 1000:1000
ownership of './configs/filebeat/filebeat.yml' retained as 1000:1000
ownership of './configs/filebeat' retained as 1000:1000
ownership of './configs' retained as 1000:1000
ownership of './pinger/run.py' retained as 1000:1000
ownership of './pinger' retained as 1000:1000
ownership of './' retained as 1000:1000
```

```log
mode of './configs/filebeat/filebeat.yml' changed from 0777 (rwxrwxrwx) to 0755 (rwxr-xr-x)
```

```log
.
├── configs
│   ├── filebeat
│   │   └── filebeat.yml
│   └── logstash
│       ├── pipelines
│       │   └── nginx.conf
│       └── pipelines.yml
├── data_logs
│   └── access.log
├── docker-compose.yml
└── pinger
    └── run.py

7 directories, 6 files
```

</details>

```bash
docker compose up -d
```

<details>
<summary>
Лог структуры работы
</summary>

```log
[+] up 9/9
 ✔ Network elk_ELK-net      Created  0.1s
 ✔ Network elk_default      Created  0.0s
 ✔ Container some_app       Created  0.1s
 ✔ Container es-hot         Created  0.1s
 ✔ Container es-warm        Created  0.1s
 ✔ Container elk-kibana-1   Created  0.1s
 ✔ Container elk-logstash-1 Created  0.1s
 ✔ Container elk-nginx-1    Created  0.1s
 ✔ Container elk-filebeat-1 Created  0.3s
```

</details>