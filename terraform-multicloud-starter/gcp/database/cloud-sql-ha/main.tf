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
variable "name" {
  type = string
  default = "starter-sql"
}
resource "google_sql_database_instance" "this" {
  name = var.name
  region = var.region
  database_version = "POSTGRES_15"
  deletion_protection = true
  settings {
    tier = "db-custom-1-3840"
    availability_type = "REGIONAL"
    disk_size = 20
    disk_autoresize = true
    backup_configuration {
      enabled = true
      point_in_time_recovery_enabled = true
      start_time = "18:00"
    }
    ip_configuration {
      ipv4_enabled = false
      private_network = "projects/${var.project_id}/global/networks/default"
    }
  }
}
resource "google_sql_database" "this" {
  name = "application"
  instance = google_sql_database_instance.this.name
}
output "instance_connection_name" { value = google_sql_database_instance.this.connection_name }
