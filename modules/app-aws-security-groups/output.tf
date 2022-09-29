# public SG
output "app_aws_sg_public" {
  value = aws_security_group.app-aws-public-security-group
}

# private SG
output "app_aws_sg_private" {
  value = aws_security_group.app-aws-private-security-group
}
