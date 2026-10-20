output "disk_id" { value = google_compute_disk.this.id }
output "disk_self_link" { value = google_compute_disk.this.self_link }
output "snapshot_policy_id" { value = google_compute_resource_policy.daily_snapshot.id }
