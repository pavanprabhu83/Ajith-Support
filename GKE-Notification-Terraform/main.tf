resource "google_pubsub_topic" "gke_cluster_upgrade_notifications" {
  name    = "gke-cluster-upgrade-notifications-python"
  project = "jlr-dl-complexity"

  labels = {
    <required labels if any>
  }

  message_storage_policy {
    allowed_persistence_regions = [
      "europe-west2",
    ]
  }
}

resource "google_container_cluster" "cluster" {
  provider = google-beta

  notification_config {
    pubsub {
      enabled = true
      topic   = google_pubsub_topic.gke_cluster_upgrade_notifications.name
    }
  }
}

resource "google_cloudfunctions_function" "gke_cluster_upgrade_notifications" {
  name        = "gke-cluster-upgrade-notifications-python"
  description = "Sends notifications to Slack for GKE cluster upgrade notifications."
  runtime     = "python38"

  available_memory_mb   = 128
  entry_point           = "notify_slack"
  ingress_settings      = "ALLOW_INTERNAL_ONLY"
  source_archive_bucket = "<gcs-bucket-name>"
  source_archive_object = "main.py.zip"
  timeout               = 30

  environment_variables = {
    SLACK_WEBHOOK_URL = "<URL>"
    PROJECT_NAME = var.project_name
  }

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.gke_cluster_upgrade_notifications.id
    failure_policy {
      retry = true
    }
  }

  labels = {
    <lables if any>
  }
}
