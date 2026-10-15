terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.0" }
  }
}
provider "google" {
  project = var.project_id
  region = var.region
}
variable "project_id" {
  type = string
  description = "GCP project ID"
}
variable "region" {
  type = string
  default = "asia-southeast2"
}
resource "google_logging_project_sink" "this" {
  name = "terraform-starter-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.logs.name}"
  filter = "severity >= WARNING"
  unique_writer_identity = true
}
resource "google_storage_bucket" "logs" {
  name = "${var.project_id}-terraform-logs"
  location = "ASIA-SOUTHEAST2"
  uniform_bucket_level_access = true
  public_access_prevention = "enforced"
  retention_policy {
    retention_period = 2592000
    is_locked = false
  }
}
resource "google_monitoring_alert_policy" "cpu" {
  display_name = "Terraform starter CPU alert"
  combiner = "OR"
  conditions {
    display_name = "CPU utilization high"
    condition_threshold {
      filter = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\""
      duration = "300s"
      comparison = "COMPARISON_GT"
      threshold_value = 0.8
      aggregations {
        alignment_period = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
}
output "log_sink_name" { value = google_logging_project_sink.this.name }
output "alert_policy_name" { value = google_monitoring_alert_policy.cpu.name }
