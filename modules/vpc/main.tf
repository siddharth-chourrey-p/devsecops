# VPC Module
resource "aws_vpc" "main" {
  cidr_block = var.vpc_config.cidr_block

  tags = {
    Name = "${var.vpc_config.name}"
  }
}

# Subnets
resource "aws_subnet" "public_subnet" {
  vpc_id        = aws_vpc.main.id
  cidr_block    = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = var.az

      tags = {
        Name = "Public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
  vpc_id        = aws_vpc.main.id

  cidr_block    = var.public_subnet_cidr

      tags = {
        Name = "private_subnet"
    }
}

# Internet Gateway + Route Table
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_config.name}-IGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "${var.vpc_config.name}-Public-Route-Table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

