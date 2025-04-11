output "bucket_name" {
    value = aws_s3_bucket.grafana_bucket
    sensitive = false
}
