provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "default-vpc"
  }

  force_destroy = true
}

resource "aws_default_subnet" "default" {
  tags = {
    Name = "default-subnet"
  }

  availability_zone = "ap-northeast-2a"
  force_destroy = true
}

resource "aws_instance" "this" {
  ami = "ami-063454de5fe8eba79"
  instance_type = "t2.micro"

  tags = {
    Name = "test instance"
  }
  subnet_id = aws_default_subnet.default.id
}

