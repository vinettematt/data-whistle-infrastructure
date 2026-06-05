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

variable "ingestion_sa_email" {
  type = string
}

variable "prompt_builder_sa_email" {
  type = string
}

variable "landing_bucket_name" {
  type = string
}

variable "raw_dataset_id" {
  type = string
}

variable "marts_dataset_id" {
  type = string
}

variable "llm_api_key_secret" {
  description = "Nom du secret dans Secret Manager contenant la clé LLM"
  type        = string
  default     = "tdw-llm-api-key"
}

# Images Docker (à builder et pusher dans Artifact Registry)
variable "football_ingestion_image" {
  type    = string
  default = "europe-west1-docker.pkg.dev/data-whistle-dev/tdw/football-ingestion:latest"
}

variable "nfl_ingestion_image" {
  type    = string
  default = "europe-west1-docker.pkg.dev/data-whistle-dev/tdw/nfl-ingestion:latest"
}

variable "prompt_builder_image" {
  type    = string
  default = "europe-west1-docker.pkg.dev/data-whistle-dev/tdw/prompt-builder:latest"
}
