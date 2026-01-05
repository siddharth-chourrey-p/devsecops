
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



module "vpc" {
  source = "./modules/vpc"

  vpc_config = {
    cidr_block  = "192.168.1.0/24"
    name        = "main-vpc"
  }

  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  az = "ap-south-1a"
}

module "sg" {
  source = "./modules/sg"

  vpc_id = module.vpc.vpc_id
  my_public_ip = var.my_public_ip
  ingress_ports = var.ingress_ports
  egress_ports = var.egress_ports
}


module "iam" {
  source = "./modules/iam"

  role_name             = "jenkins-role"
  instance_profile_name = "ec2-profile"
  policy_name           = "jenkins-policy"
}


# key pair
resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins-key"
  public_key = file(var.jenkins_pb_key_path)
}
module "ec2" {
  source = "./modules/ec2"

    ami_id          = data.aws_ami.amazon_linux.id
    instance_type   = "t2.micro"
    subnet_id       = module.vpc.public_subnet_id
    instance_name   = "jenkins-ec2"
    instance_profile_name = module.iam.instance_profile_name
    pb_key                = "jenkins-key"
    security_group_id   = module.sg.security_group_id
}


