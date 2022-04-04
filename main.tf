provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  vpc_id = "vpc-03c1e8a33ab568b4f"

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
  subnet_id = "subnet-02abe304152c47909"
  
  vpc_security_group_ids = [aws_security_group.instance.id]

  associate_public_ip_address = true

  user_data = <<-EOF
                  #!/bin/bash
                  echo "Hello, World!!" > index.html
                  nohup busybox httpd -f -p 8080 &
                  EOF

  tags = {
    Name = "terraform-example"
  }
}
