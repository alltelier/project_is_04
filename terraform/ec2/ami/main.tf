resource "aws_ami_from_instance" "project04_target_ami" {
    name                    = "project04_target_ami"
    source_instance_id      = data.terraform_remote_state.project04_target.outputs.instance_id
    snapshot_without_reboot = true

    tags = {
        Name = "project04_target_ami"
    }
}