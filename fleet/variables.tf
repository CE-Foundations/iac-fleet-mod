variable "org_id" {
  description = "The id of the organization"
  type        = string
}

variable "suffix" {
  description = "suffixes used for folders and projects"
  type = object({
    control_plane_folder  = string
    security_folder       = string
    platform_folder       = string
    observability_folder  = string
    secrets_project       = string
    sa_project            = string
    observability_project = string
    network_project       = string
    sds_project           = string
  })

  default = {
    control_plane_folder  = "-control-plane"
    network_project       = "-network"
    observability_folder  = "-observability"
    observability_project = "-observability"
    platform_folder       = "-platform"
    sa_project            = "-svc-accts"
    sds_project           = "-sds"
    secrets_project       = "-secrets"
    security_folder       = "-security"
  }
}

variable "billing_account_id" {
  type = string
}

variable "fleet_subnet" {
  description = "subnet to create"
  type = object({
    subnet_name   = string
    subnet_ip     = string
    subnet_region = string
  })
  default = {
    subnet_name   = "fleet-us-central1",
    subnet_ip     = "172.16.100.0/24",
    subnet_region = "us-central1"
  }
}

variable "fleet_vpn_region" {
  type    = string
  default = "us-central1"
}

variable "fleet_vpn_router_bgp_asn" {
  type    = string
  default = "64519"
}

variable "fleet_vpn_peer_config" {
  description = "VPN peers are configurations used by this module enabling an Anthos cluster to attach to an HA VPN gateway"
  default = [
    {
      name          = "cluster0"             # Cluster name (Unique)
      fleet         = "fleet-1a-001"
      peer_ips      = ["8.8.8.8", "8.8.4.4"] # IPs allowed to connect to this HA VPN gateway
      shared_secret = "foobarbazquux"        # HA VPN shared secret
      # configuration used by BGP sessions for each cluster; this is a link-local config
      router_ips = {
        # must have 2 interfaces as this is HA VPN
        interface1 = {
          ip_range = "169.254.0.1/30"
          peer_ip  = "169.254.0.2"
          peer_asn = "64515"
        }
        interface2 = {
          ip_range = "169.254.1.1/30"
          peer_ip  = "169.254.1.2"
          peer_asn = "64515"
        }
      }
    },
    {
      name          = "cluster1"
      fleet         = "fleet-1a-001"
      peer_ips      = ["1.1.1.1", "1.0.0.1"]
      shared_secret = "foobarbazquux"
      router_ips = {
        interface1 = {
          ip_range = "169.254.2.1/30"
          peer_ip  = "169.254.2.2"
          peer_asn = "64515"
        }
        interface2 = {
          ip_range = "169.254.3.1/30"
          peer_ip  = "169.254.3.2"
          peer_asn = "64515"
        }
      }
    },
    {
      name          = "cluster2"
      fleet         = "fleet-1a-002"
      peer_ips      = ["8.8.8.8", "8.8.4.4"] # IPs allowed to connect to this HA VPN gateway
      shared_secret = "foobarbazquux"        # HA VPN shared secret
      # configuration used by BGP sessions for each cluster; this is a link-local config
      router_ips = {
        # must have 2 interfaces as this is HA VPN
        interface1 = {
          ip_range = "169.254.0.1/30"
          peer_ip  = "169.254.0.2"
          peer_asn = "64515"
        }
        interface2 = {
          ip_range = "169.254.1.1/30"
          peer_ip  = "169.254.1.2"
          peer_asn = "64515"
        }
      }
    },
    {
      name          = "cluster3"
      fleet         = "fleet-1a-002"
      peer_ips      = ["1.1.1.1", "1.0.0.1"]
      shared_secret = "foobarbazquux"
      router_ips = {
        interface1 = {
          ip_range = "169.254.2.1/30"
          peer_ip  = "169.254.2.2"
          peer_asn = "64515"
        }
        interface2 = {
          ip_range = "169.254.3.1/30"
          peer_ip  = "169.254.3.2"
          peer_asn = "64515"
        }
      }
    }
  ]
}
