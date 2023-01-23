import requests
import json
from google.cloud import pubsub_v1

class TweetStreamer:
    def __init__(self, rules, bearer_oauth) -> None:
        self.rules_endpoint = "https://api.twitter.com/2/tweets/search/stream/rules"
        self.stream_endpoint = "https://api.twitter.com/2/tweets/search/stream"
        self.bearer_oauth = bearer_oauth
        self.delete_all_rules(self.get_rules())
        self.set_rules(rules)
        # Get list of rules

    def get_rules(self):
        res = requests.get(
            self.rules_endpoint, auth=self.bearer_oauth
        )

        if res.status_code != 200:
            raise Exception(f"Cannot get rules (HTTP {res.status_code}): {res.text}")

        return res.json()

    def delete_all_rules(self, rules):
        if rules is None or "data" not in rules:
            return None

        ids = list(map(lambda rule: rule['id'], rules['data']))
        payload = {"delete": {"ids": ids}}
        response = requests.post(
            self.rules_endpoint,
            auth=self.bearer_oauth,
            json=payload
        )

        if response.status_code != 200:
            raise Exception(
                "Cannot delete rules (HTTP {}): {}".format(
                    response.status_code, response.text
                )
            )

    def set_rules(self, rules):
        # You can adjust the rules if needed
        
        payload = {"add": rules}
        response = requests.post(
            self.rules_endpoint,
            auth=self.bearer_oauth,
            json=payload,
        )

        if response.status_code != 201:
            raise Exception(
                "Cannot add rules (HTTP {}): {}".format(response.status_code, response.text)
            )


    def stream_data(self, credentials, topic):
        response = requests.get(
            self.stream_endpoint, auth=self.bearer_oauth, stream=True,
        )
        
        if response.status_code != 200:
            raise Exception(
                "Cannot get stream (HTTP {}): {}".format(
                    response.status_code, response.text
                )
            )

        publisher = pubsub_v1.PublisherClient(credentials=credentials)
            
        for response_line in response.iter_lines():
            if response_line:
                json_response = json.loads(response_line)
                message = {k: json_response['data'][k] for k in json_response['data'] if k != 'edit_history_tweet_ids'}
                publisher.publish(topic=topic, data=json.dumps(message, indent=4, sort_keys=True).encode("utf-8"))
                print("Pushed message to topic.")