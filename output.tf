output "aws_region" {
  description = "AWS Region"
  value = var.aws_region
}

# AMI
output "amazon_linux_id" {
  description = "Amazon Linux AMI ID"
  value = module.app_vpc.amazon_linux_id
}

# Key pair
output "ssh_key_pair_name" {
  description = "SSH Key Pair"
  value = module.app_vpc.ssh_key_pair_name
}

# Bastion host
output "bastion_host_instance_id" {
  description = "ID of the bastion-host instance"
  value       = module.app_vpc.bastion_host_instance_id
}
output "bastion_host_instance_public_ip" {
  description = "Public IP address of the bastion-host instance"
  value       = module.app_vpc.bastion_host_instance_public_ip
}

# Private server
output "private_server_instances_id" {
  description = "ID of the private server instances"
  value       = module.app_vpc.private_server_instances_id
}
output "private_server_instances_private_ip" {
  description = "Private IP address of the private server instances"
  value       = module.app_vpc.private_server_instances_private_ip
}

# Database server
output "database_address" {
  description = "RDS database instance address"
  value       = module.app_vpc.database_address
  sensitive   = true
}
