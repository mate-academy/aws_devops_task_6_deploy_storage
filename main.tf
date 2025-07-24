# 1. Deploy an S3 storage bucket 

resource "aws_s3_bucket" "mb" {
  bucket = "my-tf-test-bucket-mate"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
# 2. Confugure bucket policy to allow grafana iam role to use storage 


data "aws_iam_policy_document" "grafana_s3_access" {
  statement {
    sid = "AllowListBucket"
    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.mb.arn,
    ]
  }

  statement {
    sid = "AllowGetPutObjects"
    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.mb.arn}/*",
    ]
  }
}


resource "aws_s3_bucket_policy" "grafana" {
  bucket = aws_s3_bucket.mb.id
  policy = data.aws_iam_policy_document.grafana_s3_access.json
}
