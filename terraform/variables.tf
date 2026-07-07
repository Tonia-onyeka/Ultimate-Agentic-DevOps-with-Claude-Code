variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Name of the project (used for resource naming)"
  type        = string
  default     = "portfolio-site"
}

variable "environment" {
  description = "Environment name (e.g. production, staging, dev)"
  type        = string
  default     = "production"
}

variable "domain_name" {
  description = "Custom domain name for the CloudFront distribution (optional, leave empty to use CloudFront domain)"
  type        = string
  default     = ""
}
