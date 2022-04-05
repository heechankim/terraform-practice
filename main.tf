provider "aws" {
  region = "ap-northeast-2"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

data "aws_vpc" "selected" {
  tags = {
    Name = "default-vpc"
  }
}

data "aws_subnets" "default-sn" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_subnet" "default-public1" {
  filter {
    name = "tag:Name"
    values = ["default-subnet-public1-ap-northeast-2a"]
  }
}
data "aws_subnet" "default-public2" {
  filter {
    name = "tag:Name"
    values = ["default-subnet-public2-ap-northeast-2b"]
  }
}

resource "aws_security_group" "instance" {
  name = "terra-example-sg"

  vpc_id = data.aws_vpc.selected.id 

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "terra-example" {
  image_id = "ami-063454de5fe8eba79"
  instance_type = "t2.micro"
  
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
                  #!/bin/bash
                  echo "<h1>Hello, World!!</h1>" > index.html
                  nohup busybox httpd -f -p ${var.server_port} &
                  EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "terra-example-asg" {
  launch_configuration = aws_launch_configuration.terra-example.name

  vpc_zone_identifier = data.aws_subnets.default-sn.ids

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key = "Name"
    value = "terra-example-asg"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "alb" {
  name = "terra-example-alb"
  vpc_id = data.aws_vpc.selected.id 

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "terra-lb" {
  name = "terra-example-lb"
  load_balancer_type = "application"
  subnets = [data.aws_subnet.default-public1.id, data.aws_subnet.default-public2.id] 
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.terra-lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

resource "aws_lb_target_group" "asg" {
  name = "terra-example-asg"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.selected.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}


output "alb_dns_name" {
  value = aws_lb.terra-lb
}





