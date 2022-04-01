provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami = "ami-063454de5fe8eba79"
  instance_type = "t2.micro"
  subnet_id = "subnet-00589220d728d28b3"

  user_data = <<-EOF
                  #!/bin/bash
                  echo "Hello, World!!" > index.html
                  nohub busybox httpd -f -p 8080 &
                  EOF

  tags = {
    Name = "terraform-example"
  }
}
