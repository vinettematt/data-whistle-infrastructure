# Service account — ingestion jobs (Cloud Run)
resource "google_service_account" "ingestion" {
  project      = var.project_id
  account_id   = "tdw-${var.env}-ingestion"
  display_name = "TDW ${var.env} — Ingestion jobs"
}

# Service account — Dataform
resource "google_service_account" "dataform" {
  project      = var.project_id
  account_id   = "tdw-${var.env}-dataform"
  display_name = "TDW ${var.env} — Dataform"
}

# Service account — prompt builder (Cloud Run)
resource "google_service_account" "prompt_builder" {
  project      = var.project_id
  account_id   = "tdw-${var.env}-prompt-builder"
  display_name = "TDW ${var.env} — Prompt builder"
}

# Service account — Scheduler (pour invoquer Cloud Run)
resource "google_service_account" "scheduler" {
  project      = var.project_id
  account_id   = "tdw-${var.env}-scheduler"
  display_name = "TDW ${var.env} — Cloud Scheduler"
}

# Ingestion : lecture/écriture GCS
resource "google_project_iam_member" "ingestion_gcs" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.ingestion.email}"
}

# Ingestion : écriture BigQuery (load raw)
resource "google_project_iam_member" "ingestion_bq" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.ingestion.email}"
}

resource "google_project_iam_member" "ingestion_bq_job" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.ingestion.email}"
}

# Dataform : lecture/écriture BigQuery
resource "google_project_iam_member" "dataform_bq_editor" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.dataform.email}"
}

resource "google_project_iam_member" "dataform_bq_job" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.dataform.email}"
}

# Dataform : accès au service Dataform
resource "google_project_iam_member" "dataform_service" {
  project = var.project_id
  role    = "roles/dataform.editor"
  member  = "serviceAccount:${google_service_account.dataform.email}"
}

# Prompt builder : lecture BigQuery (marts)
resource "google_project_iam_member" "prompt_builder_bq" {
  project = var.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:${google_service_account.prompt_builder.email}"
}

resource "google_project_iam_member" "prompt_builder_bq_job" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.prompt_builder.email}"
}

# Ingestion : lecture des secrets API
resource "google_project_iam_member" "ingestion_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.ingestion.email}"
}

# Prompt builder : lecture des secrets API (clé LLM)
resource "google_project_iam_member" "prompt_builder_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.prompt_builder.email}"
}

# Scheduler : invocation Cloud Run
resource "google_project_iam_member" "scheduler_run_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.scheduler.email}"
}
