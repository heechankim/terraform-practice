provider "aws" {
  region = "ap-northeast-2"
}

variable "server_name" {
  description = "The name of web server"
  type = string
  default = "terra-example"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

resource "aws_security_group" "instance" {
  name = "${var.server_name}"

  vpc_id = "vpc-03c1e8a33ab568b4f"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "terra-example" {
  ami = "ami-063454de5fe8eba79"
  instance_type = "t2.micro"
  subnet_id = "subnet-02abe304152c47909"
  
  vpc_security_group_ids = [aws_security_group.instance.id]

  associate_public_ip_address = true

  user_data = <<-EOF
                  #!/bin/bash
                  echo "Hello, World!!\n${var.server_name}" > index.html
                  nohup busybox httpd -f -p ${var.server_port} &
                  EOF

  tags = {
    Name = "${var.server_name}"
  }
}

output "server_ip" {
  value = aws_instance.terra-example.public_ip
  description = "The Public IP address of the webserver"
}
