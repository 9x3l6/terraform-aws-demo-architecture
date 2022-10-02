# Key
variable "ssh_key_name" {
  description = "SSH key pair name having access to bastion host"
  default = "terraform-aws-demo-architecture"
}
variable "ssh_public_key_path" {
  description = "SSH key pair public key path having access to bastion host"
  default = ".terraform-aws-demo-architecture-key-pair.pub"
}

# VPC
variable "vpc_region" {
  description = "Name tag value for VPC"
  default = "vpc-terraform-demo-architecture"
}

variable "vpc_name" {
  description = "Name tag value for VPC"
  default = "vpc-terraform-demo-architecture"
}

variable "vpc_cird_block" {
  description = "CIDR range for the VPC"
  default = "10.42.0.0/16"
}

# Public subnet
variable "subnet_public_name" {
  description = "Public subnet name tag"
  default = "public-subnet-terraform-demo-architecture"
}

variable "subnet_public_cidr_block" {
  description = "Public subnet CIDR range"
  default = "10.42.1.0/24"
}

# Private subnet
variable "subnet_private_name" {
  description = "Private subnet name tag"
  default = "private-subnet-terraform-demo-architecture"
}

variable "subnet_private_cidr_block" {
  description = "Private subnet CIDR range"
  default = "10.42.2.0/24"
}

# Database subnet
variable "subnet_database_name" {
  description = "Database subnet name tag"
  default = "database-subnet-terraform-demo-architecture"
}

variable "subnet_database_cidr_blocks" {
  description = "Database subnet CIDR range"
  default = ["10.42.3.0/24", "10.42.4.0/24", "10.42.5.0/24"]
  type = list(string)
}

# Internet Gateway
variable "internet_gateway_name" {
  description = "Name tag value of Internet Gateway created to allow VPC internet connection"
  default = "igw-terraform-demo-architecture"
}

# Route table
variable "route_table_name" {
  description = "Route Table Name for Internet Gateway"
  default = "route-table-terraform-demo-architecture"
}

# Security groups
variable "public_ssh_security_group_name" {
  description = "Public SSH Security Group name"
  default = "public-ssh-sg-terraform-demo-architecture"
}
variable "public_ssh_security_group_description" {
  description = "Public SSH Security Group description"
  default = "Public SSH Security Group"
}

variable "private_ssh_security_group_name" {
  description = "Private SSH Security Group name"
  default = "private-ssh-sg-terraform-demo-architecture"
}
variable "private_ssh_security_group_description" {
  description = "Private SSH Security Group description"
  default = "Private SSH Security Group"
}

variable "private_security_group_name" {
  description = "Private Security Group name"
  default = "private-sg-terraform-demo-architecture"
}
variable "private_security_group_description" {
  description = "Private Security Group description"
  default = "Private Security Group"
}
variable "private_security_group_ports" {
  description = "Private Security Group ports"
  default = [80, 443]
  type = list(number)
}

variable "database_security_group_name" {
  description = "Database Security Group name"
  default = "database-sg-terraform-demo-architecture"
}
variable "database_security_group_description" {
  description = "Database Security Group description"
  default = "Database Security Group"
}
variable "database_security_group_ports" {
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
variable "private_web_security_group_name" {
  description = "Private Web Security Group name"
  default = "private-web-sg-terraform-demo-architecture"
}
variable "private_web_security_group_description" {
  description = "Private Web Security Group description"
  default = "Private Security Group"
}
variable "public_web_security_group_name" {
  description = "Public Web Security Group name"
  default = "public-web-sg-terraform-demo-architecture"
}
variable "public_web_security_group_description" {
  description = "Public Web Security Group description"
  default = "Public Web Security Group"
}
variable "public_web_security_group_ports" {
  description = "Private Security Group ports"
  default = [80, 443]
  type = list(number)
}

# Servers
variable "bastion_host_name" {
  description = "Instance name tag of bastion host server"
  default = "bastion-host-for-demo-architecture"
}
variable "bastion_host_instance_type" {
  description = "Instance type for bastion host"
  default = "t2.micro"
}
# variable "private_server_name" {
#   description = "Instance name tag of private application server"
#   default = "private-server-for-demo-architecture"
# }
variable "private_server_names" {
  description = "Names of private servers"
  default = ["private-server-1"]
  type = list(string)
}
variable "private_server_instance_type" {
  description = "Instance type for private server"
  default = "t2.micro"
}
variable "private_server_count" {
  description = "Count amount of private server"
  default = 1
}

# Database
variable "database_subnet_group_name" {
  description = "RDS database subnet group name tag value"
  default = "Database Server"
}
variable "database_server_identifier" {
  description = "RDS database server identifier value"
  default = "database-server-for-demo-architecture"
}
variable "database_server_instance_class" {
  description = "RDS database server instance class"
  default = "db.t4g.micro"
}
variable "database_server_allocated_storage" {
  description = "RDS database server allocated storage"
  default = 5
}
variable "database_server_publicly_accessible" {
  description = "RDS database server publicly accessible"
  default = false
}
variable "database_server_skip_final_snapshot" {
  description = "RDS database server skip final snapshot"
  default = true
}
variable "database_server_engine" {
  description = "RDS database server engine"
  default = "postgres"
}
variable "database_server_engine_version" {
  description = "RDS database server engine_version"
  default = "13.7"
}
variable "database_server_family" {
  description = "RDS database server parameter group family"
  default = "postgres13"
}
variable "database_server_username" {
  description = "RDS database server username"
  default = "fuckers"
  sensitive = true
}
variable "database_server_password" {
  description = "RDS database server password"
  type = string
  sensitive = true
  default = "()chubby-is-a-good-word{}its-like-pear-shaped[]"
}

# lambda function archive file
variable "archive_file_source_dir" {
  description = "Directory where lambda source code is located"
  default = "code/"
}
variable "archive_file_output_path" {
  description = "Output path to zip file"
  default = "code.zip"
}

variable "lambda_function_runtime" {
  description = "Lambda function runtime"
  default = "python3.8"
}
variable "lambda_function_handler" {
  description = "Lambda function handler"
  default = "index.lambda_handler"
}
