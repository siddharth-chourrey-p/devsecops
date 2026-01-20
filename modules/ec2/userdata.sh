#!/bin/bash

exec > /var/log/user-data.log 2>&1
set -e

yum update -y

#Java
dnf install java-17-amazon-corretto-devel -y

# Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install jenkins -y

systemctl enable jenkins
systemctl start jenkins

# Docker
yum install docker -y
systemctl enable docker
systemctl start docker
usermod -aG docker jenkins

# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
yum install unzip -y
unzip awscliv2.zip
./aws/install