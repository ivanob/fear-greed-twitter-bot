variable "aws_region" {
  type        = string
  description = "The aws region where we deploy"
  default     = "eu-west-1"
}

variable "aws_account_id" {
  type        = string
  description = "The aws account id where we deploy"
  default     = "065454142634"
}

variable "twitter_appKey" {
  type        = string
  description = "This is the twitter API Key you can find in the Consumer Keys section"
  default     = ""
}

variable "twitter_appSecret" {
  type        = string
  description = "This is the twitter API Secret you can find in the Consumer Keys section"
  default     = ""
}

variable "twitter_accessToken" {
  type        = string
  description = "This is the twitter Access Token you can find in the Authentication Tokens section"
  default     = ""
}

variable "twitter_accessSecret" {
  type        = string
  description = "This is the twitter Access Token Secret you can find in the Authentication Tokens section"
  default     = ""
}