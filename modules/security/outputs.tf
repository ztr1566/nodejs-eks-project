output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "private_sg_id" {
  value = aws_security_group.private_sg.id
}