terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}
provider "aws" { region = var.aws_region }
variable "aws_region" { type = string
  default = "ap-southeast-1"
}
variable "name" { type = string
  default = "starter-db"
}
variable "private_subnet_ids" { type = list(string)
  description = "At least two private subnet IDs in different AZs"
}
variable "vpc_security_group_ids" { type = list(string)
  description = "Database security groups; allow inbound only from application tier"
}
variable "master_username" { type = string
  default = "dbadmin"
}
resource "aws_db_subnet_group" "this" {
  name = var.name
  subnet_ids = var.private_subnet_ids
}
resource "aws_db_instance" "this" {
  identifier = var.name
  engine = "postgres"
  engine_version = "16"
  instance_class = "db.t4g.micro"
  allocated_storage = 20
  max_allocated_storage = 100
  storage_encrypted = true
  username = var.master_username
  manage_master_user_password = true
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids
  multi_az = true
  backup_retention_period = 7
  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.name}-final"
  publicly_accessible = false
  auto_minor_version_upgrade = true
  tags = { Name = var.name }
}
output "db_endpoint" { value = aws_db_instance.this.address }
output "db_secret_arn" { value = aws_db_instance.this.master_user_secret[0].secret_arn }
