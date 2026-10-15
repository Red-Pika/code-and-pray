terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}
provider "azurerm" { features {} }
variable "subscription_id" { type = string }
variable "name" { type = string
  default = "terraform-monthly-budget"
}
variable "amount" { type = number
  default = 100
}
resource "azurerm_consumption_budget_subscription" "monthly" {
  name = var.name
  subscription_id = "/subscriptions/${var.subscription_id}"
  amount = var.amount
  time_grain = "Monthly"
  time_period {
    start_date = "2026-01-01T00:00:00Z"
    end_date = "2035-12-31T23:59:59Z"
  }
  notification {
    enabled = true
    threshold = 80
    operator = "GreaterThan"
    contact_emails = []
  }
}
output "budget_name" { value = azurerm_consumption_budget_subscription.monthly.name }
