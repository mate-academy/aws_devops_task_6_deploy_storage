output "bucket_name" {
  value     = aws_s3_bucket_policy.grafana_backups_policy
  sensitive = false
}
