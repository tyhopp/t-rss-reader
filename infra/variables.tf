variable "t-rss-reader-password" {
  description = "The password to use for authenticating requests"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "t-rss-reader-allow-origins" {
  description = "The allowed origins for CORS"
  type        = list(string)
  default     = ["http://localhost:8000"]
}

variable "aws-access-key" {
  description = "Public key for accessing AWS resources"
  type        = string
  nullable    = false
}

variable "aws-secret-access-key" {
  description = "Secret key for accessing AWS resources"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "aws-region" {
  description = "AWS region for all resources"
  type        = string
  default     = "ap-southeast-1"
}
