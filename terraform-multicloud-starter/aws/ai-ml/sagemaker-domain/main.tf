terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "name" {
  type    = string
  default = "starter-ml"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

resource "aws_iam_role" "execution" {
  name = "${var.name}-sagemaker-execution"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "sagemaker.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_sagemaker_domain" "this" {
  domain_name             = var.name
  auth_mode               = "IAM"
  vpc_id                  = data.aws_vpc.selected.id
  subnet_ids              = var.private_subnet_ids
  app_network_access_type = "VpcOnly"

  default_user_settings {
    execution_role  = aws_iam_role.execution.arn
    security_groups = var.security_group_ids
  }

  default_space_settings {
    execution_role  = aws_iam_role.execution.arn
    security_groups = var.security_group_ids
  }

  depends_on = [aws_iam_role_policy_attachment.execution]
}

data "aws_subnet" "selected" {
  id = var.private_subnet_ids[0]
}

data "aws_vpc" "selected" {
  id = data.aws_subnet.selected.vpc_id
}

output "sagemaker_domain_id" {
  value = aws_sagemaker_domain.this.id
}
