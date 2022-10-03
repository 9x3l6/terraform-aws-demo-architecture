data "aws_availability_zones" "available" {
  state = "available"
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc_cird_block # "10.42.0.0/16"
  enable_dns_support      = "true"
  enable_dns_hostnames    = "true"

  tags = {
    Name = var.vpc_name # "terraform-demo-architecture-vpc"
  }
}

# Subnets
resource "aws_subnet" "subnet_public" {
  depends_on = [
    aws_vpc.vpc
  ]

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_public_cidr_block
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.subnet_public_name
  }
}

resource "aws_subnet" "subnet_private" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet_public,
  ]

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_private_cidr_block
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.subnet_private_name
  }
}

resource "aws_subnet" "database_subnet_1" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet_private,
  ]

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_database_cidr_blocks[0]
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "DBSN-1 ${var.subnet_database_name}"
  }
}
resource "aws_subnet" "database_subnet_2" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet_private,
  ]

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_database_cidr_blocks[1]
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "DBSN-2 ${var.subnet_database_name}"
  }
}
resource "aws_subnet" "database_subnet_3" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet_private,
  ]

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_database_cidr_blocks[2]
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "DBSN-3 ${var.subnet_database_name}"
  }
}

# Internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet_public,
    aws_subnet.subnet_private,
    aws_subnet.database_subnet_1,
    aws_subnet.database_subnet_2,
  ]

  vpc_id = aws_vpc.vpc.id
  
  tags = {
    Name = var.internet_gateway_name # "terraform-demo-architecture-igw"
  }
}

# Route table
resource "aws_route_table" "route_table" {
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.internet_gateway,
  ]

  vpc_id = aws_vpc.vpc.id

  # NAT
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = var.route_table_name
  }
}

resource "aws_route_table_association" "route_table_association" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet_public,
    aws_subnet.subnet_private,
    aws_route_table.route_table,
    aws_subnet.database_subnet_1,
    aws_subnet.database_subnet_2,
  ]

  subnet_id       = aws_subnet.subnet_public.id
  route_table_id  = aws_route_table.route_table.id
}

# Security groups
resource "aws_security_group" "public_ssh_security_group" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet_public,
    aws_subnet.subnet_private,
    aws_route_table.route_table,
    aws_subnet.database_subnet_1,
    aws_subnet.database_subnet_2,
  ]

  vpc_id = aws_vpc.vpc.id
  name = var.public_ssh_security_group_name  # "public-sg-terraform-demo-architecture"
  description = var.public_ssh_security_group_description

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

