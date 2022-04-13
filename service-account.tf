
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

data "google_project" "project" {
}
