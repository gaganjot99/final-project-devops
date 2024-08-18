output "public_ips" {
    value = aws_instance.public_servers[*].public_ip
}

output "public_instances_ids" {
    value = aws_instance.public_servers[*].id
}

output "private_instances_ids" {
    value = aws_instance.private_servers[*].id
}

output "private_ips" {
    value = aws_instance.private_servers[*].private_ip
}