// folder to contain fleet control plane folders and their associated projects
module "fleet_controlPlane" {
  source   = "terraform-google-modules/folders/google"
  version  = "3.1.0"
  for_each = { for k, v in local.fleet_folders : k => v }
  parent   = each.value["id"]
  names    = ["${each.value["display_name"]}${var.suffix["control_plane_folder"]}"]

}

// below folders nest under fleet-control-plane
// fleet control plane folder for security projects
module "fleet_control_plane_security" {
  source   = "terraform-google-modules/folders/google"
  version  = "3.1.0"
  for_each     = { for k, v in flatten([for b in module.fleet_controlPlane : b]) : k => v }
  names    = ["${trimsuffix(each.value.name, var.suffix["control_plane_folder"])}${var.suffix["security_folder"]}"]
  parent       = each.value.id
}
// fleet control plane folder for network projects
module "fleet_control_plane_platform" {
  source   = "terraform-google-modules/folders/google"
  version  = "3.1.0"
  for_each     = { for k, v in flatten([for b in module.fleet_controlPlane : b]) : k => v }
  
  names  = ["${trimsuffix(each.value.name, var.suffix["control_plane_folder"])}${var.suffix["platform_folder"]}"]
  parent       = each.value.id
}
// fleet control plane folder for observability projects
module "fleet_control_plane_observability" {
  source   = "terraform-google-modules/folders/google"
  version  = "3.1.0"
  for_each     = { for k, v in flatten([for b in module.fleet_controlPlane : b]) : k => v }
  
  names = ["${trimsuffix(each.value.name, var.suffix["control_plane_folder"])}${var.suffix["observability_folder"]}"]
  parent       = each.value.id
}

// below projects nest under their associated control plane folder
// Enterprise Security Projects
module "control_plane_secrets_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"
  for_each          = { for k, v in flatten([for b in module.fleet_control_plane_security : b]) : k => v }
  
  name              = lower("${trimsuffix(each.value.name, var.suffix["security_folder"])}${var.suffix["secrets_project"]}")
  random_project_id = true
  org_id            = var.org_id
  folder_id         = each.value.id
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
  for_each          = { for k, v in flatten([for b in module.fleet_control_plane_security : b]) : k => v }

  name              = lower("${trimsuffix(each.value.name, var.suffix.security_folder)}${var.suffix["sa_project"]}")
  random_project_id = true
  org_id            = var.org_id
  folder_id         = each.value.id
  billing_account   = var.billing_account_id
  activate_apis = local.edge_enable_services
}


module "control_plane_observability_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"
  for_each          = { for k, v in flatten([for b in module.fleet_control_plane_observability : b]) : k => v }

  name              = lower("${trimsuffix(each.value.name, var.suffix["observability_folder"])}${var.suffix["observability_project"]}")
  random_project_id = true
  org_id            = var.org_id
  folder_id         = each.value.id
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
  for_each          = { for k, v in flatten([for b in module.fleet_control_plane_platform : b]) : k => v }

  name              = lower("${trimsuffix(each.value.name, var.suffix["platform_folder"])}${var.suffix["network_project"]}")
  random_project_id = true
  org_id            = var.org_id
  folder_id         = each.value.id
  billing_account   = var.billing_account_id
  activate_apis = [
    "cloudbilling.googleapis.com",
    "compute.googleapis.com"
  ]
}

module "control_plane_sds_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"
  for_each          = { for k, v in flatten([for b in module.fleet_control_plane_platform : b]) : k => v }

  name              = lower("${trimsuffix(each.value.name, var.suffix["platform_folder"])}${var.suffix["sds_project"]}")
  random_project_id = true
  org_id            = var.org_id
  folder_id         = each.value.id
  billing_account   = var.billing_account_id
  activate_apis = [
    "cloudbilling.googleapis.com",
    "storage.googleapis.com"
  ]
}
