module "aws-vpc" {
  source = "../app-aws-vpc"
}

resource "aws_subnet" "app-aws-subnet-public" {
  vpc_id = module.aws-vpc.app_aws_vpc_id

  cidr_block = var.app-aws-subnet-database-cidr-block

  map_public_ip_on_launch = "true"

  availability_zone = var.app-aws-subnet-public-az

  depends_on = [
    module.aws-vpc.app_aws_vpc_id
  ]

  tags = {
    Name = var.app-aws-subnet-public-name
  }
}

resource "aws_subnet" "app-aws-subnet-private" {
  vpc_id = module.aws-vpc.app_aws_vpc_id

  cidr_block = var.app-aws-subnet-private-cidr-block

  availability_zone = var.app-aws-subnet-private-az

  depends_on = [
    module.aws-vpc.app_aws_vpc_id
  ]

  tags = {
    Name = var.app-aws-subnet-private-name
  }
}

resource "aws_subnet" "app-aws-subnet-database" {
  vpc_id = module.aws-vpc.app_aws_vpc_id

  cidr_block = var.app-aws-subnet-database-cidr-block

  availability_zone = var.app-aws-subnet-database-az

  depends_on = [
    module.aws-vpc.app_aws_vpc_id
  ]

  tags = {
    Name = var.app-aws-subnet-database-name
  }
}
