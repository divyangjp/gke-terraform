locals {
  # THESE are too broad. Use fine grained roles for PRODUCTIOn!
  gh_runner_roles = [
    "roles/compute.admin",
    "roles/container.admin",
    "roles/storage.admin",
    "roles/secretmanager.admin",
  ]
}

resource "google_service_account" "pubsub-sa" {
  account_id   = "pubsub-access"
  display_name = "Service account used to access pubsub"
}

resource "google_project_iam_binding" "pubsub-sa-binding" {
  role    = "roles/pubsub.admin"
  members = [
    "serviceAccount:pubsub-access@${data.google_project.project.project_id}.iam.gserviceaccount.com",
  ]
}


# Workload Identity Provider config for github actions

resource "google_iam_workload_identity_pool" "gh_pool" {
  project                   = var.project
  provider                  = google-beta
  workload_identity_pool_id = "gh-pool"
}

resource "google_iam_workload_identity_pool_provider" "gh_provider" {
  provider                           = google-beta
  project                            = var.project
  workload_identity_pool_id          = google_iam_workload_identity_pool.gh_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "gh-provider"
  attribute_mapping                  = {
    "google.subject" = "assertion.sub"
    "attribute.full" = "assertion.repository"
  }
  oidc {
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "runner_sa" {
  project      = var.project
  account_id   = "gh-runner"
  display_name = "Service Account for Github Runner WLIF"
}

data "google_project" "project" {
  project_id = var.project
}

data "google_iam_policy" "gh_runner_policy" {
  binding {
    role = "roles/iam.workloadIdentityUser"

    members = [
      "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/gh-pool/attribute.full/${var.gh_repo}",
    ]
  }
}

resource "google_service_account_iam_policy" "gh-sa-account-iam" {
  service_account_id = google_service_account.runner_sa.name
  policy_data        = data.google_iam_policy.gh_runner_policy.policy_data
}

resource "google_project_iam_member" "gh_runner_roles" {
  count   = length(local.gh_runner_roles)
  project = data.google_project.project.project_id
  role    = local.gh_runner_roles[count.index]
  member  = "serviceAccount:${google_service_account.runner_sa.email}"
}
