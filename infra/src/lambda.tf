resource "aws_lambda_function" "t-rss-reader-feeds-handler" {
  filename         = "feeds-handler.zip"
  function_name    = "t-rss-reader-feeds-handler"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256("feeds-handler.zip")
  runtime          = "nodejs18.x"
}

resource "aws_lambda_event_source_mapping" "t-rss-reader-db-handler-event-source-mapping" {
  event_source_arn  = aws_dynamodb_table.t-rss-reader-feeds-table.stream_arn
  function_name     = aws_lambda_function.t-rss-reader-feeds-handler.arn
  starting_position = "LATEST"
}

resource "aws_iam_role" "t-rss-reader-handler-iam" {
  name = "t-rss-reader-handler-iam"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
  EOF
}

resource "aws_iam_role_policy" "t-rss-reader-db-handler-iam" {
  name   = "t-rss-reader-db-handler-iam"
  role   = aws_iam_role.t-rss-reader-handler-iam.id
  policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
            "Sid": "AllowLambdaFunctionToCreateLogs",
            "Action": [ 
                "logs:*" 
            ],
            "Effect": "Allow",
            "Resource": [ 
                "arn:aws:logs:*:*:*" 
            ]
        },
        {
            "Sid": "AllowLambdaFunctionInvocation",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": [
                "${aws_dynamodb_table.t-rss-reader-feeds-table.arn}/stream/*"
            ]
        },
        {
            "Sid": "APIAccessForDynamoDBStreams",
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetRecords",
                "dynamodb:GetShardIterator",
                "dynamodb:DescribeStream",
                "dynamodb:ListStreams"
            ],
            "Resource": "${aws_dynamodb_table.t-rss-reader-feeds-table.arn}/stream/*"
        }
      ]
    }
  EOF
}