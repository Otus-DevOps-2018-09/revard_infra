terraform {
  backend "gcs" {
    bucket = "storage-bucket-db"
    prefix = "terraform/state"
  }
}
