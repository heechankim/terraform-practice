provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "example" {
  ami = "ami-063454de5fe8eba79"
  instance_type = "t2.micro"
  subnet_id = "subnet-00589220d728d28b3"
}
