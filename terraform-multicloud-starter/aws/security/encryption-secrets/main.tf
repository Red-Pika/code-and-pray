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
variable "name" {
  type = string
  default = "starter-app"
  }
resource "aws_kms_key" "this" {
  description = "KMS key for ${var.name}"
  enable_key_rotation = true
  deletion_window_in_days = 30
  tags = { Name = "${var.name}-key" }
}
resource "aws_kms_alias" "this" {
  name = "alias/${var.name}"
  target_key_id = aws_kms_key.this.key_id
}
resource "aws_secretsmanager_secret" "this" {
  name = "${var.name}/application"
  description = "Application secret container secret value is intentionally not managed here"
  kms_key_id = aws_kms_key.this.arn
}
output "kms_key_arn" { value = aws_kms_key.this.arn }
output "secret_arn" { value = aws_secretsmanager_secret.this.arn }
