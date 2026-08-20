output "bucket_name" {
  value       = aws_s3_bucket.grafana_backups.bucket
  sensitive   = false
  description = "Name of the S3 bucket for Grafana backups"
}

output "bucket_arn" {
  value       = aws_s3_bucket.grafana_backups.arn
  sensitive   = false
  description = "ARN of the S3 bucket"
}

output "grafana_iam_role_arn" {
  value       = var.grafana_iam_role_arn
  sensitive   = false
  description = "ARN of the Grafana IAM role"
}
