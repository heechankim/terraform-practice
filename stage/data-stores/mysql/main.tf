provider "aws" {
  region = "ap-northeast-2"
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [var.vpc-id]
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-up-and-running"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  username = "admin"

  db_subnet_group_name = aws_db_subnet_group.default.name

  password = var.db_password
}

resource "aws_db_subnet_group" "default" {
  name = "terraform-up-and-runnging"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "terraform-up-and-running"
  }
}

terraform {
  backend "s3" {
    key = "stage/data-stores/mysql/terraform.tfstate"
  }
}
