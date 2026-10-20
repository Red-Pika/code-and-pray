output "volume_id" { value = aws_ebs_volume.this.id }
output "volume_arn" { value = aws_ebs_volume.this.arn }
output "dlm_policy_id" { value = aws_dlm_lifecycle_policy.daily.id }
