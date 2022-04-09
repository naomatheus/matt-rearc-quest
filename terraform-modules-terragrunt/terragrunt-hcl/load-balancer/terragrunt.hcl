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
    source = "../../terraform-mod/load-balancer"
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------

inputs = {
    purpose_tag = "This load balancer is used for public facing web servers for Rearcs quest challenge"
}