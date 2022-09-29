resource "aws_vpc" "app-aws-vpc" {
  cidr_block = var.app-aws-vpc-cird-block # "10.42.0.0/16"

  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.app-aws-vpc-name # "terraform-demo-architecture-vpc"
  }
}
