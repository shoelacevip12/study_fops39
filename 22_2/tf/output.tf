output "public_image_url" {
  description = "Публичная ссылка на изображение"
  value       = "https://storage.yandexcloud.net/${yandex_storage_bucket.s3_buck_den_skv_fops40.id}/image/share_shdevops.png"
}

output "nlb_external_ip" {
  description = "Внешний IP адрес балансировщика"
  value = length(yandex_lb_network_load_balancer.nlb-public.listener) > 0 ? (
    [for l in yandex_lb_network_load_balancer.nlb-public.listener :
      [for e in l.external_address_spec : e.address][0]
    ][0]
  ) : null
}