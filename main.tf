# 1. Deploy an S3 storage bucket 
resource "aws_s3_bucket" "grafana-backups" {
  bucket = "s3bucketformatetask6"
}

# 2. Confugure bucket policy to allow grafana iam role to use storage 
resource "aws_s3_bucket_policy" "grafana-backups-bucket-policy" {
  bucket = aws_s3_bucket.grafana-backups.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.grafana-backups.arn,
    ]
  }
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.grafana-backups.arn,
      "${aws_s3_bucket.grafana-backups.arn}/*",
    ]
  }
}
