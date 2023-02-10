resource "aws_lambda_function" "t-rss-reader-feeds-handler" {
  filename         = "feeds-handler.zip"
  function_name    = "t-rss-reader-feeds-handler"
  role             = aws_iam_role.t-rss-reader-handler-iam-role.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256("feeds-handler.zip")
  runtime          = "nodejs18.x"
}

resource "aws_iam_role" "t-rss-reader-handler-iam-role" {
  name = "t-rss-reader-handler-iam"
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

resource "aws_iam_role_policy" "t-rss-reader-handler-iam-policy-logs" {
  name = "t-rss-reader-handler-iam-policy-logs"
  role = aws_iam_role.t-rss-reader-handler-iam-role.id
  policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect"   = "Allow",
        "Action"   = "logs:CreateLogGroup",
        "Resource" = "arn:aws:logs:ap-southeast-1:*:*"
      },
      {
        "Effect" = "Allow",
        "Action" = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" = [
          "arn:aws:logs:ap-southeast-1:${aws_dynamodb_table.t-rss-reader-feeds-table.arn}:log-group:/aws/lambda/t-rss-reader-feeds-handler:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "t-rss-reader-handler-iam-policy-dynamodb" {
  name = "t-rss-reader-handler-iam-policy-dynamodb"
  role = aws_iam_role.t-rss-reader-handler-iam-role.id
  policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect" = "Allow",
        "Action" = [
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ],
        "Resource" = "arn:aws:dynamodb:ap-southeast-1:${aws_dynamodb_table.t-rss-reader-feeds-table.arn}:table/*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "t-rss-reader-handler-iam-policy-api" {
  name = "t-rss-reader-handler-iam-policy-api"
  role = aws_iam_role.t-rss-reader-handler-iam-role.id
  policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect" = "Allow",
        "Action" = [
          "execute-api:Invoke"
        ],
        "Resource" = [
          "arn:aws:execute-api:ap-southeast-1:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.t-rss-reader-handler-api.id}/*"
        ]
      },
    ]
  })
}
