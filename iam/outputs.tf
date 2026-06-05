output "ingestion_sa_email" {
  value = google_service_account.ingestion.email
}

output "dataform_sa_email" {
  value = google_service_account.dataform.email
}

output "prompt_builder_sa_email" {
  value = google_service_account.prompt_builder.email
}

output "scheduler_sa_email" {
  value = google_service_account.scheduler.email
}
