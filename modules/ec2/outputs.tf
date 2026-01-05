
output "instance_id" {   
    value       = aws_instance.jenkins_ec2.id
    description = "ID of the Jenkins EC2 instance"
}

output "public_ip" {   
    value       = aws_instance.jenkins_ec2.public_ip
    description = "Public IP address of the Jenkins EC2 instance"
}
