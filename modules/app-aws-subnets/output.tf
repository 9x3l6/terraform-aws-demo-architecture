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
