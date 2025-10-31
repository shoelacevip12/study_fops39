# Для домашнего задания 11.4
### commit_20, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sdb-homeworks.git

find sdb-homeworks/ -mindepth 1 \
-not -name '11-04.md' \
-delete

mv sdb-homeworks 11_4

cd !$

mkdir img config defs

mv {11-04,README}.md

curl https://raw.githubusercontent.com/ortariot/RabbitMQ-lession/refs/heads/master/config/rabbitmq_ha.conf \
-o ./config/rabbitmq_ha.conf

sed -i 's/test/skvdv/g' ./config/rabbitmq_ha.conf

sed -i '/management/d' ./config/rabbitmq_ha.conf

sed -i '4a\default_queue_type = quorum' ./config/rabbitmq_ha.conf

curl https://raw.githubusercontent.com/ortariot/RabbitMQ-lession/refs/heads/master/defs/def.json \
-o ./defs/def.json

sed -i 's/test/skvdv/g' ./defs/def.json

sed -i '/"policies": \[/,/\]/d' ./defs/def.json


cat>./producer.py<<'EOF'
import pika
from settings import URI

params = pika.URLParameters(URI)
conn = pika.BlockingConnection(params)
channel = conn.channel()

channel.queue_declare(
    queue='skv_dv_FOPS-39',
    durable=True,
    arguments={'x-queue-type': 'quorum'}
)

if __name__ == "__main__":

    count = 0

    while True:
        channel.basic_publish(
            exchange="ex_p_skv_dv_FOPS-39",
            routing_key="rk_skv_dv_FOPS-39",
            body=f"Ya v shoke, no priyatnom! - {count}",
        )
        count += 1
EOF

cat>./consumer.py<<'EOF'
#!/usr/bin/env python
# coding=utf-8
import pika
from settings import URI

connection = pika.BlockingConnection(pika.URLParameters(URI))
channel = connection.channel()
channel.queue_declare(
    queue='skv_dv_FOPS-39',
    durable=True,
    arguments={'x-queue-type': 'quorum'}
)

def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)

channel.basic_consume(
    queue='skv_dv_FOPS-39',
    on_message_callback=callback,
    auto_ack=True
)
channel.start_consuming()
EOF


curl https://raw.githubusercontent.com/ortariot/RabbitMQ-lession/refs/heads/master/demo/settings.py \
-o ./settings.py

sed -i 's/test/skvdv/g' ./settings.py



curl https://raw.githubusercontent.com/ortariot/RabbitMQ-lession/refs/heads/master/.env_example \
-o .env

sed -i 's/test/skvdv/g' .env

sudo systemctl enable --now docker.service

cat>docker-compose.yml<<'EOF'
services:
  rabbitmq1:
    image: rabbitmq:4.2.0-management-alpine
    hostname: rabbitmq1
    environment:
      - RABBITMQ_CONFIG_FILE=/config/rabbitmq_ha
      - RABBITMQ_ERLANG_COOKIE=${RABBITMQ_ERLANG_COOKIE}
    volumes:
      - ./config:/config
      - ./defs/def.json:/etc/rabbitmq/definitions.json:ro
      - ./defs/enabled_plugins:/etc/rabbitmq/enabled_plugins:ro
    ports:
      - 15672:15672
      - 5672:5672

  rabbitmq2:
    image: rabbitmq:4.2.0-management-alpine
    hostname: rabbitmq2
    environment:
      - RABBITMQ_CONFIG_FILE=/config/rabbitmq_ha
      - RABBITMQ_ERLANG_COOKIE=${RABBITMQ_ERLANG_COOKIE}
    volumes:
      - ./config:/config
      - ./defs/def.json:/etc/rabbitmq/definitions.json:ro
      - ./defs/enabled_plugins:/etc/rabbitmq/enabled_plugins:ro
    ports:
      - 15673:15672

  rabbitmq3:
    image: rabbitmq:4.2.0-management-alpine
    hostname: rabbitmq3
    environment:
      - RABBITMQ_CONFIG_FILE=/config/rabbitmq_ha
      - RABBITMQ_ERLANG_COOKIE=${RABBITMQ_ERLANG_COOKIE}
    volumes:
      - ./config:/config
      - ./defs/def.json:/etc/rabbitmq/definitions.json:ro
      - ./defs/enabled_plugins:/etc/rabbitmq/enabled_plugins:ro
    ports:
      - 15674:15672
EOF

docker-compose down \
&& docker-compose up -d

sudo pacman -Syu python-pika

python producer.py \
& python producer.py \
& python consumer.py

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_21, master' \
&& git push --set-upstream study_fops39 master
```
