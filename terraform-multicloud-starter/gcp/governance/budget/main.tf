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
variable "project_id" { type = string }
variable "region" {
  type = string
  default = "asia-southeast2"
}
variable "billing_account" {
  type = string
  description = "Billing account ID, e.g. 000000-000000-000000"
}
variable "budget_amount_usd" {
  type = number
  default = 100
}
resource "google_billing_budget" "monthly" {
  billing_account = var.billing_account
  display_name = "${var.project_id}-monthly-budget"
  budget_filter { projects = ["projects/${var.project_id}"] }
  amount {
    specified_amount {
      currency_code = "USD"
    units = tostring(floor(var.budget_amount_usd))
  } }
  threshold_rules {
    threshold_percent = 0.8
    spend_basis = "CURRENT_SPEND"
  }
  threshold_rules {
    threshold_percent = 1.0
    spend_basis = "FORECASTED_SPEND"
  }
}
output "budget_name" { value = google_billing_budget.monthly.name }
