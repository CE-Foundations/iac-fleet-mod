// Anthos Fleet Deployment Project
module "fleet_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"
  for_each          = {for k, v in local.fleet_folders : k => v }

  name              = lower(each.value["display_name"])
  random_project_id = true
  org_id            = var.org_id
  folder_id         = each.value["id"]
  billing_account   = var.billing_account_id

  activate_apis = local.edge_enable_services
}
