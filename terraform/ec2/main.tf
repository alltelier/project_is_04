#bastion ec2
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

#jenkins ec2 
resource "aws_instance" "project04-jenkins" {
    ami = data.aws_ami.ubuntu.image_id
    instance_type = "t3.large"
    key_name = "project04-key"
    #보안 그룹
    vpc_security_group_ids = [aws_security_group.project04_ssh_sg.id,aws_security_group.project04_web_sg.id]
    #서브넷 
    subnet_id = "subnet-025a662567c217d0d"
    #가용 영역
    availability_zone = "ap-northeast-2a"
    #퍼블릭 IP 할당 여부 
    associate_public_ip_address = false 

    tags = {
        Name = "project04-jenkins"
    }
}

#target ec2 
resource "aws_instance" "project04-target" {
    ami = data.aws_ami.ubuntu.image_id
    instance_type = "t2.micro"
    key_name = "project04-key"
    #보안 그룹
    vpc_security_group_ids = [aws_security_group.project04_web_sg.id,aws_security_group.project04_alb_sg.id]
    #서브넷 
    subnet_id = "subnet-05e643d7722c35b2f"
    #가용 영역
    availability_zone = "ap-northeast-2c"
    #퍼블릭 IP 할당 여부 
    associate_public_ip_address = false 

    tags = {
        Name = "project04-target"
    }
}


#시작템플릿 
resource "aws_launch_template" "project04-target-image" {
	name			= "project04-launch-template"
	image_id        = "ami-07f8ff23bb80925d1"
    # 
  	instance_type   = "t2.micro"
 	vpc_security_group_ids 	= [aws_security_group.project04_web_sg.id,aws_security_group.project04_alb_sg.id]
	key_name 				= "project04-key"
  
	lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "project04-target-group" {
 # availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]
  vpc_zone_identifier = ["subnet-07520d03716ae0e01", "subnet-0b6b4369668ab5265"]

  name             = "project04-target-group"
  desired_capacity = 3
  min_size         = 3
  max_size         = 3

  launch_template {
    id      = aws_launch_template.project04-target-image.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "project04-target-group"
    propagate_at_launch = true
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



#WEB Security group - HTTP 8080
resource "aws_security_group" "project04_web_sg" {
    name        = "Project04 WEB Accept"
    description = "security group for WEB server"
    vpc_id      = "vpc-0ef5fd852b154d136"

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
resource "aws_security_group" "project04_alb_sg" {
    name        = "Project04 ALB Accept"
    description = "security group for ALB server"
    vpc_id      = "vpc-0ef5fd852b154d136"


    ingress {
        description = "For WEB port"
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "For WEB port"
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Project04 ALB Accept"
        Description = "security group for ALB server"
    }
}

variable "vpc_id" {
	default = "<vpc-id>"
}

variable "subnet_public_1" {
	default = "<subnet-id>"
}

variable "subnet_public_2" {
	default = "<subnet-id>"
}
