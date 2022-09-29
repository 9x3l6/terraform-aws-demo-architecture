# public SG
output "app_aws_sg_public_id" {
  value = aws_security_group.app-aws-public-security-group.id
}
output "app_aws_sg_public_name" {
  value = aws_security_group.app-aws-public-security-group.name
}
output "app_aws_sg_public_arn" {
  value = aws_security_group.app-aws-public-security-group.arn
}

# private SG
output "app_aws_sg_private_id" {
  value = aws_security_group.app-aws-private-security-group.id
}
output "app_aws_sg_private_name" {
  value = aws_security_group.app-aws-private-security-group.name
}
output "app_aws_sg_private_arn" {
  value = aws_security_group.app-aws-private-security-group.arn
}
