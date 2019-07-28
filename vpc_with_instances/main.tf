resource "aws_vpc" "customer_vpc" {
  cidr_block = var.customer_vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.env_name != "" ? "${var.env_name}-${var.customer_vpc_name}" : "${terraform.workspace}-${var.customer_vpc_name}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.customer_vpc.id
  cidr_block = var.private_cidr
  availability_zone = var.subnet_availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = var.env_name != "" ? "${var.env_name}-${var.private_subnet_name}" : "${terraform.workspace}-${var.private_subnet_name}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.customer_vpc.id
  cidr_block = var.public_cidr
  availability_zone = var.subnet_availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = var.env_name != "" ? "${var.env_name}-${var.public_subnet_name}" : "${terraform.workspace}-${var.public_subnet_name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.customer_vpc.id

  tags = {
    Name = var.env_name != "" ? "${var.env_name}-${var.customer_gw_name}" : "${terraform.workspace}-${var.customer_gw_name}"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.customer_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.env_name != "" ? "${var.env_name}-${var.public_route_name}" : "${terraform.workspace}-${var.public_route_name}"
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

resource "aws_instance" "customer_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  depends_on = ["aws_internet_gateway.igw"]

  root_block_device {
    volume_type = var.block_vol_type
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = var.ebs_device_name
    volume_size = var.ebs_disk_size
    volume_type = var.ebs_vol_type
    delete_on_termination = true
    encrypted = true
  }

  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.customer_sg.id]
  iam_instance_profile = aws_iam_instance_profile.customer_ec2_profile.name
  user_data = var.user


  tags = {
    Name = var.env_name != "" ? "${var.env_name}-${var.customer_instance_name}" : "${terraform.workspace}-${var.customer_instance_name}"
  }
}

data "template_file" "customer_ec2_template" {
  template = file("userdata/bootstrap.sh")
  vars = {
    delivery_stream_name = data.terraform_remote_state.analytics.outputs.firehose_name
  }
}