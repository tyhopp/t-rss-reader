resource "aws_dynamodb_table" "t-rss-reader-last-access-table" {
  name           = "t-rss-reader-last-access-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }
}
