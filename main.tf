resource "aws_s3_bucket" "grafana_backups" {
  bucket        = "grafana-backups-bucket-clem97121"
  force_destroy = true
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
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

resource "aws_s3_bucket_policy" "grafana_backups_policy" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}