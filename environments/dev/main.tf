terraform {
  required_version = ">= 1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "tdw-dev-terraform-state"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# ── IAM — service accounts et permissions ──
module "iam" {
  source     = "../../modules/iam"
  project_id = var.project_id
  env        = var.env
}

# ── GCS — landing zone ──
module "gcs" {
  source     = "../../modules/gcs"
  project_id = var.project_id
  env        = var.env
  region     = var.region
}

# ── BigQuery — datasets ──
module "bigquery" {
  source             = "../../modules/bigquery"
  project_id         = var.project_id
  env                = var.env
  region             = var.region
  dataform_sa_email  = module.iam.dataform_sa_email
}

# ── Cloud Run — jobs ingestion + service prompt builder ──
module "cloud_run" {
  source                  = "../../modules/cloud_run"
  project_id              = var.project_id
  env                     = var.env
  region                  = var.region
  ingestion_sa_email      = module.iam.ingestion_sa_email
  prompt_builder_sa_email = module.iam.prompt_builder_sa_email
  landing_bucket_name     = module.gcs.landing_bucket_name
  raw_dataset_id          = module.bigquery.raw_dataset_id
  marts_dataset_id        = module.bigquery.marts_dataset_id
  football_ingestion_image = var.football_ingestion_image
  nfl_ingestion_image      = var.nfl_ingestion_image
  prompt_builder_image     = var.prompt_builder_image
}

# ── Scheduler — triggers automatiques ──
module "scheduler" {
  source                      = "../../modules/scheduler"
  project_id                  = var.project_id
  env                         = var.env
  region                      = var.scheduler_region
  scheduler_sa_email          = module.iam.scheduler_sa_email
  football_ingestion_job_name = module.cloud_run.football_ingestion_job_name
  nfl_ingestion_job_name      = module.cloud_run.nfl_ingestion_job_name
}

# ── Dataform — repository ──
module "dataform" {
  source              = "../../modules/dataform"
  project_id          = var.project_id
  env                 = var.env
  region              = var.region
  dataform_sa_email   = module.iam.dataform_sa_email
  github_repo_url     = var.github_repo_url
}
