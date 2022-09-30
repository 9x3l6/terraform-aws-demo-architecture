# Key pair
resource "aws_key_pair" "app-aws-key-pair" {
  key_name   = var.app-aws-key-pair-key-name
  public_key = file(var.app-aws-key-pair-public-key-path)  
}

# VPC
resource "aws_vpc" "app-aws-vpc" {
  cidr_block = var.app-aws-vpc-cird-block # "10.42.0.0/16"

  enable_dns_support = "true"
  # enable_dns_hostnames = "true"

  tags = {
    Name = var.app-aws-vpc-name # "terraform-demo-architecture-vpc"
  }
}

# Subnets
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "app-aws-subnet-public" {
  depends_on = [
    aws_vpc.app-aws-vpc
  ]

  vpc_id = aws_vpc.app-aws-vpc.id

  cidr_block = var.app-aws-subnet-public-cidr-block

  map_public_ip_on_launch = "true"

  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.app-aws-subnet-public-name
  }
}

resource "aws_subnet" "app-aws-subnet-private" {
  depends_on = [
    aws_vpc.app-aws-vpc,
    aws_subnet.app-aws-subnet-public,
  ]

  vpc_id = aws_vpc.app-aws-vpc.id

  cidr_block = var.app-aws-subnet-private-cidr-block

  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.app-aws-subnet-private-name
  }
}

resource "aws_subnet" "app-aws-subnet-database" {
  depends_on = [
    aws_vpc.app-aws-vpc,
    aws_subnet.app-aws-subnet-private,
  ]

  vpc_id = aws_vpc.app-aws-vpc.id

  cidr_block = var.app-aws-subnet-database-cidr-block

  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = var.app-aws-subnet-database-name
  }
}

# Internet gateway
resource "aws_internet_gateway" "app-aws-internet-gateway" {
  depends_on = [
    aws_vpc.app-aws-vpc,
    aws_subnet.app-aws-subnet-private,
    aws_subnet.app-aws-subnet-public,
    aws_subnet.app-aws-subnet-database,
  ]

  vpc_id = aws_vpc.app-aws-vpc.id
  
  tags = {
    Name = var.app-aws-internet-gateway-name # "terraform-demo-architecture-igw"
  }
}

# Route table
resource "aws_route_table" "app-aws-route-table" {
  depends_on = [
    aws_vpc.app-aws-vpc,
    aws_internet_gateway.app-aws-internet-gateway,
  ]

  vpc_id = aws_vpc.app-aws-vpc.id

  # NAT
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-aws-internet-gateway.id
  }

  tags = {
    Name = var.app-aws-route-table-name
  }
}

resource "aws_route_table_association" "app-aws-route-table-association" {
  depends_on = [
    aws_vpc.app-aws-vpc,
    aws_subnet.app-aws-subnet-public,
    aws_subnet.app-aws-subnet-private,
    aws_subnet.app-aws-subnet-database,
    aws_route_table.app-aws-route-table
  ]

  subnet_id = aws_subnet.app-aws-subnet-public.id

  route_table_id = aws_route_table.app-aws-route-table.id
}

# Security groups
resource "aws_security_group" "app-aws-public-ssh-security-group" {
  depends_on = [
    aws_vpc.app-aws-vpc,
    aws_subnet.app-aws-subnet-private,
    aws_subnet.app-aws-subnet-public,
    aws_subnet.app-aws-subnet-database,
  ]

  vpc_id = aws_vpc.app-aws-vpc.id
  name = var.app-aws-public-ssh-security-group-name  # "public-sg-terraform-demo-architecture"
  description = var.app-aws-public-ssh-security-group-description

  # Allow access to bastion host from anywhere in the world by default
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app-aws-private-ssh-security-group" {
  depends_on = [
    aws_vpc.app-aws-vpc,
    aws_subnet.app-aws-subnet-private,
    aws_subnet.app-aws-subnet-public,
    aws_subnet.app-aws-subnet-database,
  ]

  vpc_id = aws_vpc.app-aws-vpc.id
  name = var.app-aws-private-ssh-security-group-name  # "private-ssh-sg-terraform-demo-architecture"
  description = var.app-aws-private-ssh-security-group-description

  # Allow access to other ssh servers from bastion host
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.app-aws-public-ssh-security-group.id]
  }

  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    security_groups = [aws_security_group.app-aws-public-ssh-security-group.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app-aws-private-security-group" {
  depends_on = [
    aws_vpc.app-aws-vpc,
    aws_subnet.app-aws-subnet-private,
    aws_subnet.app-aws-subnet-public,
    aws_subnet.app-aws-subnet-database,
  ]

  vpc_id = aws_vpc.app-aws-vpc.id
  name = var.app-aws-private-security-group-name  # "private-sg-terraform-demo-architecture"
  description = var.app-aws-private-security-group-description

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.app-aws-public-ssh-security-group.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# database security group
resource "aws_security_group" "app-aws-database-security-group" {
  depends_on = [
    aws_vpc.app-aws-vpc,
    aws_subnet.app-aws-subnet-private,
    aws_subnet.app-aws-subnet-public,
    aws_subnet.app-aws-subnet-database,
    aws_security_group.app-aws-private-security-group,
  ]

  vpc_id = aws_vpc.app-aws-vpc.id
  name = var.app-aws-database-security-group-name  # "database-sg-terraform-demo-architecture"
  description = var.app-aws-database-security-group-description

  # Allow access to database from instances having private security group only
  ingress {
    from_port = var.app-aws-database-security-group-ports.from_port
    to_port = var.app-aws-database-security-group-ports.to_port
    protocol = var.app-aws-database-security-group-ports.protocol
    security_groups = [aws_security_group.app-aws-private-security-group.id]
  }

  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    security_groups = [
      aws_security_group.app-aws-public-ssh-security-group.id,
      aws_security_group.app-aws-private-security-group.id,
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# private web security group for private web servers and internal use
resource "aws_security_group" "app-aws-private-web-security-group" {
  depends_on = [
    aws_vpc.app-aws-vpc,
    aws_subnet.app-aws-subnet-private,
    aws_subnet.app-aws-subnet-public,
    aws_subnet.app-aws-subnet-database,
    aws_security_group.app-aws-private-security-group,
  ]

  vpc_id = aws_vpc.app-aws-vpc.id
  name = var.app-aws-private-web-security-group-name  # "private-web-sg-terraform-demo-architecture"
  description = var.app-aws-private-web-security-group-description

  # Allow access to web servers from anywhere in the world by default
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.app-aws-private-security-group.id]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [aws_security_group.app-aws-private-security-group.id]
  }

  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    security_groups = [
      aws_security_group.app-aws-public-ssh-security-group.id,
      aws_security_group.app-aws-private-security-group.id,
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# public web security group for public web servers facing the world
resource "aws_security_group" "app-aws-public-web-security-group" {
  depends_on = [
    aws_vpc.app-aws-vpc,
    aws_subnet.app-aws-subnet-private,
    aws_subnet.app-aws-subnet-public,
    aws_subnet.app-aws-subnet-database,
  ]

  vpc_id = aws_vpc.app-aws-vpc.id
  name = var.app-aws-public-web-security-group-name  # "public-sg-terraform-demo-architecture"
  description = var.app-aws-public-web-security-group-description

  # Allow access to web servers from anywhere in the world by default
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

