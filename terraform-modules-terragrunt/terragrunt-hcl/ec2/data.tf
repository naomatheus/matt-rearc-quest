data "aws_vpc" "dev_vpc" {
  filter {
      name = "tag:deployment"
      values = ["terraform"]
  }
}

data "aws_subnet" "private_subnet_a" {
    filter {
        name = "tag:Name"
        values =["dev-vpc-private-us-east-2a"]
    }
}

data "aws_subnet" "public_subnet_a" {
    filter {
        name = "tag:Name"
        values =["dev-vpc-public-us-east-2a"]
    }
}

# use for multiple ec2 deployments into all private subnets
data "aws_subnets" "private_subnets" {

  filter {
      name = "tag:Name"
      values = ["*-private-*"]
  }
}

# ssh-tcp security group
data "aws_security_group" "ssh_tcp_sg" {
    filter {
        name = "tag:Name"
        values = ["*ssh-*"]
    }
}

data "aws_security_group" "webserver_sg" {
    filter {
        name = "tag:Name"
        values = ["webserver-*"]
    }
}

data "aws_security_group" "launch_wizard" {
    filter {
        name = "tag:Name"
        values = ["launch-*"]
    }
}