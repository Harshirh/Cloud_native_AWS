resource "aws_cloudwatch_log_group" "application" {
  name              = var.application_log_group_name
  retention_in_days = var.log_retention_days

  tags = {
    Name = "${var.project_name}-application-logs"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-cpu-over-80-percent"
  alarm_description   = "EC2 average CPU utilization exceeded 80% for one basic-monitoring 5-minute period."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.application.id
  }
}

resource "aws_cloudwatch_metric_alarm" "instance_status_check" {
  alarm_name          = "${var.project_name}-ec2-status-check-failed"
  alarm_description   = "An EC2 system or instance status check is failing."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Maximum"
  threshold           = 0
  treat_missing_data  = "missing"

  dimensions = {
    InstanceId = aws_instance.application.id
  }
}
