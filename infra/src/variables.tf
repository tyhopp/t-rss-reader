variable "t-rss-reader-password" {
  description = "The password to use for authenticating requests"
  type = string
  sensitive = true
  nullable = false
}

variable "t-rss-reader-origin" {
  description = "The origin to configure CORS with"
  type = string
  default = "http://localhost:8000"
}

variable "aws-region" {
  description = "AWS region for all resources"
  type        = string
  default     = "ap-southeast-1"
}
