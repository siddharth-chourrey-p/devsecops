
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

  validation {
    condition     = fileexists(var.jenkins_pb_key_path)
    error_message = "public key file does not exist."
  }
}

variable "my_public_ip" {
  type  = string
  description = "public ip for ssh into ec2"
}

variable "ingress_ports" {
  type    = list(number)
  description = "List of ingress ports for security group"
}

variable "egress_ports" {
  type = list(number)
  description = "List of egress ports for security group"
}

