# через locals Преобразовываем обращение к переменным как к list
locals {
  # web - list
  web_instances = yandex_compute_instance.web
  # db_vm - преобразование map в list через values()
  db_instances = values(yandex_compute_instance.db_vm)
  # storage - из одного объекта формируем list []
  storage_instance = [yandex_compute_instance.storage]
  # Объединение в общий instances list
  all_instances = concat(local.web_instances, local.db_instances, local.storage_instance)
}

# Создание динамичного hosts.ini через tftpl файл
resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl", {
    web     = local.web_instances,
    db      = local.db_instances,
    storage = local.storage_instance
  })

  filename = "${abspath(path.module)}/hosts.ini"
}
