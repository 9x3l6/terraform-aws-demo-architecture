module "aws-vpc" {
  source = "../app-aws-vpc"
}

resource "aws_security_group" "app-aws-private-security-group" {
  name = var.app-aws-private-security-group-name  # "private-sg-terraform-demo-architecture"
  vpc_id = module.aws-vpc.app_aws_vpc_id
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app-aws-public-security-group" {
  name = var.app-aws-public-security-group-name  # "public-sg-terraform-demo-architecture"
  vpc_id = module.aws-vpc.app_aws_vpc_id

  # Allow access to bastion host from anywhere in the world by default
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.app-aws-public-security-group-cidr-blocks # ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}