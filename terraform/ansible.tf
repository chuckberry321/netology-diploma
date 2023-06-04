module "inventory" {
  source = "./inventory.tf"
}

# Импорт ресурса
locals {
  hosts = module.inventory.local_file_hosts
}

resource "null_resource" "waiting" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [
    yandex_compute_instance.master,
    yandex_compute_instance.worker
  ]
}

resource "null_resource" "pip_installation" {
  provisioner "local-exec" {
    command = "sudo apt-get update && sudo apt-get install -y python3-pip"
  }

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "kubespray_repo_cloning" {
  provisioner "local-exec" {
    command = "git clone https://github.com/kubernetes-sigs/kubespray /tmp/kubespray"
  }

  depends_on = [
    null_resource.pip_installation
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "copy_cluster_config" {
  provisioner "local-exec" {
    command = "cp -r ../ansible/netology-k8s-cluster/ /tmp/kubespray/inventory/ && ls -la /tmp/kubespray/inventory/netology-k8s-cluster/local/"
  }

  depends_on = [
    local_file.hosts,
    null_resource.kubespray_repo_cloning
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "add_master_ip_address" {
  provisioner "local-exec" {
    command = "echo 'supplementary_addresses_in_ssl_keys: [${yandex_compute_instance.master.network_interface.0.nat_ip_address}]' >> /tmp/kubespray/inventory/netology-k8s-cluster/local/group_vars/k8s_cluster/k8s-cluster.yml"
  }

  depends_on = [
    null_resource.copy_cluster_config
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "install_requirements" {
  provisioner "local-exec" {
    command = "pip3 install -r /tmp/kubespray/requirements-2.11.txt"
  }

  depends_on = [
    null_resource.kubespray_repo_cloning
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "config_netology_k8s_cluster" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_FORCE_COLOR=1 ansible-playbook -i /tmp/kubespray/inventory/netology-k8s-cluster/local/ /tmp/kubespray/cluster.yml -b -v --flush-cache"
  }

  depends_on = [
    null_resource.install_requirements,
    local_file.private_key,
    null_resource.add_master_ip_address
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}