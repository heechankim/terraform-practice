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
