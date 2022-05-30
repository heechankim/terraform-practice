provider "aws" {
  region = "ap-northeast-2"
}

variable "vpc-id" {
  description = "The VPC's id"
  type        = string
  default     = "vpc-0987dbd997f01ea0e"
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [var.vpc-id]
  }
}

module "asg" {
  source = "../../module/cluster/asg-rolling-deploy"

  cluster_name  = "asg-test"
  ami           = "ami-063454de5fe8eba79"
  instance_type = "t2.micro"

  min_size           = 1
  max_size           = 1
  enable_autoscaling = false

  subnet_ids = data.aws_subnets.default.ids
}
