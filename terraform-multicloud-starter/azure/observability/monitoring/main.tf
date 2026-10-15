terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}
provider "azurerm" {
  features {}
}
variable "location" {
  type = string
  default = "southeastasia"
}
variable "name" {
  type = string
  default = "starter-monitoring"
}
resource "azurerm_resource_group" "this" {
  name = "${var.name}-rg"
  location = var.location
}
resource "azurerm_log_analytics_workspace" "this" {
  name = var.name
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku = "PerGB2018"
  retention_in_days = 30
}
resource "azurerm_monitor_action_group" "this" {
  name = "${var.name}-alerts"
  resource_group_name = azurerm_resource_group.this.name
  short_name = "alerts"
}
output "workspace_id" { value = azurerm_log_analytics_workspace.this.id }
output "action_group_id" { value = azurerm_monitor_action_group.this.id }
