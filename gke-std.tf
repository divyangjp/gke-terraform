resource "google_container_cluster" "hk-std" {
  provider                 = google-beta

  name                     = "hk-std"
  location                 = var.sydney_zone_a
  project                  = var.project

  network                  = google_compute_network.custom.name
  subnetwork               = google_compute_subnetwork.web-std.id

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.gke_std_master_ipv4_cidr_block
  }

  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"

  # TEMP removal of authorized network to test github actions deployment
  #
  #master_authorized_networks_config {
  #  dynamic "cidr_blocks" {
  #      for_each = var.authorized_source_ranges
  #      content {
  #          cidr_block = cidr_blocks.value
  #      }
  #  }
  # }

  maintenance_policy {
    recurring_window {
      start_time = "2021-06-18T00:00:00Z"
      end_time   = "2050-01-01T04:00:00Z"
      recurrence = "FREQ=WEEKLY"
    }
  }

  vertical_pod_autoscaling {
    enabled = true
  }

  # Configuration of cluster IP allocation for VPC-native clusters
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  # Configuration options for the Release channel feature, which provide more control over automatic upgrades of your GKE clusters.
  release_channel {
    channel = "REGULAR"
  }
}


resource "google_container_node_pool" "hk-std-nodepool" {
  provider = google-beta
  name     = "hk-std-spot-inst-nodepool"
  cluster  = google_container_cluster.hk-std.name
  project  = var.project
  location = var.sydney_zone_a

  initial_node_count = 2
  autoscaling {
    min_node_count = 2
    max_node_count = 5
  }

  management {
    auto_repair   = true
    auto_upgrade  = true
  }

  node_config {
    spot          = true
    machine_type  = var.machine_type
    disk_size_gb  = var.disk_size
    
    # TOO broad
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}