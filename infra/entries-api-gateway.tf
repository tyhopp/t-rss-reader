resource "aws_apigatewayv2_api" "t-rss-reader-entries-handler-api" {
  name          = "t-rss-reader-entries-handler-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins     = var.t-rss-reader-allow-origins
    allow_methods     = ["POST"]
    allow_headers     = ["content-type", "authorization"]
    allow_credentials = true
  }
}

resource "aws_cloudwatch_log_group" "t-rss-reader-entries-handler-api-log-group" {
  name              = "/aws/t-rss-reader-entries-handler-api-log-group/${aws_apigatewayv2_api.t-rss-reader-entries-handler-api.name}"
  retention_in_days = 30
}

resource "aws_apigatewayv2_stage" "t-rss-reader-entries-handler-api-stage" {
  api_id      = aws_apigatewayv2_api.t-rss-reader-entries-handler-api.id
  name        = "default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.t-rss-reader-entries-handler-api-log-group.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "t-rss-reader-entries-handler-api-integration" {
  api_id             = aws_apigatewayv2_api.t-rss-reader-entries-handler-api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.t-rss-reader-entries-handler.invoke_arn
}

resource "aws_apigatewayv2_route" "t-rss-reader-entries-handler-api-route-post" {
  api_id    = aws_apigatewayv2_api.t-rss-reader-entries-handler-api.id
  route_key = "POST /entries"
  target    = "integrations/${aws_apigatewayv2_integration.t-rss-reader-entries-handler-api-integration.id}"
}
