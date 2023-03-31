# This block is the definiton of the lambda itself
resource "aws_lambda_function" "lambda_twitter_publisher" {
  filename         = data.archive_file.zip_twitter_publisher.output_path
  function_name    = "handler_twitter_publisher"
  handler          = "lambda-publisher.handler_publisher"
  runtime          = "nodejs16.x"
  role             = aws_iam_role.iam_for_lambda.arn
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