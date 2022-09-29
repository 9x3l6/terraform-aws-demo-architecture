module "aws-vpc" {
  source = "../app-aws-vpc"
}
module "aws-subnet" {
  source = "../app-aws-subnets"
}
module "aws-igw" {
  source = "../app-aws-igw"
}

resource "aws_route_table" "app-aws-route-table" {
  depends_on = [
    module.aws-vpc.app_aws_vpc,
    module.aws-igw.app_aws_igw
  ]

  vpc_id = module.aws-vpc.app_aws_vpc.id

  # NAT
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.aws-igw.app_aws_igw.id
  }

  tags = {
    Name = var.app-aws-route-table-name
  }
}

resource "aws_route_table_association" "app-aws-route-table-association" {
  depends_on = [
    module.aws-vpc.app_aws_vpc,
    module.aws-subnet.app_aws_subnet_public,
    module.aws-subnet.app_aws_subnet_private,
    module.aws-subnet.app_aws_subnet_database,
    aws_route_table.app-aws-route-table
  ]

  subnet_id = module.aws-subnet.app_aws_subnet_public.id

  route_table_id = aws_route_table.app-aws-route-table.id
}