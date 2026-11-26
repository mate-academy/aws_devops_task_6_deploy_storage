resource "aws_s3_bucket" "grafana_backups" {
  bucket = "grafana-backups-492133190367"

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

data "aws_iam_policy_document" "grafana_s3" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.grafana_backups.arn]
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

    resources = ["${aws_s3_bucket.grafana_backups.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "grafana_backups" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.grafana_s3.json
}
