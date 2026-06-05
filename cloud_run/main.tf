locals {
  labels = {
    env     = var.env
    project = "the-data-whistle"
  }
}

# ── Artifact Registry — stockage des images Docker ──
resource "google_artifact_registry_repository" "tdw" {
  project       = var.project_id
  location      = var.region
  repository_id = "tdw"
  format        = "DOCKER"
  labels        = local.labels
}

# ── Job d'ingestion Football ──
resource "google_cloud_run_v2_job" "football_ingestion" {
  name     = "tdw-${var.env}-football-ingestion"
  project  = var.project_id
  location = var.region
  labels   = local.labels

  template {
    template {
      service_account = var.ingestion_sa_email
      max_retries     = 3

      timeout = "900s" # 15 min max

      containers {
        image = var.football_ingestion_image

        env {
          name  = "ENV"
          value = var.env
        }
        env {
          name  = "GCS_BUCKET"
          value = var.landing_bucket_name
        }
        env {
          name  = "BQ_PROJECT"
          value = var.project_id
        }
        env {
          name  = "BQ_RAW_DATASET"
          value = var.raw_dataset_id
        }
        env {
          name = "API_FOOTBALL_KEY"
          value_source {
            secret_key_ref {
              secret  = "tdw-api-football-key"
              version = "latest"
            }
          }
        }

        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
      }
    }
  }
}

# ── Job d'ingestion NFL ──
resource "google_cloud_run_v2_job" "nfl_ingestion" {
  name     = "tdw-${var.env}-nfl-ingestion"
  project  = var.project_id
  location = var.region
  labels   = local.labels

  template {
    template {
      service_account = var.ingestion_sa_email
      max_retries     = 3
      timeout         = "900s"

      containers {
        image = var.nfl_ingestion_image

        env {
          name  = "ENV"
          value = var.env
        }
        env {
          name  = "GCS_BUCKET"
          value = var.landing_bucket_name
        }
        env {
          name  = "BQ_PROJECT"
          value = var.project_id
        }
        env {
          name  = "BQ_RAW_DATASET"
          value = var.raw_dataset_id
        }

        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
      }
    }
  }
}

# ── Service Prompt Builder ──
# C'est un Service (pas un Job) car il est appelé à la demande
resource "google_cloud_run_v2_service" "prompt_builder" {
  name     = "tdw-${var.env}-prompt-builder"
  project  = var.project_id
  location = var.region
  labels   = local.labels

  # Pas d'accès public — appelé uniquement par le Scheduler
  ingress = "INGRESS_TRAFFIC_INTERNAL_ONLY"

  template {
    service_account = var.prompt_builder_sa_email

    scaling {
      min_instance_count = 0
      max_instance_count = 2
    }

    containers {
      image = var.prompt_builder_image

      env {
        name  = "ENV"
        value = var.env
      }
      env {
        name  = "BQ_PROJECT"
        value = var.project_id
      }
      env {
        name  = "BQ_MARTS_DATASET"
        value = var.marts_dataset_id
      }
      env {
        name = "LLM_API_KEY"
        value_source {
          secret_key_ref {
            secret  = var.llm_api_key_secret
            version = "latest"
          }
        }
      }

      resources {
        limits = {
          cpu    = "2"
          memory = "1Gi"
        }
      }
    }
  }
}
