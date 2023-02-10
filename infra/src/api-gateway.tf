resource "aws_apigatewayv2_api" "t-rss-reader-handler-api" {
  name          = "t-rss-reader-handler-api"
  protocol_type = "HTTP"
}
