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
variable "bucket_name" { type = string
  description = "Globally unique S3 bucket name"
}
variable "availability_zone" { type = string
  default = "ap-southeast-1a"
}
resource "aws_s3_bucket" "data" { bucket = var.bucket_name }
resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id
  versioning_configuration { status = "Enabled" }
}
resource "aws_s3_bucket_lifecycle_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    id = "transition-and-expire"
    status = "Enabled"
    filter { prefix = "" }
    transition { days = 30
      storage_class = "STANDARD_IA"
    }
    expiration { days = 365 }
    noncurrent_version_expiration { noncurrent_days = 90 }
  }
}
resource "aws_ebs_volume" "data" {
  availability_zone = var.availability_zone
  size = 20
  type = "gp3"
  encrypted = true
  tags = { Name = "starter-data-volume" }
}
output "bucket_name" { value = aws_s3_bucket.data.id }
output "ebs_volume_id" { value = aws_ebs_volume.data.id }
