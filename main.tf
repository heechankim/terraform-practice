provider "aws" {
  region = "ap-northeast-2"
}

variable "server_port" {
  description = "The Port the server will use for HTTP requests"
  type = number
  default = 8080
}

resource "aws_instance" "example" {
  ami = "ami-063454de5fe8eba79"
  instance_type = "t2.micro"
  subnet_id = "subnet-0e7e882226867dcb6" 
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!!" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  vpc_id = "vpc-0987dbd997f01ea0e" 

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  description = "The public IP address of the web server"
  value = aws_instance.example.public_ip
}
