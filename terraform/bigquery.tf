resource "google_bigquery_dataset" "test_dataset" {
  dataset_id = "test_stream_twitter"
  location   = var.region
}

resource "google_bigquery_table" "test_table" {
  deletion_protection = false
  table_id            = "stream_twitter_to_bq"
  dataset_id          = google_bigquery_dataset.test_dataset.dataset_id

  schema = <<EOF
    [
      {
        "name": "id",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "Tweet ID"
      },
      {
        "name": "text",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "Tweet content"
      },
      {
        "name": "publish_time",
        "type": "TIMESTAMP",
        "mode": "NULLABLE",
        "description": "Published time of the message"
      },
      {
        "name": "message_id",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "ID of the published message"
      },
      {
        "name": "subscription_name",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "Sub name"
      },
      {
        "name": "data",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "Message data"
      },
      {
        "name": "attributes",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "Message attrib"
      }
    ]
    EOF
}