output "asg_name" {
  value = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  value = aws_launch_template.app.id
}

output "capacity" {
  value = {
    min     = var.min_size
    desired = var.desired_capacity
    max     = var.max_size
  }
}
