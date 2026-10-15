terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}
provider "aws" { region = var.aws_region }
variable "aws_region" {
  type = string
  default = "ap-southeast-1"
}
variable "role_name" {
  type = string
  default = "starter-workload-role"
}
variable "trusted_service" {
  type = string
  default = "ec2.amazonaws.com"
}
resource "aws_iam_role" "this" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = var.trusted_service }
      Action = "sts:AssumeRole"
    }]
  })
  tags = { ManagedBy = "Terraform" }
}
output "role_arn" { value = aws_iam_role.this.arn }
