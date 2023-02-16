output "t-rss-reader-login-handler-invoke-url" {
  description = "Login handler invoke url"
  value       = "https://${aws_apigatewayv2_api.t-rss-reader-login-handler-api.id}.execute-api.${var.aws-region}.amazonaws.com/default/login"
}

output "t-rss-reader-feeds-handler-invoke-url" {
  description = "Feeds handler invoke url"
  value       = "https://${aws_apigatewayv2_api.t-rss-reader-feeds-handler-api.id}.execute-api.${var.aws-region}.amazonaws.com/default/feeds"
}
