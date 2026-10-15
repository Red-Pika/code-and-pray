package terraform.guardrails

# Input is expected to be a Terraform plan JSON document.

deny[msg] {
  rc := input.resource_changes[_]
  rc.change.actions[_] == "create"
  rc.type == "aws_s3_bucket"
  msg := sprintf("Review S3 bucket %s: public access should be blocked and encryption enabled.", [rc.address])
}

deny[msg] {
  rc := input.resource_changes[_]
  rc.change.actions[_] == "create"
  rc.type == "aws_security_group_rule"
  rc.change.after.type == "ingress"
  rc.change.after.cidr_blocks[_] == "0.0.0.0/0"
  rc.change.after.from_port <= 22
  rc.change.after.to_port >= 22
  msg := sprintf("Do not expose SSH to the public internet: %s", [rc.address])
}

deny[msg] {
  rc := input.resource_changes[_]
  rc.change.actions[_] == "create"
  rc.type == "aws_db_instance"
  rc.change.after.publicly_accessible == true
  msg := sprintf("Database %s must not be publicly accessible.", [rc.address])
}
