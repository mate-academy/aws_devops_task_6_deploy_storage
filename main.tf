resource "aws_s3_bucket" "this" {
  bucket = "mate-bucket-melnyk"

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.this.arn]

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }
  }
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
