#=========== providers_backend-S3 ==============
cloud_id     = "b1g46dhqv17rkjcoc9k7"
folder_id    = "b1g9l0vgsvf6cegkvj1c"
default_zone = "ru-central1-a"

#=========== terraform_remote_state ==============
network_state_key   = "diplom/network.tfstate"
network_bucket_name = "tfstate-skv"

#==============

ssh_key_file = "~/.ssh/id_lab22_1_fops40_ed25519.pub"

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
  core_fraction = 100
}