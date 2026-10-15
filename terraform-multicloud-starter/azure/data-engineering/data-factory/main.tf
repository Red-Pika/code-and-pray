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
  default = "starter-datafactory"
}
resource "azurerm_resource_group" "this" {
  name = "${var.name}-rg"
  location = var.location
}
resource "azurerm_data_factory" "this" {
  name = var.name
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  public_network_enabled = false
}
output "data_factory_id" { value = azurerm_data_factory.this.id }
