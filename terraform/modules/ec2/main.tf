data "aws_ami" "main" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

resource "aws_instance" "main" {
  ami                         = data.aws_ami.main.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.main.id]
  subnet_id                   = var.public_subnet_id

  user_data = <<-EOF
    #!/usr/bin/env bash
    sudo yum update -y
    sudo amazon-linux-extras enable nginx1
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

    sudo yum upgrade -y
    sudo yum install -y java-17-amazon-corretto-headless
    sudo yum install -y jenkins docker nginx

    sudo systemctl start docker
    sudo systemctl start jenkins
    sudo systemctl start nginx
    sudo systemctl enable docker
    sudo systemctl enable jenkins
    sudo systemctl enable nginx
  EOF

  tags = {
    Name = "${var.domain}-instance"
  }
}

resource "aws_eip" "main" {
  instance = aws_instance.main.id
  domain   = "vpc"

  tags = {
    Name = "${var.domain}-instance-eip"
  }
}

resource "aws_security_group" "main" {
  name   = "${var.domain}-instance-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "main-ingress-ssh" {
  security_group_id = aws_security_group.main.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "main-ingress-http" {
  security_group_id = aws_security_group.main.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "main-egress" {
  security_group_id = aws_security_group.main.id
  type              = "egress"
  protocol          = "all"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
