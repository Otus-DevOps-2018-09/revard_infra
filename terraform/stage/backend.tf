terraform {
  backend "gcs" {
    bucket = "storage-bucket-app"
    prefix = "terraform/state"
  }
}
