output "bucket_name" {
    value = aws_s3_bucket.my_grafana_backups.bucket
    sensitive = false
}
