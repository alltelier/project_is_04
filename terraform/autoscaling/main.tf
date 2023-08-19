#시작템플릿 
resource "aws_launch_template" "project04-target-image" {
	name			= "project04-launch-template"
	image_id        = "ami-0ed6c821be77fa520"
  instance_type   = "t2.micro"
 	vpc_security_group_ids 	= ["sg-00f8fc4f9e7e95784","sg-0151c526c8195891f"]
	key_name 				= "project04-key"

    iam_instance_profile {
        name = "project04-code-deploy-ec2-role"
    } 
  
    tags = {
      Name = "project04-code-deploy-instance"
    }
	
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

  target_group_arns = [data.aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

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

data "aws_lb_target_group" "asg" {
    arn = "arn:aws:elasticloadbalancing:ap-northeast-2:257307634175:targetgroup/project04-target-group/c1463e0f0ca120e3"
}

