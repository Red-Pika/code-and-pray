terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}
provider "azurerm" { features {} }
variable "name" { type = string
  default = "starter-peering"
}
variable "resource_group_name" { type = string }
variable "local_vnet_name" { type = string }
variable "remote_vnet_id" { type = string }
resource "azurerm_virtual_network_peering" "local_to_remote" {
  name = "${var.name}-local-to-remote"
  resource_group_name = var.resource_group_name
  virtual_network_name = var.local_vnet_name
  remote_virtual_network_id = var.remote_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic = false
  allow_gateway_transit = false
  use_remote_gateways = false
}
output "peering_id" { value = azurerm_virtual_network_peering.local_to_remote.id }
