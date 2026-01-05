variable "vpc_id" { 
    type = string
    description = "Name of VPC"
}

variable "my_public_ip" {
    type        = string
    description = "Your public IP address for SSH access"  
}


variable "ingress_ports" {
    type        = list(number)
    description = "List of ingress ports to allow"
    default     = [8080, 50000]
}

variable "egress_ports" {
    type        = list(number)
    description = "List of egress ports to allow"
    default     = [80, 443]
}