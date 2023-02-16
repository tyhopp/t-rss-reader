resource "aws_lambda_function" "t-rss-reader-login-handler" {
  filename         = "./login-handler/login-handler.zip"
  function_name    = "t-rss-reader-login-handler"
  role             = aws_iam_role.t-rss-reader-login-handler-iam-role.arn
  handler          = "./dist/index.handler"
  source_code_hash = filebase64sha256("./login-handler/login-handler.zip")
  runtime          = "nodejs18.x"
  environment {
    variables = {
      T_RSS_READER_PASSWORD = var.t-rss-reader-password
    }
  }
}

resource "aws_cloudwatch_log_group" "t-rss-reader-login-handler-log-group" {
  name              = "/aws/lambda/${aws_lambda_function.t-rss-reader-login-handler.function_name}"
  retention_in_days = 30
}

resource "aws_iam_role" "t-rss-reader-login-handler-iam-role" {
  name = "t-rss-reader-login-handler-iam"
  assume_role_policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Action" = "sts:AssumeRole"
        "Effect" = "Allow"
        "Sid"    = ""
        "Principal" = {
          "Service" = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "t-rss-reader-login-handler-iam-policy" {
  name = "t-rss-reader-login-handler-iam-policy"
  role = aws_iam_role.t-rss-reader-login-handler-iam-role.id
  policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect"   = "Allow",
        "Action"   = "logs:CreateLogGroup",
        "Resource" = "*"
      },
      {
        "Effect" = "Allow",
        "Action" = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" = [
          "arn:aws:logs:${var.aws-region}:${data.aws_caller_identity.current.account_id}:*"
        ]
      }
    ]
  })
}

resource "aws_lambda_permission" "t-rss-reader-login-handler-permission-api" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.t-rss-reader-login-handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.t-rss-reader-login-handler-api.execution_arn}/*/*"
}
