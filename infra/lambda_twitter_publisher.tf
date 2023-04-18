resource "aws_iam_role" "iam_for_lambda_twitter_publisher" {
  name               = "lambda_role_twitter_publisher"
  assume_role_policy = data.aws_iam_policy_document.policy_for_execute_lambda_twitter.json
  managed_policy_arns = [
    aws_iam_policy.lambda_policy_for_cloudwatch.arn, # Permissions to write logs
    aws_iam_policy.aws_lambda_policy_interact_sqs.arn # Permissions to receive data from SQS
  ]
}

data "aws_iam_policy_document" "policy_for_execute_lambda_twitter" {
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

# This block is the definiton of the lambda itself
resource "aws_lambda_function" "lambda_twitter_publisher" {
  filename         = data.archive_file.zip_twitter_publisher.output_path
  function_name    = "handler_twitter_publisher"
  handler          = "lambda-publisher.handler_publisher"
  runtime          = "nodejs16.x"
  role             = aws_iam_role.iam_for_lambda_twitter_publisher.arn
  memory_size      = 128
  timeout          = 5
  source_code_hash = data.archive_file.zip_twitter_publisher.output_base64sha256
}

# This data block packs the lambda source code into a zip
data "archive_file" "zip_twitter_publisher" {
  type        = "zip"
  source_file = "../packages/lambda-twitter-publisher/dist/lambda-publisher.js"
  output_path = "../packages/lambda-twitter-publisher/dist/lambda-publisher.zip"
}

# Event source from SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = "${aws_sqs_queue.publish_fandg_reading.arn}"
  enabled          = true
  function_name    = "${aws_lambda_function.lambda_twitter_publisher.arn}"
  batch_size       = 1
}