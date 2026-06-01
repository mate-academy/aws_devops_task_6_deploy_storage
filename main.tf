resource "aws_s3_bucket" "this" {
  bucket = "mate-grafana-bucket"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    principals {
      identifiers = [var.grafana_iam_role_arn]
      type        = "AWS"
    }

    sid = "ListBucket"
    actions = [
      "s3:ListBucket"
    ]
    resources = [aws_s3_bucket.this.arn]
  }

  statement {
    principals {
      identifiers = [var.grafana_iam_role_arn]
      type        = "AWS"
    }

    sid = "GetPutObjects"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.this.arn}/*"]
  }
}
