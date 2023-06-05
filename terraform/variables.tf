variable "folder_id" {
  default = ""
}

variable "ssh_user" {
  type = string
  default=""
}

variable "ssh_key" {
  type = string
  default=""
}

variable "service_account_id" {
  default = ""
}

variable "cloud_id" {
  default = ""
}

variable "ansible_roles_path" {
  default = "/tmp/kubespray/roles/"
}
