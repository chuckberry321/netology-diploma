resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-stage" {
  name           = "subnet-stage"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet-prod" {
  name           = "subnet-prod"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.20.0/24"]
}