resource "aws_security_group" "private_ssh_security_group" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet_public,
    aws_subnet.subnet_private,
    aws_route_table.route_table,
    aws_subnet.database_subnet_1,
    aws_subnet.database_subnet_2,
  ]

  vpc_id = aws_vpc.vpc.id
  name = var.private_ssh_security_group_name  # "private-ssh-sg-terraform-demo-architecture"
  description = var.private_ssh_security_group_description

  # Allow access to other ssh servers from bastion host
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [
      aws_security_group.public_ssh_security_group.id,
    ]
  }

  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    security_groups = [
      aws_security_group.public_ssh_security_group.id,
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_security_group" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet_public,
    aws_subnet.subnet_private,
    aws_route_table.route_table,
    aws_subnet.database_subnet_1,
    aws_subnet.database_subnet_2,
  ]

  vpc_id = aws_vpc.vpc.id
  name = var.private_security_group_name  # "private-sg-terraform-demo-architecture"
  description = var.private_security_group_description

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [
      aws_security_group.public_ssh_security_group.id,
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
resource "aws_security_group" "private_web_security_group" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet_public,
    aws_subnet.subnet_private,
    aws_route_table.route_table,
    aws_subnet.database_subnet_1,
    aws_subnet.database_subnet_2,
    aws_security_group.private_security_group,
  ]

  vpc_id        = aws_vpc.vpc.id
  name          = var.private_web_security_group_name  # "private-web-sg-terraform-demo-architecture"
  description   = var.private_web_security_group_description

  # Allow access to web servers from anywhere in the world by default
  dynamic "ingress" { 
    for_each = var.private_security_group_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      security_groups = [
        aws_security_group.private_security_group.id,
      ]
    }
  }

  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    security_groups = [
      aws_security_group.public_ssh_security_group.id,
      aws_security_group.private_security_group.id,
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
resource "aws_security_group" "public_web_security_group" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet_public,
    aws_subnet.subnet_private,
    aws_route_table.route_table,
    aws_subnet.database_subnet_1,
    aws_subnet.database_subnet_2,
  ]

  vpc_id        = aws_vpc.vpc.id
  name          = var.public_web_security_group_name  # "public-sg-terraform-demo-architecture"
  description   = var.public_web_security_group_description

  # Allow access to web servers from anywhere in the world by default
  dynamic "ingress" { 
    for_each = var.public_web_security_group_ports
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
resource "aws_security_group" "database_security_group" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet_public,
    aws_subnet.subnet_private,
    aws_route_table.route_table,
    aws_subnet.database_subnet_1,
    aws_subnet.database_subnet_2,
    aws_security_group.private_security_group,
  ]

  vpc_id        = aws_vpc.vpc.id
  name          = var.database_security_group_name  # "database-sg-terraform-demo-architecture"
  description   = var.database_security_group_description

  # Allow access to database from instances having private security group only
  ingress {
    from_port   = var.database_security_group_ports.from_port
    to_port     = var.database_security_group_ports.to_port
    protocol    = var.database_security_group_ports.protocol
    security_groups = [
      aws_security_group.private_security_group.id,
    ]
  }

  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    security_groups = [
      aws_security_group.public_ssh_security_group.id,
      aws_security_group.private_security_group.id,
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ssh_key_pair" {
  key_name    = var.ssh_key_name
  public_key  = file(var.ssh_public_key_path)  
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "bastion_host" {
  depends_on = [
    aws_vpc.vpc,
  ]
  
  instance_type = var.bastion_host_instance_type
  ami           = data.aws_ami.amazon_linux.id
  subnet_id     = aws_subnet.subnet_public.id
  key_name      = var.ssh_key_name

  vpc_security_group_ids = [
    aws_security_group.public_ssh_security_group.id,
    aws_security_group.private_security_group.id,
    aws_security_group.private_web_security_group.id,
    aws_security_group.private_ssh_security_group.id,
  ]

  tags = {
    Name = var.bastion_host_name
  }
}

resource "aws_instance" "private_server" {
  depends_on = [
    aws_vpc.vpc,
  ]
  
  count = length(var.private_server_names)

  instance_type = var.private_server_instance_type
  ami           = data.aws_ami.amazon_linux.id
  subnet_id     = aws_subnet.subnet_private.id
  key_name      = var.ssh_key_name

  vpc_security_group_ids = [
    aws_security_group.private_security_group.id,
    aws_security_group.private_web_security_group.id,
    aws_security_group.private_ssh_security_group.id,
  ]

  tags = {
    Name = var.private_server_names[count.index]
  }
}

# RDS database
resource "aws_db_subnet_group" "database_server" {
  name       = var.database_server_identifier
  subnet_ids = [
    aws_subnet.database_subnet_1.id,
    aws_subnet.database_subnet_2.id,
    aws_subnet.database_subnet_3.id,
  ]

  tags = {
    Name = var.database_subnet_group_name
  }
}

resource "aws_db_parameter_group" "database_server" {
  name   = var.database_server_identifier
  family = var.database_server_family

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "database_server" {
  identifier             = var.database_server_identifier
  instance_class         = var.database_server_instance_class
  allocated_storage      = var.database_server_allocated_storage
  engine                 = var.database_server_engine
  engine_version         = var.database_server_engine_version
  username               = var.database_server_username
  password               = var.database_server_password
  db_subnet_group_name   = aws_db_subnet_group.database_server.name
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  parameter_group_name   = aws_db_parameter_group.database_server.name
  publicly_accessible    = var.database_server_publicly_accessible
  skip_final_snapshot    = var.database_server_skip_final_snapshot
}

module "app_vpc_lambda" {
  source = "../app-aws-lambda-functions"
  server_instance_ids = join(",", aws_instance.private_server[*].id)
}
