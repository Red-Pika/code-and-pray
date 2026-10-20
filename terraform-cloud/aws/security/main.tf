# ---- Security groups (web tier -> app tier) ----
resource "aws_security_group" "web" {
  name        = "${var.name}-web"
  description = "Web tier: HTTPS from allowed CIDRs"
  vpc_id      = var.vpc_id
  tags        = { Name = "${var.name}-web" }
}

resource "aws_vpc_security_group_ingress_rule" "web_https" {
  for_each          = toset(var.allowed_https_cidrs)
  security_group_id = aws_security_group.web.id
  description       = "HTTPS"
  cidr_ipv4         = each.value
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "web_all" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "app" {
  name        = "${var.name}-app"
  description = "App tier: only from the web tier"
  vpc_id      = var.vpc_id
  tags        = { Name = "${var.name}-app" }
}

resource "aws_vpc_security_group_ingress_rule" "app_from_web" {
  security_group_id            = aws_security_group.app.id
  description                  = "App port from web tier"
  referenced_security_group_id = aws_security_group.web.id
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "app_all" {
  security_group_id = aws_security_group.app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ---- KMS + Secrets Manager ----
resource "aws_kms_key" "this" {
  description             = "KMS key for ${var.name}"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_secretsmanager_secret" "app" {
  name       = "${var.name}/application"
  kms_key_id = aws_kms_key.this.arn
  # The secret VALUE is intentionally not managed here (it would land in state).
}
