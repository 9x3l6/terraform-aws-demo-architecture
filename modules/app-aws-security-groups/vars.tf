variable "app-aws-public-security-group-name" {
  description = "Public Security Group name"
  default = "public-sg-terraform-demo-architecture"
}

variable "app-aws-public-security-group-cidr-blocks" {
  description = "CIDR range to allow for SSH access for connecting to bastion host"
  default = ["0.0.0.0/0"]
}

variable "app-aws-private-security-group-name" {
  description = "Private Security Group name"
  default = "private-sg-terraform-demo-architecture"
}
