#bastion ec2
resource "aws_instance" "project04-bastion" {
    ami = data.aws_ami.ubuntu.image_id 
    instance_type = "t2.micro" 
    key_name = "project04-key"
    vpc_security_group_ids = [data.terraform_remote_state.project04_sg.outputs.project04_ssh]
    subnet_id = data.terraform_remote_state.project04_vpc.outputs.public_subnet2a
    availability_zone = "ap-northeast-2a"
    associate_public_ip_address = true

    tags = {
        Name = "project04-bastion"
    }
}

