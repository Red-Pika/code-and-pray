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
variable "database_name" {
  type = string
  default = "starter_catalog"
}
resource "aws_glue_catalog_database" "this" {
  name = var.database_name
  description = "Starter Glue Data Catalog database"
}
output "catalog_database_name" { value = aws_glue_catalog_database.this.name }
