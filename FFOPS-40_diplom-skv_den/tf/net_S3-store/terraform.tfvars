#=========== providers_backend-S3 ===========
cloud_id     = "b1g46dhqv17rkjcoc9k7"
folder_id    = "b1g9l0vgsvf6cegkvj1c"
default_zone = "ru-central1-a"

#=========== sa_storage ==============

pgp_key_base64 = "LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgptRE1FYXFWNWZoWUpLd1lCQkFIYVJ3OEJBUWRBUVArRjVjNjdDUU83TVVzTWMwdyt5OEpwRFVkdGhoVGhBa0VrCncvTWQ3TSswS1dSbGJuTnJkaUFvWkdWdWMydDJLU0E4YzJodlpXeGhZMlYyYVhBeE1rQm5iV0ZwYkM1amIyMCsKaUpBRUV4WUtBRGdXSVFUTUdoMm1iUVhwUTdGNzI0SUJocitFMzlCaWh3VUNhcVY1ZmdJYkF3VUxDUWdIQWdZVgpDZ2tJQ3dJRUZnSURBUUllQVFJWGdBQUtDUkFCaHIrRTM5QmloLytpQVFET1FoTUsycWVOdnhtUjlFKzdGeFIvCklUMXlrQVZ6MGJxUUo1TzRlenVqdWdFQXRIVnVEV0lERkxxaDJpUlA4MUs1RnhxbUhZTnpjMFJ6QW9Ua3lXQzQKNkFlNE9BUnFwWGwrRWdvckJnRUVBWmRWQVFVQkFRZEFJT09MQ3VCZ2doL0RnVTRySGk5dVZFTmV4TDRaSkduQwpaS1ZDcncveHlEY0RBUWdIaUhnRUdCWUtBQ0FXSVFUTUdoMm1iUVhwUTdGNzI0SUJocitFMzlCaWh3VUNhcVY1CmZnSWJEQUFLQ1JBQmhyK0UzOUJpaHpZeEFRQ0ttVTc3c1JaZ0lsVFU2cWkyWnBwQXBpQXQ4bXZsZ2lkc0RESFYKU3lPMDdBRUFuUjJaOEtyUVpLNGwzY3dYUytHVjNSSFpPWmFzT1pNODlXcjl0M1hpOXdJPQo9STBWbQotLS0tLUVORCBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCg=="

#=========== s3 ==============
bucket_name_chipher = "tfstate-skv"

#=========== kms ==============
symmetric_key_name = "sym-kms-den-skv"

#=========== network_vpc ===========
network_name = "skv-net"

#=========== network_subnet ===========
subnets = {
  "k8s_master" = [
    {
      name = "k8s_master_zone_a"
      zone = "ru-central1-a"
      cidr = ["10.10.10.0/28"]
    }
  ],
  "k8s_workers" = [
    {
      name = "k8s_worker_zone_a"
      zone = "ru-central1-a"
      cidr = ["10.10.10.16/28"]
    },
    {
      name = "k8s_worker_zone_b"
      zone = "ru-central1-b"
      cidr = ["10.10.10.32/28"]
    },
    {
      name = "k8s_worker_zone_d"
      zone = "ru-central1-d"
      cidr = ["10.10.10.48/28"]
    }
  ],
}

#=========== network_external_ipv4_address ===========
external_static_ips = {
  ingress_lb = [
    {
      name = "ingress_lb_zone_ru_central1_a"
      zone = "ru-central1-a"
    }
  ]
}

#=========== security_group ===========
white_ips_access_to_master = [
  "127.0.0.1/32",
  "0.0.0.0/0"
]

# white_ips_access_to_master = [
#   "127.0.0.1/32",
#   "$YOUR_IP/32"
#   ]
