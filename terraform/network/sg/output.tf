output "project04_ssh" {
    value = aws_security_group.project04_ssh.id
}

output "project04_web" {
    value = aws_security_group.project04_web.id
}

output "project04_alb" {
    value = aws_security_group.project04_alb.id
}