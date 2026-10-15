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
  default = "starter-vpn"
}
variable "resource_group_name" { type = string }
variable "vnet_id" { type = string }
variable "gateway_subnet_id" {
  type = string
  description = "Subnet named GatewaySubnet, typically /27 or larger"
}
variable "on_prem_public_ip" { type = string }
variable "on_prem_address_space" { type = list(string) }
variable "shared_key" {
  type = string
  sensitive = true
}
resource "azurerm_public_ip" "this" {
  name = "${var.name}-ip"
  location = var.location
  resource_group_name = var.resource_group_name
  allocation_method = "Dynamic"
}
resource "azurerm_virtual_network_gateway" "this" {
  name = var.name
  location = var.location
  resource_group_name = var.resource_group_name
  type = "Vpn"
  vpn_type = "RouteBased"
  active_active = false
  enable_bgp = false
  sku = "VpnGw1"
  ip_configuration {
    name = "vnetGatewayConfig"
    public_ip_address_id = azurerm_public_ip.this.id
    private_ip_address_allocation = "Dynamic"
    subnet_id = var.gateway_subnet_id
  }
}
resource "azurerm_local_network_gateway" "this" {
  name = "${var.name}-onprem"
  location = var.location
  resource_group_name = var.resource_group_name
  gateway_address = var.on_prem_public_ip
  address_space = var.on_prem_address_space
}
resource "azurerm_virtual_network_gateway_connection" "this" {
  name = "${var.name}-connection"
  location = var.location
  resource_group_name = var.resource_group_name
  type = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.this.id
  local_network_gateway_id = azurerm_local_network_gateway.this.id
  shared_key = var.shared_key
}
output "vpn_gateway_id" { value = azurerm_virtual_network_gateway.this.id }
