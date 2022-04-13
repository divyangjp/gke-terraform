variable "region" {
  type = string
  default = "australia-southeast1"
}

variable "project" {
  type    = string
  default = "hexkey"
}

variable "gh_repo" {
  type  = string
  default = "divyangjp/hexkey-k8s-apps"
}

variable "gke_master_ipv4_cidr_block" {
  type    = string
  default = "172.23.0.0/28"
}

variable "authorized_source_ranges" {
  type        = list(string)
  description = "Addresses or CIDR blocks which are allowed to connect to GKE API Server."
}
