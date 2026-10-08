# ==============================================================================
# Terraform Variables
# Project: Automated Web Deployment on AWS (DevOps IA Project)
# ==============================================================================
# Variables make the configuration reusable and flexible.
# Default values are provided so 'terraform apply' works without extra flags.
# To override, use: terraform apply -var="aws_region=ap-south-1"
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
# Networking — VPC & Subnet CIDRs (Sprint 1)
# ------------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR block for the VPC (e.g., 10.0.0.0/16 = 65,536 IPs)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dev_subnet_cidr" {
  description = "CIDR block for the Dev public subnet (e.g., 10.0.1.0/24 = 256 IPs)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "prod_subnet_cidr" {
  description = "CIDR block for the Prod public subnet (e.g., 10.0.2.0/24 = 256 IPs)"
  type        = string
  default     = "10.0.2.0/24"
}
