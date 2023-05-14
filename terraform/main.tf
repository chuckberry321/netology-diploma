resource "yandex_compute_instance" "master" {
  name = "master-${terraform.workspace}"
  zone = local.zone[terraform.workspace]
  count = 1

  resources {
    cores  = local.cores[terraform.workspace]
    memory = local.memory[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      #ubuntu-2204-lts
      image_id = "fd8earpjmhevh8h6ug5o"
      type = local.disk_type[terraform.workspace]
      size = local.disk_size[terraform.workspace]
    }
  }

  network_interface {
    subnet_id = local.subnet-type[terraform.workspace]
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_key}"
#    ssh-keys = "ubuntu:${file("id_rsa.pub")}"
  }

}

resource "null_resource" "add_ssh_key" {
  provisioner "remote-exec" {
    inline = [
      "echo '${var.ssh_key}' >> ~/.ssh/authorized_keys"
    ]
  }
  depends_on = [
    yandex_compute_instance.master
    ]
}

resource "yandex_compute_instance" "worker" {
  name = "worker-${terraform.workspace}-${count.index + 1}"
  zone = local.zone[terraform.workspace]
  count = 2

  resources {
    cores  = local.cores[terraform.workspace]
    memory = local.memory[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      # ubuntu-2204-lts
      image_id = "fd8earpjmhevh8h6ug5o"
      type = local.disk_type[terraform.workspace]
      size = local.disk_size[terraform.workspace]
    }
  }

  network_interface {
    subnet_id = local.subnet-type[terraform.workspace]
    nat       = true
  }

#  metadata = {
#    ssh-keys = "ubuntu:${file("id_rsa.pub")}"
#  }
}
