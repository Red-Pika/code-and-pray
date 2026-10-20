resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone
  size              = var.size_gb
  type              = var.volume_type
  encrypted         = true
  kms_key_id        = var.kms_key_id

  tags = {
    Name   = var.name
    Backup = "daily" # picked up by the DLM policy below
  }
}

resource "aws_iam_role" "dlm" {
  name = "${var.name}-dlm"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "dlm.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "dlm" {
  role       = aws_iam_role.dlm.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSDataLifecycleManagerServiceRole"
}

resource "aws_dlm_lifecycle_policy" "daily" {
  description        = "Daily EBS snapshots for volumes tagged Backup=daily"
  execution_role_arn = aws_iam_role.dlm.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]
    target_tags    = { Backup = "daily" }

    schedule {
      name = "daily"
      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["18:00"]
      }
      retain_rule {
        count = var.snapshot_retention_count
      }
      copy_tags = true
    }
  }
}
