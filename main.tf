# 1. Deploy an S3 storage bucket
resource "aws_s3_bucket" "grafana_backups" {
  bucket = "grafana-backups-andr1yk"
  tags = {
    Name = "grafana-backups"
  }
}

# 2. Configure bucket policy to allow grafana iam role to use storage
data "aws_iam_policy_document" "grafana_backup_policy" {
  statement {
    sid       = "AllowListBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.grafana_backups.arn]

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }
  }

  statement {
    sid       = "AllowGetPutObjects"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.grafana_backups.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "grafana_backups_policy" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.grafana_backup_policy.json
}
