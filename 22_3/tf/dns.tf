resource "yandex_dns_zone" "zone-dns1" {
  description = "Зона DNS ${var.zone_name}"
  folder_id   = var.folder_id
  public      = true
  zone        = var.zone_name
}

resource "yandex_dns_recordset" "dns-cname-le" {
  description = "DNS запись для Let's Encrypt"
  zone_id     = yandex_dns_zone.zone-dns1.id
  name        = yandex_cm_certificate.le-cert.challenges[0].dns_name
  type        = yandex_cm_certificate.le-cert.challenges[0].dns_type
  data        = [yandex_cm_certificate.le-cert.challenges[0].dns_value]
  ttl         = 600

  depends_on = [yandex_cm_certificate.le-cert]
}

resource "yandex_dns_recordset" "dns-aname-html" {
  description = "DNS запись для index.html"
  zone_id     = yandex_dns_zone.zone-dns1.id
  name        = var.zone_name
  type        = "ANAME"
  data        = [yandex_storage_bucket.s3_buck_den_skv_html.website_endpoint]
  ttl         = 600

  depends_on = [yandex_storage_object.files-html]
}