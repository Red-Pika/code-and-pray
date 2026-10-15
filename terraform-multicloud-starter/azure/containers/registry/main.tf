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
  default = "starterregistry"
}
resource "azurerm_resource_group" "this" {
  name = "${var.name}-rg"
  location = var.location
}
resource "azurerm_container_registry" "this" {
  name = var.name
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  sku = "Basic"
  admin_enabled = false
  public_network_access_enabled = false
}
output "registry_login_server" { value = azurerm_container_registry.this.login_server }
