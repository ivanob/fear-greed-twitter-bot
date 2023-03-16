
resource "aws_sqs_queue" "publish_fandg_reading" {
  name                      = "sqs-publish-fandg-reading"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  visibility_timeout_seconds = 3600
}