terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}
provider "aws" { region = var.aws_region }
variable "aws_region" {
  type = string
  default = "us-east-1"
}
variable "monthly_budget_usd" {
  type = number
  default = 100
}
variable "notification_email" {
  type = string
  description = "Email address for budget alerts"
}
resource "aws_budgets_budget" "monthly" {
  name = "terraform-monthly-cost-budget"
  budget_type = "COST"
  limit_amount = tostring(var.monthly_budget_usd)
  limit_unit = "USD"
  time_unit = "MONTHLY"
  notification {
    comparison_operator = "GREATER_THAN"
    threshold = 80
    threshold_type = "PERCENTAGE"
    notification_type = "ACTUAL"
    subscriber_email_addresses = [var.notification_email]
  }
  notification {
    comparison_operator = "GREATER_THAN"
    threshold = 100
    threshold_type = "PERCENTAGE"
    notification_type = "FORECASTED"
    subscriber_email_addresses = [var.notification_email]
  }
}
output "budget_name" { value = aws_budgets_budget.monthly.name }
