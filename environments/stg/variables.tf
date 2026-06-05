variable "project_id" {
  description = "GCP project ID — stg"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "stg"
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