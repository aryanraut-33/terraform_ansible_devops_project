# ==============================================================================
# Terraform Variables
# Project: Automated Web Deployment on AWS (DevOps IA Project)
# ==============================================================================

# ------------------------------------------------------------------------------
# General Settings
# ------------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region where all resources will be deployed"
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "Prefix used for naming and tagging all resources"
  type        = string
  default     = "devops-ia"
}


# ------------------------------------------------------------------------------
# Networking (Sprint 1)
# ------------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dev_subnet_cidr" {
  description = "CIDR block for the Dev public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "prod_subnet_cidr" {
  description = "CIDR block for the Prod public subnet"
  type        = string
  default     = "10.0.2.0/24"
}


# ------------------------------------------------------------------------------
# Compute Settings (Sprint 2)
# ------------------------------------------------------------------------------

variable "instance_type" {
  description = "EC2 Instance size (t2.micro is free-tier eligible)"
  type        = string
  default     = "t3.micro"
}

variable "public_key_path" {
  description = "Path to the local SSH public key generated in Sprint 0"
  type        = string
  default     = "~/.ssh/devops_aws_key.pub"
}
