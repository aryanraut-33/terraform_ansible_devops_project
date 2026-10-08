# ==============================================================================
# Terraform Main Configuration
# Project: Automated Web Deployment on AWS (DevOps IA Project)
# ==============================================================================
# Sprint 1: Networking — VPC, Subnets, Internet Gateway, Route Tables
# Sprint 2 (Current): Compute — Key Pair, Security Group, Dev & Prod EC2s
# OS: Amazon Linux 2023 (Default SSH User: ec2-user)
# ==============================================================================


# ------------------------------------------------------------------------------
# TERRAFORM SETTINGS
# ------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# ------------------------------------------------------------------------------
# AWS PROVIDER
# ------------------------------------------------------------------------------
provider "aws" {
  region = var.aws_region
}


# ==============================================================================
# 1. VPC (Virtual Private Cloud)
# ==============================================================================
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.project_name}-vpc"
    Project = var.project_name
  }
}


# ==============================================================================
# 2. PUBLIC SUBNETS (Dev and Prod)
# ==============================================================================

# --- Dev Subnet (ap-southeast-2a) ---
resource "aws_subnet" "dev_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.dev_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name        = "${var.project_name}-dev-subnet"
    Project     = var.project_name
    Environment = "dev"
  }
}

# --- Prod Subnet (ap-southeast-2b) ---
resource "aws_subnet" "prod_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.prod_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}b"

  tags = {
    Name        = "${var.project_name}-prod-subnet"
    Project     = var.project_name
    Environment = "prod"
  }
}


# ==============================================================================
# 3. INTERNET GATEWAY (IGW)
# ==============================================================================
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-igw"
    Project = var.project_name
  }
}


# ==============================================================================
# 4. ROUTE TABLE & ASSOCIATIONS
# ==============================================================================
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name    = "${var.project_name}-public-rt"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "dev_rta" {
  subnet_id      = aws_subnet.dev_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "prod_rta" {
  subnet_id      = aws_subnet.prod_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


# ==============================================================================
# 5. SSH KEY PAIR (Sprint 2)
# ==============================================================================
resource "aws_key_pair" "devops_key" {
  key_name   = "${var.project_name}-key"
  public_key = file(pathexpand(var.public_key_path))

  tags = {
    Name    = "${var.project_name}-key"
    Project = var.project_name
  }
}


# ==============================================================================
# 6. SECURITY GROUP (Sprint 2)
# ==============================================================================
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Allow inbound SSH (port 22) and HTTP (port 80) traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP web traffic from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-web-sg"
    Project = var.project_name
  }
}


# ==============================================================================
# 7. AMAZON LINUX 2023 AMI DATA SOURCE (Sprint 2)
# ==============================================================================
# Dynamically queries AWS to find the latest official Amazon Linux 2023 AMI (AL2023).
# Owner: "amazon" (official AWS AMI)
# Default SSH user for this image is "ec2-user"
# ==============================================================================
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# ==============================================================================
# 8. EC2 INSTANCES (Dev & Prod) (Sprint 2)
# ==============================================================================

# --- Development Server ---
resource "aws_instance" "dev_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.dev_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.devops_key.key_name

  tags = {
    Name        = "${var.project_name}-dev-server"
    Project     = var.project_name
    Environment = "dev"
  }
}

# --- Production Server ---
resource "aws_instance" "prod_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.prod_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.devops_key.key_name

  tags = {
    Name        = "${var.project_name}-prod-server"
    Project     = var.project_name
    Environment = "prod"
  }
}
