variable "vpc_config" {
    description = "The CIDR block for the VPC"
    type        = object({
      cidr_block = string
      name = string
    })  
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type = string
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type = string
}

variable "az" {
  description = "List of availability zones"
  type = string  
}