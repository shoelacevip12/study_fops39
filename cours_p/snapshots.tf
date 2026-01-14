# Расписание создания снимков для всех виртуальных машин
resource "yandex_compute_snapshot_schedule" "daily_snapshots" {
  name        = "daily-snapshots-fops39-${var.cours-w-skv}"
  description = "Ежедневные снимки дисков всех ВМ с хранением 7 дней"

  # Политика расписания - ежедневно в 2 часа ночи
  schedule_policy {
    expression = "0 2 * * *"  # Каждый день в 02:00
  }

  # Период хранения снимков - 7 дней (в секундах)
  retention_period = 604800  # 7 * 24 * 3600

  # ID дисков всех ВМ из проекта
  disk_ids = [
    yandex_compute_instance.bastion.boot_disk[0].disk_id,
    yandex_compute_instance.web-a.boot_disk[0].disk_id,
    yandex_compute_instance.web-b.boot_disk[0].disk_id,
    yandex_compute_instance.prometheus.boot_disk[0].disk_id,
    yandex_compute_instance.grafana.boot_disk[0].disk_id,
    yandex_compute_instance.elasticsearch.boot_disk[0].disk_id,
    yandex_compute_instance.kibana.boot_disk[0].disk_id,
  ]
}
