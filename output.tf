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

# RDS database server
output "app_database_hostname" {
  description = "RDS database instance hostname"
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