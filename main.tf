resource "random_id" "suffix" {
  byte_length = 4
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "backups" {
  bucket        = "grafana-backups-${data.aws_caller_identity.current.account_id}-${random_id.suffix.hex}"
  force_destroy = true
}

data "aws_iam_policy_document" "bucket" {
  statement {
    sid     = "AllowListBucketFromGrafanaRole"
    effect  = "Allow"
    actions = ["s3:ListBucket"]

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    resources = [aws_s3_bucket.backups.arn]
  }

  statement {
    sid     = "AllowObjectReadWriteFromGrafanaRole"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:PutObject"]

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    resources = ["${aws_s3_bucket.backups.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.backups.id
  policy = data.aws_iam_policy_document.bucket.json
}
