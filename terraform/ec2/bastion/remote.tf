#VPC 정보 가져옴 
data "terraform_remote_state" "project04_vpc" {
    backend = "s3"
    config = {
        bucket  = "project04-terraform-state"
        key     = "infra/network/vpc/terraform.tfstate"
        region  = "ap-northeast-2"
    }
}

#보안그룹 정보 가져옴 
data "terraform_remote_state" "project04_sg" {
    backend = "s3"
    config = {
        bucket = "project04-terraform-state"
        key    = "infra/network/sg/terraform.tfstate"
        region = "ap-northeast-2"
    }
}
