# 1. Створення S3 бакета (сховища)
resource "aws_s3_bucket" "grafana_backups" {
  bucket        = "mate-grafana-backup-danylopovar-12345"
  force_destroy = true
}

# 2. Створення документа з правилами доступу (IAM Policy Document)
data "aws_iam_policy_document" "bucket_policy" {

  # Перше правило: Дозвіл на перегляд вмісту бакета
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.grafana_backups.arn]

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }
  }

  # Друге правило: Дозвіл на завантаження та читання файлів
  statement {
    actions   = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.grafana_backups.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }
  }
}

# 3. Прив'язка створеної політики безпосередньо до нашого бакета
resource "aws_s3_bucket_policy" "grafana_backups" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}