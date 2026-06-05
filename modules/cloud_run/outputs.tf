output "football_ingestion_job_name" {
  value = google_cloud_run_v2_job.football_ingestion.name
}

output "nfl_ingestion_job_name" {
  value = google_cloud_run_v2_job.nfl_ingestion.name
}

output "prompt_builder_url" {
  value = google_cloud_run_v2_service.prompt_builder.uri
}
