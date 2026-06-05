output "landing_bucket_name" {
  value = google_storage_bucket.landing.name
}

output "landing_bucket_url" {
  value = "gs://${google_storage_bucket.landing.name}"
}
