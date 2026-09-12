#=========== providers_backend-S3 ===========
cloud_id     = "b1g46dhqv17rkjcoc9k7"
folder_id    = "b1g9l0vgsvf6cegkvj1c"
default_zone = "ru-central1-a"

#=========== sa_storage ==============

pgp_key_base64 = "mDMEaqV5fhYJKwYBBAHaRw8BAQdAQP+F5c67CQO7MUsMc0w+y8JpDUdthhThAkEkw/Md7M+0KWRlbnNrdiAoZGVuc2t2KSA8c2hvZWxhY2V2aXAxMkBnbWFpbC5jb20+iJAEExYKADgWIQTMGh2mbQXpQ7F724IBhr+E39BihwUCaqV5fgIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRABhr+E39Bih/+iAQDOQhMK2qeNvxmR9E+7FxR/IT1ykAVz0bqQJ5O4ezujugEAtHVuDWIDFLqh2iRP81K5FxqmHYNzc0RzAoTkyWC46Ae4OARqpXl+EgorBgEEAZdVAQUBAQdAIOOLCuBggh/DgU4rHi9uVENexL4ZJGnCZKVCrw/xyDcDAQgHiHgEGBYKACAWIQTMGh2mbQXpQ7F724IBhr+E39BihwUCaqV5fgIbDAAKCRABhr+E39BihzYxAQCKmU77sRZgIlTU6qi2ZppApiAt8mvlgidsDDHVSyO07AEAnR2Z8KrQZK4l3cwXS+GV3RHZOZasOZM89Wr9t3Xi9wI="

#=========== s3 ==============
# bucket_name_chipher = "tfstate-skv"

bucket_name_chipher = {
  bucket                  = "tfstate-skv"
  default_storage_class   = "STANDARD"
  disabled_statickey_auth = false
  max_size                = 1073741824
  versioning              = false
}

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
