#### NETWORK
locals {
    az = "${var.aws_region}a"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = local.az
  tags = {
    Name = "Default subnet for ${local.az}"
  }
}

## SG
resource "aws_security_group" "tools" {
  name        = "tools"
  vpc_id      = aws_default_vpc.default.id
  description = "Tools traffic"
}

# SG Rule egress
resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tools.id
}

# SG Rule ingress
resource "aws_security_group_rule" "allow_private_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = concat(["${trim(data.http.my_ip.body, "\n")}/32"], var.additional_ips)
  security_group_id = aws_security_group.tools.id
}

# SG Rule ingress
resource "aws_security_group_rule" "allow_private_jenkins" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = concat(["${trim(data.http.my_ip.body, "\n")}/32"], var.additional_ips)
  security_group_id = aws_security_group.tools.id
}

# SG Rule ingress
resource "aws_security_group_rule" "allow_private_jenkins_80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = concat(["${trim(data.http.my_ip.body, "\n")}/32"], var.additional_ips)
  security_group_id = aws_security_group.tools.id
}

#### SSH KEYS
resource "tls_private_key" "default" {
  algorithm = "RSA"
}

resource "aws_key_pair" "generated" {
  key_name   = "deployer-key"
  public_key = tls_private_key.default.public_key_openssh
}

resource "local_file" "public_key_openssh" {
  content  = tls_private_key.default.public_key_openssh
  filename = "${path.module}/id_rsa.pub"
}

resource "local_sensitive_file" "private_key_pem" {
  content         = tls_private_key.default.private_key_pem
  filename        = "${path.module}/id_rsa"
  file_permission = "0600"
}

#### EC2
resource "aws_instance" "tools" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.tools.id]
  key_name               = aws_key_pair.generated.key_name
  user_data              = file("${path.module}/files/install-tools.sh")
  iam_instance_profile   = aws_iam_instance_profile.tools.name

  tags = {
    Name = "ToolsCICD"
  }
}

# Could use a dedicated for long-term persistence
# resource "aws_ebs_volume" "tools" {
#     // Here , We need to give same AZ as the Instance Have.
#     availability_zone = aws_instance.tools.availability_zone
#     // Size IN GiB
#     size = 10
#     tags = {
#         Name = "tools"
#     }
# }

# resource "aws_volume_attachment" "ebs" {
#     device_name = "/dev/sdh"
#     volume_id = aws_ebs_volume.tools.id
#     instance_id = aws_instance.tools.id
# }

resource "aws_iam_instance_profile" "tools" {
  name = "tools"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name                = "tools"
  path                = "/"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]

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
