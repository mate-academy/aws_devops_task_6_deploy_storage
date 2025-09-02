output "bucket_name" {
  value     = aws_s3_bucket.grafana-backups.bucket
  sensitive = false
}
