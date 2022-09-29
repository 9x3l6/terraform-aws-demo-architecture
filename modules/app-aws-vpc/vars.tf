variable "app-aws-vpc-cird-block" {
  description = "CIDR range for the VPC"
  default = "10.42.0.0/16"
}

variable "app-aws-vpc-region" {
  description = "AWS region for VPC"
  default = "us-east-1"
}

variable "app-aws-vpc-name" {
  description = "Name tag value for VPC"
  default = "terraform-demo-architecture-vpc"
}
