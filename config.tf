##############################################################################
# Dynamic Config
##############################################################################

module "dynamic_acl_allow_rules" {
  source  = "./dynamic_acl_allow_rules"
  subnets = local.subnets
  prefix  = var.prefix
}

##############################################################################
# Local configuration
##############################################################################

locals {
  override = jsondecode(var.override_json)
  ##############################################################################
  # List of subnets for dynamic ACL rule creation
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
      }
    ]
  }
  ##############################################################################

  ##############################################################################
  # VPC config
  ##############################################################################
  config = {
    vpc_name       = "vpc"
    prefix         = var.prefix
    classic_access = var.classic_access
    ##############################################################################
    # Subnets
    ##############################################################################
    subnets = {
      zone-1 = [
        {
          name           = "subnet-zone-1"
          cidr           = "10.10.10.0/24"
          public_gateway = true
          acl_name       = "acl"
        }
      ],
      zone-2 = [
        {
          name           = "subnet-zone-2"
          cidr           = "10.20.10.0/24"
          public_gateway = true
          acl_name       = "acl"
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
    # ACL rules
    ##############################################################################
    acl_rules = flatten([
      module.dynamic_acl_allow_rules.rules,
      {
        name        = "allow-all-outbound"
        action      = "allow"
        direction   = "outbound"
        destination = "0.0.0.0/0"
        source      = "0.0.0.0/0"
      }
    ])
    ##############################################################################

    ##############################################################################
    # Public Gateways
    ##############################################################################
    use_public_gateways = {
      zone-1 = var.use_public_gateways ? true : false
      zone-2 = var.use_public_gateways ? true : false
      zone-3 = var.use_public_gateways ? true : false
    }
    ##############################################################################

    ##############################################################################
    # Default VPC Security grop rules
    ##############################################################################
    security_group_rules = [
      {
        name      = "allow-all-inbound"
        direction = "inbound"
        remote    = "0.0.0.0/0"
      }
    ]
    ##############################################################################
  }
  acls = [
    {
      name              = "acl"
      rules             = local.config.acl_rules
      add_cluster_rules = var.add_cluster_acl_rules
    }
  ]
}

##############################################################################