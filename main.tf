resource "aws_s3_bucket" "grafana_backups" {
  bucket = "devops-task-6-storage-bucket"
}

resource "aws_s3_bucket_policy" "grafana_backups_policy" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.grafana_backups_policy.json
}

data "aws_iam_policy_document" "grafana_backups_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["${var.grafana_iam_role_arn}"]
    }

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.grafana_backups.arn,
      "${aws_s3_bucket.grafana_backups.arn}/*",
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = ["${var.grafana_iam_role_arn}"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.grafana_backups.arn,
      "${aws_s3_bucket.grafana_backups.arn}/*",
    ]
  }
}
