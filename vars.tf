variable "aws_region" {
  description = "AWS region where to create resources"
  default = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile to use having your IAM credentials key and secret configured in ~/.aws/credentials"
  default = "default"
}
