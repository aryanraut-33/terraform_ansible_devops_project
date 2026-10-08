# ==============================================================================
# Terraform Main Configuration
# Project: Automated Web Deployment on AWS (DevOps IA Project)
# ==============================================================================
# This file defines all AWS infrastructure resources.
#
# Sprint 1 (Current): Networking — VPC, Subnets, Internet Gateway, Route Table
# Sprint 2 (Next):    Compute   — Security Group, EC2 Instances (Dev & Prod)
# ==============================================================================


# ------------------------------------------------------------------------------
# TERRAFORM SETTINGS
# ------------------------------------------------------------------------------
# Specifies the minimum Terraform version and the required AWS provider plugin.
# The AWS provider allows Terraform to communicate with the AWS API.
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
# Configures the AWS provider with the deployment region.
# Terraform uses the credentials from ~/.aws/credentials (set via 'aws configure')
# automatically — no need to hardcode keys here.
# ------------------------------------------------------------------------------
provider "aws" {
  region = var.aws_region
}


# ==============================================================================
# 1. VPC (Virtual Private Cloud)
# ==============================================================================
# The VPC is an isolated virtual network within AWS where all our resources live.
# CIDR 10.0.0.0/16 gives us 65,536 available private IP addresses.
# enable_dns_support and enable_dns_hostnames allow EC2 instances to resolve
# domain names and receive public DNS hostnames.
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
# Subnets divide the VPC into smaller network segments.
# Each environment (Dev, Prod) gets its own subnet.
# map_public_ip_on_launch = true ensures that any EC2 instance launched in
# these subnets automatically receives a public IP address.
# ==============================================================================

# --- Dev Subnet (10.0.1.0/24 = 256 IPs) ---
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

# --- Prod Subnet (10.0.2.0/24 = 256 IPs) ---
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
# The Internet Gateway enables communication between resources inside the VPC
# and the public internet. Without this, our EC2 instances would have no
# internet connectivity — meaning no SSH access, no HTTP traffic, and Ansible
# would not be able to reach them.
# ==============================================================================
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-igw"
    Project = var.project_name
  }
}


# ==============================================================================
# 4. ROUTE TABLE
# ==============================================================================
# A Route Table contains rules (routes) that determine where network traffic
# is directed. We create a single public route table with a default route
# (0.0.0.0/0) pointing to the Internet Gateway.
#
# 0.0.0.0/0 means "all traffic not matching any other route" — essentially,
# any traffic destined for the internet goes through the IGW.
# ==============================================================================
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  # Default route: send all internet-bound traffic to the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name    = "${var.project_name}-public-rt"
    Project = var.project_name
  }
}


# ==============================================================================
# 5. ROUTE TABLE ASSOCIATIONS
# ==============================================================================
# Associate both subnets with the public route table so that instances in
# these subnets can access the internet via the Internet Gateway.
# Without these associations, the subnets would use the VPC's default
# (private) route table, which has no internet route.
# ==============================================================================

# --- Associate Dev Subnet with Public Route Table ---
resource "aws_route_table_association" "dev_rta" {
  subnet_id      = aws_subnet.dev_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# --- Associate Prod Subnet with Public Route Table ---
resource "aws_route_table_association" "prod_rta" {
  subnet_id      = aws_subnet.prod_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
