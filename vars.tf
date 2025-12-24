
variable "aws_region" {
  type = string
  default = "ap-south-1"
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "app_port" {
  type = map(number)
  description = "Ports allowed in SG "
}

variable "vpc_cidr" {
  default = "192.168.1.0/24"
  description = "VPC cidr block"
}

variable "public_subnet_cidr" {
  default = "192.168.1.0/26"
  description = "Public subnet"
}

variable "private_subnet_cidr" {
  default     = "192.168.1.128/26"
  description = "Private subnet"
}

variable "jenkins_pb_key_path" {
  type        = string
  description = "Path to an SSH public key file"
}

variable "my_public_ip" {
  type  = string
  description = "public ip for ssh into ec2"
}

