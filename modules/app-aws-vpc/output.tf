# VPC
output "app_aws_vpc" {
  value = aws_vpc.app_aws_vpc
}

output "app_aws_vpc_name" {
  value = var.app_aws_vpc_name
}
output "app_aws_vpc_region" {
  value = var.app_aws_vpc_region
}

# public subnet
output "app_aws_subnet_public" {
  value = aws_subnet.app_aws_subnet_public
}

# private subnet
output "app_aws_subnet_private" {
  value = aws_subnet.app_aws_subnet_private
}

# database subnets
output "app_aws_database_subnet_1" {
  value = aws_subnet.app_aws_database_subnet_1
}
output "app_aws_database_subnet_2" {
  value = aws_subnet.app_aws_database_subnet_2
}
output "app_aws_database_subnet_3" {
  value = aws_subnet.app_aws_database_subnet_3
}

# internet gateway
output "app_aws_igw" {
  value = aws_internet_gateway.app_aws_internet_gateway
}

# route table
output "app_aws_route_table" {
  value = aws_route_table.app_aws_route_table
}
output "app_aws_route_table_association" {
  value = aws_route_table_association.app_aws_route_table_association
}

# security groups
output "app_aws_public_ssh_security_group" {
  value = aws_security_group.app_aws_public_ssh_security_group
}
output "app_aws_private_ssh_security_group" {
  value = aws_security_group.app_aws_private_ssh_security_group
}

output "app_aws_public_web_security_group" {
  value = aws_security_group.app_aws_public_web_security_group
}
output "app_aws_private_web_security_group" {
  value = aws_security_group.app_aws_private_web_security_group
}

output "app_aws_private_security_group" {
  value = aws_security_group.app_aws_private_security_group
}
output "app_aws_database_security_group" {
  value = aws_security_group.app_aws_database_security_group
}