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
  default = "starter-lb"
}
variable "resource_group_name" { type = string }
variable "subnet_id" { type = string }
resource "azurerm_public_ip" "this" {
  name = "${var.name}-ip"
  location = var.location
  resource_group_name = var.resource_group_name
  allocation_method = "Static"
  sku = "Standard"
}
resource "azurerm_lb" "this" {
  name = var.name
  location = var.location
  resource_group_name = var.resource_group_name
  sku = "Standard"
  frontend_ip_configuration {
    name = "public"
    public_ip_address_id = azurerm_public_ip.this.id
  }
}
resource "azurerm_lb_backend_address_pool" "this" {
  loadbalancer_id = azurerm_lb.this.id
  name = "backend"
}
resource "azurerm_lb_probe" "https" {
  loadbalancer_id = azurerm_lb.this.id
  name = "https-probe"
  protocol = "Tcp"
  port = 443
}
resource "azurerm_lb_rule" "https" {
  loadbalancer_id = azurerm_lb.this.id
  name = "https"
  protocol = "Tcp"
  frontend_port = 443
  backend_port = 443
  frontend_ip_configuration_name = "public"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.this.id]
  probe_id = azurerm_lb_probe.https.id
}
output "public_ip" { value = azurerm_public_ip.this.ip_address }
