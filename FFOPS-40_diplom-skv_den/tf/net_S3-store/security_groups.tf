resource "yandex_vpc_security_group" "internal" {
  name        = "internal"
  description = "Доступность для внутренней сети"
  network_id  = yandex_vpc_network.skv-net.id
  labels = {
    firewall = "yc_internal"
  }
  ingress {
    protocol          = "ANY"
    description       = "self"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  egress {
    protocol          = "ANY"
    description       = "self"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
}

resource "yandex_vpc_security_group" "k8s_master" {
  name        = "k8s-master"
  description = "Доступность для мастера k8s"
  network_id  = yandex_vpc_network.skv-net.id
  labels = {
    firewall = "k8s-master"
  }

  ingress {
    protocol       = "ANY"
    description    = "внутренний трафик сети k8s мастером и воркерами"
    v4_cidr_blocks = ["10.10.10.0/24"]
    from_port      = 0
    to_port        = 65535
  }

  egress {
    protocol       = "ANY"
    description    = "весь исходящий трафик (NAT/internet, внутренняя сеть)"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol       = "TCP"
    description    = "доступ до api k8s"
    v4_cidr_blocks = var.white_ips_access_to_master
    port           = 443
  }
  ingress {
    protocol       = "TCP"
    description    = "доступ до kube-apiserver (kubectl) через NLB"
    v4_cidr_blocks = var.white_ips_access_to_master
    port           = 6443
  }
  ingress {
    protocol       = "TCP"
    description    = "доступ по ssh к мастеру через NLB"
    v4_cidr_blocks = var.white_ips_access_to_master
    port           = 22
  }
  ingress {
    protocol          = "TCP"
    description       = "доступ до api k8s из Yandex load balancer"
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol       = "TCP"
    description    = "HTTP к frontend ts6-manager через NLB"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }
  ingress {
    protocol       = "TCP"
    description    = "NodePort frontend ts6-manager"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 30082
  }
  ingress {
    protocol       = "UDP"
    description    = "Для голоса TeamSpeak 6 через NLB"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 9987
  }
  ingress {
    protocol       = "UDP"
    description    = "NodePort voice TeamSpeak 6"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 30087
  }
  ingress {
    protocol       = "TCP"
    description    = "file transfer TeamSpeak 6 через NLB"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 30033
  }
  ingress {
    protocol       = "TCP"
    description    = "доступ к grafana nodeport"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 30080
  }
}

resource "yandex_vpc_security_group" "k8s_worker" {
  name        = "k8s-worker"
  description = "Доступность для рабочих нод"
  network_id  = yandex_vpc_network.skv-net.id
  labels = {
    firewall = "k8s-worker"
  }
  ingress {
    protocol       = "ANY"
    description    = "any connections"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
  egress {
    protocol       = "ANY"
    description    = "any connections"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}