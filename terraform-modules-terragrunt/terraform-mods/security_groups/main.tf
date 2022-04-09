terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.27"
        }
    }
    
    required_version = ">= 0.14.9"

    backend "s3" {}
}

module "webserver_sg" {

    source = "terraform-aws-modules/security-group/aws//modules/http-80"
    version = "~>4.8.0"

    name        = "web-server-sg"
    description = "Security group allowing access to HTTP on deployed servers"
    vpc_id      = "${data.aws_vpc.dev-vpc.id}"

    ingress_cidr_blocks      = ["10.10.0.0/16"]

    tags = {
        purpose = "${var.purpose_tag}"
        deployment = "terraform"
        Name = "webserver-sg"
    }
}


# module "ssh" {

#     source = "terraform-aws-modules/security-group/aws//modules/ssh-tcp"

#     name        = "ssh"
#     description = "Security group allowing SSH access on deployed servers"
#     vpc_id      = "${data.aws_vpc.dev-vpc.id}"

#     ingress_cidr_blocks      = ["0.0.0.0/16"]

#     tags = {
#         purpose = "${var.ssh_purpose_tag}"
#         deployment = "terraform"
#         Name = "ssh-sg"
#     }
# }