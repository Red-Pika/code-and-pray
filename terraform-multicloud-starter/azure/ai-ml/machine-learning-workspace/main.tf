terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}
provider "azurerm" { features {} }
variable "location" { type = string
  default = "southeastasia"
}
variable "name" { type = string
  default = "starter-ml-workspace"
}
variable "storage_account_id" { type = string }
variable "key_vault_id" { type = string }
variable "application_insights_id" { type = string }
variable "container_registry_id" { type = string
  default = null
}
resource "azurerm_resource_group" "this" {
  name = "${var.name}-rg"
  location = var.location
}
resource "azurerm_machine_learning_workspace" "this" {
  name = var.name
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  storage_account_id = var.storage_account_id
  key_vault_id = var.key_vault_id
  application_insights_id = var.application_insights_id
  container_registry_id = var.container_registry_id
  public_network_access_enabled = false
  identity { type = "SystemAssigned" }
}
output "workspace_id" { value = azurerm_machine_learning_workspace.this.id }
