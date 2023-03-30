resource "aws_dynamodb_table" "t-rss-reader-last-access-table" {
  name         = "t-rss-reader-last-access-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "N"
  }
}
