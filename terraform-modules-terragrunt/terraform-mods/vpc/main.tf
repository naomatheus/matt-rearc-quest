terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.27"
        }
    }
    
    required_version = ">= 0.14.9"

    # Now terragrunt will fill the s3 backend object
    backend "s3" {}
}



provider "aws" {
    profile = "default"
    region = "us-east-2"
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "~>3.14"

    name = var.vpc_name
    
    # 16 bit mask
    cidr = var.cidr_range
    azs = var.a_zones
    
    # separate subnet creation from vpc module
    public_subnets = ["${var.network_prefix}.0.0/24","${var.network_prefix}.1.0/24"]
    private_subnets = ["${var.network_prefix}.15.0/24","${var.network_prefix}.16.0/24"]

    # Network Address Translation Gateway - 
    # enable resources in a private subnet to connect to the public internet or to AWS services
    enable_nat_gateway = true
    enable_dns_hostnames = true
    
    # Flow logs for debugging
    enable_flow_log = true
    create_flow_log_cloudwatch_iam_role = true
    create_flow_log_cloudwatch_log_group = true
    flow_log_cloudwatch_log_group_name_prefix = "/dev-vpc/flow-log/"
    flow_log_file_format = "parquet"
    flow_log_destination_type = "cloud-watch-logs"


    # public_subnets = ["${var.network_prefix}.0.0/24","${var.network_prefix}.1.0/24"]
    # private_subnets = ["${var.network_prefix}.15.0/24","${var.network_prefix}.16.0/24"]
    private_inbound_acl_rules = [ 
        {
            "cidr_block": "0.0.0.0/0",
            "from_port" : 1024,
            "protocol":"6" # TCP
            "rule_action":"allow",
            "rule_number":100,
            "to_port": 65535,
        },
        {
            "cidr_block": "${var.network_prefix}.0.0/24",
            "from_port" : 1024,
            "protocol":"6" # TCP
            "rule_action":"allow",
            "rule_number":101,
            "to_port": 65535,
        }
    ]

    private_outbound_acl_rules = [ 
        {
            "cidr_block": "0.0.0.0/0",
            "from_port" : 80,
            "protocol":"6" # TCP
            "rule_action":"allow",
            "rule_number":102,
            "to_port":  80,
        },
        {
            "cidr_block": "0.0.0.0/0",
            "from_port" : 443,
            "protocol":"6" # TCP
            "rule_action":"allow",
            "rule_number":103,
            "to_port":  443,
        },
        {
        # public subnet cidr
            "cidr_block": "${var.network_prefix}.0.0/24",
            "from_port" : 80,
            "protocol":"6" # TCP
            "rule_action":"allow",
            "rule_number":104,
            "to_port":  80,
        },
        {
        # public subnet cidr
            "cidr_block": "${var.network_prefix}.0.0/24",
            "from_port" : 443,
            "protocol":"6" # TCP
            "rule_action":"allow",
            "rule_number":105,
            "to_port":  443,
        }
    ]

    public_inbound_acl_rules = [ 
        {
        # private subnet cidr
            "cidr_block": "${var.network_prefix}.15.0/24",
            "from_port" : 443,
            "protocol":"6" # TCP
            "rule_action":"allow",
            "rule_number":106,
            "to_port":  443,
        },
        {
            "cidr_block": "0.0.0.0/0",
            "from_port" : 80,
            "protocol":"6" # TCP
            "rule_action":"allow",
            "rule_number":107,
            "to_port":  80,
        },
        {
            "cidr_block": "0.0.0.0/0",
            "from_port" : 1024,
            "protocol":"6" # TCP
            "rule_action":"allow",
            "rule_number":108,
            "to_port":  65536,
        }
    ]

    public_outbound_acl_rules = [ 
        {
            "cidr_block": "0.0.0.0/0",
            "from_port" : 443,
            "protocol":"6" # TCP
            "rule_action":"allow",
            "rule_number":109,
            "to_port":  443,
        },
        {
            "cidr_block": "0.0.0.0/0",
            "from_port" : 80,
            "protocol":"6" # TCP
            "rule_action":"allow",
            "rule_number":110,
            "to_port":  80,
        },
        {
        # private subnet cidr
            "cidr_block": "${var.network_prefix}.15.0/24",
            "from_port" : 1024,
            "protocol":"6" # TCP
            "rule_action":"allow",
            "rule_number":110,
            "to_port":  65535,
        }
    ]

    tags = {
        purpose = "development account vpc"
        deployment = "terraform"
        environment = var.environment
    }
}