output "app_aws_vpc_id" {
  value = aws_vpc.app-aws-vpc.id
}
output "app_aws_vpc_arn" {
  value = aws_vpc.app-aws-vpc.arn
}

output "app_aws_vpc_name" {
  value = var.app-aws-vpc-name
}
output "app_aws_vpc_region" {
  value = var.app-aws-vpc-region
}

