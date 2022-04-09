# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that supports locking and enforces best
# practices: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# Include all settings from the root terragrunt.hcl file
include "root" {
    path = find_in_parent_folders()
}

terraform {
    source = "../../terraform-mod/vpc"
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------


inputs = {
    
    vpc_name = "dev-vpc"
    
    cidr_range = "10.7.0.0/16"
    a_zones = ["us-east-2a","us-east-2b","us-east-2c"]

    network_prefix = "10.7"
    
    ## SUBNETS ##
        # Note: enable these values and enter existing SUBNETS if they already exist 
        # priv_sub_exists = true
        # pub_sub_exists = true
        # priv_sub_list = []
        # pub_sub_list = []
    ## SUBNETS ##




}