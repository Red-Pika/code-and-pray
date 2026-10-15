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
  default = "starter-edge"
}
resource "azurerm_resource_group" "this" {
  name = "${var.name}-rg"
  location = var.location
}
resource "azurerm_virtual_network" "this" {
  name = "${var.name}-vnet"
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space = ["10.70.0.0/16"]
}
resource "azurerm_subnet" "public" {
  name = "public"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = ["10.70.1.0/24"]
}
resource "azurerm_subnet" "private" {
  name = "private"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = ["10.70.11.0/24"]
}
resource "azurerm_public_ip" "nat" {
  name = "${var.name}-nat-ip"
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method = "Static"
  sku = "Standard"
}
resource "azurerm_nat_gateway" "this" {
  name = "${var.name}-nat"
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku_name = "Standard"
}
resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.nat.id
}
resource "azurerm_subnet_nat_gateway_association" "private" {
  subnet_id = azurerm_subnet.private.id
  nat_gateway_id = azurerm_nat_gateway.this.id
}
resource "azurerm_route_table" "private" {
  name = "${var.name}-private-rt"
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}
resource "azurerm_subnet_route_table_association" "private" {
  subnet_id = azurerm_subnet.private.id
  route_table_id = azurerm_route_table.private.id
}
output "vnet_id" { value = azurerm_virtual_network.this.id }
output "private_subnet_id" { value = azurerm_subnet.private.id }
output "nat_gateway_id" { value = azurerm_nat_gateway.this.id }
