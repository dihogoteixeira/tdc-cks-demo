output "name" {
  value = google_compute_instance.this[*].name
  description = "Nome da VM"
}

output "instance_id" {
    value = google_compute_instance.this[*].instance_id
    description = "ID da VM"
}

output "cpu_platform" {
  value = google_compute_instance.this[*].cpu_platform
}

output "external_ip" {
    value = google_compute_instance.this[*].network_interface.0.access_config.0.nat_ip
    description = "IP externo da VM"
}

output "internal_ip" {
    value = google_compute_instance.this[*].network_interface.0.network_ip
    description = "IP interno da VM"
}

output "self_link" {
  value = google_compute_instance.this[*].self_link
  description = "VM Self Link"
}