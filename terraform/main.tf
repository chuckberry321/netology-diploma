terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.13"
    }
  }
}

provider "yandex" {
  folder_id = var.folder_id
  token     = var.oauth_token
  cloud_id  = var.cloud_id
}

module "vpc" {
  source = "./modules/vpc"

  workspace = terraform.workspace
}
