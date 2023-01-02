// folder to contain fleet control plane folders and their associated projects
module "fleet_controlPlane" {
  source   = "terraform-google-modules/folders/google"
  version  = "3.1.0"
  for_each = { for k, v in local.fleet_folders : k => v }
  parent   = each.value["id"]
  names    = ["fleet-control-plane"]

}

// below folders nest under fleet-control-plane
// fleet control plane folder for security projects
module "fleet_control_plane_security" {
  source   = "terraform-google-modules/folders/google"
  version  = "3.1.0"
  names    = ["security"]
  for_each     = { for k, v in flatten([for b in module.fleet_controlPlane : b.ids_list]) : k => v }
  parent       = each.value
}
// fleet control plane folder for network projects
module "fleet_control_plane_platform" {
  source   = "terraform-google-modules/folders/google"
  version  = "3.1.0"
  names  = ["platform"]
  for_each     = { for k, v in flatten([for b in module.fleet_controlPlane : b.ids_list]) : k => v }
  parent       = each.value
}
// fleet control plane folder for observability projects
module "fleet_control_plane_observability" {
  source   = "terraform-google-modules/folders/google"
  version  = "3.1.0"
  names = ["observability"]
  for_each     = { for k, v in flatten([for b in module.fleet_controlPlane : b.ids_list]) : k => v }
  parent       = each.value
}

// below projects nest under their associated control plane folder
// Enterprise Security Projects
module "control_plane_secrets_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}secrets"
  random_project_id = true
  org_id            = var.org_id
  for_each          = { for k, v in flatten([for b in module.fleet_control_plane_security : b.ids_list]) : k => v }
  folder_id         = each.value
  billing_account   = var.billing_account_id

  activate_apis = [
    "cloudbilling.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudkms.googleapis.com"
  ]
}

module "control_plane_service_account_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}svc-accts"
  random_project_id = true
  org_id            = var.org_id
  for_each          = { for k, v in flatten([for b in module.fleet_control_plane_security : b.ids_list]) : k => v }
  folder_id         = each.value
  billing_account   = var.billing_account_id

  activate_apis = local.edge_enable_services
}


module "control_plane_observability_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}observability"
  random_project_id = true
  org_id            = var.org_id
  for_each          = { for k, v in flatten([for b in module.fleet_control_plane_observability : b.ids_list]) : k => v }
  folder_id         = each.value
  billing_account   = var.billing_account_id

  activate_apis = [
    "cloudbilling.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com"
  ]
}

module "control_plane_networking_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}network"
  random_project_id = true
  org_id            = var.org_id
  for_each          = { for k, v in flatten([for b in module.fleet_control_plane_platform : b.ids_list]) : k => v }
  folder_id         = each.value
  billing_account   = var.billing_account_id

  activate_apis = [
    "cloudbilling.googleapis.com",
    "compute.googleapis.com"
  ]
}

module "control_plane_sds_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name              = "${local.project_prefix}sds"
  random_project_id = true
  org_id            = var.org_id
  for_each          = { for k, v in flatten([for b in module.fleet_control_plane_platform : b.ids_list]) : k => v }
  folder_id         = each.value
  billing_account   = var.billing_account_id

  activate_apis = [
    "cloudbilling.googleapis.com",
    "storage.googleapis.com"
  ]
}
