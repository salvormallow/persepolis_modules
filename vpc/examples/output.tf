output "instance_id" {
    value = "${aws_instance.test_instance.id}"
}
output "instance_public_ip" {
    value = "${aws_instance.test_instance.public_ip}"
}
