#==============
platform_id = "standard-v2"

disk = {
  type = "network-hdd"
  size = 20
}

vm_image_family = "debian-13"

host = {
  cores         = 2
  memory        = 4
  core_fraction = 20
  gpus          = 0
}

deploy_pol = {
  max_creating     = 1
  max_deleting     = 2
  max_unavailable  = 1
  max_expansion    = 1
  startup_duration = 60
  strategy         = "proactive"
}

group_name_prefix = "k8s-workers-group"

scale_policy_size = 3

master_group_name_prefix = "k8s-master-group"

master_scale_policy_size = 1

master_host = {
  cores         = 2
  memory        = 4
  core_fraction = 20
}