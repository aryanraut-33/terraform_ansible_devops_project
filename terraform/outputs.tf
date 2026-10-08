# ==============================================================================
# Terraform Outputs
# Project: Automated Web Deployment on AWS (DevOps IA Project)
# ==============================================================================

# ------------------------------------------------------------------------------
# Networking Outputs (Sprint 1)
# ------------------------------------------------------------------------------

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


# ------------------------------------------------------------------------------
# Compute Outputs (Sprint 2 - Crucial for Sprint 4 Ansible inventory)
# ------------------------------------------------------------------------------

output "dev_instance_id" {
  description = "The EC2 Instance ID of the Development server"
  value       = aws_instance.dev_server.id
}

output "dev_instance_public_ip" {
  description = "Public IP address of Dev server (used in Ansible inventory.ini)"
  value       = aws_instance.dev_server.public_ip
}

output "dev_website_url" {
  description = "Direct browser URL to access the Development website"
  value       = "http://${aws_instance.dev_server.public_ip}"
}

output "prod_instance_id" {
  description = "The EC2 Instance ID of the Production server"
  value       = aws_instance.prod_server.id
}

output "prod_instance_public_ip" {
  description = "Public IP address of Prod server (used in Ansible inventory.ini)"
  value       = aws_instance.prod_server.public_ip
}

output "prod_website_url" {
  description = "Direct browser URL to access the Production website"
  value       = "http://${aws_instance.prod_server.public_ip}"
}
