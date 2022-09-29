module "aws-vpc" {
  source = "../app-aws-vpc"
}
module "aws-subnet" {
  source = "../app-aws-subnets"
}

resource "aws_internet_gateway" "app-aws-internet-gateway" {
  depends_on = [
    module.aws-vpc.app-aws-vpc,
    module.aws-subnet.app-aws-subnet-private,
    module.aws-subnet.app-aws-subnet-public,
    # module.aws-subnet.app-aws-subnet-database,
  ]

  vpc_id = module.aws-vpc.app_aws_vpc.id
  
  tags = {
    Name = var.app-aws-internet-gateway-name # "terraform-demo-architecture-igw"
  }
}