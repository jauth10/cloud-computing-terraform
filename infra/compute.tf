data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/../src/lambda/index.mjs"
  output_path = "${path.module}/.build/lambda.zip"
}

# Created explicitly so retention applies; an implicit log group never expires.
resource "aws_cloudwatch_log_group" "lambda" {
  name              = local.log_group_name
  retention_in_days = var.log_retention_days
}

resource "aws_lambda_function" "api" {
  function_name    = local.function_name
  role             = aws_iam_role.lambda.arn
  runtime          = "nodejs24.x"
  handler          = "index.handler"
  architectures    = ["arm64"]
  memory_size      = 128
  timeout          = 5
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.campaign_counter.name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy.lambda_logs,
  ]
}

resource "aws_lambda_function_url" "api" {
  function_name      = aws_lambda_function.api.function_name
  authorization_type = "AWS_IAM"
}
