#VPC 정보를 가져오는 곳
data "terraform_remote_state" "project04_vpc" {
    backend = "s3"
    config = {
        bucket  = "project04-terraform-state"
        key     = "infra/network/vpc/terraform.tfstate"
        region  = "ap-northeast-2"
    }
}

#보안그룹 정보 
data "terraform_remote_state" "project04_sg" {
    backend = "s3"
    config = {
        bucket = "project04-terraform-state"
        key    = "infra/network/sg/terraform.tfstate"
        region = "ap-northeast-2"
    }
}

data "terraform_remote_state" "project04_target_ami" {
    backend = "s3"
    config = {
        bucket = "project04-terraform-state"
        key    = "infra/ec2/ami/terraform.tfstate"
        region = "ap-northeast-2"
    }
}