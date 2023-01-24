##############################################################################
# VPC GUID
##############################################################################

output "vpc_id" {
  description = "ID of VPC created"
  value       = module.ez_vpc.vpc_id
}

output "vpc_crn" {
  description = "CRN of VPC created"
  value       = module.ez_vpc.vpc_crn
}

##############################################################################


##############################################################################
# VPN Gateway Public IPs
##############################################################################

output "vpn_gateway_public_ips" {
  description = "List of VPN Gateway public IPS"
  value       = module.ez_vpc.vpn_gateway_public_ips
}

##############################################################################


##############################################################################
# Subnet Outputs
##############################################################################

output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = module.ez_vpc.subnet_ids
}

output "subnet_detail_list" {
  description = "A list of subnets containing names, CIDR blocks, and zones."
  value       = module.ez_vpc.subnet_detail_list
}

output "subnet_zone_list" {
  description = "A list containing subnet IDs and subnet zones"
  value       = module.ez_vpc.subnet_zone_list
}

##############################################################################
