
terraform {
  backend "gcs" {
    bucket = "belitre-terraform-bucket"
    prefix  = "terraform/state"
  }
}