output "bucket_name" {
  description = "Name of the S3 bucket used for Grafana backups."
  value       = aws_s3_bucket.grafana_backups.bucket
  sensitive   = false
}
