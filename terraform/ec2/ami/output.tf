output "ami_id" {
    value = aws_ami_from_instance.project04_target_ami.id
}