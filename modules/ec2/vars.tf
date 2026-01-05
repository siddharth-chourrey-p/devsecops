variable "ami_id" {
    type        = string
    description = "AMI ID for the EC2 instance"  
}

variable "instance_type" { 
    type        = string
    description = "EC2 instance type"  
}

variable "subnet_id" {
    type        = string
    description = "Subnet ID where the EC2 instance will be launched"
}

variable "pb_key" {  
    type        = string
    description = "Key pair name for SSH access to the EC2 instance"
}

variable "instance_profile_name" {
    type        = string
    description = "IAM instance profile name for the EC2 instance"
}

variable "instance_name" {
    type = string
    description = "name of instance"
}

variable "security_group_id" {
    type        = string
    description = "Security group ID to associate with the EC2 instance"
    default = ""
}