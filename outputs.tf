output "bucket_name" {
    value = aws_s3_bucket.mate-grafana-bucket.bucket
    sensitive = false
}
