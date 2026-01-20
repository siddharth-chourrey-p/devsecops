# EC2 Module
resource "aws_instance" "jenkins_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.instance_profile_name
  key_name                    = var.pb_key
  associate_public_ip_address = true
  user_data = base64decode(file("${path.module}/userdata.sh"))

  tags = {
    Name = "jenkins_ec2"
  }
}

