variable "prefix" {}


//VPC configuration
variable "customer_vpc_name" {
  default = "vpc_customer"
}
variable "customer_vpc_cidr_block" {
  default = "10.0.0.0/16"
}
variable "private_cidr" {
  default = "10.0.1.0/24"
}

variable "public_cidr" {
  default = "10.0.2.0/24"
}

variable "subnet_availability_zone" {
  default = "us-east-1a"
}

variable "public_subnet_name" {
  default = "customer_public_sub"
}

variable "private_subnet_name" {
  default = "customer_private_sub"
}

variable "customer_gw_name" {
  default = "customer_internet_gw"
}

variable "public_route_name" {
  default = "customer_public_route"
}
