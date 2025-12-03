# 1. Deploy an S3 storage bucket 
resource "aws_s3_bucket" "grafana_backups" {
  bucket = "mate-bucket-end"

  tags = {
    Name = "grafana-storage-bucket"
  }
}

# 2. Confugure bucket policy to allow grafana iam role to use storage 
data "aws_iam_policy_document" "grafana_bucket_policy" {
  statement {
    sid = "AllowListBucket"

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.grafana_backups.arn
    ]
  }

  statement {
    sid = "AllowGetPutObjects"

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.grafana_backups.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "grafana_bucket_policy" {
  bucket = aws_s3_bucket.grafana_backups.bucket
  policy = data.aws_iam_policy_document.grafana_bucket_policy.json
}
