resource "aws_s3_bucket" "grafana_backups" {
  bucket = "mate-aws-grafana-backup-tuts-tuts"

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

data "aws_iam_policy_document" "s3_policy" {
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
      aws_s3_bucket.grafana_backups.arn
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
      "${aws_s3_bucket.grafana_backups.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "attach_grafana_policy" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.s3_policy.json
}