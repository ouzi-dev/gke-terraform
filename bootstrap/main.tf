provider "google" {
  region  = var.tf_state_region
  project = var.project
}

resource "google_storage_bucket" "terraform-bucket" {
  name          = var.tf_bucket_name
  location      = var.tf_bucket_location
  force_destroy = true
  versioning = {
    enabled = true
  }
}