# VPC
output "vpc" {
  value = aws_vpc.vpc
}

output "vpc_name" {
  value = var.vpc_name
}
output "vpc_region" {
  value = var.vpc_region
}

# public subnet
output "subnet_public" {
  value = aws_subnet.subnet_public
}

# private subnet
output "subnet_private" {
  value = aws_subnet.subnet_private
}

# database subnets
output "database_subnet_1" {
  value = aws_subnet.database_subnet_1
}
output "database_subnet_2" {
  value = aws_subnet.database_subnet_2
}
output "database_subnet_3" {
  value = aws_subnet.database_subnet_3
}

# internet gateway
output "igw" {
  value = aws_internet_gateway.internet_gateway
}

# route table
output "route_table" {
  value = aws_route_table.route_table
}
output "route_table_association" {
  value = aws_route_table_association.route_table_association
}

# security groups
output "public_ssh_security_group" {
  value = aws_security_group.public_ssh_security_group
}
output "private_ssh_security_group" {
  value = aws_security_group.private_ssh_security_group
}

output "public_web_security_group" {
  value = aws_security_group.public_web_security_group
}
output "private_web_security_group" {
  value = aws_security_group.private_web_security_group
}

output "private_security_group" {
  value = aws_security_group.private_security_group
}
output "database_security_group" {
  value = aws_security_group.database_security_group
}

# AMI
output "amazon_linux_id" {
  description = "Amazon Linux AMI ID"
  value = data.aws_ami.amazon_linux.id
}

# Key pair
output "ssh_key_pair_name" {
  description = "SSH Key Pair"
  value = aws_key_pair.ssh_key_pair.key_name
}

# Bastion host EC2 instance
output "bastion_host_instance_id" {
  description = "ID of the bastion-host instance"
  value       = aws_instance.bastion_host.id
}
output "bastion_host_instance_public_ip" {
  description = "Public IP address of the bastion-host instance"
  value       = aws_instance.bastion_host.public_ip
}
output "bastion_host_instance_public_dns" {
  description = "Public DNS address of the bastion-host instance"
  value       = aws_instance.bastion_host.public_dns
}

# Private server EC2 instance
output "private_server_instances_id" {
  description = "ID of the private server instances"
  value       = aws_instance.private_server[*].id
}
output "private_server_instances_private_ip" {
  description = "Private IP address of the private server instances"
  value       = aws_instance.private_server[*].private_ip
}
output "private_server_instances_private_dns" {
  description = "Private DNS address of the private server instances"
  value       = aws_instance.private_server[*].private_dns
}

# RDS database server
output "database_address" {
  description = "RDS database instance address"
  value       = aws_db_instance.database_server.address
  sensitive   = true
}
output "database_port" {
  description = "RDS database instance port"
  value       = aws_db_instance.database_server.port
}
output "database_username" {
  description = "RDS database instance root username"
  value       = aws_db_instance.database_server.username
  sensitive   = true
}
