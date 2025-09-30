output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value = [aws_subnet.public_subnet.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]
}
