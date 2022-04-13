terraform {
  backend "gcs" {
    bucket = "hexkey-tfstate"
    prefix = "hk"
  }
}
