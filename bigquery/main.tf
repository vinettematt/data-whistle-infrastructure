locals {
  labels = {
    env     = var.env
    project = "the-data-whistle"
  }
}

# ── Dataset raw — JSON brut chargé depuis GCS ──
resource "google_bigquery_dataset" "raw" {
  dataset_id  = "tdw_${var.env}_raw"
  project     = var.project_id
  location    = var.region
  description = "Données brutes chargées depuis GCS landing zone"
  labels      = local.labels

  delete_contents_on_destroy = var.env != "prd"
}

# ── Dataset staging — nettoyage et typage (Dataform) ──
resource "google_bigquery_dataset" "staging" {
  dataset_id  = "tdw_${var.env}_staging"
  project     = var.project_id
  location    = var.region
  description = "Données nettoyées et typées par Dataform"
  labels      = local.labels

  delete_contents_on_destroy = var.env != "prd"
}

# ── Dataset intermediate — jointures et agrégats (Dataform) ──
resource "google_bigquery_dataset" "intermediate" {
  dataset_id  = "tdw_${var.env}_intermediate"
  project     = var.project_id
  location    = var.region
  description = "Jointures et agrégats inter-sports"
  labels      = local.labels

  delete_contents_on_destroy = var.env != "prd"
}

# ── Dataset marts — KPIs finaux exposés au prompt builder ──
resource "google_bigquery_dataset" "marts" {
  dataset_id  = "tdw_${var.env}_marts"
  project     = var.project_id
  location    = var.region
  description = "Tables finales football et NFL — consommées par le prompt builder"
  labels      = local.labels

  delete_contents_on_destroy = var.env != "prd"
}

# Accès Dataform sur staging, intermediate et marts
resource "google_bigquery_dataset_iam_member" "dataform_staging" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.staging.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${var.dataform_sa_email}"
}

resource "google_bigquery_dataset_iam_member" "dataform_intermediate" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.intermediate.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${var.dataform_sa_email}"
}

resource "google_bigquery_dataset_iam_member" "dataform_marts" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.marts.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${var.dataform_sa_email}"
}

# Lecture raw par Dataform (pour les modèles staging)
resource "google_bigquery_dataset_iam_member" "dataform_raw_reader" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.raw.dataset_id
  role       = "roles/bigquery.dataViewer"
  member     = "serviceAccount:${var.dataform_sa_email}"
}
