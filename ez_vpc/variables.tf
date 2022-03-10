##############################################################################
# Account Variables
##############################################################################

variable "prefix" {
  description = "A unique identifier for resources. Must begin with a letter. This prefix will be prepended to any resources provisioned by this template."
  type        = string
  default     = "ez-multizone"

  validation {
    error_message = "Prefix must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([A-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.prefix))
  }
}

variable "region" {
  description = "Region where VPC will be created. To find your VPC region, use `ibmcloud is regions` command to find available regions."
  type        = string
  default     = "us-south"
}

variable "resource_group" {
  description = "Name of existing resource group where all infrastructure will be provisioned"
  type        = string
  default     = "asset-development"

  validation {
    error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.resource_group))
  }
}

variable "tags" {
  description = "List of tags to apply to resources created by this module."
  type        = list(string)
  default     = ["ez-vpc", "multizone-vpc"]
}

##############################################################################


##############################################################################
# VPC Variables
##############################################################################

variable "use_public_gateways" {
  description = "Add a public gateway in each zone."
  type        = bool
  default     = true
}

variable "add_cluster_acl_rules" {
  description = "Add all needed rules to allow an IBM managed cluster to work on your VPC subnes."
  type        = bool
  default     = false
}

variable "allow_inbound_traffic" {
  description = "Add a rule to the ACL to allow for inbound traffic from any IP address."
  type        = bool
  default     = true
}

variable "classic_access" {
  description = "Add the ability to access classic infrastructure from your VPC."
  type        = bool
  default     = false
}

variable "override_json" {
  description = "Override any values with JSON to create a completely custom network. All quotation marks must be correctly escaped."
  type        = string
  default     = "{}"

  validation {
    error_message = "Override JSON must be able to be parsed by Terraform."
    condition     = can(jsondecode(var.override_json))
  }
}

##############################################################################