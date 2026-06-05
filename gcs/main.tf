# Bucket landing zone — données brutes des APIs
resource "google_storage_bucket" "landing" {
  name                        = "tdw-${var.env}-landing"
  project                     = var.project_id
  location                    = var.region
  force_destroy               = var.env != "prd"
  uniform_bucket_level_access = true

  labels = {
    env     = var.env
    project = "the-data-whistle"
  }

  # Cycle de vie : supprimer les fichiers raw après 90 jours
  # (les données sont déjà chargées dans BigQuery)
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }

  versioning {
    enabled = var.env == "prd"
  }
}

# Structure des préfixes (documentée, pas créée par Terraform)
# landing/
#   raw/
#     football/
#       YYYY-MM-DD/
#         matches.json
#         player_stats.json
#         team_stats.json
#     nfl/
#       YYYY-MM-DD/
#         box_scores.json
#         player_stats.json
#         play_by_play.json
