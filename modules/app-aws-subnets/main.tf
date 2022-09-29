module "aws-vpc" {
  source = "../app-aws-vpc"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "app-aws-subnet-public" {
  depends_on = [
    module.aws-vpc.app-aws-vpc
  ]

  vpc_id = module.aws-vpc.app_aws_vpc.id

  cidr_block = var.app-aws-subnet-public-cidr-block

  map_public_ip_on_launch = "true"

  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.app-aws-subnet-public-name
  }
}

resource "aws_subnet" "app-aws-subnet-private" {
  depends_on = [
    module.aws-vpc.app_aws_vpc,
    aws_subnet.app-aws-subnet-public,
  ]

  vpc_id = module.aws-vpc.app_aws_vpc.id

  cidr_block = var.app-aws-subnet-private-cidr-block

  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.app-aws-subnet-private-name
  }
}

resource "aws_subnet" "app-aws-subnet-database" {
  depends_on = [
    module.aws-vpc.app_aws_vpc,
    aws_subnet.app-aws-subnet-private,
  ]

  vpc_id = module.aws-vpc.app_aws_vpc.id

  cidr_block = var.app-aws-subnet-database-cidr-block

  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = var.app-aws-subnet-database-name
  }
}
