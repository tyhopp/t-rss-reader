resource "aws_apigatewayv2_api" "t-rss-reader-handler-api" {
  name          = "t-rss-reader-handler-api"
  protocol_type = "HTTP"
}

resource "aws_cloudwatch_log_group" "t-rss-reader-handler-api-log-group" {
  name              = "/aws/t-rss-reader-handler-api-log-group/${aws_apigatewayv2_api.t-rss-reader-handler-api.name}"
  retention_in_days = 30
}

resource "aws_apigatewayv2_stage" "t-rss-reader-handler-api-stage" {
  api_id      = aws_apigatewayv2_api.t-rss-reader-handler-api.id
  name        = "default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.t-rss-reader-handler-api-log-group.arn
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

resource "aws_apigatewayv2_integration" "t-rss-reader-handler-api-integration" {
  api_id             = aws_apigatewayv2_api.t-rss-reader-handler-api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.t-rss-reader-feeds-handler.invoke_arn
}

resource "aws_apigatewayv2_route" "t-rss-reader-handler-api-route" {
  api_id    = aws_apigatewayv2_api.t-rss-reader-handler-api.id
  route_key = "ANY /feeds"
  target    = "integrations/${aws_apigatewayv2_integration.t-rss-reader-handler-api-integration.id}"
}
