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

module "alb" {
    source  = "terraform-aws-modules/alb/aws"
    version = "~>6.4"

    name = "rearc-quest-alb"

    load_balancer_type = "application"

    vpc_id = "${data.aws_vpc.dev_vpc.id}"
    subnets = ["${data.aws_subnet.public_subnet_a.id}","${data.aws_subnet.public_subnet_b.id}"]
    security_groups = ["${data.aws_security_group.load_balancer_sg.id}"]

    # access_logs = {
    #     # Would fill in production
    # }

    # LB target group
    target_groups = [
        # receive HTTP traffic on port 80
        {
            name_prefix = "rearc-"
            backend_protocol = "HTTP"
            backend_port = 80
            target_type = "instance"
            targets = [
                {
                    target_id = "i-0067a26e45897650c"
                    port = 3000
                    health_check = {
                        path = "/secret_word"
                    }
                }
            ]
        },
        {
            name_prefix = "rearc-ssl-"
            backend_protocol = "HTTPS"
            backend_port = 443
            target_type = "instance"
            targets = [
                {
                    target_id = "i-0067a26e45897650c"
                    port = 3000
                    health_check = {
                        path = "/secret_word"
                    }
                }
            ]
        }
    ]

    # LB Listeners
    ## Forward traffic received at 80 to 3000 on target
    http_tcp_listeners = [
        {
            port = 80
            protocol = "HTTP"
            action_type = "forward"
            forward = {
                port = "3000"
                protocol = "TCP"
                status_code = 200
            }

        }
    ]

    https_tcp_listeners = [
        {
            port = 443
            protocol = "HTTPS"
            certificate_arn = "arn:aws:iam::892307477546:server-certificate/certificate"
            action_type = "forward"
            forward = {
                port = "3000"
                protocol = "TCP"
                status_code = 200
            }
        }
    ]

    tags = {
        purpose = "${var.purpose_tag}"
        deployment = "terraform"
        region = "${var.region}"
    }

}