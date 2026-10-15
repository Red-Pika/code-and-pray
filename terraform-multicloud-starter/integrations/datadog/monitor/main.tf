terraform {
  required_version = ">= 1.5.0"
  required_providers {
    datadog = { source = "DataDog/datadog", version = "~> 3.0" }
  }
}
variable "datadog_api_key" { type = string; sensitive = true }
variable "datadog_app_key" { type = string; sensitive = true }
variable "monitor_name" { type = string; default = "Terraform starter monitor" }
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
resource "datadog_monitor" "high_cpu" {
  name = var.monitor_name
  type = "metric alert"
  message = "Review high CPU utilization. Notify your configured Datadog team."
  query = "avg(last_5m):avg:system.cpu.user{*} > 80"
  monitor_thresholds { critical = 80; warning = 70 }
  notify_no_data = false
  renotify_interval = 0
}
output "monitor_id" { value = datadog_monitor.high_cpu.id }
