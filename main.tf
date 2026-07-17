# 1. Deploy an S3 storage bucket 
resource "aws_s3_bucket" "grafana_backups" {
  bucket = "grafana-bucketand9s"

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}
# 2. Confugure bucket policy to allow grafana iam role to use storage 
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    sid = "ReadWriteBucket"
    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.grafana_backups.arn}/*",
    ]
  }
  statement {
    sid = "ListBucket"
    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "${aws_s3_bucket.grafana_backups.arn}",
    ]
  }
}

