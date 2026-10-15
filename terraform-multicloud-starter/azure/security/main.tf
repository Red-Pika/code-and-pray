terraform {
  required_version = ">= 1.5.0"
  required_providers { azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" } }
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
  default = "starter-nsg"
  }
resource "azurerm_resource_group" "this" {
  name = "${var.name}-rg"
  location = var.location
}
resource "azurerm_network_security_group" "this" {
  name = var.name
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  security_rule {
    name = "AllowHTTPSInbound"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "443"
    source_address_prefix = "Internet"
    destination_address_prefix = "*"
  }
  security_rule {
    name = "DenyOtherInbound"
    priority = 4096
    direction = "Inbound"
    access = "Deny"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}
output "network_security_group_id" { value = azurerm_network_security_group.this.id }
