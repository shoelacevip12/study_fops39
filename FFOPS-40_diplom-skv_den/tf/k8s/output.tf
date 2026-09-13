output "nlb_master_ip" {
  description = "Публичный IP Network Load Balancer для подключения kubectl/ssh к мастер-ноде"
  value       = [for l in yandex_lb_network_load_balancer.nlb-k8s-master.listener : [for e in l.external_address_spec : e.address]][0][0]
}