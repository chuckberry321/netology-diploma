resource "null_resource" "download_kubectl" {
  provisioner "local-exec" {
    command = "curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl"
  }

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "install_kubectl" {
  provisioner "local-exec" {
    command = "chmod +x ./kubectl && ./kubectl version --client"
  }

  depends_on = [
    null_resource.download_kubectl
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "export_env_kube_config" {
  provisioner "local-exec" {
    command = "export KUBECONFIG=$HOME/.kube/config && echo $KUBECONFIG"
  }

  depends_on = [
    null_resource.download_kubectl
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "mkdir_kube_config" {
  provisioner "local-exec" {
    command = "mkdir ~/.kube"
  }

  depends_on = [
    null_resource.waiting
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "prepare_copy_kube_config" {
  provisioner "remote-exec" {
    inline = [
      "mkdir ~/.kube && sudo cp /root/.kube/config ~/.kube/config && sudo chown $USER:$USER ~/.kube/config"
    ]
  }

  connection {
    type            = "ssh"
    user            = "ubuntu"
    private_key     = tls_private_key.tf_generated_private_key.private_key_openssh
    host            = yandex_compute_instance.master[0].network_interface.0.nat_ip_address
  }

  depends_on = [
    null_resource.config_netology_k8s_cluster
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "copy_kube_config" {
  provisioner "local-exec" {
    command = "scp -i /tmp/id_rsa_cloud_user -o 'StrictHostKeyChecking no' ubuntu@${yandex_compute_instance.master[0].network_interface.0.nat_ip_address}:/home/ubuntu/.kube/config $HOME/.kube/config"
  }

  depends_on = [
    null_resource.prepare_copy_kube_config
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "add_ext_address_kube_config" {
  provisioner "local-exec" {
    command = "sed -i 's/127.0.0.1/${yandex_compute_instance.master[0].network_interface.0.nat_ip_address}/g' $HOME/.kube/config"
  }

  depends_on = [
    null_resource.copy_kube_config
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "get_pods" {
  provisioner "local-exec" {
    command = "./kubectl get pods --all-namespaces"
  }

  depends_on = [
    null_resource.add_ext_address_kube_config
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}
