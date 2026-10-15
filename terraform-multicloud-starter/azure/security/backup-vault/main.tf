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
  default = "starter-backup"
}
resource "azurerm_resource_group" "this" {
  name = "${var.name}-rg"
  location = var.location
}
resource "azurerm_recovery_services_vault" "this" {
  name = var.name
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku = "Standard"
  soft_delete_enabled = true
  storage_mode_type = "GeoRedundant"
}
output "recovery_vault_id" { value = azurerm_recovery_services_vault.this.id }
