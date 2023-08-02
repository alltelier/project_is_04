
#SSH Security group
resource "aws_security_group" "project04_ssh_sg" {
    name   = "project04_ssh_sg"
    description = "security group for ssh server"
    vpc_id = project04_vpc


    ingress {
        description = "For SSH port"
        protocol    = "tcp"
        from_port   = 22
        to_port     = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "project04_ssh_sg"
        Description = "SSH security group"
    }
}


#WEB Security group
resource "aws_security_group" "project04_web_sg" {
    name        = "project04_web_sg"
    description = "security group for WEB server"
    vpc_id      = project04_vpc


    ingress {
        description = "For WEB port"
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "project04_web_sg"
        Description = "WEB security group"
    }
}



