# 1. Deploy an S3 storage bucket 
resource "aws_s3_bucket" "grafana_backups" {
  bucket = "tf-bucket-aws-task6"

  tags = {
    Name        = "S3 bucket"
    Environment = "Dev"
  }
}

# 2. Confugure bucket policy to allow grafana iam role to use storage
resource "aws_s3_bucket_policy" "grafana_backups" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.grafana_bucket_access.json
}

data "aws_iam_policy_document" "grafana_bucket_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    actions = ["s3:ListBucket"]
    resources = [aws_s3_bucket.grafana_backups.arn]
  }

    statement {
    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    actions = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.grafana_backups.arn}/*"]
  }
}
