variable "grafana_iam_role_arn" {
  type        = string
  description = ""
}

variable "bucket_name" {
  type        = string
  description = "Name for the Grafana S3 bucket"
}

variable "bucket_tags" {
  type        = map(string)
  description = "Tags to apply to the Grafana S3 bucket"
}
