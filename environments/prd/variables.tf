variable "project_id" {
  description = "GCP project ID — prd"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "prd"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west9"
}

variable "github_repo_url" {
  description = "URL du repo GitHub Dataform"
  type        = string
}