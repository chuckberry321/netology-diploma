output "int_ip_address_master" {
  value = yandex_compute_instance.master.*.network_interface.0.ip_address
}

output "ext_ip_address_master" {
  value = yandex_compute_instance.master.*.network_interface.0.nat_ip_address
}

output "int_ip_address_worker" {
  value = yandex_compute_instance.worker.*.network_interface.0.ip_address
}

output "ext_ip_address_worker" {
  value = yandex_compute_instance.worker.*.network_interface.0.nat_ip_address
}

output "ext_ip_address_jenkins" {
  value = yandex_compute_instance.jenkins.*.network_interface.0.nat_ip_address
}

