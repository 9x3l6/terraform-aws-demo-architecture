resource "aws_vpc" "app-aws-vpc" {
  cidr_block = var.app-aws-vpc-cird-block # "10.42.0.0/16"
  
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.app-aws-vpc-name # "terraform-demo-architecture-vpc"
  }
}

resource "aws_internet_gateway" "app-aws-internet-gateway" {
  vpc_id = aws_vpc.app-aws-vpc.id
  
  tags = {
    Name = var.app-aws-internet-gateway-name # "terraform-demo-architecture-igw"
  }
}