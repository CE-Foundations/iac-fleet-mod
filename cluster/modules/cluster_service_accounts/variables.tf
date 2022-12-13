variable "cluster_name" {
  type = string
}

variable "gsa_project_id" {
  type        = string
  description = "project in which to create service accounts"
}

variable "gsa_gcr_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_abm_gke_connect_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_abm_gke_register_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_acm_monitoring_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_abm_ops_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_external_secrets_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_sds_backup_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_gateway_connect_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_source_repo_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_cdi_import_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}

variable "gsa_storage_agent_iam_project" {
  type        = string
  description = "project in which to create IAM bindings for the named service account"
}