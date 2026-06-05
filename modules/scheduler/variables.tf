variable "project_id" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west9"
}

variable "scheduler_sa_email" {
  type = string
}

variable "football_ingestion_job_name" {
  type = string
}

variable "nfl_ingestion_job_name" {
  type = string
}

variable "prompt_builder_url" {
  type = string
}
