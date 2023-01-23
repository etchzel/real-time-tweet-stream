import os
from google.oauth2 import service_account
from lib.tweet_streamer import TweetStreamer


BEARER_TOKEN = os.environ.get('TWITTER_BEARER_TOKEN')
PROJECT_ID = os.environ.get('GCP_PROJECT_ID')
PUBSUB_TOPIC = os.environ.get('GCP_PUBSUB_TOPIC')
SERVICE_ACCOUNT_PATH = os.environ.get('GCP_SERVICE_ACCOUNT_PATH')


def bearer_oauth(r):
    r.headers["Authorization"] = f"Bearer {BEARER_TOKEN}"
    r.headers["User-Agent"] = "v2FilteredStreamPython"
    return r    


def main():
    credentials = service_account.Credentials.from_service_account_file(SERVICE_ACCOUNT_PATH)
    topic_name = f'projects/{PROJECT_ID}/topics/{PUBSUB_TOPIC}'

    rules = [
        {"value": "football", "tag": "football arsenal"}
    ]
    tweetobj = TweetStreamer(rules, bearer_oauth)
    tweetobj.stream_data(credentials, topic_name)


if __name__ == "__main__":
    main()