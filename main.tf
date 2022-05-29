provider "aws" {
  region = "ap-northeast-2"
}

variable "vpc-id" {
  description = "The VPC's id"
  type = string
  default = "vpc-0987dbd997f01ea0e"
}

variable "public-subnet1" {
  type = string
  default = "subnet-0e7e882226867dcb6"
}

variable "public-subnet2" {
  type = string
  default = "subnet-08a3d30fa40e441fd"
}

variable "server_port" {
  description = "The Port the server will use for HTTP requests"
  type = number
  default = 8080
}

resource "aws_launch_configuration" "example" {
  image_id = "ami-063454de5fe8eba79"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "<h1>Hello, World!!</h1><br><br><hr>" > index.html
              echo "Host: `uname -a`" >> index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name

  min_size = 2
  max_size = 2

  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
  vpc_zone_identifier = [var.public-subnet1, var.public-subnet2]
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  vpc_id = var.vpc-id 

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

