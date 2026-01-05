# security group for jenkins
resource "aws_security_group" "sg_main" {
  vpc_id      = var.vpc_id

  tags = {
    Name = "jenkins_sg"
  }

# ingress (dynamic)
dynamic "ingress" {
  for_each = var.ingress_ports

  content {
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip]
  }
}
}

resource "aws_security_group_rule" "egress" {
  for_each = { for port in var.egress_ports : tostring(port) => port }

  type              = "egress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_main.id
  cidr_blocks       = ["0.0.0.0/0"]
}