terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
    region = var.aws_region
}

####################################
# VPC
####################################

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Demo-VPC"
  }
}

####################################
# SUBNETS
####################################

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr

  tags = {
    Name = "Private-Subnet"
  }
}

####################################
# INTERNET GATEWAY + ROUTE TABLE
####################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Demo-IGW"
  }

}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-route-table"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

####################################
# SECURITY GROUP
####################################
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow Jenkins Traffic"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "Jenkins SG"
  }
}

# App Ports (dynamic)
resource "aws_security_group_rule" "app_ports" {
  for_each          = var.app_port
  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  security_group_id = aws_security_group.jenkins_sg.id
  description       = "Allow ${each.key} traffic"
  cidr_blocks       = [var.my_public_ip]
}

# SSH Rule restricted to your public IP
resource "aws_security_group_rule" "ssh_access" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_blocks       = [var.my_public_ip]
  description       = "Allow SSH from my IP"
}

# Allow outbound traffic
resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_sg.id
}



data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*al2023-ami-2023.*.*-kernel-6.1-x86_64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"] # Canonical
}

# --- IAM Role for Jenkins EC2 ---

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.jenkins_role.name
}

# Attach IAM policy to Jenkins role
resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.jenkins_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
     {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
     }
  ]
}
EOF
}
### key pair ####
resource "aws_key_pair" "pb_key" {
  key_name   = var.key_name
  public_key = file(var.jenkins_pb_key_path)
}


####################################
# EC2 INSTANCE
####################################
resource "aws_instance" "jenkins_web" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  subnet_id = aws_subnet.public.id
  user_data       = file("install_jenkins.sh")

  tags = {
    Name = "Jenkins"
  }
}