resource "aws_dynamodb_table" "t-rss-reader-feeds-table" {
  name           = "t-rss-reader-feeds-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "url"

  attribute {
    name = "url"
    type = "S"
  }
}
