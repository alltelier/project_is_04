#SSH Security group
resource "aws_security_group" "project04_ssh" {
    name   = "project04_ssh"
    description = "security group for SSH server"
    vpc_id = data.terraform_remote_state.project04_vpc.outputs.vpc_id

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
        Name = "Project04 SSH Accept"
        Description = "security group for SSH server"
    }
}


#WEB Security group - HTTP 8080
resource "aws_security_group" "project04_web" {
    name        = "project04_web"
    description = "security group for WEB server"
    vpc_id      = data.terraform_remote_state.project04_vpc.outputs.vpc_id


    ingress {
        description = "For WEB port"
        protocol    = "tcp"
        from_port   = 8080
        to_port     = 8080
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Project04 WEB Accept"
        Description = "security group for WEB server"
    }
}


#WEB Security group - HTTP 80, 443
resource "aws_security_group" "project04_alb" {
    name        = "project04_alb"
    description = "security group for ALB server"
    vpc_id      = data.terraform_remote_state.project04_vpc.outputs.vpc_id


    ingress {
      description = "For Jenkins port"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol  = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "For ALB port"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol  = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "For ALB port"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol  = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Project04 ALB Accept"
        Description = "security group for ALB server"
    }
}
