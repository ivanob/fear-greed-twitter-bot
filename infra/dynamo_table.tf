resource "aws_dynamodb_table" "fear-greed-readings" {
  name           = "fear-greed-readings"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }
  tags = {
    Environment = "fear-greed"
  }
}
