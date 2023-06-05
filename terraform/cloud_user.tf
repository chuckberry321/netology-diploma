#resource "tls_private_key" "tf_generated_private_key" {
#  algorithm = "RSA"
#  rsa_bits  = 4096
#}

resource "local_file" "cloud_user" {
  content = <<-DOC
#cloud-config
users:
  - name: centos
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - "${var.ssh_key}"
DOC
  filename = "/tmp/cloud_user.txt"
  file_permission = "0600"      # Права доступа для пользователя


  provisioner "local-exec" {
    command = "chmod 600 /tmp/cloud_user.txt && ls -la /tmp/"
  }

  depends_on = [
     yandex_compute_instance.master,
     yandex_compute_instance.worker
#    tls_private_key.tf_generated_private_key
  ]
}


#resource "local_file" "private_key" {
#  content = tls_private_key.tf_generated_private_key.private_key_openssh
#  filename = "/tmp/id_rsa_pk.txt"
#  file_permission = "600"
#
#  depends_on = [
#    tls_private_key.tf_generated_private_key
#  ]
#}
