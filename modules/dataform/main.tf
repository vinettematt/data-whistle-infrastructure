variable "project_id" { type = string }
variable "env"        { type = string }
variable "region"     { type = string; default = "europe-west1" }
variable "dataform_sa_email" { type = string }
variable "github_repo_url" {
  description = "URL du repo GitHub contenant les sources Dataform"
  type        = string
}
variable "github_token_secret" {
  description = "Secret Manager secret name pour le token GitHub"
  type        = string
  default     = "tdw-github-token"
}

resource "google_dataform_repository" "tdw" {
  name     = "tdw-${var.env}"
  project  = var.project_id
  region   = var.region

  git_remote_settings {
    url                                 = var.github_repo_url
    default_branch                      = var.env == "prd" ? "main" : var.env
    authentication_token_secret_version = "projects/${var.project_id}/secrets/${var.github_token_secret}/versions/latest"
  }

  workspace_compilation_overrides {
    default_database = var.project_id
    schema_suffix    = var.env == "prd" ? "" : "_${var.env}"
  }
}
