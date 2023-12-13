terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Create a new VPC with an internet gateway and a custom route table
resource "aws_vpc" "clcm35504finalexam" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "clcm35504finalexam_igw" {
  vpc_id = aws_vpc.clcm35504finalexam.id
}

resource "aws_route_table" "custom_route_table" {
  vpc_id = aws_vpc.clcm35504finalexam.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.clcm35504finalexam_igw.id
  }
}

# Create a new public subnet in the specified VPC
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.clcm35504finalexam.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a" # Change the availability zone if needed
  map_public_ip_on_launch = true
}

# Set the custom route table as the main route table for the VPC
resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.clcm35504finalexam.id
  route_table_id = aws_route_table.custom_route_table.id
}


# Create a new security group
resource "aws_security_group" "allow-http-ssh-8080" {
  name_prefix = "allow-http-ssh-8080-"
  vpc_id      = aws_vpc.clcm35504finalexam.id
  

  # Inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic from anywhere
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic on port 8080 from anywhere
  }

   # Outbound rule allowing all traffic to all ports with destination 0.0.0.0/0
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "JohnpaulCLCM3504FinalExam" {
  ami           = "ami-05c13eab67c5d8861" # Specify the AMI ID of the desired Linux distribution
  instance_type = "t2.micro" # Set your desired instance type here
  key_name      = "jplinuxkey" # Specify the name of your existing key pair
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow-http-ssh-8080.id] # Reference the security group ID here
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd docker

              systemctl start docker
              systemctl enable docker

              usermod -aG docker ec2-user
              EOF

  tags = {
    Name = "JohnpaulCLCM3504FinalExam"
  }
}