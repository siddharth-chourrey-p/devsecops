# --- IAM Role for Jenkins EC2 ---

resource "aws_iam_role" "jenkins_role" {
  name = var.role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_instance_profile" "test_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.jenkins_role.name
}

# Attach IAM policy to Jenkins role
resource "aws_iam_role_policy" "ec2_policy" {
  name = var.policy_name
  role = aws_iam_role.jenkins_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
     {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
     }
  ]
}
EOF
}