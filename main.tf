terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.33"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "hactiv8r"

    workspaces {
      name = "hello-world"
    }
  }
}

provider "aws" {
  profile = "hactiv8r"
  region  = "af-south-1"
}

resource "aws_security_group" "server_sg" {
  name = "Nginx Security Group"

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = file("server.yml")
}

resource "aws_instance" "nginx_server" {
  ami           = "ami-0953ade692c96279b"
  instance_type = "t3.micro"
  key_name      = "server_key"
  tags = {
    Name = "Yusuf Nginx Server"
  }
  user_data                   = data.template_file.user_data.rendered
  vpc_security_group_ids      = [aws_security_group.server_sg.id]
  associate_public_ip_address = true
}