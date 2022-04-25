terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.71.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "~> 4.10.0"
    }
  }
}
