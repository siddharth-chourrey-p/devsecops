variable "role_name" {
    type        = string
    description = "Name of the IAM role for Jenkins EC2" 
}

variable "instance_profile_name" {
    type        = string
    description = "Name of the IAM instance profile for Jenkins EC2"
}

variable "policy_name" {
    type = string
    description = "Name of the IAM instance policy ofile for Jenkins EC2"
}