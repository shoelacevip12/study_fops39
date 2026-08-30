resource "yandex_cm_certificate" "le-cert" {
  name    = "den-skv"
  domains = ["den-skv.ru"]

  managed {
    challenge_type = "DNS_CNAME"
    # challenge_type  = "HTTP"
    challenge_count = 1
  }
}
