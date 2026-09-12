resource "time_sleep" "iam_propagation" {
    /*
    задержка после создания IAM-биндинга sa_encrypterDecrypter, 
    чтобы провайдер успел прочитать его обратно 
    */
  depends_on      = [yandex_resourcemanager_folder_iam_member.sa_encrypterDecrypter]
  create_duration = "30s"
}