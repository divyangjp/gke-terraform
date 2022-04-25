variable "region" {
  type    = string
  default = "australia-southeast1"
}

variable "project" {
  type    = string
  default = "hexkey"
}

variable "sydney_zone_a" {
  type    = string
  default = "australia-southeast1-a"
}
variable "gh_repo" {
  type    = string
  default = "divyangjp/hexkey-k8s-apps"
}

variable "gke_master_ipv4_cidr_block" {
  type    = string
  default = "172.23.0.0/28"
}

variable "gke_std_master_ipv4_cidr_block" {
  type    = string
  default = "172.11.0.0/28"
}

variable "authorized_source_ranges" {
  type        = list(string)
  description = "Addresses or CIDR blocks which are allowed to connect to GKE API Server."
}

variable "num_nodes" {
  type        = number
  description = "Number of nodes for standard gke cluster"
  default     = 3
}

variable "machine_type" {
  type        = string
  description = "Node machine type for standard gke cluster"
  default     = "e2-standard-2"
}

variable "disk_size" {
  type        = number
  description = "Node disk size"
  default     = 20
}
