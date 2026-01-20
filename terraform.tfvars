aws_region = "ap-south-1"

vpc_cidr = "192.168.1.0/24"

public_subnet_cidr = "192.168.1.0/26"

private_subnet_cidr = "192.168.1.128/26"

key_name = "jenkins-key"

instance_type = "t2.micro"

jenkins_pb_key_path = "~/.ssh/id_rsa.pub"

my_public_ip = ""

ingress_ports = [22, 8080]

egress_ports = [80, 443]

     