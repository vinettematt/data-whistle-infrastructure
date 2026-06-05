variable "project_id" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "dataform_sa_email" {
  description = "Service account Dataform — accès datasets staging/marts"
  type        = string
}
