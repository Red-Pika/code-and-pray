output "instance_id" {
  value = aws_instance.app.id
}

output "public_ip" {
  value = aws_instance.app.public_ip
}

output "instance_type" {
  value = aws_instance.app.instance_type
}

output "lifecycle_note" {
  value = "Stop/start via AWS API keeps this resource. terraform destroy terminates it."
}
