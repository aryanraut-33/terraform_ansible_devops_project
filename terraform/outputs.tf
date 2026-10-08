# ==============================================================================
# Terraform Outputs
# Project: Automated Web Deployment on AWS (DevOps IA Project)
# ==============================================================================
# Outputs display useful metadata once 'terraform apply' succeeds.
# These networking IDs verify our setup and will be referenced in Sprint 2.
# ==============================================================================

output "vpc_id" {
  description = "The ID of the created Virtual Private Cloud (VPC)"
  value       = aws_vpc.main.id
}

output "dev_subnet_id" {
  description = "The Subnet ID designated for the Development environment"
  value       = aws_subnet.dev_subnet.id
}

output "prod_subnet_id" {
  description = "The Subnet ID designated for the Production environment"
  value       = aws_subnet.prod_subnet.id
}

output "internet_gateway_id" {
  description = "The ID of the attached Internet Gateway"
  value       = aws_internet_gateway.main_igw.id
}
