resource "tls_private_key" "tf_generate_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "cloud_user" {
  content = <<-DOC
#cloud-config
users:
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - "${var.ssh_key}"
      - "${tls_private_key.tf_generate_key.public_key_openssh}"
DOC
  filename = "./meta.txt"
  file_permission = "600"      # Права доступа для пользователя

  depends_on = [
    tls_private_key.tf_generate__key
  ]
}

resource "local_file" "private_key" {
  content = tls_private_key.tf_generate_key.private_key_openssh
  filename = "/tmp/id_rsa_cloud_user"
  file_permission = "600"

  depends_on = [
    tls_private_key.tf_generate_key
  ]
}
