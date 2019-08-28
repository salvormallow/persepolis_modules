resource "aws_vpc" "customer_vpc" {
  cidr_block = var.customer_vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix}-${var.customer_vpc_name}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.customer_vpc.id
  cidr_block = var.private_cidr
  availability_zone = var.subnet_availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.prefix}-${var.private_subnet_name}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.customer_vpc.id
  cidr_block = var.public_cidr
  availability_zone = var.subnet_availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-${var.public_subnet_name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.customer_vpc.id

  tags = {
    Name = "${var.prefix}-${var.customer_gw_name}"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.customer_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.prefix}-${var.public_route_name}"
  }
}

resource "aws_route_table_association" "route_subnet_public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}


resource "aws_security_group_rule" "allow_ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.customer_sg.id
}

resource "aws_security_group_rule" "allow_udp" {
  type            = "ingress"
  from_port       = 514
  to_port         = 514
  protocol        = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.customer_sg.id
}

resource "aws_security_group_rule" "allow_outbound" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "all"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.customer_sg.id
}


resource "aws_security_group" "customer_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.customer_vpc.id
}
