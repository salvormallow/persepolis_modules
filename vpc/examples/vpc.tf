variable "prefix" {}
variable "instance_type" {}
variable "key_name" {}
variable "block_vol_type" {}
variable "test_instance_name" {}
variable "region" {
  default = "us-east-1"
}


provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./.."
  prefix = var.prefix
}

data "aws_ami" "image_id" {
  most_recent = true
  owners = ["self"]
  name_regex = "^persepolis-customer-simulation-*"
}

resource "aws_instance" "test_instance" {
  ami           = data.aws_ami.image_id.id
  instance_type = var.instance_type
  key_name = var.key_name

  root_block_device {
    volume_type = var.block_vol_type
    delete_on_termination = true
  }


  subnet_id = module.vpc.aws_subnet_public_subnet
  vpc_security_group_ids = [module.vpc.aws_customer_sg]

  tags = {
    Name = "${var.prefix}-${var.test_instance_name}"
  }
}

output "instance_id" {
  value = "${aws_instance.test_instance.id}"
}
output "instance_public_ip" {
  value = "${aws_instance.test_instance.public_ip}"
}
