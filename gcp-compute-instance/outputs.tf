output "instance_name" {
  value = google_compute_instance.app.name
}

output "machine_type" {
  value = google_compute_instance.app.machine_type
}

output "nat_ip" {
  value = google_compute_instance.app.network_interface[0].access_config[0].nat_ip
}
