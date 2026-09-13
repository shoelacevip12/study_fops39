#=========== s3 ==============
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

#=========== network_nat_gateway ===========
nat_gateway_name = "skv-nat-gateway"

route_table_name = "skv-route-table"

#=========== security_group ===========
white_ips_access_to_master = [
  "127.0.0.1/32",
  "0.0.0.0/0"
]

# white_ips_access_to_master = [
#   "127.0.0.1/32",
#   "$YOUR_IP/32"
#   ]
