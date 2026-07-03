resource "aws_s3_bucket" "grafana_backups" {
  bucket = "mate-aws-grafana-backups-779403607840"

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

data "aws_iam_policy_document" "grafana_backups" {
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
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.grafana_backups.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "grafana_backups" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.grafana_backups.json
}
