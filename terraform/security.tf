resource "aws_security_group" "application" {
  name        = "${var.project_name}-http-only"
  description = "Public HTTP for the website; administration uses Systems Manager, not SSH."
  vpc_id      = aws_vpc.application.id

  ingress {
    description = "Public E-Commerce website"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTPS for Docker Hub, Supabase, package repositories, and Systems Manager"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-security-group"
  }
}
