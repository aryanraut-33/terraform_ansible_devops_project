# ==============================================================================
# Terraform Variables
# ==============================================================================

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}
variable "project_name" {
  description = "Prefix for tagging and resource names"
  type        = string
  default     = "devops-ia"
}