data "terraform_remote_state" "project04_target" {
    backend = "s3"
    config = {
        bucket = "project04-terraform-state"
        key    = "infra/ec2/target/terraform.tfstate"
        region = "ap-northeast-2"
    }
}