# VPC
variable "app_aws_vpc_region" {
  description = "Name tag value for VPC"
  default = "vpc-terraform-demo-architecture"
}

variable "app_aws_vpc_name" {
  description = "Name tag value for VPC"
  default = "vpc-terraform-demo-architecture"
}

variable "app_aws_vpc_cird_block" {
  description = "CIDR range for the VPC"
  default = "10.42.0.0/16"
}

# Public subnet
variable "app_aws_subnet_public_name" {
  description = "Public subnet name tag"
  default = "public-subnet-terraform-demo-architecture"
}

variable "app_aws_subnet_public_cidr_block" {
  description = "Public subnet CIDR range"
  default = "10.42.1.0/24"
}

# Private subnet
variable "app_aws_subnet_private_name" {
  description = "Private subnet name tag"
  default = "private-subnet-terraform-demo-architecture"
}

variable "app_aws_subnet_private_cidr_block" {
  description = "Private subnet CIDR range"
  default = "10.42.2.0/24"
}

# Database subnet
variable "app_aws_subnet_database_name" {
  description = "Database subnet name tag"
  default = "database-subnet-terraform-demo-architecture"
}

variable "app_aws_subnet_database_cidr_blocks" {
  description = "Database subnet CIDR range"
  default = ["10.42.3.0/24", "10.42.4.0/24", "10.42.5.0/24"]
  type = list(string)
}

# Internet Gateway
variable "app_aws_internet_gateway_name" {
  description = "Name tag value of Internet Gateway created to allow VPC internet connection"
  default = "igw-terraform-demo-architecture"
}

# Route table
variable "app_aws_route_table_name" {
  description = "Route Table Name for Internet Gateway"
  default = "route-table-terraform-demo-architecture"
}

# Security groups
variable "app_aws_public_ssh_security_group_name" {
  description = "Public SSH Security Group name"
  default = "public-ssh-sg-terraform-demo-architecture"
}
variable "app_aws_public_ssh_security_group_description" {
  description = "Public SSH Security Group description"
  default = "Public SSH Security Group"
}

variable "app_aws_private_ssh_security_group_name" {
  description = "Private SSH Security Group name"
  default = "private-ssh-sg-terraform-demo-architecture"
}
variable "app_aws_private_ssh_security_group_description" {
  description = "Private SSH Security Group description"
  default = "Private SSH Security Group"
}

variable "app_aws_private_security_group_name" {
  description = "Private Security Group name"
  default = "private-sg-terraform-demo-architecture"
}
variable "app_aws_private_security_group_description" {
  description = "Private Security Group description"
  default = "Private Security Group"
}
variable "app_aws_private_security_group_ports" {
  description = "Private Security Group ports"
  default = [80, 443]
  type = list(number)
}

variable "app_aws_database_security_group_name" {
  description = "Database Security Group name"
  default = "database-sg-terraform-demo-architecture"
}
variable "app_aws_database_security_group_description" {
  description = "Database Security Group description"
  default = "Database Security Group"
}
variable "app_aws_database_security_group_ports" {
  description = "Database Security Group description"
  # type = map
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
  })
  default = {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
  }
}
variable "app_aws_private_web_security_group_name" {
  description = "Private Web Security Group name"
  default = "private-web-sg-terraform-demo-architecture"
}
variable "app_aws_private_web_security_group_description" {
  description = "Private Web Security Group description"
  default = "Private Security Group"
}
variable "app_aws_public_web_security_group_name" {
  description = "Public Web Security Group name"
  default = "public-web-sg-terraform-demo-architecture"
}
variable "app_aws_public_web_security_group_description" {
  description = "Public Web Security Group description"
  default = "Public Web Security Group"
}
variable "app_aws_public_web_security_group_ports" {
  description = "Private Security Group ports"
  default = [80, 443]
  type = list(number)
}