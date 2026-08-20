
data "aws_caller_identity" "current" {}


resource "aws_s3_bucket" "grafana_backups" {
  bucket = "grafana-backups-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "grafana-backups"
  }
}


data "aws_iam_policy_document" "grafana_s3_policy" {

  statement {
    sid    = "AllowListBucket"
    effect = "Allow"

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
    sid    = "AllowGetPutObject"
    effect = "Allow"

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

resource "aws_s3_bucket_policy" "grafana_backups" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.grafana_s3_policy.json
}