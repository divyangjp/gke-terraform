resource "google_compute_network" "custom" {
  name                    = "custom"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "web" {
  name          = "web"
  ip_cidr_range = "10.10.10.0/24"
  network       = google_compute_network.custom.id
  region        = var.region

  secondary_ip_range  = [
    {
        range_name    = "services"
        ip_cidr_range = "10.10.11.0/24"
    },
    {
        range_name    = "pods"
        ip_cidr_range = "10.1.0.0/20"
    }
  ]

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  private_ip_google_access = true
}

resource "google_compute_subnetwork" "data" {
  name          = "data"
  ip_cidr_range = "10.20.10.0/24"
  network       = google_compute_network.custom.id
  region        = var.region

  private_ip_google_access = true
}

# Global External IPv4 used with HTTP(s) load balancer
resource "google_compute_global_address" "external-ipv4" {
  project      = var.project
  name         = "${var.project}-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}


# Subnetwork for Standard gke cluster
resource "google_compute_subnetwork" "web-std" {
  name          = "web-std"
  ip_cidr_range = "20.20.20.0/24"
  network       = google_compute_network.custom.id
  region        = var.region
  project       = var.project

  secondary_ip_range  = [
    {
        range_name    = "services"
        ip_cidr_range = "20.20.21.0/24"
    },
    {
        range_name    = "pods"
        ip_cidr_range = "20.1.0.0/20"
    }
  ]

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  private_ip_google_access = true
}