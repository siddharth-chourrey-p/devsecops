output "vpc_id" {
    value = aws_vpc.main.id
    description = "VPC ID"
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "jenkins_server_public_ip" {
  value = aws_instance.jenkins_web.public_ip
}

output "jenkins_sg_id" {
  value = aws_security_group.jenkins_sg.id
}