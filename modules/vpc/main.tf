resource "yandex_vpc" "vpc" {
  name = "${terraform.workspace}-vpc"

  subnet {
    name       = "${terraform.workspace}-subnet"
    zone       = var.zone
    prefix     = var.prefix
    subnet_ipv4_cidr_blocks = [var.subnet_ipv4_cidr_block]
  }
}

variable "workspace" {}
variable "zone" {}
variable "prefix" {}
variable "subnet_ipv4_cidr_block" {}
