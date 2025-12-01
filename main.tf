# 1. Deploy an S3 storage bucket
resource "aws_s3_bucket" "my_grafana_backups" {
  bucket = "my-grafana-backups-data"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
# 2. Confugure bucket policy to allow grafana iam role to use storage
resource "aws_s3_bucket_policy" "grafana-access" {
  bucket = aws_s3_bucket.my_grafana_backups.id
  policy = data.aws_iam_policy_document.example.json
}
data "aws_iam_policy_document" "example" {
    statement {
        principals {
          type = "AWS"
          identifiers = [var.grafana_iam_role_arn]
        }

        actions = ["s3:ListBucket"]
        resources = ["arn:aws:s3:::${aws_s3_bucket.my_grafana_backups.bucket}"]
    }
    statement {
        principals {
          type = "AWS"
          identifiers = [var.grafana_iam_role_arn]
        }

        actions = ["s3:GetObject","s3:PutObject"]
        resources = ["arn:aws:s3:::${aws_s3_bucket.my_grafana_backups.bucket}/*"]
    }
}