terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

locals {
  project_prefix = var.project_prefix == "" ? "" : "${var.project_prefix}-"
  edge_enable_services = [
    "cloudbilling.googleapis.com",
    "anthos.googleapis.com",
    "anthosaudit.googleapis.com",
    "anthosgke.googleapis.com",
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
    "storage.googleapis.com"
  ]
  fleet_folders = flatten([
    for bd in data.terraform_remote_state.fleet_folders.outputs.fleet_folders : [for f in bd.folders_map : f]
    ])
}

// create a folder that houses the fleet control plane and the fleet project. This folder should attach to a region folder.
data "terraform_remote_state" "fleet_folders" {
  backend = "gcs"
  config = {
    bucket = "ce-tf-backend"
    prefix = "terraform/state/generic/3-org-structure/"
  }
}
