terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.14"

cloud {
  organization = "chuckberry321"

  workspaces {
    tags = ["stage", "prod"]
   }
 }
}

provider "yandex" {
  folder_id = var.folder_id
  cloud_id  = var.cloud_id
  token     = "${var.oauth_token}"
}
