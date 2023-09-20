#target ec2 
resource "aws_instance" "project04-target" {
    ami = data.aws_ami.ubuntu.image_id
    instance_type = "t2.micro"
    key_name = "project04-key"
    vpc_security_group_ids = [data.terraform_remote_state.project04_sg.outputs.project04_ssh,data.terraform_remote_state.project04_sg.outputs.project04_alb]
    subnet_id = data.terraform_remote_state.project04_vpc.outputs.private_subnet2c
    availability_zone = "ap-northeast-2c" 
    associate_public_ip_address = false 
    iam_instance_profile = "project04-code-deploy-ec2-role"
      
    tags = {
        Name = "project04-target"
    }
}

#target-ec2에 적용할 iam_instance_profile 생성 
#resource "aws_iam_instance_profile" "ec2-role" {
#  name = "project04-ec2-role" 
#  role = data.aws_iam_role.code-deploy.name
#}
#iam_instance_profile 생성을 위한 iam_role 불러오기 
#data "aws_iam_role" "code-deploy" {
#    name = "project04-code-deploy-ec2-role"
#}


