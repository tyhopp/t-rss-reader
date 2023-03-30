resource "aws_dynamodb_table" "t-rss-reader-feeds-table" {
  name         = "t-rss-reader-feeds-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "url"

  attribute {
    name = "url"
    type = "S"
  }
}
