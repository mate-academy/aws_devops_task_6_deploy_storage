# 1. Deploy an S3 storage bucket 

# 2. Confugure bucket policy to allow grafana iam role to use storage 


# ---------- helpers for unique bucket name ----------
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# 1) Deploy an S3 storage bucket
resource "aws_s3_bucket" "grafana_backups" {
  # S3 bucket name must be globally unique
  bucket        = "mate-aws-grafana-backups-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  force_destroy = true

  tags = {
    Name = "mate-aws-grafana-backups"
  }
}

# 2) Configure bucket policy to allow grafana iam role to use storage
data "aws_iam_policy_document" "grafana_backups_policy" {
  # Statement 1: allow ListBucket
  statement {
    sid    = "AllowGrafanaListBucket"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.grafana_backups.arn]
  }

  # Statement 2: allow GetObject + PutObject on all objects
  statement {
    sid    = "AllowGrafanaGetPutObject"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    actions = ["s3:GetObject", "s3:PutObject"]
    resources = [
      "${aws_s3_bucket.grafana_backups.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "grafana_backups" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.grafana_backups_policy.json
}
