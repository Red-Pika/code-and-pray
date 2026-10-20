resource "google_compute_disk" "this" {
  name   = var.name
  type   = var.disk_type
  zone   = var.zone
  size   = var.size_gb
  labels = var.labels

  dynamic "disk_encryption_key" {
    for_each = var.kms_key_id == null ? [] : [1]
    content {
      kms_key_self_link = var.kms_key_id
    }
  }
}

resource "google_compute_resource_policy" "daily_snapshot" {
  name   = "${var.name}-daily"
  region = var.region

  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "18:00"
      }
    }
    retention_policy {
      max_retention_days    = var.snapshot_retention_days
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
  }
}

resource "google_compute_disk_resource_policy_attachment" "daily" {
  name = google_compute_resource_policy.daily_snapshot.name
  disk = google_compute_disk.this.name
  zone = var.zone
}
