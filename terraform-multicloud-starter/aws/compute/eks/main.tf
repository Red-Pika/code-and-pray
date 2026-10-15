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
variable "cluster_name" { type = string
  default = "starter-eks"
}
variable "private_subnet_ids" { type = list(string)
  description = "Private subnet IDs across at least two AZs"
}
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "cluster" {
  role = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_eks_cluster" "this" {
  name = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version = "1.30"
  vpc_config {
    subnet_ids = var.private_subnet_ids
    endpoint_public_access = false
    endpoint_private_access = true
  }
  depends_on = [aws_iam_role_policy_attachment.cluster]
}
output "cluster_name" { value = aws_eks_cluster.this.name }
output "cluster_endpoint" { value = aws_eks_cluster.this.endpoint }
