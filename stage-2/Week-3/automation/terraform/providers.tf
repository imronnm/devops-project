terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.5.0"
    }
  }
}

provider "google" {
  credentials = file("key.json")
  project     = "my-project-butkem"
  region      = var.region
  zone        = var.zone
}
