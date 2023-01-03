module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.1.0"

  for_each     = { for k, v in flatten([for b in module.control_plane_networking_project : b.*.project_id]) : k => v }
  project_id   = each.value
  network_name = "fleet"
  routing_mode = "REGIONAL"

  delete_default_internet_gateway_routes = true

  subnets = [var.fleet_subnet]
  # secondary_ranges = local.restricted_vpc_secondary_ranges
}

# cloud router supporting the fleet internal VPN gateway
resource "google_compute_router" "fleet-router" {
  for_each = { for k, v in flatten([for b in module.control_plane_networking_project : b.*.project_id]) : k => v }

  name    = "fleet-vpn-${var.fleet_subnet.subnet_region}"
  region  = var.fleet_subnet.subnet_region
  network = module.vpc[each.key].network_id
  project = each.value

  bgp {
    asn = var.fleet_vpn_router_bgp_asn
  }
}

# creates the internal VPN gateway
resource "google_compute_ha_vpn_gateway" "ha_gateway" {
  for_each = { for k, v in flatten([for b in module.control_plane_networking_project : b.*.project_id]) : k => v }

  project = each.value
  name    = "fleet-gw-${var.fleet_vpn_region}"
  region  = var.fleet_vpn_region
  network = module.vpc[each.key].network_id
}

# # creates external VPN gateway w/ an interface for each peer IP
# resource "google_compute_external_vpn_gateway" "peer" {
#   for_each = var.fleet_vpn_peer_config

#   project         = module.control_plane_networking_project.project_id
#   name            = each.key
#   redundancy_type = "TWO_IPS_REDUNDANCY"
#   description     = "An externally managed VPN gateway"

#   dynamic "interface" {
#     for_each = each.value.peer_ips
#     content {
#       id         = interface.key
#       ip_address = interface.value
#     }
#   }
# }

# # creates and attaches tunnels for each cluster
# module "tunnels" {
#   source = "./submodules/tunnels"

#   for_each = var.fleet_vpn_peer_config

#   cluster_name  = each.key
#   project_id    = module.control_plane_networking_project.project_id
#   region        = var.fleet_vpn_region
#   router        = google_compute_router.fleet-router.id
#   vpn_gw        = google_compute_ha_vpn_gateway.ha_gateway.id
#   peer_gw       = google_compute_external_vpn_gateway.peer[each.key].id
#   shared_secret = each.value.shared_secret
# }


# creates router interfaces and bgp peers, one each per tunnel
# module "bgp" {
#   source = "./submodules/bgp"

#   for_each = var.fleet_vpn_peer_config

#   cluster_name = each.key
#   project_id   = module.control_plane_networking_project.project_id
#   region       = var.fleet_vpn_region
#   router       = google_compute_router.fleet-router.name
#   tunnels      = module.tunnels[each.key]
#   router_ifs   = each.value.router_ips
# }
