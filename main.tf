resource "aws_s3_bucket" "backups_bucket" {
  bucket = var.bucket_name

  tags = var.bucket_tags
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.backups_bucket.id
  policy = data.aws_iam_policy_document.policy-document.json
}

data "aws_iam_policy_document" "policy-document" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.backups_bucket.arn
    ]
  }

  statement {
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
      "${aws_s3_bucket.backups_bucket.arn}/*"
    ]
  }
}
