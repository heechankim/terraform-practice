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

resource "aws_security_group" "instance" {
  name = "sg-terra-example"

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

  min_size = 2
  max_size = 10

  tag {
    key = "Name"
    value = "terra-example-asg"
    propagate_at_launch = true
  }
}

