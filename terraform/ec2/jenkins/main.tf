#jenkins ec2 
resource "aws_instance" "project04-jenkins" {
    ami = data.aws_ami.ubuntu.image_id
    instance_type = "t3.large"
    key_name = "project04-key"
    #보안 그룹
    vpc_security_group_ids = [data.terraform_remote_state.project04_sg.outputs.project04_ssh,data.terraform_remote_state.project04_sg.outputs.project04_web]
    #서브넷 
    subnet_id = data.terraform_remote_state.project04_vpc.outputs.private_subnet2a
    #가용 영역
    availability_zone = "ap-northeast-2a"
    #퍼블릭 IP 할당 여부 
    associate_public_ip_address = false 

    tags = {
        Name = "project04-jenkins"
    }
}