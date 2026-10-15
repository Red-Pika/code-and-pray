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
  default = "starter-service"
  }
variable "alarm_email" {
  type = string
  default = ""
  }
resource "aws_cloudwatch_log_group" "app" {
  name = "/application/${var.name}"
  retention_in_days = 30
}
resource "aws_sns_topic" "alerts" { name = "${var.name}-alerts" }
resource "aws_sns_topic_subscription" "email" {
  count = var.alarm_email == "" ? 0 : 1
  topic_arn = aws_sns_topic.alerts.arn
  protocol = "email"
  endpoint = var.alarm_email
}
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name = "${var.name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 300
  statistic = "Average"
  threshold = 80
  alarm_description = "Average CPU exceeded 80 percent"
  alarm_actions = [aws_sns_topic.alerts.arn]
  treat_missing_data = "notBreaching"
  dimensions = { AutoScalingGroupName = var.name }
}
output "log_group_name" { value = aws_cloudwatch_log_group.app.name }
output "alert_topic_arn" { value = aws_sns_topic.alerts.arn }
