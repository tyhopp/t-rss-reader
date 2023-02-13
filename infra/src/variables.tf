variable "t-rss-reader-password" {
  description = "The password to use for authenticating requests"
  type = string
  sensitive = true
  nullable = false
}

variable "aws-region" {
  description = "AWS region for all resources"
  type        = string
  default     = "ap-southeast-1"
}
