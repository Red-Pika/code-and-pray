output "web_security_group_id" { value = aws_security_group.web.id }
output "app_security_group_id" { value = aws_security_group.app.id }
output "kms_key_arn" { value = aws_kms_key.this.arn }
output "secret_arn" { value = aws_secretsmanager_secret.app.arn }
