data "aws_availability_zones" "available" {
  state = "available"
}

# VPC
resource "aws_vpc" "app_aws_vpc" {
  cidr_block              = var.app_aws_vpc_cird_block # "10.42.0.0/16"
  enable_dns_support      = "true"
  enable_dns_hostnames    = "true"

  tags = {
    Name = var.app_aws_vpc_name # "terraform-demo-architecture-vpc"
  }
}

# Subnets
resource "aws_subnet" "app_aws_subnet_public" {
  depends_on = [
    aws_vpc.app_aws_vpc
  ]

  vpc_id                  = aws_vpc.app_aws_vpc.id
  cidr_block              = var.app_aws_subnet_public_cidr_block
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.app_aws_subnet_public_name
  }
}

resource "aws_subnet" "app_aws_subnet_private" {
  depends_on = [
    aws_vpc.app_aws_vpc,
    aws_subnet.app_aws_subnet_public,
  ]

  vpc_id            = aws_vpc.app_aws_vpc.id
  cidr_block        = var.app_aws_subnet_private_cidr_block
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.app_aws_subnet_private_name
  }
}

resource "aws_subnet" "app_aws_database_subnet_1" {
  depends_on = [
    aws_vpc.app_aws_vpc,
    aws_subnet.app_aws_subnet_private,
  ]

  vpc_id            = aws_vpc.app_aws_vpc.id
  cidr_block        = var.app_aws_subnet_database_cidr_blocks[0]
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "DBSN-1 ${var.app_aws_subnet_database_name}"
  }
}
resource "aws_subnet" "app_aws_database_subnet_2" {
  depends_on = [
    aws_vpc.app_aws_vpc,
    aws_subnet.app_aws_subnet_private,
  ]

  vpc_id            = aws_vpc.app_aws_vpc.id
  cidr_block        = var.app_aws_subnet_database_cidr_blocks[1]
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "DBSN-2 ${var.app_aws_subnet_database_name}"
  }
}
resource "aws_subnet" "app_aws_database_subnet_3" {
  depends_on = [
    aws_vpc.app_aws_vpc,
    aws_subnet.app_aws_subnet_private,
  ]

  vpc_id            = aws_vpc.app_aws_vpc.id
  cidr_block        = var.app_aws_subnet_database_cidr_blocks[2]
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "DBSN-3 ${var.app_aws_subnet_database_name}"
  }
}

# Internet gateway
resource "aws_internet_gateway" "app_aws_internet_gateway" {
  depends_on = [
    aws_vpc.app_aws_vpc,
    aws_subnet.app_aws_subnet_public,
    aws_subnet.app_aws_subnet_private,
    aws_subnet.app_aws_database_subnet_1,
    aws_subnet.app_aws_database_subnet_2,
  ]

  vpc_id = aws_vpc.app_aws_vpc.id
  
  tags = {
    Name = var.app_aws_internet_gateway_name # "terraform-demo-architecture-igw"
  }
}

# Route table
resource "aws_route_table" "app_aws_route_table" {
  depends_on = [
    aws_vpc.app_aws_vpc,
    aws_internet_gateway.app_aws_internet_gateway,
  ]

  vpc_id = aws_vpc.app_aws_vpc.id

  # NAT
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_aws_internet_gateway.id
  }

  tags = {
    Name = var.app_aws_route_table_name
  }
}

resource "aws_route_table_association" "app_aws_route_table_association" {
  depends_on = [
    aws_vpc.app_aws_vpc,
    aws_subnet.app_aws_subnet_public,
    aws_subnet.app_aws_subnet_private,
    aws_route_table.app_aws_route_table,
    aws_subnet.app_aws_database_subnet_1,
    aws_subnet.app_aws_database_subnet_2,
  ]

  subnet_id       = aws_subnet.app_aws_subnet_public.id
  route_table_id  = aws_route_table.app_aws_route_table.id
}

