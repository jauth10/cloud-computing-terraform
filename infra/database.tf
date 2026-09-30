# Provisioned mode only: on-demand is not covered by the always-free tier.
resource "aws_dynamodb_table" "campaign_counter" {
  name           = local.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
