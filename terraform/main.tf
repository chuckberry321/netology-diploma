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

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    user-data = local_file.cloud_user.content
#    ssh-keys = "ubuntu:${file("./id_rsa.pub")}"
  }
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

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    user-data = local_file.cloud_user.content
#    ssh-keys = "ubuntu:${file("./id_rsa.pub")}"
  }
}
