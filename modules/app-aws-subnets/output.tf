# public subnet
output "app_aws_subnet_public_id" {
  value = aws_subnet.app-aws-subnet-public.id
}
output "app_aws_subnet_public_arn" {
  value = aws_subnet.app-aws-subnet-public.arn
}

# private subnet
output "app_aws_subnet_private_id" {
  value = aws_subnet.app-aws-subnet-private.id
}
output "app_aws_subnet_private_arn" {
  value = aws_subnet.app-aws-subnet-private.arn
}

# database subnet
output "app_aws_subnet_database_id" {
  value = aws_subnet.app-aws-subnet-database.id
}
output "app_aws_subnet_database_arn" {
  value = aws_subnet.app-aws-subnet-database.arn
}
