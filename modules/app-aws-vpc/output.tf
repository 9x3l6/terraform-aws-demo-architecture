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

# public SG
output "app_aws_sg_public" {
  value = aws_security_group.app-aws-public-security-group
}

# private SG
output "app_aws_sg_private" {
  value = aws_security_group.app-aws-private-security-group
}
