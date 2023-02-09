# Module `iac-fleet-mod` 

This module takes the output fleet_folders from iac-fleet-org-mod and constructs fleet contol plane with its required projects, SAs and VPN HA to connect the cluster.


## Variables

- org_id (string) => Organiztion ID
  format: "[org_id]"

- Billing_account (string) => Billing account to be attached to the fleets.
  format: "01FC35-45E186-227832"

fleet_vpn_peer_config
[
    {
      name          = "cluster0" # Cluster name (Unique)
      project_id    = ""
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
      project_id    = ""
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
      project_id    = ""
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
      project_id    = ""
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

## Output

- control_plane_observability_project
- control_plane_networking_project
- control_plane_secrets_project
- control_plane_service_account_project
- control_plane_sds_project
- fleet_project
