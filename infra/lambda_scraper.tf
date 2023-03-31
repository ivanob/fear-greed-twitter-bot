resource "aws_iam_role" "iam_for_lambda" {
  name               = "lambda_role"
  assume_role_policy = data.aws_iam_policy_document.policy.json

  # This inline_policy is for attaching to the lambda the permissions to interact with DB
  inline_policy {
    name   = "policy-dynamodb-writer"
    policy = data.aws_iam_policy_document.inline_policy.json
  }
  inline_policy {
    name   = "policy-sqs-writer"
    policy = data.aws_iam_policy_document.inline_policy2.json
  }
}

data "aws_iam_policy_document" "inline_policy2" {
  statement {
    actions = [
      "sqs:SendMessage"
    ]

    resources = [aws_sqs_queue.publish_fandg_reading.arn]

    effect = "Allow"
  }
}

resource "aws_lambda_permission" "sqs_permission" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_scraper.arn
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.publish_fandg_reading.arn
}

# This block is the definiton of the lambda itself
resource "aws_lambda_function" "lambda_scraper" {
  filename         = data.archive_file.zip.output_path
  function_name    = "handler_scraper"
  handler          = "lambda-scraper.handler"
  runtime          = "nodejs16.x"
  role             = aws_iam_role.iam_for_lambda.arn
  memory_size      = 128
  timeout          = 5
  source_code_hash = data.archive_file.zip.output_base64sha256
}

# This data block packs the lambda source code into a zip
data "archive_file" "zip" {
  type        = "zip"
  source_file = "../packages/lambda-scraper/dist/lambda-scraper.js"
  output_path = "../packages/lambda-scraper/dist/lambda-scraper.zip"
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
# This are the permissions for the lambda to access the database. It is only needed
# dynamodb:PutItem but I am granting all the permissions available. Could be done this
# way also: "dynamodb:*"
data "aws_iam_policy_document" "inline_policy" {
  statement {
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:ListTables",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
      "dynamodb:UpdateTable",
    ]

    resources = [aws_dynamodb_table.fear-greed-readings.arn]

    effect = "Allow"
  }
}

# This is the cloudwatch resource that will trigger the lambda every X minutes
resource "aws_cloudwatch_event_rule" "cloudwatch_wakeup_scraper_lambda" {
  name        = "wakeup_scraper_rule"
  description = "It wakes up the lambda to scrape the fear&greed data"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "cloudwatch_target_scraper_lambda" {
  target_id = "wakeup_scraper_target"
  arn = aws_lambda_function.lambda_scraper.arn
  rule = aws_cloudwatch_event_rule.cloudwatch_wakeup_scraper_lambda.name
}
# Permissions for the event bridge rule to call the lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_scraper.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cloudwatch_wakeup_scraper_lambda.arn
}