# Public subnet
variable "app-aws-subnet-public-name" {
  description = "Public subnet name tag"
  default = "terraform-demo-architecture-public-subnet"
}

variable "app-aws-subnet-public-cidr-block" {
  description = "Public subnet CIDR range"
  default = "10.42.0.0/24"
}

# Private subnet
variable "app-aws-subnet-private-name" {
  description = "Private subnet name tag"
  default = "terraform-demo-architecture-private-subnet"
}

variable "app-aws-subnet-private-cidr-block" {
  description = "Private subnet CIDR range"
  default = "10.42.1.0/24"
}

# Database subnet
variable "app-aws-subnet-database-name" {
  description = "Database subnet name tag"
  default = "terraform-demo-architecture-database-subnet"
}

variable "app-aws-subnet-database-cidr-block" {
  description = "Database subnet CIDR range"
  default = "10.42.2.0/24"
}