# Security groups
resource "aws_security_group" "app_aws_public_ssh_security_group" {
  depends_on = [
    aws_vpc.app_aws_vpc,
    aws_subnet.app_aws_subnet_public,
    aws_subnet.app_aws_subnet_private,
    aws_route_table.app_aws_route_table,
    aws_subnet.app_aws_database_subnet_1,
    aws_subnet.app_aws_database_subnet_2,
  ]

  vpc_id = aws_vpc.app_aws_vpc.id
  name = var.app_aws_public_ssh_security_group_name  # "public-sg-terraform-demo-architecture"
  description = var.app_aws_public_ssh_security_group_description

  # Allow access to bastion host from anywhere in the world by default
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_aws_private_ssh_security_group" {
  depends_on = [
    aws_vpc.app_aws_vpc,
    aws_subnet.app_aws_subnet_public,
    aws_subnet.app_aws_subnet_private,
    aws_route_table.app_aws_route_table,
    aws_subnet.app_aws_database_subnet_1,
    aws_subnet.app_aws_database_subnet_2,
  ]

  vpc_id = aws_vpc.app_aws_vpc.id
  name = var.app_aws_private_ssh_security_group_name  # "private-ssh-sg-terraform-demo-architecture"
  description = var.app_aws_private_ssh_security_group_description

  # Allow access to other ssh servers from bastion host
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [
      aws_security_group.app_aws_public_ssh_security_group.id,
    ]
  }

  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    security_groups = [
      aws_security_group.app_aws_public_ssh_security_group.id,
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_aws_private_security_group" {
  depends_on = [
    aws_vpc.app_aws_vpc,
    aws_subnet.app_aws_subnet_public,
    aws_subnet.app_aws_subnet_private,
    aws_route_table.app_aws_route_table,
    aws_subnet.app_aws_database_subnet_1,
    aws_subnet.app_aws_database_subnet_2,
  ]

  vpc_id = aws_vpc.app_aws_vpc.id
  name = var.app_aws_private_security_group_name  # "private-sg-terraform-demo-architecture"
  description = var.app_aws_private_security_group_description

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [
      aws_security_group.app_aws_public_ssh_security_group.id,
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# private web security group for private web servers and internal use
resource "aws_security_group" "app_aws_private_web_security_group" {
  depends_on = [
    aws_vpc.app_aws_vpc,
    aws_subnet.app_aws_subnet_public,
    aws_subnet.app_aws_subnet_private,
    aws_route_table.app_aws_route_table,
    aws_subnet.app_aws_database_subnet_1,
    aws_subnet.app_aws_database_subnet_2,
    aws_security_group.app_aws_private_security_group,
  ]

  vpc_id        = aws_vpc.app_aws_vpc.id
  name          = var.app_aws_private_web_security_group_name  # "private-web-sg-terraform-demo-architecture"
  description   = var.app_aws_private_web_security_group_description

  # Allow access to web servers from anywhere in the world by default
  dynamic "ingress" { 
    for_each = var.app_aws_private_security_group_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      security_groups = [
        aws_security_group.app_aws_private_security_group.id,
      ]
    }
  }
  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   security_groups = [
  #     aws_security_group.app_aws_private_security_group.id,
  #   ]
  # }
  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   security_groups = [
  #     aws_security_group.app_aws_private_security_group.id,
  #   ]
  # }

  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    security_groups = [
      aws_security_group.app_aws_public_ssh_security_group.id,
      aws_security_group.app_aws_private_security_group.id,
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# public web security group for public web servers facing the world
resource "aws_security_group" "app_aws_public_web_security_group" {
  depends_on = [
    aws_vpc.app_aws_vpc,
    aws_subnet.app_aws_subnet_public,
    aws_subnet.app_aws_subnet_private,
    aws_route_table.app_aws_route_table,
    aws_subnet.app_aws_database_subnet_1,
    aws_subnet.app_aws_database_subnet_2,
  ]

  vpc_id        = aws_vpc.app_aws_vpc.id
  name          = var.app_aws_public_web_security_group_name  # "public-sg-terraform-demo-architecture"
  description   = var.app_aws_public_web_security_group_description

  # Allow access to web servers from anywhere in the world by default
  dynamic "ingress" { 
    for_each = var.app_aws_public_web_security_group_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# database security group
resource "aws_security_group" "app_aws_database_security_group" {
  depends_on = [
    aws_vpc.app_aws_vpc,
    aws_subnet.app_aws_subnet_public,
    aws_subnet.app_aws_subnet_private,
    aws_route_table.app_aws_route_table,
    aws_subnet.app_aws_database_subnet_1,
    aws_subnet.app_aws_database_subnet_2,
    aws_security_group.app_aws_private_security_group,
  ]

  vpc_id        = aws_vpc.app_aws_vpc.id
  name          = var.app_aws_database_security_group_name  # "database-sg-terraform-demo-architecture"
  description   = var.app_aws_database_security_group_description

  # Allow access to database from instances having private security group only
  ingress {
    from_port   = var.app_aws_database_security_group_ports.from_port
    to_port     = var.app_aws_database_security_group_ports.to_port
    protocol    = var.app_aws_database_security_group_ports.protocol
    security_groups = [
      aws_security_group.app_aws_private_security_group.id,
    ]
  }

  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    security_groups = [
      aws_security_group.app_aws_public_ssh_security_group.id,
      aws_security_group.app_aws_private_security_group.id,
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
