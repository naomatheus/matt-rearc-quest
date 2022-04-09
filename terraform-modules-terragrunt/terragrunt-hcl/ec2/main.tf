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

provider "aws" {
    profile = "default"
    region = "${var.region}"
}

module "ec2_instance" {
    source = "terraform-aws-modules/ec2-instance/aws"
    version = "~> 3.4"

    name = var.name
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    monitoring = var.monitoring

    vpc_security_group_ids = [data.aws_security_group.ssh_tcp_sg.id] 

    subnet_id = "${data.aws_subnet.public_subnet_a.id}"

    # if AZ spread can assist with availability of a service, it would warrant multiple instances deployed across AZs    
    # for_each = toset(data.aws_subnets.private_subnets.ids)
    # subnet_id = each.value

    depends_on = [aws_key_pair.rearc-rsa]

}

resource "aws_key_pair" "rearc-rsa" {
  key_name = "rearc-rsa"
  public_key = file("~/.ssh/rearc-rsa.pub")
}