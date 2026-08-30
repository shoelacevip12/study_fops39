output "public_image_chipher" {
  description = "Публичная ссылка на изображение"
  value       = "https://storage.yandexcloud.net/${yandex_storage_bucket.s3_buck_den_skv_fops40.id}/files/share_shdevops.png"
}

output "public_html_url" {
  description = "Публичная ссылка на изображение"
  value       = "https://storage.yandexcloud.net/${yandex_storage_bucket.s3_buck_den_skv_html.id}/index.html"
}

output "public_image_url" {
  description = "Публичная ссылка на изображение"
  value       = "https://storage.yandexcloud.net/${yandex_storage_bucket.s3_buck_den_skv_html.id}/files/share_shdevops.png"
}


output "cert-id" {
  description = "Certificate ID"
  value       = yandex_cm_certificate.le-cert.id
}