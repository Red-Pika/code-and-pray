terraform {
  required_version = ">= 1.5.0"
  required_providers { azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" } }
}
provider "azurerm" { features {} }
variable "location" { type = string
  default = "southeastasia" }
variable "name" { type = string
  default = "starter-network" }
resource "azurerm_resource_group" "this" { name = "${var.name}-rg"
  location = var.location }
resource "azurerm_virtual_network" "this" {
  name = "${var.name}-vnet"
  address_space = ["10.40.0.0/16"]
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}
resource "azurerm_subnet" "private" {
  name = "private"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = ["10.40.1.0/24"]
}
output "vnet_id" { value = azurerm_virtual_network.this.id }
output "subnet_id" { value = azurerm_subnet.private.id }
