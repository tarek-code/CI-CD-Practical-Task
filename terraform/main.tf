terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.13.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.aws_region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "ci_ephemeral" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = "Jenkins"
  subnet_id                   = "subnet-0474b78b9419670f8"
  tags = {
    Name     = "ci-ephemeral"
    lifespan = "ephemeral"
    owner    = "jenkins"
  }
}

# Store Public IP in SSM Parameter Store
resource "aws_ssm_parameter" "ci_ephemeral_ip" {
  name  = "/jenkins/ci_ephemeral_ip"
  type  = "String"
  value = aws_instance.ci_ephemeral.public_ip
}
