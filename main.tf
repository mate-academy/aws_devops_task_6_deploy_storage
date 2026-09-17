# 1. Deploy an S3 storage bucket 

# 2. Confugure bucket policy to allow grafana iam role to use storage 

resource "aws_s3_bucket" "grafana_backups" {
  bucket = "mate-task6-tf-bucket"

  tags = {
    Name = "My bucket"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.grafana_policy.json
}

data "aws_iam_policy_document" "grafana_policy" {
  statement {
    principals {
      type = "AWS"

      identifiers = [
        var.grafana_iam_role_arn
      ]
    }

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.grafana_backups.bucket}",
    ]
  }

  statement {

    principals {
      type = "AWS"

      identifiers = [
        var.grafana_iam_role_arn
      ]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.grafana_backups.bucket}/*",
    ]

  }

}