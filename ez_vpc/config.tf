##############################################################################
# Dynamic Config
##############################################################################

module "dynamic_acl_allow_rules" {
  source  = "./dynamic_acl_allow_rules"
  subnets = local.subnets
  prefix  = var.prefix
}
##############################################################################


##############################################################################
# Local configuration
##############################################################################

locals {
  override = jsondecode(var.override_json)
  ##############################################################################
  # Create Subnet rules for VPC
  ##############################################################################
  subnets = {
    zone-1 = var.allow_inbound_traffic ? [
      {
        name = "allow-all"
        cidr = "0.0.0.0/0"
      },
      {
        name           = "subnet-zone-1"
        cidr           = "10.10.10.0/24"
        public_gateway = true
      }
      ] : [
      {
        name           = "subnet-zone-1"
        cidr           = "10.10.10.0/24"
        public_gateway = true
      }
    ],
    zone-2 = [
      {
        name           = "subnet-zone-2"
        cidr           = "10.20.10.0/24"
        public_gateway = true
      }
    ],
    zone-3 = [
      {
        name           = "subnet-zone-3"
        cidr           = "10.30.10.0/24"
        public_gateway = true
        acl_name       = "acl"
      }
    ]
  }
  ##############################################################################

  ##############################################################################
  # VPC config
  ##############################################################################
  config = {
    vpc_name       = "vpc"
    classic_access = var.classic_access
    subnets = {
      zone-1 = [
        {
          name           = "subnet-zone-1"
          cidr           = "10.10.10.0/24"
          public_gateway = true
          acl_name       = "acl"
        }
      ]
      zone-2 = [
        {
          name           = "subnet-zone-2"
          cidr           = "10.20.10.0/24"
          public_gateway = true
          acl_name       = "acl"
        }
      ]
      zone-3 = [
        {
          name           = "subnet-zone-3"
          cidr           = "10.30.10.0/24"
          public_gateway = true
          acl_name       = "acl"
        }
      ]
    }
    network_acls = [
      {
        name              = "acl"
        add_cluster_rules = var.add_cluster_acl_rules
        rules = flatten([
          module.dynamic_acl_allow_rules.rules,
          {
            name        = "allow-all-outbound"
            action      = "allow"
            direction   = "outbound"
            destination = "0.0.0.0/0"
            source      = "0.0.0.0/0"
          }
        ])
      }
    ]
    use_public_gateways = {
      zone-1 = var.use_public_gateways ? true : false
      zone-2 = var.use_public_gateways ? true : false
      zone-3 = var.use_public_gateways ? true : false
    }
  }

  ##############################################################################

  ##############################################################################
  # Environment
  ##############################################################################

  env = {
    prefix                      = lookup(local.override, "prefix", var.prefix)
    vpc_name                    = lookup(local.override, "vpc_name", local.config.vpc_name)
    classic_access              = lookup(local.override, "classic_access", local.config.classic_access)
    network_acls                = lookup(local.override, "network_acls", local.config.network_acls)
    use_public_gateways         = lookup(local.override, "use_public_gateways", local.config.use_public_gateways)
    subnets                     = lookup(local.override, "subnets", local.config.subnets)
    use_manual_address_prefixes = lookup(local.override, "use_manual_address_prefixes", null)
    default_network_acl_name    = lookup(local.override, "default_network_acl_name", null)
    default_security_group_name = lookup(local.override, "default_security_group_name", null)
    default_routing_table_name  = lookup(local.override, "default_routing_table_name", null)
    address_prefixes            = lookup(local.override, "address_prefixes", null)
    routes                      = lookup(local.override, "routes", [])
    vpn_gateways                = lookup(local.override, "vpn_gateways", [])
  }

  ##############################################################################

  ##############################################################################
  # Output data
  ##############################################################################
  string = "\"${jsonencode(local.env)}\""
  ##############################################################################
}

##############################################################################

##############################################################################
# Convert Environment to escaped readable string
##############################################################################

data "external" "format_output" {
  program = ["python3", "${path.module}/scripts/output.py", local.string]
}

##############################################################################