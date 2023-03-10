resource "aws_apigatewayv2_api" "t-rss-reader-login-handler-api" {
  name          = "t-rss-reader-login-handler-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins     = var.t-rss-reader-allow-origins
    allow_methods     = ["POST"]
    allow_headers     = ["content-type", "authorization"]
    allow_credentials = true
    max_age           = 7200
  }
}

resource "aws_cloudwatch_log_group" "t-rss-reader-login-handler-api-log-group" {
  name              = "/aws/t-rss-reader-login-handler-api-log-group/${aws_apigatewayv2_api.t-rss-reader-login-handler-api.name}"
  retention_in_days = 30
}

resource "aws_apigatewayv2_stage" "t-rss-reader-login-handler-api-stage" {
  api_id      = aws_apigatewayv2_api.t-rss-reader-login-handler-api.id
  name        = "default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.t-rss-reader-login-handler-api-log-group.arn
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

resource "aws_apigatewayv2_integration" "t-rss-reader-login-handler-api-integration" {
  api_id             = aws_apigatewayv2_api.t-rss-reader-login-handler-api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.t-rss-reader-login-handler.invoke_arn
}

resource "aws_apigatewayv2_route" "t-rss-reader-login-handler-api-route" {
  api_id    = aws_apigatewayv2_api.t-rss-reader-login-handler-api.id
  route_key = "POST /login"
  target    = "integrations/${aws_apigatewayv2_integration.t-rss-reader-login-handler-api-integration.id}"
}
