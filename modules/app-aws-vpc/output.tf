# Key pair
output "app_aws_key_pair" {
  value = aws_key_pair.app-aws-key-pair
}

# VPC
output "app_aws_vpc" {
  value = aws_vpc.app-aws-vpc
}

output "app_aws_vpc_name" {
  value = var.app-aws-vpc-name
}
output "app_aws_vpc_region" {
  value = var.app-aws-vpc-region
}

# public subnet
output "app_aws_subnet_public" {
  value = aws_subnet.app-aws-subnet-public
}

# private subnet
output "app_aws_subnet_private" {
  value = aws_subnet.app-aws-subnet-private
}

# database subnet
output "app_aws_subnet_database" {
  value = aws_subnet.app-aws-subnet-database
}

# internet gateway
output "app_aws_igw" {
  value = aws_internet_gateway.app-aws-internet-gateway
}

# route table
output "app_aws_route_table" {
  value = aws_route_table.app-aws-route-table
}
output "app_aws_route_table_association" {
  value = aws_route_table_association.app-aws-route-table-association
}

# security groups
output "app_aws_public_ssh_security_group" {
  value = aws_security_group.app-aws-public-ssh-security-group
}
output "app_aws_private_ssh_security_group" {
  value = aws_security_group.app-aws-private-ssh-security-group
}

output "app_aws_private_security_group" {
  value = aws_security_group.app-aws-private-security-group
}

output "app_aws_database_security_group" {
  value = aws_security_group.app-aws-database-security-group
}

output "app_aws_private_web_security_group" {
  value = aws_security_group.app-aws-private-web-security-group
}
output "app_aws_public_web_security_group" {
  value = aws_security_group.app-aws-public-web-security-group
}