terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

locals {
  edge_enable_services = [
    "anthos.googleapis.com",
    "anthosaudit.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "anthosgke.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "connectgateway.googleapis.com",
    "container.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "opsconfigmonitoring.googleapis.com",
    "secretmanager.googleapis.com",
    "serviceusage.googleapis.com",
    "sourcerepo.googleapis.com",
    "stackdriver.googleapis.com",
    "storage.googleapis.com",
  ]

  fleet_folders = flatten([
    for bd in data.terraform_remote_state.fleet_folders.outputs.fleet_folders : [for f in bd.folders_map : f]
  ])

  fleet_vpn_peer_config_info = flatten([
    for project in module.control_plane_networking_project : [
      for cluster in var.fleet_vpn_peer_config :
      merge(cluster, { project_id = project.project_id })
      if cluster.fleet == trimsuffix(substr(project.project_id, 0, length(project.project_id) - 5), var.suffix.network_project)
    ]
  ])

  fleet_router_config_info = {
    for fleet in google_compute_router.fleet-router : fleet.project => fleet
  }

  ha_gateway_config_info = {
    for ha_gateway in google_compute_ha_vpn_gateway.ha_gateway : ha_gateway.project => ha_gateway
  }

  vpn_gateway_peer_info = {
    for vpn_gw_peer in google_compute_external_vpn_gateway.peer : vpn_gw_peer.name => vpn_gw_peer
  }

  tunnels_info = {
    for tunnel in module.tunnels : tunnel.cluster => tunnel
  }
}

// create a folder that houses the fleet control plane and the fleet project. This folder should attach to a region folder.
data "terraform_remote_state" "fleet_folders" {
  backend = "gcs"
  config = {
    bucket = var.tf_state_bucket
    prefix = "terraform/state/generic/iac-fleet-org-mod"
  }
}
