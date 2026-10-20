terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
  }
}

variable "subscription_id" {
  description = "Azure subscription ID (required by azurerm 4.x)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "southeastasia"
}

variable "tags" {
  description = "Tags applied to every resource"
  type        = map(string)
  default     = { ManagedBy = "terraform" }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
