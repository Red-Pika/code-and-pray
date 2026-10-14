output "mig_name" {
  value = google_compute_region_instance_group_manager.app.name
}

output "template_id" {
  value = google_compute_instance_template.app.id
}
