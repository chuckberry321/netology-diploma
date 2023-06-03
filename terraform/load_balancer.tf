resource "yandex_lb_target_group" "k8s-lb-tg" {
  name = "${terraform.workspace}-k8s-lb-tg"

  dynamic "target" {
    for_each = {
      for node_type, nodes in {
        "master" = yandex_compute_instance.master,
        "worker" = yandex_compute_instance.worker
      } : {
        for node in nodes : node.network_interface.0.ip_address => {
          subnet_id = node.network_interface.0.subnet_id
        } if node.tags.* contains node_type
      }
    }

    content {
      subnet_id = target.value.subnet_id
      address   = key(target.value)
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
