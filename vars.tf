variable "aws-terraform-state-bucket" {
  description = "AWS backend where to store the terraform state"
  default = ""
}

variable "aws-terraform-locks-table" {
  description = "AWS Dynamo DB table name used for terraform locks"
  default = ""
}

variable "aws-region" {
  description = "AWS region where to create resources"
  default = "us-east-1"
}

variable "aws-profile" {
  description = "AWS profile to use having your IAM credentials key and secret configured in ~/.aws/credentials"
  default = "default"
}