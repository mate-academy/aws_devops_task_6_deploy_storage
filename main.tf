# 1. Deploy an S3 storage bucket
resource "aws_s3_bucket" "grafana_bucket" {
  bucket = "grafana-storage-bucket"
  tags = {
    Name        = "GrafanaStorage"
    Environment = "Production"
  }
}

# 2. Configure bucket policy to allow Grafana IAM role to use storage

data "aws_iam_policy_document" "grafana_policy_document" {
  statement {
    sid = "AllowListBucket"
    actions = ["s3:ListBucket"]
    resources = [aws_s3_bucket.grafana_bucket.arn]

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::069874459391:role/t2_micro-role"]
    }
  }

  statement {
    sid = "AllowGetPutObjects"
    actions = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.grafana_bucket.arn}/*"]

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::069874459391:role/t2_micro-role"]
    }
  }
}

resource "aws_s3_bucket_policy" "grafana_bucket_policy" {
  bucket = aws_s3_bucket.grafana_bucket.id
  policy = data.aws_iam_policy_document.grafana_policy_document.json
}
# 1. Deploy an S3 storage bucket

# 2. Confugure bucket policy to allow grafana iam role to use storage 
