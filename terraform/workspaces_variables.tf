locals {
  memory = {
   stage = 2
   prod = 4
  }
  cores = {
    stage = 2
    prod = 4
  }
  disk_size = {
    stage = 15
    prod = 30
  }
  disk_type = {
    stage = "network-ssd"
    prod = "network-ssd"
  }
  subnet-type = {
    stage = yandex_vpc_subnet.subnet-stage.id
    prod = yandex_vpc_subnet.subnet-prod.id
  }
  zone = {
    stage = "ru-central1-a"
    prod = "ru-central1-b"
  }
  } 
