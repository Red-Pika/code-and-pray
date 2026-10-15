terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.0" }
  }
}
provider "google" { project = var.project_id
  region = var.region
}
variable "project_id" { type = string }
variable "region" { type = string
  default = "asia-southeast2"
}
variable "name" { type = string
  default = "starter-disk-backup"
}
resource "google_compute_resource_policy" "this" {
  name = var.name
  region = var.region
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time = "18:00"
      }
    }
    retention_policy {
      max_retention_days = 30
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
    snapshot_properties {
      storage_locations = ["asia"]
      guest_flush = false
    }
  }
}
output "snapshot_policy_id" { value = google_compute_resource_policy.this.id }
