// reference: https://cloud.google.com/pubsub/docs/create-subscription#assign_service_account
resource "google_pubsub_schema" "tweet_schema" {
  name       = "tweet_schema_bigquery"
  type       = "AVRO"
  definition = "{\n  \"type\" : \"record\",\n  \"name\" : \"Avro\",\n  \"fields\" : [\n    {\n      \"name\" : \"id\",\n      \"type\" : \"string\"\n    },\n    {\n      \"name\" : \"text\",\n      \"type\" : \"string\"\n    }\n  ]\n}\n"
}

resource "google_pubsub_topic" "tweet_topic" {
  name = "stream-tweet-topic"

  depends_on = [
    google_bigquery_dataset.test_dataset,
    google_bigquery_table.test_table,
    google_pubsub_schema.tweet_schema
  ]

  schema_settings {
    schema   = "projects/${var.project}/schemas/tweet_schema_bigquery"
    encoding = "JSON"
  }
}

resource "google_project_iam_member" "viewer" {
  project = var.project
  role    = "roles/bigquery.metadataViewer"
  member  = "serviceAccount:service-${var.project_number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "editor" {
  project = var.project
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:service-${var.project_number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_pubsub_subscription" "tweet_to_bq" {
  name  = "stream-tweet-subs"
  topic = google_pubsub_topic.tweet_topic.name

  bigquery_config {
    table            = "${google_bigquery_table.test_table.project}:${google_bigquery_table.test_table.dataset_id}.${google_bigquery_table.test_table.table_id}"
    use_topic_schema = true
    write_metadata   = true
  }

  depends_on = [
    google_project_iam_member.viewer,
    google_project_iam_member.editor,
    google_pubsub_topic.tweet_topic
  ]
}