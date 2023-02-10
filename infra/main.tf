terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1" # Singapore
}

resource "aws_dynamodb_table" "dynamo_db_feeds" {
  name           = "t-rss-reader-feeds-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "Id"
  range_key      = "Name"

  attribute {
    name = "Id"
    type = "S"
  }

  attribute {
    name = "Name"
    type = "S"
  }
}

resource "aws_lambda_function" "lambda_db_handler" {
  filename         = "${path.module}/../lambda-db-handler/lambda-db-handler.zip"
  function_name    = "lambda-db-handler"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256("${path.module}/../lambda-db-handler/lambda-db-handler.zip")
  runtime          = "nodejs18.x"
}

resource "aws_lambda_event_source_mapping" "lambda_dynamodb" {
  event_source_arn  = aws_dynamodb_table.dynamo_db_feeds.stream_arn
  function_name     = aws_lambda_function.lambda_db_handler.arn
  starting_position = "LATEST"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_iam_role_policy" "dynamodb_lambda_policy" {
  name   = "lambda-dynamodb-policy"
  role   = aws_iam_role.iam_for_lambda.id
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
                "${aws_dynamodb_table.dynamo_db_feeds.arn}/stream/*"
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
            "Resource": "${aws_dynamodb_table.dynamo_db_feeds.arn}/stream/*"
        }
      ]
    }
  EOF
}
