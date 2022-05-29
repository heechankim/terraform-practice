provider "aws" {
  region = "ap-northeast-2"
}

module "webserver-cluster" {
  source = "../../../module/services/webserver-cluster"

  cluster_name = "webservers-stage"
  db_remote_state_bucket = "chan-terraform-up-and-running-state"
  db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  min_size = 2
  max_size = 2

  enable_autoscaling = false

  custom_tags = {
    Owner = "team-foo"
    DeployedBy = "terraform"
  }
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type = "ingress"
  security_group_id = module.webserver-cluster.alb_security_group_id

  from_port = 12060
  to_port = 12060
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
