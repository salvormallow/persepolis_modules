output "aws_customer_sg" {
  value = aws_security_group.customer_sg.id
}

output "aws_subnet_public_subnet" {
  value = aws_subnet.public_subnet.id
}