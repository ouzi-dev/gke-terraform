variable "tf_state_region" {
  description = "GCE region"
}

variable "project" {
  description = "Name of the project"
}

variable "tf_bucket_name" {
  description = "Name of the bucket for terraform state"
}

variable "tf_bucket_location" {
  description = "Location of the bucket for terraform state"
}
