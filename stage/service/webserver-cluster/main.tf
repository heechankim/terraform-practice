provider "aws" {
  region = "ap-northeast-2"
}

module "webserver-cluster" {
  source = "../../../module/services/webserver-cluster"
}
