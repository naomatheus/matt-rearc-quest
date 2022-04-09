variable "environment" {
  default = "dev"
}

variable "region" {
  default = "us-east-2"
}


variable "name" {
  default = ""
  type = string
}

variable "ami" {
  default = ""
  type = string
}

variable "instance_type" {
  default = ""
  type = string
}

variable "key_name" {
  default = ""
  type = string
}

variable "monitoring" {
  default = true
  type = bool
}