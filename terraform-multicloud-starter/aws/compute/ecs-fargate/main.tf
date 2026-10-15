terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}
provider "aws" { region = var.aws_region }
variable "aws_region" { type = string
  default = "ap-southeast-1" }
variable "name" { type = string
  default = "starter-fargate" }
variable "container_image" { type = string
  description = "Container image URI" }
variable "subnet_ids" { type = list(string)
  description = "Private subnet IDs" }
variable "security_group_ids" { type = list(string)
  description = "Task security groups" }
resource "aws_ecs_cluster" "this" {
  name = var.name
  setting { name = "containerInsights"
  value = "enabled" }
}
resource "aws_iam_role" "execution" {
  name = "${var.name}-execution"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Effect = "Allow", Principal = { Service = "ecs-tasks.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}
resource "aws_iam_role_policy_attachment" "execution" {
  role = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${var.name}"
  retention_in_days = 30
}
resource "aws_ecs_task_definition" "this" {
  family = var.name
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 256
  memory = 512
  execution_role_arn = aws_iam_role.execution.arn
  container_definitions = jsonencode([{
    name = var.name
    image = var.container_image
    essential = true
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group = aws_cloudwatch_log_group.this.name
        awslogs-region = var.aws_region
        awslogs-stream-prefix = "app"
      }
    }
  }])
}
resource "aws_ecs_service" "this" {
  name = var.name
  cluster = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count = 1
  launch_type = "FARGATE"
  network_configuration {
    subnets = var.subnet_ids
    security_groups = var.security_group_ids
    assign_public_ip = false
  }
  depends_on = [aws_iam_role_policy_attachment.execution]
}
output "cluster_name" { value = aws_ecs_cluster.this.name }
output "service_name" { value = aws_ecs_service.this.name }
