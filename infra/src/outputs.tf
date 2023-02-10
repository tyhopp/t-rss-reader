output "t-rss-reader-handler-api-invoke-url" {
  description = "URL that can be invoked to test that the resources work."
  value       = "https://${aws_apigatewayv2_api.t-rss-reader-handler-api.id}.execute-api.ap-southeast-1.amazonaws.com/default/feeds"
}
