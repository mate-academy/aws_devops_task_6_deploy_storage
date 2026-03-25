resource "aws_s3_bucket" "s3" {
  bucket = "my-bucket"

  tags = {
    Name = "MateBucket"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.s3.arn,
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
      "${aws_s3_bucket.s3.arn}/*",
    ]
  }
}
