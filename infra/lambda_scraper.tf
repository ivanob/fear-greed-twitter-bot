resource "aws_iam_role" "iam_for_lambda" {
  name               = "lambda_role"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_lambda_function" "lambda_scraper" {
  filename         = data.archive_file.zip.output_path
  function_name    = "lambda-scraper"
  handler          = "lambda-scraper.handler"
  runtime          = "nodejs14.x"
  role             = aws_iam_role.iam_for_lambda.arn
  memory_size      = 128
  timeout          = 5
  source_code_hash = data.archive_file.zip.output_base64sha256
}


data "archive_file" "zip" {
  type        = "zip"
  source_file = "../src/lambda-scraper.js"
  output_path = "../src/lambda-scraper.zip"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}
