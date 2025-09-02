output "s3_bucket_name" {
  description = "Name of the S3 bucket for Grafana backups"
  value       = aws_s3_bucket.backups.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket for Grafana backups"
  value       = aws_s3_bucket.backups.arn
}
