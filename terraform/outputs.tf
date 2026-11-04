output "aws_region" {
  description = "AWS region used by this deployment."
  value       = var.aws_region
}

output "instance_id" {
  description = "EC2 instance ID; select this instance for Session Manager access."
  value       = aws_instance.application.id
}

output "instance_public_ip" {
  description = "Public IP address for website access."
  value       = aws_instance.application.public_ip
}

output "website_url" {
  description = "HTTP URL for the E-Commerce website."
  value       = "http://${aws_instance.application.public_ip}"
}

output "application_log_group" {
  description = "Preserved CloudWatch Logs group; container output uses Docker's local logging driver."
  value       = aws_cloudwatch_log_group.application.name
}

output "instance_type_free_tier_notice" {
  description = "Reminder to verify account-specific Free Tier/Free Plan eligibility and remaining usage before apply."
  value       = "Configured instance type: t3.micro. Verify eligibility, credits, and usage in AWS Billing > Free Tier before applying."
}
