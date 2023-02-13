output "t-rss-reader-invoke-url" {
  description = "Invoke url"
  value       = "https://${aws_apigatewayv2_api.t-rss-reader-feeds-handler-api.id}.execute-api.${var.aws-region}.amazonaws.com/default"
}
