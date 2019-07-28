//Instance configuration
variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "customer_instance_name" {}

//EBS configuration
variable "block_vol_type" {}
variable "ebs_device_name" {}
variable "ebs_disk_size" {}
variable "ebs_vol_type" {}
//VPC configuration
variable "customer_vpc_name" {}
variable "customer_vpc_cidr_block" {}
variable "private_cidr" {}
variable "public_cidr" {}

variable "subnet_availability_zone" {}
variable "public_subnet_name" {}
variable "private_subnet_name" {}

variable "customer_gw_name" {}
variable "public_route_name" {}