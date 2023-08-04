resource "aws_instance" "project04_bastion" {
    ami = data.aws_ami.ubuntu.image_id 
    instance_type = "t2.micro" 
    key_name = "project04-key"
    #보안 그룹
    vpc_security_group_ids = [aws_security_group.project04_ssh_sg.id]
    #서브넷 
    subnet_id = "subnet-07520d03716ae0e01"
    #가용 영역
    availability_zone = "ap-northeast-2a"
    #퍼블릭 IP 할당 여부 
    associate_public_ip_address = true

    tags = {
        Name = "project04-bastion"
    }
}


#SSH Security group
resource "aws_security_group" "project04_ssh_sg" {
    name   = "Project04 SSH Accept"
    description = "security group for SSH server"
    vpc_id = "vpc-0ef5fd852b154d136"


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
