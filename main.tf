# resource "aws_s3_bucket" "terraform_state" {
#   bucket = terraform.backend.s3.bucket

#   # lifecycle {
#   #   prevent_destroy = true
#   # }

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
  profile = var.aws-profile
  region  = var.aws-region
}

module "aws-key-pair" {
  source = "./modules/app-aws-key-pair"
}

# module "aws-vpc" {
#   source = "./modules/app-aws-vpc"
# }

# module "aws-subnets" {
#   source = "./modules/app-aws-subnets"
# }

# module "aws-security-groups" {
#   source = "./modules/app-aws-security-groups"
# }

# module "aws-igw" {
#   source = "./modules/app-aws-igw"
# }

module "aws-route-table" {
  source = "./modules/app-aws-route-table"
}

# module "aws-database" {
#   source = "./modules/app-aws-database"
# }

# module "aws-lambda-functions" {
#   source = "./modules/app-aws-lambda-functions"
# }

# module "aws-public-instances" {
#   source = "./modules/app-aws-public-instances"
# }

# module "aws-private-instances" {
#   source = "./modules/app-aws-private-instances"
# }
