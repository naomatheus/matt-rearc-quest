# Dev account vpc
data "aws_vpc" "dev_vpc" {
    filter {
        name = "tag:deployment"
        values = ["terraform"]
    }
}

# load balancer sg, open to public traffic
data "aws_security_group" "load_balancer_sg" {
    filter {
        name = "tag:Name"
        values = ["load-balancer-sg"]
    }
}

# public subnet a
data "aws_subnet" "public_subnet_a" {
    filter {
        name = "tag:Name"
        values =["dev-vpc-public-us-east-2a"]
    }
}

# public subnet b
data "aws_subnet" "public_subnet_b" {
    filter {
        name = "tag:Name"
        values =["dev-vpc-public-us-east-2b"]
    }
}