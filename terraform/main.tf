# ==============================================================================
# Terraform Main Configuration
# Project: Automated Web Deployment on AWS
# ==============================================================================
# Sprint 1: Provisions VPC, Subnets, Internet Gateway, and Route Tables.
# Sprint 2: Provisions Security Groups and Dev/Prod EC2 instances.
# ==============================================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider and resources will be added in Sprint 1
