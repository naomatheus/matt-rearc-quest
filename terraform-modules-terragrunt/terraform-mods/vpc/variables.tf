variable "environment" {
  default = "dev"
}

variable "vpc_name" {
    default = ""
}

variable "cidr_range" {
    type = string
    default = ""
}

variable "a_zones" {
    default = []
    type = list
}

variable "network_prefix" {
  default = "10.0."
}

# # if subnets exist already flip to true 
# variable "priv_sub_exists" {
#     default = false
#     type = bool
# }

# # if subnets exist already flip to true 
# variable "pub_sub_exists" {
#     default = false
#     type = bool
# }


# variable "priv_sub_list" {
#     type = list(string)
#     default = []
# }

# variable "pub_sub_list" {
#     type = list(string)
#     default = []
# }

