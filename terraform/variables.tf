variable "aws_region" {
  description = "Deployment region. This project is intentionally restricted to US East (N. Virginia)."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = var.aws_region == "us-east-1"
    error_message = "This project must be deployed in us-east-1."
  }
}

variable "project_name" {
  description = "Prefix used for resource names and tags."
  type        = string
  default     = "ecommerce-cloudnative"
}

variable "app_image" {
  description = "Public Docker Hub image to deploy."
  type        = string
  default     = "harshithreddy382/ecommerce-app:latest"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the project VPC."
  type        = string
  default     = "10.40.0.0/16"
}

variable "public_subnet_cidr" {
  description = "IPv4 CIDR block for the single public subnet."
  type        = string
  default     = "10.40.1.0/24"
}

variable "availability_zone" {
  description = "Availability Zone for the public subnet and EC2 instance."
  type        = string
  default     = "us-east-1a"
}

variable "root_volume_size_gib" {
  description = "Encrypted gp3 root volume size. Verify this against the EBS allowance in your Billing/Free Tier console."
  type        = number
  default     = 12

  validation {
    condition     = var.root_volume_size_gib >= 8
    error_message = "The root volume must be at least 8 GiB for this deployment."
  }
}

variable "application_log_group_name" {
  description = "Name of the preserved CloudWatch Logs group; the container uses Docker's local logging driver."
  type        = string
  default     = "/ecommerce/application"
}

variable "log_retention_days" {
  description = "Number of days to retain application logs."
  type        = number
  default     = 7

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days)
    error_message = "Choose a supported CloudWatch Logs retention period."
  }
}

variable "common_tags" {
  description = "Tags applied to supported AWS resources."
  type        = map(string)
  default = {
    Project   = "ecommerce-cloudnative"
    ManagedBy = "Terraform"
  }
}
