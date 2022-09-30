variable "aws_region" {
  description = "AWS region where to create resources"
  default = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile to use having your IAM credentials key and secret configured in ~/.aws/credentials"
  default = "default"
}

# Key
variable "app_ssh_key_name" {
  description = "SSH key pair name having access to bastion host"
  default = "terraform-aws-demo-architecture"
}
variable "app_ssh_public_key_path" {
  description = "SSH key pair public key path having access to bastion host"
  default = ".terraform-aws-demo-architecture-key-pair.pub"
}

# Servers
variable "app_bastion_host_name" {
  description = "Instance name tag of bastion host server"
  default = "bastion-host-for-demo-architecture"
}
variable "app_private_server_name" {
  description = "Instance name tag of private application server"
  default = "private-server-for-demo-architecture"
}

# Database
variable "app_database_subnet_group_name" {
  description = "RDS database subnet group name tag value"
  default = "Database Server"
}
variable "app_database_server_identifier" {
  description = "RDS database server identifier value"
  default = "database-server-for-demo-architecture"
}
variable "app_database_server_instance_class" {
  description = "RDS database server instance class"
  default = "db.t4g.micro"
}
variable "app_database_server_allocated_storage" {
  description = "RDS database server allocated storage"
  default = 5
}
variable "app_database_server_publicly_accessible" {
  description = "RDS database server publicly accessible"
  default = false
}
variable "app_database_server_skip_final_snapshot" {
  description = "RDS database server skip final snapshot"
  default = true
}
variable "app_database_server_engine" {
  description = "RDS database server engine"
  default = "postgres"
}
variable "app_database_server_engine_version" {
  description = "RDS database server engine_version"
  default = "13.7"
}
variable "app_database_server_family" {
  description = "RDS database server parameter group family"
  default = "postgres13"
}
variable "app_database_server_username" {
  description = "RDS database server username"
  default = "fuckers"
  sensitive = true
}
variable "app_database_server_password" {
  description = "RDS database server password"
  type = string
  sensitive = true
  default = "chubby is a good word its like pear shaped"
}
