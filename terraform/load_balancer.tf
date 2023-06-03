resource "yandex_lb_target_group" "k8s-lb-tg" {
  name = "${terraform.workspace}-k8s-lb-tg"

  dynamic "target" {
    for_each = {
      for node_type in ["master", "worker"] : node in yandex_compute_instance:
        node_type == "master" ? node.tags.* contains "master" : node.tags.* contains "worker"
    }

    content {
      address   = target.value.network_interface.0.ip_address
      subnet_id = target.value.network_interface.0.subnet_id
    }
  }

  depends_on = [
    yandex_compute_instance.master,
    yandex_compute_instance.worker
  ]

}

resource "yandex_lb_network_load_balancer" "k8s-lb" {
  name = "${terraform.workspace}-k8s-lb"

  listener {
    name        = "grafana-listener"
    port        = 3000
    target_port = 30090
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  listener {
    name        = "jenkins-listener"
    port        = 8080
    target_port = 32000
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  listener {
    name        = "app-listener"
    port        = 80
    target_port = 30880
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s-lb-tg.id

    healthcheck {
      name = "http"
      http_options {
        port = 30090
        path = "/login"
      }
    }
  }
}
