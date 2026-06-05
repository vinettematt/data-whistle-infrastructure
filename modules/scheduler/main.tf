locals {
  # URL d'invocation des Cloud Run Jobs
  run_jobs_base_url = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs"
}

# ── Football — samedi et dimanche soir après les matchs (22h00 CET) ──
resource "google_cloud_scheduler_job" "football_saturday" {
  name             = "tdw-${var.env}-football-sat"
  project          = var.project_id
  region           = var.region
  description      = "Ingestion football — samedi post-matchs"
  schedule         = "0 22 * * 6" # 22h00 chaque samedi
  time_zone        = "Europe/Paris"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 3
  }

  http_target {
    http_method = "POST"
    uri         = "${local.run_jobs_base_url}/${var.football_ingestion_job_name}:run"

    oauth_token {
      service_account_email = var.scheduler_sa_email
    }
  }
}

resource "google_cloud_scheduler_job" "football_sunday" {
  name             = "tdw-${var.env}-football-sun"
  project          = var.project_id
  region           = var.region
  description      = "Ingestion football — dimanche post-matchs"
  schedule         = "0 22 * * 0" # 22h00 chaque dimanche
  time_zone        = "Europe/Paris"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 3
  }

  http_target {
    http_method = "POST"
    uri         = "${local.run_jobs_base_url}/${var.football_ingestion_job_name}:run"

    oauth_token {
      service_account_email = var.scheduler_sa_email
    }
  }
}

# ── NFL — lundi matin (résultats du dimanche américain) ──
resource "google_cloud_scheduler_job" "nfl_monday" {
  name             = "tdw-${var.env}-nfl-mon"
  project          = var.project_id
  region           = var.region
  description      = "Ingestion NFL — lundi matin (résultats dimanche)"
  schedule         = "0 7 * * 1" # 07h00 chaque lundi
  time_zone        = "Europe/Paris"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 3
  }

  http_target {
    http_method = "POST"
    uri         = "${local.run_jobs_base_url}/${var.nfl_ingestion_job_name}:run"

    oauth_token {
      service_account_email = var.scheduler_sa_email
    }
  }
}

# ── Génération newsletter — lundi matin après ingestion NFL ──
resource "google_cloud_scheduler_job" "newsletter_generation" {
  name             = "tdw-${var.env}-newsletter-gen"
  project          = var.project_id
  region           = var.region
  description      = "Génération newsletter — lundi 09h00"
  schedule         = "0 9 * * 1" # 09h00 chaque lundi (après ingestion à 07h00)
  time_zone        = "Europe/Paris"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 2
  }

  http_target {
    http_method = "POST"
    uri         = "${var.prompt_builder_url}/generate"

    oauth_token {
      service_account_email = var.scheduler_sa_email
    }
  }
}
