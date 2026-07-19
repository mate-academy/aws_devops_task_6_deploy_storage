# 1. Deploy an S3 storage bucket 
resource "aws_s3_bucket" "grafana_backups" {
  bucket = "grafana-backups-bucket-aws-ma-task"

}


# 2. Confugure bucket policy to allow grafana iam role to use storage
resource "aws_s3_bucket_policy" "authorize_grafana" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.authorize_grafana.json
}


data "aws_iam_policy_document" "authorize_grafana" {
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
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.grafana_backups.arn}/*",
    ]
  }
}