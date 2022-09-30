output "app_aws_region" {
  description = "AWS Region"
  value = var.aws_region
}

# AMI
output "app_amazon_linux_id" {
  description = "Amazon Linux AMI ID"
  value = data.aws_ami.amazon_linux.id
}

# Key pair
output "app_ssh_key_pair_name" {
  description = "SSH Key Pair"
  value = aws_key_pair.app_ssh_key_pair.key_name
}

# Bastion host EC2 instance
output "app_bastion_host_instance_id" {
  description = "ID of the bastion-host instance"
  value       = aws_instance.bastion_host.id
}
output "app_bastion_host_instance_public_ip" {
  description = "Public IP address of the bastion-host instance"
  value       = aws_instance.bastion_host.public_ip
}
output "app_bastion_host_instance_public_dns" {
  description = "Public DNS address of the bastion-host instance"
  value       = aws_instance.bastion_host.public_dns
}

# Private server EC2 instance
output "app_private_server_instance_id" {
  description = "ID of the private server instance"
  value       = aws_instance.private_server.id
}
output "app_private_server_instance_private_ip" {
  description = "Private IP address of the private server instance"
  value       = aws_instance.private_server.private_ip
}
output "app_private_server_instance_private_dns" {
  description = "Private DNS address of the private server instance"
  value       = aws_instance.private_server.private_dns
}

# RDS database server
output "app_database_address" {
  description = "RDS database instance address"
  value       = aws_db_instance.database_server.address
  sensitive   = true
}
output "app_database_port" {
  description = "RDS database instance port"
  value       = aws_db_instance.database_server.port
}
output "app_database_username" {
  description = "RDS database instance root username"
  value       = aws_db_instance.database_server.username
  sensitive   = true
}