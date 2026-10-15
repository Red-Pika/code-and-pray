terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}
provider "azurerm" { features {} }
variable "location" { type = string; default = "southeastasia" }
variable "name" { type = string; default = "starter-container-app" }
variable "container_image" { type = string; description = "Container image URI" }
resource "azurerm_resource_group" "this" {
  name = "${var.name}-rg"
  location = var.location
}
resource "azurerm_log_analytics_workspace" "this" {
  name = "${var.name}-logs"
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku = "PerGB2018"
  retention_in_days = 30
}
resource "azurerm_container_app_environment" "this" {
  name = "${var.name}-env"
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
}
resource "azurerm_container_app" "this" {
  name = var.name
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name = azurerm_resource_group.this.name
  revision_mode = "Single"
  template {
    min_replicas = 1
    max_replicas = 3
    container {
      name = "app"
      image = var.container_image
      cpu = 0.25
      memory = "0.5Gi"
    }
  }
  ingress {
    external_enabled = false
    target_port = 8080
    transport = "auto"
    traffic_weight { percentage = 100; latest_revision = true }
  }
}
output "container_app_id" { value = azurerm_container_app.this.id }
