# Key pair
variable "app-aws-key-pair-key-name" {
  description = "SSH key pair name having access to bastion host"
  default = "terraform-aws-demo-architecture"
}
variable "app-aws-key-pair-public-key-path" {
  description = "SSH key pair public key path having access to bastion host"
  default = ".terraform-aws-demo-architecture-key-pair.pub"
}

# VPC
variable "app-aws-vpc-region" {
  description = "AWS region for VPC"
  default = "us-east-1"
}

variable "app-aws-vpc-name" {
  description = "Name tag value for VPC"
  default = "vpc-terraform-demo-architecture"
}

variable "app-aws-vpc-cird-block" {
  description = "CIDR range for the VPC"
  default = "10.42.0.0/16"
}

# Public subnet
variable "app-aws-subnet-public-name" {
  description = "Public subnet name tag"
  default = "public-subnet-terraform-demo-architecture"
}

variable "app-aws-subnet-public-cidr-block" {
  description = "Public subnet CIDR range"
  default = "10.42.1.0/24"
}

# Private subnet
variable "app-aws-subnet-private-name" {
  description = "Private subnet name tag"
  default = "private-subnet-terraform-demo-architecture"
}

variable "app-aws-subnet-private-cidr-block" {
  description = "Private subnet CIDR range"
  default = "10.42.2.0/24"
}

# Database subnet
variable "app-aws-subnet-database-name" {
  description = "Database subnet name tag"
  default = "database-subnet-terraform-demo-architecture"
}

variable "app-aws-subnet-database-cidr-block" {
  description = "Database subnet CIDR range"
  default = "10.42.3.0/24"
}

# Internet Gateway
variable "app-aws-internet-gateway-name" {
  description = "Name tag value of Internet Gateway created to allow VPC internet connection"
  default = "igw-terraform-demo-architecture"
}

# Route table
variable "app-aws-route-table-name" {
  description = "Route Table Name for Internet Gateway"
  default = "route-table-terraform-demo-architecture"
}

# Security groups
variable "app-aws-public-ssh-security-group-name" {
  description = "Public SSH Security Group name"
  default = "public-ssh-sg-terraform-demo-architecture"
}
variable "app-aws-public-ssh-security-group-description" {
  description = "Public SSH Security Group description"
  default = "Public SSH Security Group"
}

variable "app-aws-private-ssh-security-group-name" {
  description = "Private SSH Security Group name"
  default = "private-ssh-sg-terraform-demo-architecture"
}
variable "app-aws-private-ssh-security-group-description" {
  description = "Private SSH Security Group description"
  default = "Private SSH Security Group"
}

variable "app-aws-private-security-group-name" {
  description = "Private Security Group name"
  default = "private-sg-terraform-demo-architecture"
}
variable "app-aws-private-security-group-description" {
  description = "Private Security Group description"
  default = "Private Security Group"
}

variable "app-aws-database-security-group-name" {
  description = "Database Security Group name"
  default = "database-sg-terraform-demo-architecture"
}
variable "app-aws-database-security-group-description" {
  description = "Database Security Group description"
  default = "Database Security Group"
}
variable "app-aws-database-security-group-ports" {
  description = "Database Security Group description"
  type = map
  default = {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
  }
}
variable "app-aws-private-web-security-group-name" {
  description = "Private Web Security Group name"
  default = "private-web-sg-terraform-demo-architecture"
}
variable "app-aws-private-web-security-group-description" {
  description = "Private Web Security Group description"
  default = "Private Security Group"
}
variable "app-aws-public-web-security-group-name" {
  description = "Public Web Security Group name"
  default = "public-web-sg-terraform-demo-architecture"
}
variable "app-aws-public-web-security-group-description" {
  description = "Public Web Security Group description"
  default = "Public Web Security Group"
}