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
  app_aws_vpc_region = var.aws_region
}

resource "aws_key_pair" "app_ssh_key_pair" {
  key_name    = var.app_ssh_key_name
  public_key  = file(var.app_ssh_public_key_path)  
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "bastion_host" {
  depends_on = [
    module.app_vpc,
  ]
  
  instance_type = "t2.micro"
  ami           = data.aws_ami.amazon_linux.id
  subnet_id     = module.app_vpc.app_aws_subnet_public.id
  key_name      = var.app_ssh_key_name

  vpc_security_group_ids = [
    module.app_vpc.app_aws_public_ssh_security_group.id,
    module.app_vpc.app_aws_private_security_group.id,
  ]

  tags = {
    Name = var.app_bastion_host_name
  }
}

resource "aws_instance" "private_server" {
  depends_on = [
    module.app_vpc,
  ]
  
  instance_type = "t2.micro"
  ami           = data.aws_ami.amazon_linux.id
  subnet_id     = module.app_vpc.app_aws_subnet_private.id
  key_name      = var.app_ssh_key_name

  vpc_security_group_ids = [
    module.app_vpc.app_aws_private_security_group.id,
    module.app_vpc.app_aws_private_web_security_group.id,
    module.app_vpc.app_aws_private_ssh_security_group.id,
  ]

  tags = {
    Name = var.app_private_server_name
  }
}

# RDS database
resource "aws_db_subnet_group" "database_server" {
  name       = var.app_database_server_identifier
  subnet_ids = [
    module.app_vpc.app_aws_database_subnet_1.id,
    module.app_vpc.app_aws_database_subnet_2.id,
    module.app_vpc.app_aws_database_subnet_3.id,
  ]

  tags = {
    Name = var.app_database_subnet_group_name
  }
}

resource "aws_db_parameter_group" "database_server" {
  name   = var.app_database_server_identifier
  family = var.app_database_server_family

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "database_server" {
  identifier             = var.app_database_server_identifier
  instance_class         = var.app_database_server_instance_class
  allocated_storage      = var.app_database_server_allocated_storage
  engine                 = var.app_database_server_engine
  engine_version         = var.app_database_server_engine_version
  username               = var.app_database_server_username
  password               = var.app_database_server_password
  db_subnet_group_name   = aws_db_subnet_group.database_server.name
  vpc_security_group_ids = [module.app_vpc.app_aws_database_security_group.id]
  parameter_group_name   = aws_db_parameter_group.database_server.name
  publicly_accessible    = var.app_database_server_publicly_accessible
  skip_final_snapshot    = var.app_database_server_skip_final_snapshot
}

