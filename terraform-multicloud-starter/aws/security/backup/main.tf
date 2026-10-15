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
  default = "starter-backup"
}
resource "aws_backup_vault" "this" {
  name = var.name
  encryption_key_arn = null
}
resource "aws_backup_plan" "this" {
  name = var.name
  rule {
    rule_name = "daily"
    target_vault_name = aws_backup_vault.this.name
    schedule = "cron(0 18 * * ? *)"
    lifecycle {
      delete_after = 35
    }
  }
}
resource "aws_iam_role" "backup" {
  name = "${var.name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "backup.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "backup" {
  role = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}
output "backup_vault_arn" { value = aws_backup_vault.this.arn }
output "backup_plan_id" { value = aws_backup_plan.this.id }
