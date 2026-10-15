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
  default = "starter-aks"
}
resource "azurerm_resource_group" "this" {
  name = "${var.name}-rg"
  location = var.location
}
resource "azurerm_kubernetes_cluster" "this" {
  name = var.name
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix = var.name
  private_cluster_enabled = true
  role_based_access_control_enabled = true
  default_node_pool {
    name = "system"
    node_count = 2
    vm_size = "Standard_D2s_v5"
    type = "VirtualMachineScaleSets"
  }
  identity { type = "SystemAssigned" }
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
    network_policy = "azure"
  }
}
output "cluster_id" { value = azurerm_kubernetes_cluster.this.id }
output "kube_config_raw" {
  value = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive = true
}
