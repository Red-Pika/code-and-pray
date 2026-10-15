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
resource "aws_ecr_repository" "this" {
  name = var.name
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration { scan_on_push = true }
  encryption_configuration { encryption_type = "AES256" }
}
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description = "Keep the latest 30 images"
      selection = { tagStatus = "any", countType = "imageCountMoreThan", countNumber = 30 }
      action = { type = "expire" }
    }]
  })
}
output "repository_url" { value = aws_ecr_repository.this.repository_url }
