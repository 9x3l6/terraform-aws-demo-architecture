# resource "aws_s3_bucket" "terraform_state" {
#   bucket = terraform.backend.s3.bucket

#   lifecycle {
#     prevent_destroy = true
#   }

#   versioning {
#     enabled = true
#   }

#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm = "AES256"
#       }
#     }
#   }
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#   name = terraform.backend.s3.dynamodb_table
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

# terraform {
#   backend "s3" {
#     key = "stage/data-stores/mysql/terraform.tfstate"
#   }
# }

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

module "app_vpc" {
  source = "./modules/app-aws-vpc"
  vpc_region = var.aws_region
}
