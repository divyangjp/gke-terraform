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

resource "google_compute_global_address" "private-ip-peering" {
  name          = "google-managed-services-custom"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.custom.id
}

resource "google_service_networking_connection" "private-vpc-connection" {
  network = google_compute_network.custom.id
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.private-ip-peering.name
  ]
}
