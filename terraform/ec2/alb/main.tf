provider "aws" {
  region = "ap-northeast-2"
}

#로드밸런서 생성 
resource "aws_lb" "project04-lb" {
	name			= "project04-lb"
	load_balancer_type	= "application"
#로드밸런스 생성되는 vpc의 서브넷 
	subnets			= [data.terraform_remote_state.project04_vpc.outputs.public_subnet2a,data.terraform_remote_state.project04_vpc.outputs.public_subnet2c]
	#data.terraform_remote_state.project04_vpc.outputs.public_subnet2a
#로드밸런스에 사용할 보안 그룹들 
	security_groups		= [data.terraform_remote_state.project04_sg.outputs.project04_alb]
} 

#jenkins 리스너 - HTTP:80
resource "aws_lb_listener" "http" {
  load_balancer_arn	= aws_lb.project04-lb.arn
  port				= 80
  protocol			= "HTTP"

  default_action {
    type			= "forward"
    target_group_arn= aws_lb_target_group.asg.arn
  } 
}

#target 리스너 HTTP:8080
resource "aws_lb_listener" "HTTP" {
  load_balancer_arn = aws_lb.project04-lb.arn
  port				= 8080
  protocol			= "HTTP"

  default_action {
    type            = "forward"
    target_group_arn= aws_lb_target_group.asg-jenkins.arn
  } 
}

#target 리스너 HTTPS:443
resource "aws_lb_listener" "HTTPS" {
  load_balancer_arn = aws_lb.project04-lb.arn
  port				= 443
  protocol			= "HTTPS"

  default_action {
    type            = "forward"
    target_group_arn= aws_lb_target_group.asg-jenkins.arn
  } 
}




#로드밸런서 리스너 룰 구성
#resource "aws_lb_listener_rule" "http" {
#	listener_arn	= aws_lb_listener.http.arn
#	priority		= 100
#
#	condition {
#		path_pattern {
#			values	= ["*"]
#		}
# }
#
#	action {
#		type				= "forward"
#		target_group_arn	= aws_lb_target_group.asg.arn
#		}
#}


#resource "aws_lb_listener_rule" "HTTP" {
#	listener_arn	= aws_lb_listener.http.arn
#	priority		= 100
#
#	condition {
#		path_pattern {
#			values	= ["*"]
#		}
#	}

#	action {
#		type				= "forward"
#		target_group_arn	= aws_lb_target_group.asg-jenkins.arn
#		}
#}



#로드밸런서 대상그룹 
resource "aws_lb_target_group" "asg" {
	name	= "project04-target-group"
	port	= var.server_port
	protocol	= "HTTP"
	vpc_id		= data.terraform_remote_state.project04_vpc.outputs.vpc_id

	health_check {
		path		        = "/"
		protocol	        = "HTTP"
		matcher		        = "200"
		interval 	        = 15
		timeout		        = 3
		healthy_threshold	= 2
		unhealthy_threshold	= 2
	}	
}


resource "aws_lb_target_group" "asg-jenkins" {
  name        = "project04-target-group-jenkins"
  port        = var.server_port
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.project04_vpc.outputs.vpc_id

	health_check {
		path		        = "/"
		protocol	        = "HTTP"
		matcher		        = "200"
		interval 	        = 15
		timeout		        = 3
		healthy_threshold	= 2
		unhealthy_threshold	= 2
	}	
}


#정보 가져 오기
data "template_file" "web_output" {
	template = file("${path.module}/web.sh")
	vars = {
		server_port = "${var.server_port}"
	}
}

variable "server_port" {
  description = "The port will use for HTTP requests"
  type        = number
  default     = 8080
}
