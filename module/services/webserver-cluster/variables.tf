variable "vpc-id" {
  description = "The VPC's id"
  type = string
  default = "vpc-0987dbd997f01ea0e"
}

variable "public-subnet1" {
  type = string
  default = "subnet-0e7e882226867dcb6"
}

variable "public-subnet2" {
  type = string
  default = "subnet-08a3d30fa40e441fd"
}

variable "server_port" {
  description = "The Port the server will use for HTTP requests"
  type = number
  default = 8080
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type = string
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type = string
}

variable "instance_type" {
  description = "The type of EC2 Instance to run"
  type = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type = number
}

variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  type = bool
}
