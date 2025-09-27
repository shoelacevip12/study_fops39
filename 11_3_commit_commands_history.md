# Для домашнего задания 11.3
### commit_18, master
```bash
git checkout master

git branch -v

git clone https://github.com/netology-code/sdb-homeworks.git

find sdb-homeworks/ -mindepth 1 -not -name '11-03.md' -delete

mv sdb-homeworks 11_3

cd 11_3

mkdir img

mv {11-03,README}.md

git clone  https://github.com/ortariot/neto-elk.git

rm -rf neto-elk/.git

mv neto-elk/* .

rm -rf neto-elk

cat /dev/null > ./app/log_gen.log

sudo systemctl enable --now docker.service

cat>docker-compose.yml<<'EOF'
version: "3.9"
services:
  elasticsearch:
    image: elasticsearch:9.1.4
    environment:
      - discovery.type=single-node
      - cluster.name=es_SKV-DV
      - xpack.security.enabled=false
    ports:
      - 9200:9200
EOF

docker-compose up -d

curl -X GET 'localhost:9200/_cluster/health?pretty'

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_18, master' \
&& git push --set-upstream study_fops39 master
```

### commit_1, 11_3-ELK
```bash
git log --oneline

git checkout -b 11_3-ELK

git branch -v

git remote -v

git status

git log --oneline

git add . ..

git commit -am 'commit_1, 11_3-ELK' \
&& git push --set-upstream study_fops39 11_3-ELK
```
### commit_2, 11_3-ELK
```bash
cat>>docker-compose.yml<<'EOF'
    networks:
      - ELK-net

  kibana:
    image: kibana:9.1.4
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    networks:
      - ELK-net

networks:
  ELK-net:
    driver: bridge
EOF

docker-compose up -d

docker ps -a

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_2, 11_3-ELK' \
&& git push --set-upstream study_fops39 11_3-ELK
```
### commit_3, 11_3-ELK
```bash
mkdir data_logs

touch ./data_logs/access.log

cat>./configs/logstash/pipelines/nginx_file_read.conf<<'EOF'
input {
  file {
    path => "/var/log/nginx/access.log"
    start_position => "beginning"
    sincedb_path => "/dev/null"
    tags => ["nginx_access"]
  }
}

filter {
  grok {
    match => { "message" => '%{IPORHOST:client_ip} - - \[%{HTTPDATE:timestamp}\] "%{WORD:http_method} %{URIPATHPARAM:request} HTTP/%{NUMBER:http_version}" %{NUMBER:response_code:int} %{NUMBER:bytes_sent:int} "%{GREEDYDATA:referrer}" "%{GREEDYDATA:user_agent}" "%{GREEDYDATA:other}"' }
  }
  
  mutate {
    convert => { "status" => "integer" }
    convert => { "bytes" => "integer" }
  }

  date {
    match => ["timestamp", "dd/MMM/yyyy:HH:mm:ss Z"]
    target => "@timestamp"
  }

  useragent {
    source => "agent"
    target => "user_agent_details"
  }
}

output {
  stdout {
    codec => rubydebug
  }

  if "nginx_access" in [tags] {
    elasticsearch {
      hosts => [ "${ES_HOST}" ]
      index => "logs-nginx-access-%{+YYYY.MM.dd}"
      action => "create"  # важно для data stream!
    }
  }
}
EOF

sed -i 's|nx.c|nx_file_read.c|' ./configs/logstash/pipelines.yml

sed -i '24 r /dev/stdin' docker-compose.yml << 'EOF'
  logstash:
    image: logstash:9.1.4
    environment:
      ES_HOST: "elasticsearch:9200"
    ports:
      - "5044:5044/udp"
    depends_on:
      - elasticsearch
    volumes:
      - ./configs/logstash/pipelines.yml:/usr/share/logstash/config/pipelines.yml
      - ./configs/logstash/pipelines:/usr/share/logstash/config/pipelines
      - ./data_logs:/var/log/nginx
    networks:
      - ELK-net

  nginx:
    image: nginx:1.29.1-perl
    ports:
      - 8081:80
      - 8443:443
    depends_on:
      - logstash
    volumes:
      - ./data_logs/access.log:/var/log/nginx/access.log
    networks:
      - ELK-net

EOF

docker-compose down \
&& docker-compose up -d

git remote -v

git status

git diff && git diff --staged

git add . .. \
&& git status

git log --oneline

git commit -am 'commit_3, 11_3-ELK' \
&& git push --set-upstream study_fops39 11_3-ELK
```