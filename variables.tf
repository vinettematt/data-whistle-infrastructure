variable "project_id" {
  description = "GCP project ID — dev"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "github_repo_url" {
  description = "URL du repo GitHub Dataform"
  type        = string
}
