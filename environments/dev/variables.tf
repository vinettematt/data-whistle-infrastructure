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
  default     = "europe-west9"
}

variable "github_repo_url" {
  description = "URL du repo GitHub Dataform"
  type        = string
}

variable "football_ingestion_image" {
  type    = string
  default = "python:3.11-slim"
}

variable "nfl_ingestion_image" {
  type    = string
  default = "python:3.11-slim"
}

variable "prompt_builder_image" {
  type    = string
  default = "python:3.11-slim"
}
