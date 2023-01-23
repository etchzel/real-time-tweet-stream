terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.49.0"
    }
  }
}

provider "google" {
  credentials = file("../google_credentials/gcp_key.json")

  project = var.project
  region  = var.region
  zone    = var.zone
}