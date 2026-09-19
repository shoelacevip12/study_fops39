resource "local_file" "hosts_ini" {
  content = templatefile("${path.module}/hosts.tftpl", {
    masters = [
      for instance in yandex_compute_instance_group.ins-gr_master.instances : {
        name = instance.name
        ip   = local.master_nlb_ip
      }
    ]
    workers = [
      for instance in yandex_compute_instance_group.ins-gr_workers.instances : {
        name = instance.name
        ip   = instance.network_interface[0].ip_address
      }
    ]
    ssh_user     = "skv"
    ssh_key_file = local.private_ssh_key_path
  })

  filename = "../ansible/hosts.ini"
}