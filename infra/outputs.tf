output "t-rss-reader-login-handler-invoke-url" {
  description = "Login handler invoke url"
  value       = "https://${aws_apigatewayv2_api.t-rss-reader-login-handler-api.id}.execute-api.${var.aws-region}.amazonaws.com/default/login"
}

output "t-rss-reader-feeds-handler-invoke-url" {
  description = "Feeds handler invoke url"
  value       = "https://${aws_apigatewayv2_api.t-rss-reader-feeds-handler-api.id}.execute-api.${var.aws-region}.amazonaws.com/default/feeds"
}

output "t-rss-reader-entries-handler-invoke-url" {
  description = "Entries handler invoke url"
  value       = "https://${aws_apigatewayv2_api.t-rss-reader-entries-handler-api.id}.execute-api.${var.aws-region}.amazonaws.com/default/entries"
}

output "t-rss-reader-last-access-handler-invoke-url" {
  description = "Last access handler invoke url"
  value       = "https://${aws_apigatewayv2_api.t-rss-reader-last-access-handler-api.id}.execute-api.${var.aws-region}.amazonaws.com/default/last-access"
}
